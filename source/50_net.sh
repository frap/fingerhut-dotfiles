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
    alias curl-trace='curl -w "$HOME/.curl-format" -o /dev/null -s'
fi
