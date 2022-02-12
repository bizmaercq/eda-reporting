set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999

SPOOL c:\manual_mark_eofi_021.spl

declare
  p_errcode varchar2(200) := '';
begin
  global.pr_init('021', 'SYSTEM');
  wrp_batch.pr_aeodmarkeofi(p_errcode, '021', 'SYSTEM', '');
  dbms_output.put_line(p_errcode);

end;
/

commit;

set echo off
spool off
