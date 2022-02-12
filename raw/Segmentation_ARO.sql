select local_branch, category, customer_no,NAME,address_line1 , TELEPHONE
from
(
select c.local_branch,'INDIVIDUAL' category, c.customer_no,c.customer_name1 NAME,c.address_line1 ,p.mobile_number TELEPHONE
from sttm_customer c , sttm_cust_personal p
where c.customer_no = p.customer_no
and c.customer_type ='I'
and c.customer_no in ( select customer from mitm_customer_default where cust_mis_6 ='&ARO')
union
select c.local_branch,'CORPORATE' category, c.customer_no,c.customer_name1 NAME,c.address_line1 ,d.mobile_number TELEPHONE
from sttm_customer c , sttm_corp_directors d
where c.customer_no = d.customer_no
and c.customer_type ='C'
and c.customer_no in ( select customer from mitm_customer_default where cust_mis_6 ='&ARO')
)
order by local_branch,name
