set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SPOOL c:\skip_batch.spl


select * from eitb_pending_programs ;

UPDATE eitb_pending_programs SET run_stat='S' WHERE function_id='ICODEOD'
AND branch_code='040' ;
commit ;

select * from eitb_pending_programs ;

set echo off
spool off