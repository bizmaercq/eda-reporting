set array 1
set line 5000
set head on
set pagesize 10000
set feedback on
set trimspool on
set numformat 9999999999999999.999
set echo on
set colsep ";"
SPOOL C:\Liab_det.SPL

select * from getb_utils where liab_id =(select id from getm_liab where liab_no= '&LIAB') order by  util_id, version_no;


SPOOL OFF