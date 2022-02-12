
-- VOIR TOUTES LES SIGNATURES non autorisées

SELECT * FROM svtm_acc_sig_master cc where cc.auth_stat = 'U'
SELECT * FROM svtm_acc_sig_det cc where cc.SIG_MSG <> 'A'
select * from svtm_cif_sig_master dd where dd.auth_stat = 'U'
----------------------------------------------------------------------------------------------------
-------------------------------------- EOD Checks---------------------------------------------------

--- users release  ---


select * from smtb_current_users  for update
select * from smtb_current_users 

-- To clear all the login user--- 
 DELETE SMTB_CURRENT_USERS where user_id='&user_id'
COMMIT;


---------------------------------------------

-- ff / VAULT CHECKS
SELECT * FROM FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'
-- Txn Log pending
SELECT * FROM FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') -- AND BRANCHCODE='002'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE;

--UPDATE FBTB_TXNLOG_MASTER SET TXNSTATUS='DIS',STAGESTATUS='DIS' WHERE TXNSTATUS NOT IN ('COM','DIS','REV','FAL')

select * from eivw_pending_items cd where cd.MD <> 'MA'


-- To view Pending WB Teller Transactions
select branchcode, FUNCTIONID, b.sub_menu_2, count(*)
  from fbtb_txnlog_master f, smtb_function_description b
 where f.txnstatus = 'IPR'
   and f.functionid not in ('TVCL', 'TVQR', 'EODM')
   and b.function_id = F.functionid
   and F.POSTINGDATE='&Date'
 group by branchcode, FUNCTIONID, b.sub_menu_2
 order by BRANCHCODE, F.FUNCTIONID
--- peding trnsaction for user ---
select F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO,count(*)
from fbtb_txnlog_master f, smtb_function_description b, STTM_BRANCH C
where f.txnstatus = 'IPR'
AND C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE IN ('&DATE')
group by F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO 
order by F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid, ASSIGNEDTO



select * from fbtb_txnlog_master where POSTINGDATE in ('19/07/2013') and txnstatus='IPR' and makerid ='QMBAKU'

-- Branches which are NOT YET completed with EODM
SELECT * FROM STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

select * from sttb_brn_eodm where RUN_DATE='28-MAY-2013' order by BRANCH_CODE

--- Branches which are completed with EODM
select branch_code,currentpostingdate,nextpostingdate from fbtm_branch_info 
where currentpostingdate='&DATE'

select * from fbtm_branch_info  where branch_code='082' for update 
select * from sttm_lcl_holiday where year='2012' /*and branch_code='001'*/ and month=8--082
select * from sttm_dates
select * from sttm_aeod_dates


-- To view Branches ready for EODM run
select branch_code from 
(
  select branch_code
  from sttm_branch
  where branch_code not in (SELECT D.BRANCH_CODE
                             FROM FBTB_TILL_MASTER d
                            WHERE D.BALANCED_IND = 'N'
                            GROUP BY D.BRANCH_CODE)
   MINUS 
   select branch_code from sttb_brn_eodm where run_date = '31/05/2012'    
)               

-- EOD Completed for below
select * from sttb_brn_eodm where run_date = '28-may-2013'

 
-- Host Pending items   
select * from eivw_pending_items XA where xa.id = 'CSUNYIN'
select * from eivw_pending_items XA

-- Branches EOD Stage  //run this when some package is Aborted
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE  
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS='C' ORDER BY BRANCH_CODE
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' and TARGET_STAGE='POSTEOFI' ORDER BY BRANCH_CODE
select * from Fbtb_Txnlog_Details where xrefid = 'FJB1214400900751'
select * from FBTB_TXNLOG_MASTER xx
where xx.branchcode='043'
and xx.postingdate='29/05/2012' AND xx.xrefid = 'FJB1214400900751' for update xx.TXNSTATUS='IPR'

select * from FBTB_TILL_MASTER
WHERE BRANCH_CODE='023'


SELECT * FROM FBTM_FUNCT
--- Branches EOD Batches Stage //run this when some package is Aborted
SELECT * FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE  
SELECT * FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   IN ('C','N') ORDER BY BRANCH_CODE--cndbatch
select * from ictb_acc_pr where brn='020' and last_calc_dt<>'08/05/2012'
SELECT * FROM AETB_EOC_PROGRAMS where EOC_batch='ICEOD' and eod_date='30-APR-2012' and  eoc_batch_status<>'C'

select * from smtb_role_detail
-- EITB 
SELECT * FROM EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='020'

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, 
DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status
FROM STTM_DATES A, STTM_BRANCH B
WHERE A.BRANCH_CODE = B.BRANCH_CODE
ORDER BY STATUS, TODAY, A.BRANCH_CODE


-- EOC Run Chart //run this when some package is Aborted
select * FROM AETB_EOC_RUNCHART where EOC_STAGE_STATUS='A';
select * from actb_daily_log dd where dd.external_ref_no = 'FJB1309901469723'
-- SWITCH ON DEBUG

--1 run this first
UPDATE CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG'

--2 run this second
UPDATE CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID'
 
--3 run if number of updated rows is 0 on script 2
INSERT INTO CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM SMTB_MODULES )


-- Verify if Debug is active for any user

SELECT * FROM cstb_debug_users xa where xa.debug = 'Y'

-- SWITCH OFF DEBUG check this every times before start the EOD ---

UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID'

UPDATE CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'

-- After Eod check below tables for date befor go to restart ---

select branch_code,end_of_input from sttm_branch ---end_of_input should be 'N' for all the branch---
select dd.branch_code,dd.currentpostingdate,nextpostingdate from fbtm_branch_info dd -- currentpostingdate should be next bussiness day
select branch_code,today,prev_working_day,next_working_day from sttm_dates order by branch_code


select * from acvw_all_ac_entries ac where ac.LCY_AMOUNT = 74500 and ac.TRN_DT = '02-AUG-2013' and ac.USER_ID = 'INKWAIN'
