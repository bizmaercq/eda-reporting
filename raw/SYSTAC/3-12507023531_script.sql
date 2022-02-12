set numformat 999,999,999,999,999,999,999.999
set linesize 10000
set serveroutput on
set echo on
set colsep ";"
set trimspool on
set pagesize 50000
spool c:\3-12431528321.spl


select * from eitb_pending_programs;

update eitb_pending_programs
set RUN_STAT = 'T'
where BRANCH_CODE = '021'
and  EOC_GROUP = 'T'
and FUNCTION_ID = 'ICODEOD';

select * from eitb_pending_programs;

COMMIT;
set echo off
spool off


