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
    export VCENTER_PASS="${VCENTER_PASS:-changeme}"
    export GOVC_URL=https://administrator@vsphere.local:${VCENTER_PASS}@vcenter.atea.dev
    export GOVC_TLS_KNOWN_HOSTS=~/.govc_known_hosts
    export GOVC_INSECURE=true
    function vm.ip() {
        govc vm.info -json $1 | jq -r .VirtualMachines[].Guest.Net[].IpAddress[0]
    }
    alias vm.power.on='govc vm.power -on=true ';
    alias vm.power.off='govc vm.power -off=true';
    alias vm.dev.ls='govc device.ls -vm ';
fi

if hash consul 2>/dev/null
then
    alias cons.mem='consul members';
fi

if hash curl 2>/dev/null
then
    alias curl-trace='curl -w "@$HOME/.curl-format" -o /dev/null -s'
fi

getIP()  {
  curr_hostname=$(hostname -s)
  interface=${1:-eth0}
  perldoc -l Regexp::Common >/dev/null 2>&1
  if [ $? -eq 0  ]  ; then
        local ip=$(ifconfig $interface | perl -MRegexp::Common -lne 'print $1 if /($RE{net}{IPv4})/' | grep -v "127.0.0.1")
    else
        local ip=$(ip -o -4 add list $interface | awk '{print $4}' | cut -d/ -f1)
    fi
    e_arrow "$interface=$ip"
}
