accept BATCH PROMPT 'Enter the Batch no ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
SPOOL C:\batch.spl

select * from detb_batch_master where batch_no='&BATCH'
/
select * from detb_upload_master where batch_no='&BATCH'
/
select * from detb_upload_detail  where batch_no='&BATCH'
/
SELECT * FROM DETBS_JRNL_LOG where batch_no='&BATCH'
/
select * from DETB_UPLOAD_EXCEPTIONS where batch_no='&BATCH'
/
SELECT * FROM ACTB_DAILY_LOG WHERE BATCH_NO = '&BATCH' 
/


set echo off
spool off