set colsep '|'
set echo off
set feedback off
set linesize 1000
set pagesize 0
set sqlprompt ''
set trimspool on
set heading on
set headsep on

spool myfile.csv
select 'TIL_ID'||';'||'branch_code'||';'||'USER_ID' from dual;


select TIL_ID||';'||branch_code||';'||USER_ID from XAFNFC.FBTB_TILL_MASTER a WHERE BALANCED_IND<>'Y' ORDer by branch_code;
/
spool off  
/   
   
