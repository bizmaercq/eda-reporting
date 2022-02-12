select a.branch_code,c.customer_no,c.customer_name1, a.cust_ac_no,a.ac_desc,a.ac_stat_dormant, a.dormancy_date,a.DATE_LAST_DR,a.DATE_LAST_CR, sum(al.somme) charges
,case when a.lcy_curr_balance <0 then -a.lcy_curr_balance else null end DEbit_Balance,case when a.lcy_curr_balance >=0 then a.lcy_curr_balance else null end Credit_Balance 
from xafnfc.sttm_cust_account a , xafnfc.sttm_customer c ,(select l.ac_no account,l.lcy_amount somme from xafnfc.acvw_all_ac_entries l where l.module = 'IC') al
where a.cust_no = c.customer_no 
and a.CUST_AC_NO = al.account
and a.ac_stat_dormant = 'Y' and a.record_stat ='O'
and a.branch_code = nvl(&branch_code,a.branch_code)
group by a.branch_code,c.customer_no,c.customer_name1, a.cust_ac_no,a.ac_desc,a.ac_stat_dormant, a.dormancy_date,a.DATE_LAST_DR,a.DATE_LAST_CR,a.lcy_curr_balance