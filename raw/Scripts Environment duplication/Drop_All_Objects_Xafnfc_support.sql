--content
set head off;
set feedback off;
spool /home/oracle/scripts/DropDB_03122014.lst;

select 'DROP '||object_type||' '||object_name||';'
from user_objects where
object_type in ('CLUSTER','FUNCTION','LIBRARY','DATABASE LINK','MATERIALIZED VIEW',
'PACKAGE','PROCEDURE','SEQUENCE','SYNONYM','TABLE','TRIGGER','TYPE','VIEW')
and sys_context( 'userenv', 'current_schema' )='XAFNFC' 
order by object_name desc;

spool off;
@/home/oracle/scripts/DropDB_20012014.lst;
purge recyclebin
set head on;
set feedback on;
