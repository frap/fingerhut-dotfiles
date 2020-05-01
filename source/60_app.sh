# source secrets such as VCENTER_PASS
if [ -f ~/.secrets ]; then
    . ~/.secrets
fi

if has_gls
then
    alias ls="gls --color"
    alias ll="gls --color -alhFtr"
    alias  l="gls --color -alhF"
    alias lls="gls --color -alhSr"
    alias la="gls --color -Atr"
    alias dir="gls --color=auto"
else
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -alhFtr'
    alias  l='ls -alhF'
    alias lls='ls -alhSr'
    alias la='ls -Atr'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

alias h="history"
alias clr="clear" # Clear your terminal screen
alias myip="curl icanhazip.com" # Your public IP address
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias curdate='date +"%d-%m-%Y"'

if has_rg
then
    alias grep='rg'
else
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if is_osx
then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
fi

if is_redhat && [[ -r /atea/home/atearoot ]]
then
    export NVM_DIR="/atea/home/atearoot/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi


if has_gpg_agent
then
     gpg_restart() {
        gpg-connect-agent reloadagent /bye
    }

    gpg_forget() {
        gpg-connect-agent reloadagent /bye
    }
fi


#if has_ssh_agent
#then
#        if [ -n "$HOME" ] && [ -f "$HOME/.ssh/agent-info" ]; then
#            eval "$(cat "$HOME/.ssh/agent-info")" >/dev/null
#        fi
#    }

#    ssh_connected() {
#        ps -p "$SSH_AGENT_PID" 2>&1 | grep -qF ssh-agent
#    }

 #   ssh_forget() {
 #       ssh-add -D
 #   }

 #   ssh_restart() {
 #       if [ -n "$HOME" ]; then
 #           pkill -U "$USER" ssh-agent
 #           mkdir -p "$HOME/.ssh"
 #           ssh-agent -t 86400 > "$HOME/.ssh/agent-info"
 #           ssh_connect
 #       fi
 #   }

 #   ssh_connect
 #   if ! ssh_connected; then
 #       ssh_restart
 #   fi
#fi

if has_docker
then
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
