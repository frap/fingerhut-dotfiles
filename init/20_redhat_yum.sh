# Redhat-only stuff. Abort if not redHat.
is_redhat || return 1

major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`";

# Update YUM.
e_header "Updating VM packages"
# make sure we use dnf on EL 8+
if [ "$major_version" -ge 8 ]; then
  dnf -y update
else
  yum -y update
fi

# install ripgrep
if which rg >/dev/null 2>&1
  then
    e_header "Installing ripgrep"
    sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum install ripgrep
fi

# Install YUM packages.
packages=(
#  ansible
  binutils
  curl
  python3
  python3-pip
  java-1.8.0-openjdk-headless
  htop
  nmap
  nmap-ncat
  socat
  tree
  tcpdump
)

if (( ${#packages[@]} > 0 )); then
  e_header "Installing YUM packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    sudo yum -y install "$package"
  done
fi

# update PIP
e_header "Updating pip & setuptools"
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
