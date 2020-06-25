# Redhat-only stuff. Abort if not redHat.
is_redhat || return 1

# Update YUM.
e_header "Updating VM packages"
# make sure we use dnf on EL 8+
if [ $redhat_version -ge 8 ]; then
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    sudo dnf -y update
else
    sudo yum -y update
fi

# install ripgrep
if ! has_rg
  then
    e_header "Installing ripgrep"
    sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum -y install ripgrep
fi

# Install YUM packages.
packages=(
#  ansible
    binutils
    bind-utils
    cargo
    curl
    emacs-nox
    inotify-tools
    java-1.8.0-openjdk-headless
    lsof
    nmap
    nmap-ncat
    python3
    python3-pip
    rlwrap
    rust
    socat
    tree
    tcpdump
    vim
)

if (( ${#packages[@]} > 0 )) && [ $redhat_version -ge 8 ];
then
  e_header "Installing packages via DNF: $[packages[*]]"
  for package in "${packages[@]}"; do
    sudo dnf -y install "$package"
  done
else
  e_header "Installing packages via YUM: ${packages[*]}"
  for package in "${packages[@]}"; do
    sudo yum -y install "$package"
  done
fi

#e_info "Linking python3 to python and pip"
#sudo ln -s /usr/bin/python3 /usr/local/bin/python
#sudo ln -s /usr/bin/pip3.6 /usr/local/bin/pip

function install_app() {
  local app=$1
  local url=$2
  pushd /tmp
  curl -fsSJL ${url} -o /tmp/${app}.tar.gz
  mkdir ${app} & tar xvzf "${app}.tar.gz" -C ${app} --strip-components 1
  sudo mv ${app}/${app} /usr/local/bin/
  exists ${app}/autocomplete/${app}.bash_completion && \
     sudo mv ${app}/autocomplete/${app}.bash-completion /etc/bash_completion.d/
  rm -rf "${app}"*
  popd
}


e_install "Installing fd - a better find"
install_app "fd" "https://github.com/sharkdp/fd/releases/download/v8.1.0/fd-v8.1.0-x86_64-unknown-linux-gnu.tar.gz"

e_install "Installing bat - a better cat"
install_app "bat" "https://github.com/sharkdp/bat/releases/download/v0.15.1/bat-v0.15.1-x86_64-unknown-linux-gnu.tar.gz"

# procs replacement for htop
sudo rpm -i https://github.com/dalance/procs/releases/download/v0.10.3/procs-0.10.3-1.x86_64.rpm
