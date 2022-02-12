select customer_no,customer_name1,sum(lcy_amount) 
from xafnfc.actb_history join xafnfc.sttm_customer on related_customer = customer_no
where ac_no in ('374002000','374003000','374005000')
and period_code ='M10'
group by customer_no,customer_name1
having sum(lcy_amount) >1000000
