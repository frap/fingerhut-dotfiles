# Linux-only stuff. Abort if not Linux.
is_linux || return 1

# Install fleck a clojured bash
if which /usr/local/bin/flk >/dev/null 2>&1; then
	e_install "Installing flk - a lisp based bash"
	sudo sh -c "curl -s https://chr15m.github.io/flk/flk > /usr/local/bin/flk && chmod 755 /usr/local/bin/flk"
fi

if ! has_exa; then
	e_install "Installing exa - a better ls"
	curl --proto '=https' --tlsv1.2 -sSOLJf https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
	unzip exa-linux*
	sudo mv exa-linux-x86_64 /usr/local/bin/
	sudo ln -s /usr/local/bin/exa-linux-x86_64 /usr/local/bin/exa
	rm -f exa-linux*
fi

# install powerline go
go get -u github.com/justjanne/powerline-go
