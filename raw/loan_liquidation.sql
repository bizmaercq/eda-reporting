select substr(related_account,4,4)Code , product_desc,sum(lcy_amount) Liquidated 
from xafnfc.acvw_all_ac_entries join xafnfc.cltm_product
on product_code = substr(related_account,4,4) 
where module ='CL'
and financial_cycle ='FY2012'
and period_code = 'M11'
and event ='ALIQ' and trn_code ='LQP'
group by substr(related_account,4,4),product_desc
order by substr(related_account,4,4);

select * from user_tables where table_name like '%GL%'

select * from gltm_glmaster

select * from CSTM_PRODUCT_STATUS_GL 

select * from GLTM_FMS_MAPPING 
where central_bank_code in 
('C01','C02','C03','C04','C05','C06','C07','C11','C12','C13','C14','C15','C16','C17','C2C','C2J','C2K','C2L','C22','C23','C2M','C2N','C2D','C2E','C2F','C2G','C2H','C26','C27','C29');

select * from cltm_product
