set linesize 10000
set array 1
set head on
set pagesize 10000
set long 10000
set trimspool on
spool c:\TabRows.spl
set serverout on size 1000000

declare
   cursor  curTab is select rtrim(ltrim(object_name)) tabname 
		       from user_objects where object_type = 'TABLE';
   rowCnt  NUMBER;
   sqlStmt VARCHAR2(1000);	
	 
begin
   for curVar in curTab
   loop
	sqlStmt := 'SELECT COUNT(*) FROM ' || curVar.tabname;
        EXECUTE IMMEDIATE sqlStmt INTO rowCnt;
	dbms_output.put_line( '-' || lpad(curVar.tabname,30,' ') || ' ' || lpad(rowCnt,30,' '));
   end loop;
end;
/

spool off       