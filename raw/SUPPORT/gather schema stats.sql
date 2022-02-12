$sqlplus “/ as sysdba”
exec dbms_stats.gather_schema_stats(OWNNAME=>'NFCSUP' ,ESTIMATE_PERCENT=>NULL,METHOD_OPT=>'FOR ALL COLUMNS SIZE 1',OPTIONS => 'GATHER',DEGREE=>4);
