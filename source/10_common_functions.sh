if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	_bold=$(tput bold);
	_reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
  _uline=$(tput setaf 4);
  _inverse=$(tput setaf 7);
	_black=$(tput setaf 0);
	_blue=$(tput setaf 33);
	_cyan=$(tput setaf 37);
	_green=$(tput setaf 64);
	_orange=$(tput setaf 166);
	_purple=$(tput setaf 125);
	_red=$(tput setaf 124);
	_violet=$(tput setaf 61);
	_white=$(tput setaf 15);
	_yellow=$(tput setaf 136);
else
  _bold='';
  _reset="\e[0m";
  _uline="\e[4m";
  _inverse="\e[7m";
  _black="\e[1;30m";
  _blue="\e[1;34m";
  _cyan="\e[1;36m";
  _green="\e[1;32m";
  _orange="\e[1;33m";
  _purple="\e[1;35m";
  _red="\e[1;31m";
  _violet="\e[1;35m";
  _white="\e[1;37m";
  _yellow="\e[1;33m";
fi;
 # Logging stuff.
 function e_header()   { echo -e "\n${_bold}${_purple}$@${_reset}"; }
 function e_success()  { echo -e " ${_bold}${_cyan}✔ $@${_reset}"; }
 function e_error()    { echo -e " ${_bold}${_red}✖  $@${_reset}"; }
 function e_arrow()    { echo -e " ${_bold}${_yellow}➜${_reset}${_cyan} $@${_reset}"; }
 function e_info()     { echo -e " ${_green}∴ $@${_reset}"; }
 function e_data()     { echo -e " ${_green}$@${_reset}"; }
 function e_line()     { echo -e " ${_orange}$@${_reset}"; }
 function e_question() { echo -e " ${_violet}$@${_reset}"; }
 function flasher ()   { while true; do printf \\e[?5h; sleep 0.1; printf \\e[?5l; read -s -n1 -t1 && break; done; }

is_empty() {
  local var=$1

  [[ -z $var ]]
}

is_not_empty() {
  local var=$1

  [[ -n $var ]]
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

file_exists() {
  local file=$1

  sudo test -e $1
}


is_dir() {
  local dir=$1

  [[ -d $dir ]]
}

is_not_dir() {
  local dir=$1

  [[ ! -d $dir ]]
}

is_link() {
  local dir=$1

  [[ -L $dir ]]
}

matches_regex() {
  local filepath=$1
  local regex=$2

  [[ $filepath =~ $regex ]]
}

# For testing.
# function assert() {
#   local success modes equals actual expected
#   modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
#   actual="$("$@")"
#   [[ "$actual" == "$expected" ]] && success=1 || success=0
#   ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\"" }

# Check to see that a required environment variable is set.
# Use it without the $, as in:
#   require_env_var VARIABLE_NAME
# or
#   require_env_var VARIABLE_NAME "Some description of the variable"
function require_env_var {
  var_name="${1:-}"
  if [ -z "${!var_name:-}" ]; then
    e_error "The required env variable ${var_name} is empty"
    if [ ! -z "${2:-}" ]; then
       echo "  - $2"
    fi
    exit 1
  fi
}

# Check to see that we have a required binary on the path
function require_binary {
  if [ -z "${1:-}" ]; then
    echo "${FUNCNAME[0]} requires an argument"
    exit 1
  fi
  if ! [ -x "$(command -v "$1")" ]; then
    e_error "The required executable '$1' is not on the path."
    exit 1
  fi
}

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  e_error "Trapped CTRL-C - exiting"
}
prepend_to_path_if_exists () {
    local dir=$1
    if [ -d "${dir}" ]
    then
        export PATH="${dir}:$(path_remove ${dir})"
    fi
}

prepend_to_manpath_if_exists () {
    local dir=$1
    if [ -d "${dir}" ]
    then
        export MANPATH="${dir}:$(manpath_remove ${dir})"
    fi
}
