----------------------------------------------------------------------------------------------------
-------------------------------------- EOD Checks--------------------------------------------
----------------------------------------------------------------------------------------------------

-- TILL / VAULT CHECKS
SELECT * FROM xafnfc.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y' 

SELECT * FROM xafnfc.FBTB_TILL_MASTER WHERE TIL_ID = 'TILL_031_1'
-- Txn Log pending
SELECT * FROM xafnfc.FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') -- AND BRANCHCODE='002'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE

--UPDATE FBTB_TXNLOG_MASTER SET TXNSTATUS='DIS',STAGESTATUS='DIS' WHERE TXNSTATUS NOT IN ('COM','DIS','REV','FAL')

-- To view Pending WB Teller Transactions
select branchcode, FUNCTIONID, b.sub_menu_2, count(*)
  from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b
 where f.txnstatus = 'IPR'
   and f.functionid not in ('TVCL', 'TVQR', 'EODM')
   and b.function_id = F.functionid
   and F.POSTINGDATE='30-MAY-2012'
 group by branchcode, FUNCTIONID, b.sub_menu_2
  ORDER BY BRANCHCODE, F.FUNCTIONID

-- peding trnsaction for user
select F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO,count(*)
from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b, xafnfc.STTM_BRANCH C
where f.txnstatus = 'IPR'
AND C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE IN ('31-MAY-2012')
group by F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO
ORDER BY F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid

-- Branches which are NOT YET completed with EODM
SELECT * FROM XAFNFC.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
( select BRANCH_CODE from XAFNFC.sttb_brn_eodm where RUN_DATE='30-MAY-2012' )

-- Branches that have completed EODM as of current date
select *from xafnfc.sttb_brn_eodm where RUN_DATE=&System_Date format is 'DD-MON-YYYY'

select * from xafnfc.fbtb_txnlog_master WHERE BRANCHCODE = '031'


-- Branches which are completed with EODM
select branch_code,currentpostingdate,nextpostingdate from XAFNFC.fbtm_branch_info 
where currentpostingdate='30-MAY-2012'

select * from fbtm_branch_info  where branch_code='082'
select * from sttm_lcl_holiday where year='2012' /*and branch_code='001'*/ and month=8--082
select * from sttm_dates
select * from sttm_aeod_dates


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
   select branch_code from xafnfc.sttb_brn_eodm where run_date = '&DateEOD'    
)               

-- EODM Completed for below
select * from xafnfc.sttb_brn_eodm where run_date = '&DateEOD'


-- Host Pending items
select * from xafnfc.eivw_pending_items


-- Branches EOD Stage
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE  

SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' and TARGET_STAGE<>'POSTEOFI' ORDER BY BRANCH_CODE


-- Branches EOD Batches Stage
SELECT * FROM XAFNFC.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE  

SELECT * FROM XAFNFC.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   IN ('C','N') ORDER BY BRANCH_CODE--cndbatch


select * from ictb_acc_pr where brn='020' and last_calc_dt<>'30-APR-2012'




SELECT * FROM AETB_EOC_PROGRAMS where EOC_batch='ICEOD' and eod_date='30-APR-2012' and  eoc_batch_status<>'C'


-- EITB 
SELECT * FROM EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='020'

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, 
DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status
FROM XAFNFC.STTM_DATES A, XAFNFC.STTM_BRANCH B
WHERE A.BRANCH_CODE = B.BRANCH_CODE
ORDER BY STATUS, TODAY, A.BRANCH_CODE


-- EOC Run Chart
SELECT * FROM AETB_EOC_RUNCHART where EOC_STAGE_STATUS='A' AND EOC_STAGE='MARKEOD'


-- SWITCH ON DEBUG

UPDATE CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG'
 
INSERT INTO CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM SMTB_MODULES )

UPDATE CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID'


-- SWITCH OFF DEBUG

UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID'
UPDATE CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'
 


--DUPLICATE TRANSACTIONS

SELECT DISTINCT GG.* FROM ( 

 SELECT SUBSTR(TRN_REF_NO,1,3)"BRANCH",PRODUCT,EXTERNAL_REF_NO,AC_NO,DRCR_IND,LCY_AMOUNT,USER_ID

 FROM xafnfc.ACTB_DAILY_LOG

 WHERE AC_BRANCH =AC_BRANCH

 AND CUST_GL='A'

 AND AUTH_STAT='A'

 AND NVL(DELETE_STAT,'Y')<>'D'

  AND EXTERNAL_REF_NO IN

      (select XREFID

         from xafnfc.fbtb_txnlog_master

        where txnstatus = 'COM'

          and to_date(to_char(wfinitdate,'DD-MON-YYYY'))=to_date(TO_char(sysdate,'DD-MON-YYYY'))) ) GG,

 (

 SELECT SUBSTR(TRN_REF_NO,1,3)"BRANCH",PRODUCT,EXTERNAL_REF_NO,AC_NO,DRCR_IND,LCY_AMOUNT,USER_ID

 FROM xafnfc.ACTB_DAILY_LOG

 WHERE AC_BRANCH =AC_BRANCH

 AND CUST_GL='A'

 AND AUTH_STAT='A'

 AND NVL(DELETE_STAT,'Y')<>'D'

  AND EXTERNAL_REF_NO IN

      (select XREFID

         from xafnfc.fbtb_txnlog_master

        where txnstatus = 'COM'

                and to_date(to_char(wfinitdate,'DD-MON-YYYY'))=to_date(TO_char(sysdate,'DD-MON-YYYY'))) )HH

 WHERE GG.BRANCH=HH.BRANCH

 AND GG.PRODUCT=HH.PRODUCT

 AND GG.AC_NO=HH.AC_NO

 AND GG.DRCR_IND=HH.DRCR_IND

 AND GG.LCY_AMOUNT=HH.LCY_AMOUNT   

 AND GG.EXTERNAL_REF_NO<>HH.EXTERNAL_REF_NO  

 order by gg.lcy_amount  

SELECT * FROM  xafnfc.CLTB_ACCOUNT_MASTER WHERE CUSTOMER_ID = '014311'

SELECT * FROM xafnfc.CLTB_ACCOUNT_SCHEDULES WHERE ACCOUNT_NUMBER = '020M06S121190014'  AND COMPONENT_NAME = 'PRINCIPAL'   --0202820100142243

SELECT * FROM  xafnfc.STTM_CUST_ACCOUNT WHERE CUST_AC_NO = '0202820100142243'--CUST_NO = '014214'
 
SELECT * from xafnfc.eivw actn_daily_log

select * from  xafnfc.sttm_customer where customer_name1 like '%CHOUMEL%'

SELECT * from xafnfc.ACVW_ALL_AC_ENTRIES WHERE RELATED_ACCOUNT = '020M06S121190014'
