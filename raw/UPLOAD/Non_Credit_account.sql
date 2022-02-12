select de.branch_code,cu.customer_no, cu.customer_name1,  de.account,de.addl_text,de.amount
from detb_upload_detail_history de , sttm_customer cu
where substr(de.account,9,6) = cu.customer_no
and batch_no = '9999'  and upload_stat <>'Y' --in( 'E','O','S')
and de.addl_text like '%SALAIRE MINEFI 10-2017%'
and de.account not in 
( SELECT ae.ac_no FROM actb_history ae WHERE ae.batch_no ='9999' and ae.trn_code ='SAL' and ae.trn_dt ='25-OCT-2017' )
 order by de.branch_code
