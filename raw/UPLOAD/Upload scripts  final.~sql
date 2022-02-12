-- Entries that went into suspense
-- past history


select de.batch_no,de.branch_code,de.account,cu.customer_name1,de.addl_text,de.amount,de.upload_stat 
from detb_upload_detail_history de , sttm_customer cu
where substr(de.account,9,6) = cu.customer_no
and batch_no = '9999'  --and upload_stat  in( 'E','O','S')
and de.addl_text like '%SALAIRE MINEFI 10-2018%'
and de.branch_code ='023'
order by de.branch_code; 

-- Actual

select de.batch_no,de.branch_code,de.account,cu.customer_name1,de.amount,de.upload_stat 
from detb_upload_detail de , sttm_customer cu
where substr(de.account,9,6) = cu.customer_no
and batch_no = '9999'  and upload_stat in( 'E','S','O')
--and branch_code in ('020','021','030','040','042')
order by de.branch_code; 


SELECT  uh.batch_no,uh.branch_code,uh.account,cu.customer_name1,uh.amount,uh.upload_stat 
FROM detb_upload_detail_history uh, sttm_customer cu 
WHERE substr(uh.account,9,6) = cu.customer_no
and batch_no='0618' 
and uh.value_date ='22-JUN-2018'  
and uh.branch_code ='051' 
and uh.upload_stat ='S'


--- Monitoring Uploads
select branch_code,count(*) 
from detb_upload_detail 
where batch_no = '9999' 
and upload_stat<>'Y'-- in( 'E','O','S'); 
group by branch_code;
