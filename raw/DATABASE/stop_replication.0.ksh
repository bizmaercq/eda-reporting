sqlplus "/ as sysdba" <<EOF
select status,sequence#,block#,client_process  from v\$managed_standby;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE OPEN READ ONLY;
select status from v\$instance;
exit;
EOF
