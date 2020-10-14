# OSX-only stuff. Abort if not OSX.
is_osx || return 1

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

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
prepend_to_path_if_exists "/usr/local/bin"
prepend_to_path_if_exists "/opt/local/bin"
prepend_to_path_if_exists "/usr/local/sbin"

# For some reason, these are not there by default:
prepend_to_manpath_if_exists "/opt/local/share/man"
prepend_to_manpath_if_exists "$HOME/share/man"
prepend_to_manpath_if_exists "/usr/share/man"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

#NVM settings
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"

# create a new password and paste to clipboard
function pwcopy {
  < /dev/urandom \
    LANG= \
    tr -dc a-zA-Z0-9 \
    | head -c ${1:-16} \
    | pbcopy \
    && pbpaste \
    && echo
  }
# Create a new Parallels VM from template, replacing the existing one.
# function vm_template() {
#   local name="$@"
#   local basename="$(basename "$name" ".zip")"
#   local dest_dir="$HOME/Documents/Parallels"
#   local dest="$dest_dir/$basename"
#   local src_dir="$dest_dir/Templates"
#   local src="$src_dir/$name"
#   if [[ ! "$name" || ! -e "$src" ]]; then
#     echo "You must specify a valid VM template from this list:";
#     shopt -s nullglob
#     for f in "$src_dir"/*.pvm "$src_dir"/*.pvm.zip; do
#       echo " * $(basename "$f")"
#     done
#     shopt -u nullglob
#     return 1
#   fi
#   if [[ -e "$dest" ]]; then
#     echo "Deleting old VM"
#     rm -rf "$dest"
#   fi
#   echo "Restoring VM template"
#   if [[ "$name" == "$basename" ]]; then
#     cp -R "$src" "$dest"
#   else
#     unzip -q "$src" -d "$dest_dir" && rm -rf "$dest_dir/__MACOSX"
#   fi && \
#   echo "Starting VM" && \
#   open -g "$dest"
# }

# Export Localisation.prefPane text substitution rules.
# function txt_sub_backup() {
#   local prefs=~/Library/Preferences/.GlobalPreferences.plist
#   local backup=$DOTFILES/conf/osx/NSUserReplacementItems.plist
#   /usr/libexec/PlistBuddy -x -c "Print NSUserReplacementItems" "$prefs" > "$backup" &&
#   echo "Le fichier ~${backup#$HOME} écrire."
# }

# Import Localization.prefPane text substitution rules.
# function txt_sub_restore() {
#   local prefs=~/Library/Preferences/.GlobalPreferences.plist
#   local backup=$DOTFILES/conf/osx/NSUserReplacementItems.plist
#   if [[ ! -e "$backup" ]]; then
#     echo "Erreur: le fichier  ~${backup#$HOME} n'existe pas!"
#     return 1
#   fi
#   cmds=(
#     "Delete NSUserReplacementItems"
#     "Add NSUserReplacementItems array"
#     "Merge '$backup' NSUserReplacementItems"
#   )
#   for cmd in "${cmds[@]}"; do /usr/libexec/PlistBuddy -c "$cmd" "$prefs"; done
# }
