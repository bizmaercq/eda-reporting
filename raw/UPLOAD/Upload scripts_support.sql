-- Verify the effectively posted Transactions
-- Count should be equal to the number of lines in the .csv File
select * from actb_daily_log ac where ac.batch_no='0261' and substr(ac.trn_ref_no,1,3)= &Branch and nvl(ib,'N')='N' ;
-- verifying equilibrum of batches
select ah.trn_ref_no,ah.ac_branch, ah.ac_no,ah.ac_ccy,sum(decode(drcr_ind, 'D',lcy_amount,0) ) as Dr, sum(decode(drcr_ind, 'C',lcy_amount,0) ) Cr from actb_history ah
where batch_no ='0001'
group by ah.trn_ref_no,ah.ac_branch, ah.ac_no,ah.ac_ccy

select distinct batch_no from actb_daily_log

select count(*) 
from actb_daily_log ac 
where ac.batch_no='1001' 
--and substr(ac.trn_ref_no,1,3)= &Branch 
and nvl(ib,'N')='N' ;

select * from actb_history where batch_no ='0001'

select * from actb_daily_log where batch_no ='0001'

--Verifying the Temporary Posted or Suspense posted Transactions 
-- Count = 0 Means the Batch has been successfully posted
select * from detb_upload_detail where batch_no = '&Batch' and branch_code =&Branch and upload_stat not  in( 'E','O','S');  
select * from detb_upload_detail where batch_no = '&Batch' and branch_code =&Branch and upload_stat in( 'E','O','S'); 

select * from detb_upload_detail where batch_no = '&Batch'  and branch_code= &Branch and upload_stat in( 'E','O','S'); 

select count(*) from detb_upload_detail where batch_no = '&Batch' and branch_code =&Branch and upload_stat in( 'E','O','S'); 


-- Vefifying Equilibrum in Batch
SELECT SUM( LCY_AMOUNT ) , DRCR_IND  FROM ACTB_DAILY_LOG WHERE BATCH_NO = &Batch_No
AND SUBSTR(TRN_REF_NO , 1, 3) =&Branch AND NVL(IB,'N')='N'
GROUP BY DRCR_IND

select * from actb_daily_log ac where ac.batch_no='&Batch' and substr(ac.trn_ref_no,1,3)= &Branch and nvl(ib,'N')='N' ;

select substr(ac.trn_ref_no,1,3),count(*)
from cactb_daily_log ac 
where ac.batch_no='&Batch'
and nvl(ib,'N')='N' 
group by substr(ac.trn_ref_no,1,3);

select branch_code,count(*) 
from detb_upload_detail 
where batch_no = '&Batch' 
and upload_stat<> 'Y'-- in( 'E','O','S'); 
group by branch_code;


select *
from detb_upload_detail 
where batch_no = '1002' 
and upload_stat in('E','O', 'S');

--  Check any entries posted which is not there in  upload file ( suspense )

select  * from acvw_all_ac_entries where batch_no ='0262' and
( ac_no , curr_no ) not in ( select account , curr_no  
from 
--Detb_Upload_Detail_History  -- history table
Detb_Upload_Detail -- today upload
where batch_no ='0262' )
 and value_date  = '27/08/2012'                             ) and nvl(IB,'N') ='N'
 and  value_dt  = '27/08/2012'     ;
 
 
-- if anythign return then check 
select  * from Detb_Upload_Detail_History where ( account , curr_no ) in 
( select   ac_no , curr_no  from acvw_all_ac_entries where batch_no ='9188' and
( ac_no , curr_no ) not in ( select account , curr_no  
from 
Detb_Upload_Detail_History  -- history table
--Detb_Upload_Detail -- today upload
where batch_no ='9188' 
 and value_date  = '23-JUL-2012' 
-- and 
) and nvl(IB,'N') ='N' )
  and  value_dt  = '23-JUL-2012'    
  
--  Check any entries which is not posted but there in  upload file ( EOD suspence )
select  * from 
--Detb_Upload_Detail_History -- history
Detb_Upload_Detail         --today
 where batch_no ='0012'
 and value_date ='16/08/2012'
 and
( account , curr_no ) not in ( select ac_no , curr_no  
from acvw_all_ac_entries where batch_no ='0012' and nvl(IB,'N') ='N'
 and value_dt ='16/08/2012'
) 


select a.ac_no , a.value_dt , a.trn_dt , a.financial_cycle , a.period_code from actb_daily_log a
where batch_no='0012'
