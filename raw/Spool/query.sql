set numformat 999,999,999,999,999,999,999.999
set linesize 10000
set serveroutput on
set echo on
set colsep ";"
set trimspool on
set pagesize 50000
spool c:\query.spl

--GLTB_GL_BAL
select *
  from gltb_gl_bal
 where branch_code = '010'
   and gl_code in ('381005000', '454101000')
   and fin_year = 'FY2012';

/

spool off
