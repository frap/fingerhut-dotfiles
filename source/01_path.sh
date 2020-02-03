paths=(
  ~/.local/bin
  $DOTFILES/bin
)

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths

# source secrets such as VCENTER_PASS
if [ -f ~/.secrets ]; then
    . ~/.secrets
fi
