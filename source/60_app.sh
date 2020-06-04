if has_rg; then
	alias grep='rg'
else
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

if has_gpg_agent; then
	function gpg_restart() {
		gpg-connect-agent reloadagent /bye
	}

	function gpg_forget() {
		gpg-connect-agent reloadagent /bye
	}
fi

if has_ssh_agent
then

  function _get_sshagent_pid_from_env_file() {
  local env_file="${1}"
  [[ -r "${env_file}" ]] || {
    echo "";
    return
  }
  tail -1 "${env_file}" \
  | cut -d' ' -f4 \
  | cut -d';' -f1
  }

  function _get_process_status_field() {
    # uses /proc filesystem
    local \
      pid \
      status_file \
      field
    pid="${1}"
    field="${2}"
    status_file="/proc/${pid}/status"
    if ! ([[ -d "${status_file%/*}" ]] \
      && [[ -r "${status_file}" ]]); then
      echo ""; return;
    fi
    grep "${field}:" "${status_file}" \
      | cut -d':' -f2 \
      | sed -e 's/[[:space:]]\+//g' \
      | cut -d'(' -f1
  }

    function _is_item_in_list() {
      local item
      for item in "${@:1}"; do
        if [[ "${item}" == "${1}" ]]; then
          return 1
        fi
      done
      return 0
    }


    function _is_proc_alive_at_pid() {
      local \
        pid \
        expected_name \
        actual_name \
        actual_state
      pid="${1?}"
      expected_name="ssh-agent"
      # we want to exclude: X (killed), T (traced), Z (zombie)
      actual_name=$(_get_process_status_field "${pid}" "Name")
      [[ "${expected_name}" == "${actual_name}" ]] || return 1
      actual_state=$(_get_process_status_field "${pid}" "State")
      if _is_item_in_list "${actual_state}" "X" "T" "Z"; then
        return 1
      fi
      return 0
    }


    function _ensure_valid_sshagent_env() {
      local agent_pid tmp_res

      mkdir -p "${HOME}/.ssh"
      type restorecon &> /dev/null
      tmp_res="$?"

      if [[ "${tmp_res}" -eq 0 ]]; then
        restorecon -rv "${HOME}/.ssh"
      fi

      # no env file -> shoot a new agent
      if ! [[ -r "${SSH_AGENT_ENV}" ]]; then
        ssh-agent > "${SSH_AGENT_ENV}"
        return
      fi

      ## do not trust pre-existing SSH_AGENT_ENV
      agent_pid=$(_get_sshagent_pid_from_env_file "${SSH_AGENT_ENV}")
      if [[ -z "${agent_pid}" ]]; then
        # no pid detected -> shoot a new agent
        ssh-agent > "${SSH_AGENT_ENV}"
        return
      fi

      ## do not trust SSH_AGENT_PID
      if _is_proc_alive_at_pid "${agent_pid}"; then
        return
      fi

      e_info "Il y a un ssh-agent mort au palier..."
      #rm -f "${SSH_AGENT_ENV}"
      ssh-agent > "${SSH_AGENT_ENV}"
      return
    }


    function _ensure_sshagent_dead() {
      [[ -r "${SSH_AGENT_ENV}" ]] \
      || return ## no agent file - no problems
      ## ensure the file indeed points to a really running agent:
      agent_pid=$(
        _get_sshagent_pid_from_env_file \
        "${SSH_AGENT_ENV}"
      )

      [[ -n "${agent_pid}" ]] \
      || return # no pid - no problem

      _is_proc_alive_at_pid "${agent_pid}" \
      || return # process is not alive - no problem

      echo "Le teur ssh-agent (pid:${agent_pid}) ... "
      kill -9 "${agent_pid}" && echo "FINI" || echo "FAILED"
      rm -f "${SSH_AGENT_ENV}"
    }


    function sshagent() {

      [[ -z "${SSH_AGENT_ENV}" ]] \
      && export SSH_AGENT_ENV="${HOME}/.ssh/agent_env.${HOSTNAME}"

      case "${1}" in
        on) _ensure_valid_sshagent_env;
          source "${SSH_AGENT_ENV}" > /dev/null;
          ;;
        off) _ensure_sshagent_dead
          ;;
        *)
          ;;
      esac
    }

    #sshagent on

    function add_ssh() {

      [[ $# -ne 3 ]] && echo "add_ssh host hostname user" && return 1
      [[ ! -d ~/.ssh ]] && mkdir -m 700 ~/.ssh
      [[ ! -e ~/.ssh/config ]] && touch ~/.ssh/config && chmod 600 ~/.ssh/config
      echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
    }

    function sshlist() {
      awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
    }

    function ssh-add-all() {
      grep -slR "PRIVATE" ~/.ssh | xargs ssh-add
    }


fi

if has_docker; then
	# ---------------------------------
	# Docker
	# ---------------------------------
	alias macaddress="docker inspect --format '{{ range .NetworkSettings.Networks}}{{.MacAddress }}{{end}}'"
	alias ipaddress="docker inspect --format '{{ range .NetworkSettings.Networks}}{{.IPAddress }}{{end}}'"
	alias logpath="docker inspect --format='{{.LogPath}}'"
	alias dsl='docker stack ls'
	alias dss='docker stack services'
	alias dsp='docker stack ps'
fi

if has_clojure; then
   alias repl='clojure -Sdeps "{:deps {com.bhauman/rebel-readline {:mvn/version \"0.1.4\"}}}" -m rebel-readline.main'
fi


# ---------------------------------
# top specific aliases
# ---------------------------------
# show top cpu consuming processes
alias topc="ps -e -o pcpu,pid,user,tty,args | sort -n -k 1 -r | head"
# show top memory consuming processes
alias topm="ps -e -o pmem,pid,user,tty,args | sort -n -k 1 -r | head"

# "fuck"
#if [[ "$(which thefuck)" ]]; then
#  eval $(thefuck --alias)
#fi

# Run a command repeatedly in a loop, with a delay (defaults to 1 sec).
# Usage:
#   loop [delay] single_command [args]
#   loopc [delay] 'command1 [args]; command2 [args]; ...'
# Note, these do the same thing:
#   loop 5 bash -c 'echo foo; echo bar;
#   loopc 5 'echo foo; echo bar'
function loopc() { loop "$@"; }
function loop() {
  local caller=$(caller 0 | awk '{print $2}')
  local delay=1
  if [[ $1 =~ ^[0-9]*(\.[0-9]+)?$ ]]; then
    delay=$1
    shift
  fi
  while true; do
    if [[ "$caller" == "loopc" ]]; then
      bash -c "$@"
    else
      "$@"
    fi
    sleep $delay
  done
}
