select hi.financial_cycle,hi.period_code,hi.ac_branch,mc.code_desc, pr.product_description, sum(hi.lcy_amount) Revenue 
from actb_history hi, cstm_product pr, mitm_customer_default mi, gltm_mis_code mc
where hi.product = pr.product_code
and mi.customer = hi.related_customer
and mi.cust_mis_3 = mc.mis_code
and hi.ac_no like '7%'
group by  hi.financial_cycle,hi.period_code,hi.ac_branch,mc.code_desc, pr.product_description
order by hi.financial_cycle,hi.period_code,hi.ac_branch
