if has_rg; then
	alias grep='rg'
else
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

if is_osx; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # This loads nvm
	[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
fi

if is_redhat && [[ -r /atea/home/atearoot ]]; then
	export NVM_DIR="/atea/home/atearoot/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

if has_gpg_agent; then
	gpg_restart() {
		gpg-connect-agent reloadagent /bye
	}

	gpg_forget() {
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
      local \
        agent_pid \
        tmp_res

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

      echo "Il y a un ssh-agent mort au palier..."
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

      echo -e -n "Le teur ssh-agent (pid:${agent_pid}) ... "
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

    sshagent on

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

# ---------------------------------
# top specific aliases
# ---------------------------------
# show top cpu consuming processes
alias topc="ps -e -o pcpu,pid,user,tty,args | sort -n -k 1 -r | head"
# show top memory consuming processes
alias topm="ps -e -o pmem,pid,user,tty,args | sort -n -k 1 -r | head"
