accept uid PROMPT 'Enter the SMS schema/oracle user name ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

SPOOL C:\table_tbs.spl


select segment_name,segment_type,tablespace_name,count(*) No_of_Obj,sum(bytes)/1048576 size_Mb
from user_segments
group by segment_name,segment_type,tablespace_name;

spool off