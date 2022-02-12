--accept BATCH PROMPT 'Enter the Batch no ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
SPOOL C:\Automatic_susp.spl

select b.suspense_entry_reqd,b.* from sttm_branch b
/
SELECT *  FROM eitb_Eod_Susp_Entry_Dtls
/

set echo off
spool off
