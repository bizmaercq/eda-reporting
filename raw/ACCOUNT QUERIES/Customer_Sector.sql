select cu.local_branch,cu.customer_name1,mc.code_desc
from sttm_customer cu, mitm_customer_default cd, gltm_mis_code mc
where cu.customer_no = cd.customer
and cd.cust_mis_3 = mc.mis_code
and cu.customer_type <>'I'
order by cu.local_branch, mc.code_desc;

select * from gltm_mis_code
