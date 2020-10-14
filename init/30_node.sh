# Linux-only stuff. Abort if not Linux.
is_linux || return 1

# Install nvm
if ! has_nvm
   e_install "Installing nvm"
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi
