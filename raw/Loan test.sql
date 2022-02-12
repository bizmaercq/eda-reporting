select b.branch_code, b.account_number, m.DR_PROD_AC,m.PRIMARY_APPLICANT_NAME, m.USER_DEFINED_STATUS,b.balance
from cltb_account_comp_bal_breakup b  , cltb_account_master m
where b.account_number = m.ACCOUNT_NUMBER
and b.component ='PRINCIPAL'
and m.USER_DEFINED_STATUS like 'DO%'
and b.balance <>0
and b.creation_date between '01/03/2013' and '22/03/2013'

select ab.branch_code,ab.account_number "LOAN ACCOUNT",am.DR_PROD_AC "CUSTOMER ACCOUNT", ca.ac_desc,ab.status_code ,ab.creation_date, ab.lcy_balance 
from cltb_account_comp_bal_breakup ab, cltb_account_master am , sttm_cust_account ca
where ab.account_number = am.ACCOUNT_NUMBER
and am.DR_PROD_AC = ca.cust_ac_no
and ab.account_number in (
select b.account_number
from cltb_account_comp_bal_breakup b  , cltb_account_master m
where b.account_number = m.ACCOUNT_NUMBER
and b.component ='PRINCIPAL'
and m.USER_DEFINED_STATUS like 'DO%'
and b.balance <>0)
and ab.component ='PRINCIPAL'
order by ab.account_number,creation_date;



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

