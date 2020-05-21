# Editing

alias vi=vim

if [[ -x "/Applications/Emacs.app/Contents/MacOS/Emacs" ]]
then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
fi

if [[ -z "$EMACS" ]];
then
  export EDITOR=vim
else
  export EDITOR="${EMACS}"
fi
export VISUAL="${EDITOR}"

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

alias e=ec
alias emacs=ec
