# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


alias m='less'
# TBD: Is this useful for anything?
export PAGER=`which less`
# Note: The -R option to less helps it show 'git diff' output
# # Prevent less from clearing the screen while still showing colors.
# export LESS=-XR
# colorized correctly, instead of showing a bunch of escape sequences.
export LESS='-iX -R -P--Less--?f %f .?x%t (next is %x) .?e(END\: hit q to quit):?pB(%pB\%)..'

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

# I'm used to tcsh 'where' to learn the info that bash 'type -a' prints
alias where='type -a'

alias ldd='otool -L'

# fwf - find writable files
alias fwf='find . \! -type d -a -perm -200 -ls'

# fnd - find non-directory files
alias fnd='find . \! -type d'

#       make mv, cp ask before over writing, and rm ask before removing
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

alias ds='dirs -v'
#alias x=exit
alias du='du -k'
alias hd='hexdump -C'

if has_clojure
   alias repl='clojure -Sdeps "{:deps {com.bhauman/rebel-readline {:mvn/version \"0.1.4\"}}}" -m rebel-readline.main'
fi
# Will recursively search every file in the directory tree starting with node
# <directory> for a match with <string>.
# Each occurrence of a match will be listed on one line. The file pathname and
# line number within the file where the match occurred will be listed.
# The search is CASE INSENSITIVE.
# Only ordinary files will be searched.

# TBD: This still has some tcsh-isms in it.  Consider converting to
# bash function.
alias search='find \!:1 -type f -exec grep -i -n \!:2 '{}' /dev/null \;'

# disable ctrl-d as logout method, unless you press it 10 times in row
IGNOREEOF=10

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
