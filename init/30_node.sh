# Linux-only stuff. Abort if not Linux.
is_linux || return 1

# Install nvm
if command -v nvm >/dev/null 2>&1
  then
    e_header "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
fi
