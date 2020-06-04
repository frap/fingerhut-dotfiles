# General Aliases

alias m='less'
# Note: The -R option to less helps it show 'git diff' output
# # Prevent less from clearing the screen while still showing colors.
# export LESS=-XR
# colorized correctly, instead of showing a bunch of escape sequences.
export LESS='-iX -R -P--Less--?f %f .?x%t (next is %x) .?e(END\: hit q to quit):?pB(%pB\%)..'

# I'm used to tcsh 'where' to learn the info that bash 'type -a' prints
alias where='type -a'

alias ldd='otool -L'

# fwf - find writable files
alias fwf='find . \! -type d -a -perm -200 -ls'

# fnd - find non-directory files
alias fnd='find . \! -type d'

#  make mv, cp ask before over writing, and rm ask before removing
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

#alias x=exit
alias du='du -k'
