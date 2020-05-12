case $- in *i*) . ~/.bashrc;; esac

if [ -f ~/.profile ]; then
    source ~/.profile
fi
