if [ -f ~/.profile ]; then
	source ~/.profile
fi

case $- in *i*) . ~/.bashrc ;; esac
