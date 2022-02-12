set linesize 10000
set long 10000
set pagesize 10000
set feedback off
SET ECHO ON
set head on
set trimspool on
set colsep ";"

column column_name format a50
column table_name format a50
column index_name format a50

SPOOL C:\Constraints.Spl

PROMPT CONSTRAINTS
Select a.CONSTRAINT_NAME,b.CONSTRAINT_TYPE,a.TABLE_NAME,a.COLUMN_NAME,a.POSITION,b.STATUS 
from USER_CONS_COLUMNS a ,USER_CONSTRAINTS b
where a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
order by TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_TYPE,COLUMN_NAME,POSITION,STATUS
/

SPOOL OFF
