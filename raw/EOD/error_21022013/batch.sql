set array 1
set line 5000
set head on
set pagesize 10000
set feedback on
set trimspool on
set numformat 9999999999999999.999
set colsep ";"
set echo on

SPOOL C:\BATCH_DETAILS.SPL

accept BATCH_NO PROMPT 'Enter the batch no ==> '

SELECT * FROM DETB_BATCH_MASTER WHERE BATCH_NO='&BATCH_NO';

SELECT * FROM ACTB_DAILY_LOG WHERE BATCH_NO ='&BATCH_NO';

SELECT * FROM DETB_JRNL_LOG WHERE BATCH_NO='&BATCH_NO';

SELECT * FROM DETB_UPLOAD_MASTER WHERE BATCH_NO='&BATCH_NO';

SELECT * FROM DETB_UPLOAD_DETAIL WHERE BATCH_NO='&BATCH_NO';

spool off