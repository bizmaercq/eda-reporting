sqlplus "/ as sysdba"<<EOF
shutdown immediate
startup nomount
alter database mount standby database;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT;
select status,sequence#,block#,client_process  from v\$managed_standby;
exit;
EOF<<
