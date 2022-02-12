select branch_code,date_creation,sum(individual) individual,sum(savings) savings,sum(corporate) corporate
from 
(select ac.branch_code, null as Date_Creation,case when cu.customer_type ='I'then count(*) else 0 end as individual, 
case when ac.account_class like '3%' then count(*) else 0 end as Savings,
case when cu.customer_type ='C'then count(*) else 0 end as corporate
from sttm_cust_account ac,sttm_customer cu
where ac.cust_no = cu.customer_no
and ac.record_stat = 'O'
group by ac.branch_code,cu.customer_type,ac.Account_Class)
group by branch_code,date_creation
order by branch_code;

select ca.branch_code,cu.customer_name1,co.description,ca.cust_ac_no,ca.ac_desc 
from sttm_cust_account ca,sttm_customer cu,sttm_country co 
where ca.cust_no = cu.customer_no
and cu.country = co.country_code
and ca.cust_no in (select customer_no from sttm_customer where country <>'CM')
