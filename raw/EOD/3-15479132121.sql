SET SERVEROUTPUT ON SIZE 1000000
SET BUFFER 10000000
SET ARRAY 1
SET PAU OFF
SET HEAD ON
SET FEEDBACK ON
SET LINES 32767
SET PAGESIZE 50000
SET ECHO ON
SET TRIMSPOOL ON
SET COLSEP ";"
SET LONG 2000000000
SET TIME ON
SET TIMING ON
SET numformat 999999999999999999999.99

spool c:\3-15479132121.spl

select * from eitb_pending_programs where branch_code = '040';

update eitb_pending_programs 
set run_stat = 'S'
where branch_code = '040'
and run_stat = 'T'
and eoc_group = 'F';



commit;

select * from eitb_pending_programs where branch_code = '040';

spool off