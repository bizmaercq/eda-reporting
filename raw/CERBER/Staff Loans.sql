select m.BRANCH_CODE, m.CUSTOMER_ID,  c.customer_name1,m.PRODUCT_CODE, b.status_code,b.component ,b.balance
from cltb_account_comp_bal_breakup b, cltb_account_master m, sttm_customer c
where b.account_number = m.ACCOUNT_NUMBER
and m.CUSTOMER_ID = c.customer_no
and b.component ='PRINCIPAL'
and substr(m.DR_PROD_AC,4,3) ='281'
and b.lcy_balance <>0
