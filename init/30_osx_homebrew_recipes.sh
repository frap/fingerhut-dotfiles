## OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Homebrew recipes
recipes=(
  awscli
  bash
  cmatrix
  coreutils
  cowsay
  findutils
  git
  git-extras
  gnu-indent
  gnu-sed
  gnu-tar
  gnutls
  grep
  htop-osx
  hub
  id3tool
  jq
  lesspipe
  man2html
  nmap
  reattach-to-user-namespace
  ripgrep
  sl
  socat
  ssh-copy-id
  terminal-notifier
  thefuck
  tmux
  tmux-xpanes
  tree
  wget
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Ajout de $binroot/bash à la liste des shells acceptabless"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Ajout de $binroot/bash à la liste des shells acceptables"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "S'il vous plaît quitter et redémarrer tous vos shells."
fi
