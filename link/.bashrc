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
            #PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
            eval "$(starship init bash)"
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

#NVM settings
if is_dir "/atea/home/atearoot"; then
  export NVM_DIR="/atea/home/atearoot/.nvm"
else
  export NVM_DIR="$HOME/.nvm"
fi
if is_osx
then
 [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # This loads nvm
 [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
else
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi
