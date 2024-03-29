-- Dormant accounts
select a.branch_code,c.customer_no,c.customer_name1, a.cust_ac_no,a.ac_desc,a.ac_stat_dormant, a.dormancy_date , round((to_date('30/06/2019','DD/MM/YYYY')-a.dormancy_date)/30) Dormancy_months,a.lcy_curr_balance
from sttm_cust_account a , sttm_customer c 
where a.cust_no = c.customer_no 
and a.account_class ='282'
and substr(a.account_class,1,1) in ('1','2')
and a.ac_stat_dormant = 'Y' and a.record_stat ='O'
and round((to_date('31/08/2019','DD/MM/YYYY')-a.dormancy_date)/30) > 2
order by a.dormancy_date ;


-- Debit Dormancy
select a.branch_code,c.customer_no,c.customer_name1, a.cust_ac_no,a.ac_desc,a.ac_stat_dormant, a.dormancy_date , round((to_date('30/06/2019','DD/MM/YYYY')-a.dormancy_date)/30) Dormancy_months,a.date_last_dr_activity,a.lcy_curr_balance
from sttm_cust_account a , sttm_customer c 
where a.cust_no = c.customer_no 
and a.account_class ='282'
and a.ac_stat_dormant = 'Y' and a.record_stat ='O'
and round((to_date('31/08/2019','DD/MM/YYYY')-a.date_last_dr_activity)/30) > 2
order by a.dormancy_date ;


-- Accounts Blocked for debits

select a.branch_code,c.customer_no,c.customer_name1, a.cust_ac_no,a.ac_desc,a.ac_stat_no_dr, a.dormancy_date from sttm_cust_account a , sttm_customer c 
where a.cust_no = c.customer_no 
and a.ac_stat_no_dr = 'Y' 
and a.record_stat ='O';

-- General Dormancy per Branch

SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc,ac.description,ca.ac_stat_dormant,ca.dormancy_date 
FROM sttm_cust_account ca, sttm_account_class ac
WHERE ca.account_class = ac.account_class
and ca.ac_stat_dormant = 'Y'
and ca.branch_code ='050'
order by ac.account_class


--- Deceased and their accounts
SELECT cu.local_branch,cu.customer_no,cu.customer_name1,cu.deceased, ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance
FROM sttm_customer cu, sttm_cust_account ca
WHERE cu.customer_no = ca.cust_no 
and ca.account_class =282
and cu.deceased ='Y' and cu.record_stat ='O'
order by cu.local_branch;

--- Transactions carried out in Dormant accounts
SELECT ae.AC_BRANCH,ae.RELATED_CUSTOMER,cu.customer_name1,da.cust_ac_no,da.dormancy_date,ae.TRN_DT, ae.TRN_REF_NO,acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,ae.MODULE,'TXN',ae.TRN_CODE,'ENG',Ae.AC_NO,Ae.AC_BRANCH,ae.ac_ccy,ae.trn_dt,ae.LCY_AMOUNT),ae.DRCR_IND,ae.LCY_AMOUNT 
FROM acvw_all_ac_entries ae, (SELECT ca.cust_ac_no, ca.dormancy_date from sttm_cust_account ca WHERE ca.dormancy_date between '01/01/2018' and '30/06/2019') da, sttm_customer cu
WHERE ae.AC_NO = da.cust_ac_no
and ae.RELATED_CUSTOMER = cu.customer_no
and da.dormancy_date <= ae.TRN_DT
--and da.dormancy_date between '01/01/2018' and '30/06/2019'
and da.dormancy_date <= '01/01/2018' 
and ae.DRCR_IND ='D'
--and ae.TRN_CODE='GPC' 
and ae.TRN_CODE in ('COM')
--and (ae.TRN_CODE in ('CCQ','CCW','ACW','IIP','AAT','SIO','SIP','CCQ','OGC','OFT') or ae.MODULE ='DE')
and length(ae.ac_no)=16 and ae.TRN_DT between '01/01/2018' and '30/06/2019'
order by ae.AC_BRANCH,ae.AC_NO,ae.TRN_DT;





Manual accounting entries
