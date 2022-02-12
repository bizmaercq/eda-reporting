select cu.local_branch,cu.customer_no,cu.customer_name1,co.description country ,cu.address_line1,'NON RESIDENT' Status
from sttm_customer cu,sttm_cust_personal  cp , sttm_country  co
where cu.customer_no = cp.customer_no
and cu.country = co.country_code
and cP.resident_status <>'R'
order by cu.local_branch,cu.customer_name1
