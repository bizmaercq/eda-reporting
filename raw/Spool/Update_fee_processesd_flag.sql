set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SPOOL c:\Update_fee_processesd_flag.spl


select * from sttb_cust_salary 
where cust_ac_no='0402820104095954';

update sttb_cust_salary
set Fee_Processed_Flag='X'
where cust_ac_no='0402820104095954'
AND Nvl(Fee_Processed_Flag, 'U') =  'U';

commit ;

select * from sttb_cust_salary 
where cust_ac_no='0402820104095954';

set echo off
spool off