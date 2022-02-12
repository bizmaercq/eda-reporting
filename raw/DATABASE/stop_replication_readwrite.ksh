sqlplus "/ as sysdba" <<EOF
select status,sequence#,block#,client_process  from v\$managed_standby;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
ALTER DATABASE OPEN;
select status from v\$instance;
exit;
EOF
