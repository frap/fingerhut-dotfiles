# RedHat-only stuff. Abort if not a Red Hat distribution.
is_redhat || return 1

# Package management
if major_version ge 8
then
   alias update="sudo dnf update"
   alias install="sudo dnf install"
   alias remove="sudo dnf remove"
   alias search="sudo dnf search"
else
    alias update="sudo yum update"
    alias install="sudo yum install"
    alias remove="sudo yum remove"
    alias search="sudo rpm -qa | rg "
fi
alias say=spd-say

## Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
