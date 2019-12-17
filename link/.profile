#!/usr/bin/env bash
# This file is loaded by many shells, including graphical ones.

#--- Check what type of Machine we are on --
case "$(uname -s)" in

   Darwin)
     ON_A_MAC="Mac"
     ;;

   Linux)
     ON_LINOS="Penquin"
     ;;

   CYGWIN*|MINGW32*|MSYS*)
     ON_CRAP="Crap"
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
     OSTYPE='Wierd%hitsh'
     ;;
esac

## gpg-agent

if command -v gpg-connect-agent >/dev/null 2>&1; then

    gpg_restart() {
        gpg-connect-agent reloadagent /bye
    }

    gpg_forget() {
        gpg-connect-agent reloadagent /bye
    }

fi

## ssh-agent

if command -v ssh-agent >/dev/null 2>&1; then

    ssh_connect() {
        if [ -n "$HOME" ] && [ -f "$HOME/.ssh/agent-info" ]; then
            eval "$(cat "$HOME/.ssh/agent-info")" >/dev/null
        fi
    }

    ssh_connected() {
        ps -p "$SSH_AGENT_PID" 2>&1 | grep -qF ssh-agent
    }

    ssh_forget() {
        ssh-add -D
    }

    ssh_restart() {
        if [ -n "$HOME" ]; then
            pkill -U "$USER" ssh-agent
            mkdir -p "$HOME/.ssh"
            ssh-agent -t 86400 > "$HOME/.ssh/agent-info"
            ssh_connect
        fi
    }

    ssh_connect
    if ! ssh_connected; then
        ssh_restart
    fi

fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# -n => string is not null
# -z => string is null, has 0 length
# -a => logical and, exp1 -a exp2 returns true if both exp1 and  exp2 are true
# -o => logical or,  exp1 -o exp2 returns true if      exp1 *or* exp2 are true
if [ -n "$ON_A_MAC" ]
then

    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob;

    # Append to the Bash history file, rather than overwriting it
    shopt -s histappend;

    # Autocorrect typos in path names when using `cd`
    shopt -s cdspell;

    # Enable some Bash 4 features when possible:
    # * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
    # * Recursive globbing, e.g. `echo **/*.txt`
    for option in autocd globstar; do
	    shopt -s "$option" 2> /dev/null;
    done;

    # Add tab completion for many Bash commands
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"


    # Enable tab completion for `g` by marking it as an alias for `git`
    if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	    complete -o default -o nospace -F _git g;
    fi;

    # Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
    [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults;

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;
    # This should be the last line of the file
    # For local changes
fi

if [ -n "$ON_LINOS" ]
then
    # Add tab completion for many Bash commands
    [[ -r "/etc/profile.d/bash_completion.sh" ]] && source "/etc/profile.d/bash_completion.sh"
fi
# ------------- standard editor settings ---
export EDITOR="ec"
export VISUAL="$EDITOR"
export ALTERNATE_EDITOR=""

# Don't make edits below this
[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"
