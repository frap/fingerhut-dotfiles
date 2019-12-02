sudo apt-get install curl
export github_user=frap
bash -c "$(curl -fsSL https://raw.github.com/$github_user/dotfiles-fingerhut/master/bin/dotfiles)" && source ~/.bashrc
