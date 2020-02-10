# RedHat-only stuff. Abort if not a Red Hat distribution.
is_redhat || return 1

# Package management
alias update="sudo yum update"
alias install="sudo yum install"
alias remove="sudo yum remove"
alias search="sudo rpm -qa | rg "

alias say=spd-say

## Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

