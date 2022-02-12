set array 1
set head on
set feedback on
set line 10000
set pagesize 50000
set echo on
set trimspool on
set colsep ';'
spool c:\si_details.spl

select * from sitb_contract_master a ,sitb_instruction b where 
a.instruction_no=b.instruction_no
and b.next_exec_date=to_date('22-12-2012','dd-mm-yyyy');

select * from SITB_INSTRUCTION where next_exec_date=to_date('22-12-2012','dd-mm-yyyy');

SELECT * FROM SITBS_CYCLE_DUE_EXEC WHERE INSTRUCTION_NO in 
(select instruction_no from SITB_INSTRUCTION where next_exec_date=to_date('22-12-2012','dd-mm-yyyy')) ;

select * from sitb_contract_master a ,sitb_instruction b, sttm_cust_account c where 
a.instruction_no=b.instruction_no
and b.next_exec_date=to_date('22-12-2012','dd-mm-yyyy')
and c.cust_ac_no=a.dr_account;

spool off 