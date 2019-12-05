# Install fleck a clojured bash
if which /usr/local/bin/flk >/dev/null 2>&1
then
    e_header "Installing flk - a lisp based bash"
    sudo sh -c "curl -s https://chr15m.github.io/flk/flk > /usr/local/bin/flk && chmod 755 /usr/local/bin/flk"
fi
