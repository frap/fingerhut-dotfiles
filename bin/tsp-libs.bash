#!/usr/bin/env bash
#set -euo pipefail

# Load colours and helpers first so they can be used in base theme
source "${DOTFILES}/themes/colours.theme.bash"

function e_header() { printf "\n%4b${echo_purple}  %-70s${echo_reset_color}\n" "\U0001F916" "$@"; }
function e_install() { printf "%4b${echo_purple}  %-60s${echo_reset_color}\n" "🏗 " "$@"; }
function e_success() { printf "%b${echo_cyan}  %s${echo_reset_color}\n" "✔" "$@"; }
function e_error() { printf "%b${echo_red} %s${echo_reset_color}\n" "❌" "$@"; }
function e_excep() { printf "\n%4b${echo_red}  %-60s${echo_reset_color}\n" "🧨" "$@"; }
function e_arrow() { printf "${echo_yellow}%4b  ${echo_cyan}%-60s${echo_reset_color}\n" "➜" "$@"; }
function e_info() { printf "${echo_green}%4b  %-60s${echo_reset_color}\n" "∴" "$@"; }
function e_data() { printf "${echo_green}%4b  %-60s${echo_reset_color}\n" "➜" "$@"; }
function e_line() { printf "${echo_yellow}%4b  %-60s${echo_reset_color}\n" "\U262F" "$@"; }
function e_sep() { printf "${echo_yellow}%4b  %-60s${echo_reset_color}\n" "\U1F4CD" "--------------------------------------------------------"; }
function e_question() { printf "${echo_purple}%4b  %-60s${echo_reset_color}\n" "\U00002049" "$@"; }

# bash helpers
function is_file() {
	local file=$1

	[[ -f $file ]]
}

function exists() {
	local file=$1

	test -e $1
}

function is_dir() {
	local dir=$1

	[[ -d $dir ]]
}

function is_link() {
	local dir=$1

	[[ -L $dir ]]
}

function matches_regex() {
	local filepath=$1
	local regex=$2

	[[ $filepath =~ $regex ]]
}

# OS detection
function is_osx() {
	[[ "$OSTYPE" =~ ^darwin ]] 2>/dev/null || return 1
}
function is_ubuntu() {
	[[ "$(cat /etc/issue 2>/dev/null)" =~ Ubuntu ]] || return 1
}
function is_ubuntu_desktop() {
	dpkg -l ubuntu-desktop >/dev/null 2>&1 || return 1
}
function is_redhat() {
	[[ "$(cat /etc/redhat-release 2>/dev/null)" =~ "Red Hat" ]] || return 1
}
function is_oraclelinux() {
	[[ "$(cat /etc/oracle-release 2>/dev/null)" =~ "Oracle Linux" ]] || return 1
}

function is_ateatsp() {
	exists "/atea/home/atearoot" || return 1
}

function is_custtsp() {
	exists "/atea/home/thirdparty" || return 1
}

if exists /etc/redhat-release; then
	redhat_version="$(sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}')"
fi

function is_linux() {
	is_ubuntu || is_redhat || is_oraclelinux
}

function get_os() {
	for os in linux osx oraclelinux redhat ubuntu ateatsp custtsp; do
		is_$os
		[[ $? == ${1:-0} ]] && echo $os
	done
}
# Service detection
function has_gls() {
	hash gls 2>/dev/null || return 1
}

function has_exa() {
	hash exa 2>/dev/null || return 1
}

function has_docker() {
	hash docker 2>/dev/null || return 1
}

function has_java() {
	hash java 2>/dev/null || return 1
}

function has_rg() {
	hash rg 2>/dev/null || return 1
}

function has_clojure() {
	hash clojure 2>/dev/null || return 1
}

function has_tomcat() {
	exists /opt/tomcat_latest/bin || return 1
}

function has_systemd() {
	exists /etc/systemd || return 1
}

# Oracle DB shit
XE18pattern='18c'

function has_oracledb() {
	exists /etc/profile.d/oracle_env.sh || return 1
}

function has_sqlcl() {
	exists /opt/sqlcl/bin/sql || return 1
}

function has_sqlplus() {
	hash sqlplus 2>/dev/null || return 1
}

function has_18xe() {
	has_oracledb && [[ ${ORACLE_HOME} =~ $XE18pattern ]] || return 1
}

function has_gpg_agent() {
	hash gpg-connect-agent 2>/dev/null || return 1
}

function has_govc() {
	hash govc 2>/dev/null || return 1
}

function has_ssh_agent() {
	hash ssh-agent 2>/dev/null || return 1
}

function has_app() {
	for app in clojure docker exa gls govc gpg_agent java rg ssh_agent systemd tomcat oracledb sqlcl sqlplus 18xe; do
		has_$app
		[[ $? == ${1:-0} ]] && echo $app
	done
}
