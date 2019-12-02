# RedHat-only stuff. Abort if not a Red Hat distribution.
is_redhat || return 1

# Package management
alias update="sudo yum update"
alias install="sudo yum install"
alias remove="sudo yum remove"
alias search="sudo rpm -qa | rg "

alias say=spd-say

## Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Switch between already-downloaded node versions.
#function node_ver() {
#  (
#    ver="${1#v}"
#    nodes=()
#    if [[ ! -e "/usr/local/src/node-v$ver" ]]; then
#      shopt -s extglob
#      shopt -s nullglob
#      cd "/usr/local/src"
#      eval 'for n in node-v*+([0-9]).+([0-9]).+([0-9]); do nodes=("${nodes[@]}" "${n#node-}"); done'
#      [[ "$1" ]] && echo "Node.js version \"$1\" not found."
#      echo "Valid versions are: ${nodes[*]}"
#      [[ "$(type -P node)" ]] && echo "Current version is: $(node --version)"
#      exit 1
#    fi
#    cd "/usr/local/src/node-v$ver"
#    sudo make install >/dev/null 2>&1 &&
#    echo "Node.js $(node --version) installed." ||
#    echo "Error, $(node --version) installed."
#  )
#}
