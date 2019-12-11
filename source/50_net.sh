# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Ping the specified server (or the default 8.8.8.8) and say "ping"
# through the speaker every time a ping is successful. Based on an
# idea from @gnarf.
function pingtest() {
  local c
  for c in say spd-say; do [[ "$(which $c)" ]] && break; done
  ping ${1:-8.8.8.8} | perl -pe '/bytes from/ && `'$c' ping`'
}

if which govc  >/dev/null 2>&1
then
    export GOVC_URL=https://administrator@vsphere.local:${VCENTER_PASS}@vcenter.ateasystems.com
    export GOVC_TLS_KNOWN_HOSTS=~/.govc_known_hosts
    export GOVC_INSECURE=true
    function vm.ip() {
        govc vm.info -json $1 | jq -r .VirtualMachines[].Guest.Net[].IpAddress[0]
    }
    alias vm.poweron='govc vm.power -on=true ';
    alias vm.poweroff='govc vm.power -off=true';
    alias vm.dev.ls='govc device.ls -vm ';
fi

if which consul >/dev/null 2>&1
then
    alias cons.mem='consul members';
fi

if which curl >/dev/null 2>&1
then
    alias curl-trace='curl -w "@$HOME/.curl-format" -o /dev/null -s'
fi

## gpg-agent

if command -v gpg-connect-agent >/dev/null 2>&1; then

    gpg_restart() {
        gpg-connect-agent reloadagent /bye
    }

    gpg_forget() {
        gpg-connect-agent reloadagent /bye
    }

fi

## ssh-agent

if command -v ssh-agent >/dev/null 2>&1; then

    ssh_connect() {
        if [ -n "$HOME" ] && [ -f "$HOME/.ssh/agent-info" ]; then
            eval "$(cat "$HOME/.ssh/agent-info")" >/dev/null
        fi
    }

    ssh_connected() {
        ps -p "$SSH_AGENT_PID" 2>&1 | grep -qF ssh-agent
    }

    ssh_forget() {
        ssh-add -D
    }

    ssh_restart() {
        if [ -n "$HOME" ]; then
            pkill -U "$USER" ssh-agent
            mkdir -p "$HOME/.ssh"
            ssh-agent -t 86400 > "$HOME/.ssh/agent-info"
            ssh_connect
        fi
    }

    ssh_connect
    if ! ssh_connected; then
        ssh_restart
    fi

fi
