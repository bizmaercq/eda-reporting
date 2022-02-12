SELECT DISTINCT s.customer_no cust_no ,nvl(s.local_branch, ' ') ,nvl(s.short_name, ' ') cust_name ,s.address_line1 || ',' || s.address_line2 || ',' || s.address_line3 || ',' || s.address_line4 cust_addr ,(SELECT date_of_birth FROM xafnfc.sttm_cust_personal WHERE customer_no = s.customer_no) ,nvl(s.unique_id_value, ' ') unique_no ,a.cust_ac_no ,a.branch_code ,decode(a.ac_stat_frozen, 'A', ' FROZEN ', decode(a.ac_stat_dormant, 'Y', ' DORMANT ', ' ACTIVE ')) ac_stat ,a.acy_uncollected ,a.acy_avl_bal,a.acy_curr_balance ,a.ccy ,a.ac_desc descrip ,a.account_class ,' A ' account_type, xafnfc.fn_getavlbal_with_limit(a.branch_code,a.cust_ac_no)
LMT_AMT FROM xafnfc.sttm_customer s ,xafnfc.sttm_cust_personal p ,xafnfc.sttms_cust_account a ,nfceod.temp_account e
WHERE s.customer_no = a.cust_no AND p.customer_no = s.customer_no and a.cust_ac_no = e.ac_no;

select * from nfceod.temp_account

-- This query is based on the previous to take only some fields
SELECT DISTINCT nvl(s.local_branch, ' ') branch ,s.customer_no cust_no ,a.cust_ac_no ,a.ac_desc descrip ,a.account_class ,decode(a.ac_stat_frozen, 'A', ' FROZEN ', decode(a.ac_stat_dormant, 'Y', ' DORMANT ', ' ACTIVE ')) ac_stat ,a.acy_uncollected ,a.acy_avl_bal,a.acy_curr_balance ,a.ccy , xafnfc.fn_getavlbal_with_limit(a.branch_code,a.cust_ac_no)
LMT_AMT FROM xafnfc.sttm_customer s ,xafnfc.sttm_cust_personal p ,xafnfc.sttms_cust_account a ,nfceod.temp_account e
WHERE s.customer_no = a.cust_no AND p.customer_no = s.customer_no and a.cust_ac_no = e.ac_no;

SELECT DISTINCT nvl(s.local_branch, ' ') branch ,s.customer_no cust_no ,a.cust_ac_no ,a.ac_desc descrip ,a.account_class ,decode(a.ac_stat_frozen, 'A', ' FROZEN ', decode(a.ac_stat_dormant, 'Y', ' DORMANT ', ' ACTIVE ')) ac_stat ,a.acy_uncollected ,a.acy_avl_bal,a.acy_curr_balance ,a.ccy , xafnfc.fn_getavlbal_with_limit(a.branch_code,a.cust_ac_no)
LMT_AMT FROM xafnfc.sttm_customer s ,xafnfc.sttm_cust_personal p ,xafnfc.sttms_cust_account a ,nfceod.temp_account e
WHERE s.customer_no = a.cust_no AND p.customer_no = s.customer_no and a.cust_ac_no = e.ac_no
and substr(s.customer_no,1,3)='021' and a.account_class between '110' and '387';