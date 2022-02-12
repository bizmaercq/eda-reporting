set linesize 10000
set long 10000
set pagesize 10000
set feedback off
SET ECHO ON
set head on
set trimspool on
set colsep ";"

column column_name format a40
column table_name format a40
column index_name format a50

SPOOL C:\Indexdet.Spl


PROMPT INDEXES
SELECT 	TABLE_NAME,INDEX_NAME,COLUMN_NAME,COLUMN_POSITION 
FROM 	USER_IND_COLUMNS 
ORDER BY 	TABLE_NAME,
		INDEX_NAME,
		COLUMN_POSITION;

SPOOL OFF
