# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Always use colour output for `ls`
if has_exa
  then
    alias ls="exa --long"
    alias la="exa --long -a --sort modified --reverse"
    alias ld="exa --only-dirs --tree --level 3"
    alias ll="exa --tree --level 3"
    alias l="exa --long -a"
    alias lls="exa --long --sort size --reverse"
fi
elif is_osx
then
  if has_gls
  then
  #       make ls mark directories (F),
  #       show all files except . and .. (A), and show sizes (s)
      alias ls="/usr/local/bin/gls --color -sAF"
      alias ll="/usr/local/bin/gls --color -alhFtr"
      alias  l="/usr/local/bin/gls --color -alhF"
      alias lls="/usr/local/bin/gls --color -alhSr"
      alias la="/usr/local/bin/gls --color -Atr"
  fi
fi
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


# Easier navigation: .., ..., -
#alias ..='cd ..'
#alias ...='cd ../..'
#alias -- -='cd -'


# Long listing of only the most recently updated files
#lr () { ll -rt "$@" | tail ; }
#lra () { ll -rt "$@" ; }

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

alias clr="clear"               # Clear your terminal screen
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias curdate='date +"%d-%m-%Y"'

# TBD: Consider uncommenting after I learn how it works
# Fast directory switching
#mkdir -p $DOTFILES/caches/z
#_Z_NO_PROMPT_COMMAND=1
#_Z_DATA=$DOTFILES/caches/z/z
#. $DOTFILES/vendor/z/z.sh

# by default, do not overwrite files accidently
set -o noclobber
