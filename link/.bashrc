# Where the magic happens.
export DOTFILES=~/.local/dotfiles

# Add binaries into the path

PATH=$DOTFILES/bin:$PATH
export PATH

#load up the bash_prompt - do it here as emacs tramp gets fucked up with
# non > prompts
case "$TERM" in
          "dumb")
            export PS1="> "
            ;;
          xterm*|rxvt*|eterm*|screen*)
            BASH_IT_THEME="powerline"
            #export THEME_CLOCK_FORMAT="%H:%M"
            #export POWERLINE_LEFT_PROMPT="scm cwd"
            #export POWERLINE_RIGHT_PROMPT="clock battery shlvl user_info hostname"
            export BASH_IT_THEME
            ;;
            *)
              PS1="> "
            ;;
esac

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
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
