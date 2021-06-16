# Editing

alias vi=vim

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

function ec() {
  if [ -z "$DISPLAY" ]; then
    emacsclient -nw -a "" "$@"
  else
    emacsclient -n -e "(> (length (frame-list)) 1)" | grep t
    if [ "$?" = "1" ]; then
      emacsclient -c -n -a "" "$@"
    else
      emacsclient -n -a "" "$@"
    fi
  fi
}

em() {
  CFLAG=""
  [[ -z "$@" ]] && CFLAG="--create-frame"
  emacsclient $CFLAG --alternate-editor=emacs --no-wait "$@"
}

if is_ateatsp
then
    export EDITOR="vim"
else
    export EDITOR="ec"
fi

alias e=ec
export VISUAL="${EDITOR}"
export ALTERNATE_EDITOR=""
