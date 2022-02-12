SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance,ca.sal_od_optin FROM sttm_cust_account ca 
WHERE ca.account_class in ('281','282','283','285')
and ca.sal_od_optin ='N'
and ca.lcy_curr_balance <0

SELECT * FROM detb_rtl_teller rt WHERE rt.trn_dt='30/12/2019' and rt.branch_code='021'
