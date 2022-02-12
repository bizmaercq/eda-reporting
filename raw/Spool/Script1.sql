set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\Script1.spl

SELECT * FROM FBTB_DATES ;
SELECT * FROM STTM_DATES ;
SELECT * FROM STTM_AEOD_DATES ;
SELECT * FROM ACTB_DAILY_LOG where trn_dt=to_date('26-Oct-2012','dd-mm-yyyy') ;
SELECT trn_dt,count(trn_dt) FROM ACTB_DAILY_LOG a group by trn_dt ;

spool off