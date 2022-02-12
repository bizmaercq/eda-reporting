set array 1
set line 5000
set head on
set pagesize 10000
set feedback on
set trimspool on
set numformat 9999999999999999.999
set echo on
set colsep ";"
SPOOL C:\XAFNFCFCC0077_1.SPL

select record_stat from sttm_customer where customer_no='040959';

select record_stat from sttm_cust_account where cust_ac_no='0402820104095954';

update sttm_cust_account
set record_stat='C'
where  cust_ac_no='0402820104095954';

update sttm_customer
set record_stat='C'
where  customer_no='040959';

select record_stat from sttm_customer where customer_no='040959';

select record_stat from sttm_cust_account where cust_ac_no='0402820104095954';

commit;

SPOOL OFF
