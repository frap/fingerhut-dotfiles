# Where the magic happens.
export DOTFILES=~/.local/dotfiles

# Add binaries into the path
BASH_IT_THEME="powerline-multiline"
PATH=$DOTFILES/bin:$PATH
export THEME_CLOCK_FORMAT="%H:%M"
export POWERLINE_LEFT_PROMPT="node scm wd"
export POWERLINE_RIGHT_PROMPT="clock hostname user_info battery"
export PATH BASH_IT_THEME

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
      for file in $DOTFILES/source/*; do
          source "$file"
      done
  fi
  #load up the bash_prompt - do it here as emacs tramp gets fucked up with
  #non > prompts
  case "$TERM" in
        "dumb")
            export PS1="> "
            ;;
        xterm*|rxvt*|eterm*|screen*)
 #           tty -s && source ~/.bash_prompt
            ;;
  esac
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
