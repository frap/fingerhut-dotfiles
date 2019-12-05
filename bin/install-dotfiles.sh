sudo apt-get install curl
export github_user=frap
bash -c "$(curl -fsSL https://raw.github.com/$github_user/atea-dotfiles/master/bin/dotfiles)" && source ~/.bashrc
