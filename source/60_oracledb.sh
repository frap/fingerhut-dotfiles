# Only stuff relevant if Oracle DB exists
has_oracledb || return 1

# OracleDB exists hence lets set Oracle env
source "/etc/profile.d/oracle_env.sh"

if has_sqlcl
then
   prepend_to_path_if_exists "/opt/sqlcl/bin"
fi
