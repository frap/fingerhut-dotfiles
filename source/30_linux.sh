# Linux stuff. Abort if not a Linux distribution.
is_linux || return 1

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Add tab completion for many Bash commands
[[ -r "/etc/profile.d/bash_completion.sh" ]] && source "/etc/profile.d/bash_completion.sh"


if has_systemd
then
    alias sctl='sudo systemctl'
    alias sc='sudo systemctl'
    alias jctl='sudo journalctl'
    alias jc='sudo journalctl'
fi

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi
