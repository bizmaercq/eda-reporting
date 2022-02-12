--Verifying the Temporary Posted or Suspense posted Transactions 
-- Count = 0 Means the Batch has been successfully posted

select de.batch_no,de.branch_code,de.account,cu.customer_name1,de.amount,de.upload_stat 
from detb_upload_detail de , sttm_customer cu
where substr(de.account,9,6) = cu.customer_no
and batch_no = &Batch_no  and upload_stat in( 'E','O','S','Y')
order by de.branch_code; 

-- Vefifying Equilibrum in Batch
SELECT SUM( LCY_AMOUNT ) , DRCR_IND  FROM ACTB_DAILY_LOG WHERE BATCH_NO = &Batch_No
AND SUBSTR(TRN_REF_NO , 1, 3) =&Branch AND NVL(IB,'N')='N'
GROUP BY DRCR_IND;


-- Verifying number of lines left to be uploaded from Batch
select branch_code,count(*) 
from detb_upload_detail 
where batch_no = '1001' 
and upload_stat<> 'Y'-- in( 'E','O','S'); 
group by branch_code;
