SET SERVEROUTPUT ON SIZE 100000
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
SPOOL C:\Customer_Rebuild.spl
show user;

BEGIN
  GLOBAL.PR_INIT('040', 'SYSTEM');
  
    IF NOT glpkss_mis_rebuild.fn_build_custacc('040','M07','FY2012','XAF') 
    then
      dbms_output.put_line('fn_cust_gl_breakup failed ');
      Rollback;
    Else
      if not glpkss_rebuild.fn_rebuild_cust_gl('040','M07','FY2012','Y','XAF') 
      then
        dbms_output.put_line('fn_rebuild_cust_gl failed ');
        Rollback;
      end if;
    End if;
    dbms_output.put_line('success......');
  commit;
EXCEPTION
  when others then
    dbms_output.put_line('sqlerrm' || sqlerrm);
END;
/
SPOOL OFF