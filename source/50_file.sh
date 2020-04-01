# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Always use colour output for `ls`
#if is_osx; then
 if which /usr/local/bin/gls >/dev/null 2>&1
  then
  #       make ls mark directories (F),
  #       show all files except . and .. (A), and show sizes (s)
      alias ls="/usr/local/bin/gls --color -sAF"
      alias ll="/usr/local/bin/gls --color -alhFtr"
      alias  l="/usr/local/bin/gls --color -alhF"
      alias lls="/usr/local/bin/gls --color -alhSr"
      alias la="/usr/local/bin/gls --color -Atr"
      alias dir="/usr/local/bin/gls --color=auto"
 else
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -alhFtr'
    alias  l='ls -alhF'
    alias lls='ls -alhSr'
    alias la='ls -Atr'
    alias dir='ls --color=auto'
    alias vdir='dir -sAF'
fi

# Directory listing
if [[ "$(type -P tree)" ]]; then
  alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias lsd='ll -d'
fi

# Easier navigation: .., ..., -
#alias ..='cd ..'
#alias ...='cd ../..'
#alias -- -='cd -'


# Long listing of only the most recently updated files
lr () { ll -rt "$@" | tail ; }
lra () { ll -rt "$@" ; }

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# TBD: Consider uncommenting after I learn how it works
# Fast directory switching
#mkdir -p $DOTFILES/caches/z
#_Z_NO_PROMPT_COMMAND=1
#_Z_DATA=$DOTFILES/caches/z/z
#. $DOTFILES/vendor/z/z.sh

# by default, do not overwrite files accidently
set -o noclobber
