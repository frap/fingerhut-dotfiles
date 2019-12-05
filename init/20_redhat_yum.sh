# Redhat-only stuff. Abort if not redHat.
is_redhat || return 1

# If the old files isn't removed, the duplicate APT alias will break sudo!
sudoers_old="/etc/sudoers.d/sudoers-atearoot"; [[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

# Installing this sudoers file makes life easier.
sudoers_file="atearoot"
sudoers_src=$DOTFILES/conf/atea/$sudoers_file
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ]]; then
  cat <<EOF
The sudoers file can be updated to allow "sudo yum" to be executed
without asking for a password. You can verify that this worked correctly by
running "sudo -k yum". If it doesn't ask for a password, and the output
looks normal, it worked.

THIS SHOULD ONLY BE ATTEMPTED IF YOU ARE LOGGED IN AS ROOT IN ANOTHER SHELL.

This will be skipped if "Y" isn't pressed within the next $prompt_delay seconds.
EOF
  read -N 1 -t $prompt_delay -p "Update sudoers file? [y/N] " update_sudoers; echo
  if [[ "$update_sudoers" =~ [Yy] ]]; then
    e_header "Updating sudoers"
    visudo -cf "$sudoers_src" &&
    sudo cp "$sudoers_src" "$sudoers_dest" &&
    sudo chmod 0440 "$sudoers_dest" &&
    echo "File $sudoers_dest updated." ||
    echo "Error updating $sudoers_dest file."
  else
    echo "Skipping."
  fi
fi

# Update YUM.
e_header "Updating yum"
	sudo yum -y update

# install ripgrep
if which rg >/dev/null 2>&1
    e_header "Installing ripgrep"
   sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
   sudo yum install ripgrep
fi

# Install YUM packages.
packages=(
#  ansible
  binutils
  curl
  #  cowsay
  git-core
  htop
  nmap
  nmap-ncat
  #  id3tool
  #  libssl-dev
  socat
  tree
  tcpdump
)

# update PIP
e_header "Updating pip & setuptools"
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools

if (( ${#packages[@]} > 0 )); then
  e_header "Installing YUM packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    sudo yum -y install "$package"
  done
fi
