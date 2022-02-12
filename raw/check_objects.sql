SELECT object_type, count(*) from user_objects group by object_type order by object_type;
SELECT object_name,status from user_objects where status ='INVALID';
select count(*) from actb_daily_log;
SELECT ca.cust_ac_no,ca.lcy_curr_balance FROM sttm_cust_account ca WHERE ca.account_class ='281' order by ca.cust_ac_no;
SELECT ca.cust_ac_no,ca.lcy_curr_balance FROM sttm_cust_account ca WHERE ca.account_class ='381' order by ca.cust_ac_no;
