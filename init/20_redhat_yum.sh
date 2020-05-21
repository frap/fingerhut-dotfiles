# Redhat-only stuff. Abort if not redHat.
is_redhat || return 1

#major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`";

# Update YUM.
e_header "Updating VM packages"
# make sure we use dnf on EL 8+
if [ "$major_version" -ge 8 ]; then
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
  cargo
  curl
  emacs-nox
  java-1.8.0-openjdk-headless
  nmap
  nmap-ncat
  python3
  python3-pip
  rust
  socat
  tree
  tcpdump
  vim
)

if (( ${#packages[@]} > 0 )); then
  else if [ "$major_version" -ge 8 ]; then
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
fi

e_info "Linking python3 to python and pip"
sudo ln -s /usr/bin/python3 /usr/local/bin/python
sudo ln -s /usr/bin/pip3.6 /usr/local/bin/pip

# procs replacement for htop
rpm -i https://github.com/dalance/procs/releases/download/v0.10.3/procs-0.10.3-1.x86_64.rpm
