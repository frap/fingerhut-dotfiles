# Only stuff relevant if Oracle DB exists
has_oracledb || return 1

# OracleDB exists hence lets set Oracle env
exists "/etc/profile.d/oracle_env.sh" && source "/etc/profile.d/oracle_env.sh"
