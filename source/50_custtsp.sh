# specifics to Customer TSPs
is_custtsp || return 1

# connect to PDB with sql / as sysdba
if has_18xe
then
    export ORACLE_PDB_SID=xepdb1
fi
