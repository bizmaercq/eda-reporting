select ac.branch_code,ac.ac_open_date,ac.cust_ac_no,cu.customer_name1
from sttm_cust_account ac, sttm_customer cu
where ac.cust_no=cu.customer_no
and ac.record_stat ='O'
and ac.ac_open_date<='10/08/2015'
order by ac.branch_code,cu.customer_name1
