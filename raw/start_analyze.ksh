sqlplus '/ as sysdba'<<EOF
EXEC DBMS_STATS.gather_schema_stats (ownname => 'SYS', cascade =>true,estimate_percent => dbms_stats.auto_sample_size);
EXEC dbms_stats.gather_schema_stats(OWNNAME=>'NEWFLASH' ,ESTIMATE_PERCENT=>NULL,METHOD_OPT=>'FOR ALL COLUMNS SIZE 1',OPTIONS => 'GATHER',DEGREE=>12);
exit;
EOF


