

-- Query to have the Accounts positions 
select a.branch_code BRANCH ,c.customer_name1 STAFF , a.cust_ac_no ACCOUNT, a.ac_desc DESCRIPTION, a.lcy_curr_balance BALANCE
from sttm_cust_account a, sttm_customer c
where a.cust_no = c.customer_no
and a.account_class = 281
and a.acc_status ='NORM'
order by a.lcy_curr_balance desc;


-- Query to have the ongoing loans and balances for staff

select m.BRANCH_CODE, m.CUSTOMER_ID,  c.customer_name1,m.PRODUCT_CODE, b.status_code,b.component ,b.balance
from cltb_account_comp_bal_breakup b, cltb_account_master m, sttm_customer c
where b.account_number = m.ACCOUNT_NUMBER
and m.CUSTOMER_ID = c.customer_no
and b.component ='PRINCIPAL'
and substr(m.DR_PROD_AC,4,3) ='281'
and b.lcy_balance <>0






