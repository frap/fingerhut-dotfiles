# Redhat-only stuff. Abort if not redHat.
is_redhat || return 1

major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`";

# Update YUM.
e_header "Updating VM packages"
# make sure we use dnf on EL 8+
if [ "$major_version" -ge 8 ]; then

  sudo dnf -y update
else
  sudo yum -y update
fi

# install ripgrep
if which rg >/dev/null 2>&1
  then
    e_header "Installing ripgrep"
    sudo yum-config-manager --add-repo=Https://Copr.Fedorainfracloud.Org/Coprs/Carlwgeorge/Ripgrep/Repo/Epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum -y install ripgrep
fi

# Install YUM packages.
packages=(
#  ansible
  binutils
  curl
  emacs-nox
  htop
  java-1.8.0-openjdk-headless
  nmap
  nmap-ncat
  python3
  python3-pip
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

sudo ln -s /usr/bin/python3 /usr/local/bin/python
sudo ln -s /usr/bin/pip3.6 /usr/local/bin/pip
# update PIP
e_header "Updating pip"
sudo /usr/local/bin/pip install --upgrade pip
