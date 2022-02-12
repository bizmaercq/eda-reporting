select * FROM xafnfc.actb_daily_log
select * from xafnfc.actb_history
----------------------------------------------------------------------------------------------------
-------------------------------------- EOD Checks--------------------------------------------

-- users release

select * from xafnfc.smtb_current_users  ORDER BY USER_ID for update;
----------------------------------------------------------------------------------------------------

-- ff / VAULT CHECKS
SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'
-- Txn Log pending
SELECT * FROM XAFNFC.FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') -- AND BRANCHCODE='002'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE

--UPDATE FBTB_TXNLOG_MASTER SET TXNSTATUS='DIS',STAGESTATUS='DIS' WHERE TXNSTATUS NOT IN ('COM','DIS','REV','FAL')

-- To view Pending WB Teller Transactions
select branchcode, FUNCTIONID, b.sub_menu_2, count(*)
  from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b
 where f.txnstatus = 'IPR'
   and f.functionid not in ('TVCL', 'TVQR', 'EODM')
   and b.function_id = F.functionid
   and F.POSTINGDATE='&Date'
 group by branchcode, FUNCTIONID, b.sub_menu_2
  ORDER BY BRANCHCODE, F.FUNCTIONID
-- peding transaction for user
select F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO,count(*)
from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b, xafnfc.STTM_BRANCH C
where f.txnstatus = 'IPR'
AND C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE IN ('&Date')
group by F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO
ORDER BY F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid


select * from xafnfc.fbtb_txnlog_master where POSTINGDATE IN ('11/05/2012') and txnstatus='IPR'

-- Branches which are NOT YET completed with EODM
SELECT * FROM xafnfc.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from xafnfc.sttb_brn_eodm where RUN_DATE='&DATE' )

SELECT * FROM xafnfc.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from xafnfc.sttb_brn_eodm where to_char(RUN_DATE,'ddmmyyyy')='&DATE' )


select * from XAFNFC.sttb_brn_eodm where RUN_DATE='30-OCT-2012' ORDER BY BRANCH_CODE

-- Branches which are not completed with EODM
select branch_code,currentpostingdate,nextpostingdate from XAFNFC.fbtm_branch_info 
where currentpostingdate='&DATE' ORDER BY branch_code

select * from xafnfc.fbtm_branch_info  where branch_code='082'for update 
select * from xafnfc.sttm_lcl_holiday where year='2012' /*and branch_code='001'*/ and month=8--082
select * from sttm_dates
select * from xafnfc.sttm_aeod_dates


-- To view Branches ready for EODM run
select branch_code from 
(
  select branch_code
  from xafnfc.sttm_branch
  where branch_code not in (SELECT D.BRANCH_CODE
                             FROM xafnfc.FBTB_TILL_MASTER d
                            WHERE D.BALANCED_IND = 'N'
                            GROUP BY D.BRANCH_CODE)
   MINUS 
   select branch_code from xafnfc.sttb_brn_eodm where run_date = '12/06/2012'    
)               

-- EOD Completed for below
select * from xafnfc.sttb_brn_eodm where run_date = '31/10/2012' ORDER BY BRANCH_code

 
-- Host Pending items   
select * from xafnfc.eivw_pending_items XA where xa.id = 'CMENGONG'


-- Branches EOD Stage  and verification of batches execution
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE  
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' and TARGET_STAGE<>'POSTEOFI' ORDER BY BRANCH_CODE

select * from XAFNFC.FBTB_TXNLOG_MASTER xx
where xx.branchcode='041'
and xx.postingdate='08/05/2012' AND xx.TXNSTATUS='IPR'

select * from FBTB_TILL_MASTER
WHERE BRANCH_CODE='023'

-- Branches EOD Batches Stage //run this when some package is Aborted
SELECT * FROM xafnfc.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE  

SELECT * FROM xafnfc.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   IN ('C','N') ORDER BY BRANCH_CODE--cndbatch


select * from xafnfc.ictb_acc_pr where brn='020' and last_calc_dt<>'08/05/2012'




SELECT * FROM xafnfc.AETB_EOC_PROGRAMS where EOC_batch='ICEOD' and eod_date='30-APR-2012' and  eoc_batch_status<>'C'


-- EITB 
SELECT * FROM xafnfc.EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='020'

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, 
DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status
FROM xafnfc.STTM_DATES A, XAFNFC.STTM_BRANCH B
WHERE A.BRANCH_CODE = B.BRANCH_CODE
ORDER BY STATUS, TODAY, A.BRANCH_CODE


-- EOC Run Chart //run this when some package is Aborted
SELECT * FROM xafnfc.AETB_EOC_RUNCHART where EOC_STAGE_STATUS='A'/* AND EOC_STAGE='MARKEOD'*/



---Verify if debug is defined for the  user
SELECT * FROM XAFNFC.CSTB_DEBUG_USERS WHERE USER_ID ='User_ID';

--if this query returns no records then run the following script
INSERT INTO CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM SMTB_MODULES );


-- SWITCH ON DEBUG
UPDATE XAFNFC.CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG';
UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID';


-- After the user has finished executing the transaction 
-- SWITCH OFF DEBUG
UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID';
UPDATE XAFNFC.CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG';
 
-- VERIFIED DEBUB ON
SELECT * FROM xafnfc.cstb_debug_users xa where xa.debug = 'Y'

select * from xafnfc.cstb_debug_users
