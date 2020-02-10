# Linux stuff. Abort if not a Linux distribution.
is_linux || return 1

# Add tab completion for many Bash commands
[[ -r "/etc/profile.d/bash_completion.sh" ]] && source "/etc/profile.d/bash_completion.sh"

# If OracleDB exists then set Oracle env
[[ -r "/etc/profile.d/oracle_env.sh" ]] && source "/etc/profile.d/oracle_env.sh"

export EDITOR="vim"
export VISUAL="$EDITOR"
export ALTERNATE_EDITOR=""

