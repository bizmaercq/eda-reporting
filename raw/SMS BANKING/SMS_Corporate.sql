set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

declare
  Cursor C_Corporate_Cust_Account  is select cu.customer_no,ca.cust_ac_no from sttm_cust_account ca, sttm_customer  cu where cu.customer_no = ca.cust_no and cu.customer_type ='C'
begin

  
end;
