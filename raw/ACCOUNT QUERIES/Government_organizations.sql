SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc,ca.ac_open_date,ca.lcy_curr_balance 
FROM sttm_cust_account ca 
WHERE ca.account_class in ('161','162','163','171','191') 
and ca.record_stat ='O'
order by ca.branch_code,ca.cust_ac_no ;
