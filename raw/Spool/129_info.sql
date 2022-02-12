set array 1
set head on
set feedback on
set line 10000
set pagesize 50000
set echo on
set trimspool on
set colsep ';'
spool c:\129_info.spl

select * from detbs_rtl_teller where xref = 'FJB1221901028678';

select xref, count(*) from detbs_rtl_teller group by xref having count(*) > 1;

spool off