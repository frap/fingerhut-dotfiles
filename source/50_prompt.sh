# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white
# get colours from gasbash-lib.sh

if ! [ -z "${prompt_colors[@]:-}" ]
then
  prompt_colors=(
    "36" # information color
    "37" # bracket color
    "31" # error color
    "7"  # inverse
  );
fi

# Highlight the user name when logged in as root.
if [ "${USER:-}" == "root" ]; then
	userStyle="${_red}";
else
	userStyle="${_bold}${_purple}";
fi

# Highlight the hostname when connected via SSH.
if ! [ -z "${SSH_TTY:-}" ]; then
	hostStyle="${_bold}${_orange}";
else
	hostStyle="${_cyan}";
fi


# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done'

# Exit code of previous command.
function prompt_exitcode() {
  prompt_getcolors
  [[ $1 != 0 ]] && e_error " erreur: $1\n"
}

# Git status.
function prompt_git_old() {
  prompt_getcolors
  local status output flags branch
  # For large git repositories, especially on NFS mounted file
  # systems, 'git status' is much slower than 'git status -uno', and
  # the latter also gives all of the output used by this function.
  status="$(git status -uno 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r "+"}\
        /^(# )?Changes not staged for commit:$/  {r=r "!"}\
        /^(# )?Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$c1:$c0$flags"
  fi
  echo "$c1[$c0$output$c1]$c9"
}

function prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}


# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

prompt_enable_vcs_info=1
prompt_program_installed_git=0
if [ $(command -v git >& /dev/null) ]
then
    prompt_program_installed_git=1
fi


function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  if ! [[ -z "${simple_prompt:-}" ]]; then
    PS1='\n$ ' && return
  fi

  # prompt_getcolors

  # http://twitter.com/cowboy/status/150254030654939137
  # Set the terminal title and prompt.
  PS1="\[\033]0;\W\007\]"; # working directory base name
  PS1+="\[${_bold}\]\n"; # newline
  PS1+="\[${userStyle}\]\u"; # username
  PS1+="\[${_white}\]@";
  PS1+="\[${hostStyle}\]\h"; # host
  PS1+="\[${_white}\] in ";
  PS1+="\[${_cyan}\]\w"; # working directory full path

  # I sometimes work on systems where a 'git status' command takes
  # several seconds to complete (while in the directory of a clone of
  # a large git repository, where the file system is NFS-mounted on a
  # remote NFS server, which I believe slows down traversal of the
  # files in the clone).  This causes a multi-second delay whenever a
  # shell prompt is generated, making it painfully slow to wait for
  # each new prompt.  Like 'simple_prompt' above, use the shell
  # variable 'prompt_enable_vcs_info' to enable these parts of the
  # prompt.  A user can do 'unset prompt_enable_vcs_info' in a shell
  # where they want to speed things up by not including this
  # information in the prompt.
 # if [[ "$prompt_enable_vcs_info" ]]; then
 #     if [ $prompt_program_installed_git == 1 ]
 #     then
#	  # git: [branch:flags]
	     PS1+="\$(prompt_git \"\[${_white}\] with \[${_violet}\]\" \"\[${_blue}\]\")"; # Git repository details
 #     fi
#  fi
  # misc: [cmd#:hist#]
  # PS1="$PS1$c1[$c0#\#$c1:$c0!\!$c1]$c9"
  # path: [user@host:path]
  #PS1="$PS1$c1[$c0\u$c1@$c0\h$c1:$c0\w$c1]$c9"
  #PS1="$PS1$c3[\u@\h:\w]$c9"
  #PS1+="${_reset}\n";
  # date: [HH:MM:SS]
  #PS1+="$c1[$c0$(date +"%H$c1:$c0%M$c1:$c0%S")$c1]$c9";
  # exit code: 127
  #PS1+="$(prompt_exitcode "$exit_code")";
  PS1+="\[${_white}\]\$ \[${_reset}\]"; # `$` (and reset color)
  PS1="$PS1 \$ "
}

PROMPT_COMMAND="prompt_command"


PS2="\[${_yellow}\]→ \[${_reset}\]";
export PS2;
