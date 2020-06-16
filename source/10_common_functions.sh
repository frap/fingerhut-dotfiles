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
  e_excep "Trapped CTRL-C - exiting"
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
