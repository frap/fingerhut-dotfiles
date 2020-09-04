# INSTALL Rust Utilities via cargo
# Linux-only stuff. Abort if not Linux.
is_linux || return 1
# starship prompt
curl -fsSL https://starship.rs/install.sh | bash
