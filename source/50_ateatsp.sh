# Atea TSP stuff
is_ateatsp || return 1

function has_ccze() {
  hash ccze 2>/dev/null || return 1
}

if has_tomcat && has_ccze
then
    alias ccze='ccze -A -o nolookups'
    alias tt='jctl -u tomcat -o cat -f | ccze -A -o nolookups'
    alias tomcattail=tt
    alias tt2day='jctl -u tomcat -o cat -S today | ccze'
    alias tt2min='jctl -u tomcat -o cat -S "2 minutes ago" | ccze'
    alias tt5min='jctl -u tomcat -o cat -S "5 minutes ago" | ccze'
    alias tcrst='sctl restart tomcat'
    alias restarttomcat=tcrst
elif has_tomcat
then
    alias tt='jctl -u tomcat -f'
    alias tomcattail=tt
    alias tt2day='jctl -u tomcat -o cat -S today'
    alias tt2min='jctl -u tomcat -o cat -S "2 minutes ago"'
    alias tt5min='jctl -u tomcat -o cat -S "5 minutes ago"'
    alias tcrst='sctl restart tomcat'
    alias restarttomcat=tcrst
fi

exists "/etc/atea/properties/tnsnames.ora" && export TNS_ADMIN="/etc/atea/properties/tnsnames.ora"
