-- Evolution of Doubtful loans
select ab.branch_code,ab.account_number "LOAN ACCOUNT",am.DR_PROD_AC "CUSTOMER ACCOUNT", ca.ac_desc,ab.status_code ,ab.creation_date, ab.lcy_balance 
from cltb_account_comp_bal_breakup ab, cltb_account_master am , sttm_cust_account ca
where ab.account_number = am.ACCOUNT_NUMBER
and am.DR_PROD_AC = ca.cust_ac_no
and ab.account_number in (
select account_number
from cltb_account_master m
where m.USER_DEFINED_STATUS like 'DO%')
and ab.component ='PRINCIPAL'
order by ab.account_number,creation_date;

