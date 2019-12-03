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
  git
  git-extras
  gls
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

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Mise à jour des autorisations htop"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

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
