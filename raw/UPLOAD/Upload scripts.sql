-- Verify the effectively posted Transactions
-- Count should be equal to the number of lines in the .csv File
select * from xafnfc.actb_daily_log ac where ac.batch_no='9527' and substr(ac.trn_ref_no,1,3)= &Branch and nvl(ib,'N')='N' and length(ac_no) <> 9 ;
-- verifying equilibrum of batches
select ah.trn_ref_no,ah.ac_branch, ah.ac_no,ah.ac_ccy,sum(decode(drcr_ind, 'D',lcy_amount,0) ) as Dr, sum(decode(drcr_ind, 'C',lcy_amount,0) ) Cr from xafnfc.actb_history ah
where batch_no ='0001'
group by ah.trn_ref_no,ah.ac_branch, ah.ac_no,ah.ac_ccy

select distinct batch_no from xafnfc.actb_daily_log

select count(*) 
from xafnfc.actb_daily_log ac  
where ac.batch_no='0001' 
--and substr(ac.trn_ref_no,1,3)= &Branch 
and nvl(ib,'N')='N' ;

select * from xafnfc.actb_history where batch_no ='9535' and ac_branch ='041' and 

select * from xafnfc.actb_daily_log where batch_no ='9535'

--Verifying the Temporary Posted or Suspense posted Transactions 
-- Count = 0 Means the Batch has been successfully posted
select * from xafnfc.detb_upload_detail where batch_no = &Batch_no and branch_code =&Branch and upload_stat not  in( 'E','O','S');  
select * from xafnfc.detb_upload_detail where batch_no = &Batch_no and branch_code =&Branch and upload_stat in( 'E','O','S'); 

select * from xafnfc.detb_upload_detail where batch_no = &Batch_no  and upload_stat not  in( 'E','O','S');  
select * from xafnfc.detb_upload_detail where batch_no = &Batch_no  and upload_stat in( 'E','O','S'); 

select de.batch_no,de.branch_code,de.account,cu.customer_name1,de.amount,de.upload_stat 
from xafnfc.detb_upload_detail de , sttm_customer cu
where substr(de.account,9,6) = cu.customer_no
and batch_no = &Batch_no  and upload_stat in( 'E','O','S')
order by de.branch_code; 


select * from xafnfc.detb_upload_detail where batch_no = &Batch  and branch_code= &Branch and upload_stat in( 'E','O','S'); 

select count(*) from xafnfc.detb_upload_detail where batch_no = &Batch_no and branch_code =&Branch and upload_stat in( 'E','O','S'); 


-- Vefifying Equilibrum in Batch
SELECT SUM( LCY_AMOUNT ) , DRCR_IND  FROM XAFNFC.ACTB_DAILY_LOG WHERE BATCH_NO = &Batch_No
AND SUBSTR(TRN_REF_NO , 1, 3) =&Branch AND NVL(IB,'N')='N'
GROUP BY DRCR_IND

select * from xafnfc.actb_daily_log ac where ac.batch_no=&Batch_no and substr(ac.trn_ref_no,1,3)= &Branch and nvl(ib,'N')='N' ;

select substr(ac.trn_ref_no,1,3),count(*)
from xafnfc.actb_daily_log ac 
where ac.batch_no='7135'
and nvl(ib,'N')='N' 
group by substr(ac.trn_ref_no,1,3);

--- Monitoring Uploads
select branch_code,count(*) 
from xafnfc.detb_upload_detail 
where batch_no = '9999' 
and upload_stat<> 'Y'-- in( 'E','O','S'); 
group by branch_code;

-- Blocked accounts
select ca.branch_code,ca.cust_ac_no,ca.ac_desc,dl.lcy_amount,ca.ac_stat_no_dr from actb_daily_log dl,sttm_cust_account ca  
WHERE dl.ac_no = ca.cust_ac_no  
and dl.lcy_amount >= 1000000 and dl.batch_no ='9999' and trn_dt ='24/09/2015' and length(dl.ac_no)<>9;

select * from detb_upload_detail where batch_no ='7135' for update

-- Seeing uploded records in actb_daily_log
Select * from actb_daily_log where batch_no ='7135' and auth_stat ='A'

Select count(*) from actb_daily_log where batch_no ='7135' and auth_stat ='U'

select * from detb_batch_master where batch_no ='7135';

SELECT * FROM sttm_cust_account WHERE ac_desc like '%ASHIME IG%'

-- Checking uploded records per branch for a batch
select branch_code, count(*) from detb_upload_detail where batch_no = '&Batch' group by branch_code;

select * from detb_upload_detail where batch_no = '&Batch' for update ;


select *
from xafnfc.detb_upload_detail 
where batch_no = '9999' 
and branch_code ='020'
and upload_stat in('E','O', 'S');

--  Check any entries posted which is not there in  upload file ( suspense )

select  * from xafnfc.acvw_all_ac_entries where batch_no ='0262' and
( ac_no , curr_no ) not in ( select account , curr_no  
from 
--xafnfc.Detb_Upload_Detail_History  -- history table
xafnfc.Detb_Upload_Detail -- today upload
where batch_no ='0262' )
 and value_date  = '27/08/2012'                             ) and nvl(IB,'N') ='N'
 and  value_dt  = '27/08/2012'     ;
 
 
-- if anythign return then check 
select  * from xafnfc.Detb_Upload_Detail_History where ( account , curr_no ) in 
( select   ac_no , curr_no  from xafnfc.acvw_all_ac_entries where batch_no ='1033' and
( ac_no , curr_no ) not in ( select account , curr_no  
from 
xafnfc.Detb_Upload_Detail_History  -- history table
--Detb_Upload_Detail -- today upload
where batch_no ='1033' 
 and value_date  = '26-SEP-2012' 
-- and 
) and nvl(IB,'N') ='N' )
  and  value_date  = '26-SEP-2012'    
  
--  Check any entries which is not posted but there in  upload file ( EOD suspence )
select  * from 
xafnfc.Detb_Upload_Detail_History -- history
--xafnfc.Detb_Upload_Detail         --today
 where batch_no ='0011'
 and value_date ='20/12/2012'
 and
( account , curr_no ) not in ( select ac_no , curr_no  
from xafnfc.acvw_all_ac_entries where batch_no ='0011' and nvl(IB,'N') ='N'
 and value_dt ='20/12/2012'
) 


select a.ac_no , a.value_dt , a.trn_dt , a.financial_cycle , a.period_code from xafnfc.actb_daily_log a
where batch_no='1209'



select distinct batch_no from detb_upload_master

select * from xafnfc.detb_upload_exception


select * from actb_daily_log where batch_no ='2314'

select * from actb_history where trn_dt ='16/11/2012' and batch_no ='8482'

select * from gltb_cust_accbreakup where gl_code = '371006000' and period_code = 'M10' AND FIN_YEAR = 'FY2012' 

delete smtb_current_users where user_id ='PESAME'
