--- checking the desequilibrate batch ---
select * FROM  actb_daily_log lo where lo.batch_no = '1026'
SELECT * FROM getm_liab WHERE id = '91822'; 

--- --- checking the validated desequilibrate batch --- ---
select*from  fbtb_txnlog_master ff where ff.txnactdet='0231720101560102' and ff.txnamtdet='8785000.' --for update
select * from  actb_daily_log dd where dd.auth_stat = 'U' and dd.module = 'CG'
select * from  actb_history hi where hi.batch_no = '0646'
select * from  actb_history where external_ref_no ='FJB1334001918728'and trn_dt ='&date'
select * from  actb_history where txn_init_date = '17-july-2012' and lcy_amount = '100000'
 acvw_all_ac_entries_fin

--- petite requete perso ---
select ac.brancmh_code,ac.cust_ac_no,ac.ac_desc,ac.ac_open_date,ac.maker_id from  sttm_cust_account ac
where ac.date_last_cr not between to_date('&start_date','DD/MM/YYYY') and to_date('&end_date','DD/MM/YYYY')
and ac.account_type in ('U','S') and ac.auth_stat = 'A'

select ac.branch_code, ac.cust_no, ac.cust_ac_no, ac.ac_desc, ac.ac_open_date, ac.alt_ac_no from  sttm_cust_account ac
where ac.branch_code='023' order by cust_no, cust_ac_no
 
select * from  sttm_cust_account ac
--- VOIR TOUTES LES SIGNATURES non autorisées

SELECT * FROM  svtm_acc_sig_master cc where cc.auth_stat = 'U'
SELECT * FROM  svtm_acc_sig_master cc where cc.MAKER_DT_STAMP='&DATE'
SELECT * FROM  svtm_acc_sig_det cc where cc.SIG_MSG <> 'A'
select * from  svtm_cif_sig_master dd where dd.auth_stat = 'X'
-- 
select * from  sttb_record_log where auth_stat = 'U' order by KEY_ID for update;
----------------------------------------------------------------------------------------------------
-------------------------------------- EOD Checks --------------------------------------------------
select * from aetb_eoc_branches_history where branch_code='042';
--- users release  ---

select * from  smtb_current_users c where c.current_branch = '031' order by HOME_BRANCH for update
select * from  smtb_current_users where user_id ='%JCHOU%'
select * from  smtb_user where user_id like 'MC%'
select * from  smtb_user 
select * from  smtb_current_users--for update --where user_id = 'MCA'
--- Branches which are NOT YET completed with EODM ---
SELECT * FROM  STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from  sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

SELECT * FROM  sttm_trncode
-- Host Pending items   
select * from  eivw_pending_items XA where xa.id = 'SYSTAC'
 ---- Vérifier si un debug est activé ------
SELECT * FROM  cstb_debug_users xa where xa.debug = 'Y'

--- To clear all the login user --- 
 delete  SMTB_CURRENT_USERS where user_id='&user_id'
  commit;

CREATE TABLE DAILY_log_01_07_2015 as select * from  actb_daily_log a where a.ac_branch='023' and AUTH_STAT='U';
select * from  actb_daily_log a where a.ac_branch='024' and AUTH_STAT='U' ---for update;
---------------------------------------------
select * from sttm_trn_code where trn_code='EFB'
select * from gltm_glmaster where gl_code like '37%'

--- ff / VAULT CHECKS --- ---

SELECT * FROM  FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'  ORDer by branch_code
SELECT * FROM  FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y' AND BRANCH_CODE='021' ORDer by branch_code
SELECT * FROM  FBTB_TILL_MASTER WHERE BALANCED_IND='N'

 --- Txn Log pending
SELECT * FROM  FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') -- AND BRANCHCODE='002'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE --for update

--UPDATE FBTB_TXNLOG_MASTER SET TXNSTATUS='DIS',STAGESTATUS='DIS' WHERE TXNSTATUS NOT IN ('COM','DIS','REV','FAL')

select * from  eivw_pending_items cd where cd.MD <> 'MA'
select * from  sttb_record_log where auth_stat = 'U'

--- To view Pending WB Teller Transactions ---
select branchcode, FUNCTIONID, b.sub_menu_2, count(*)
  from  fbtb_txnlog_master f,  smtb_function_description b
 where f.txnstatus = 'IPR'
   and f.functionid not in ('TVCL', 'TVQR', 'EODM')
   and b.function_id = F.functionid
   and F.POSTINGDATE='&Date'
 group by branchcode, FUNCTIONID, b.sub_menu_2
 order by BRANCHCODE, F.FUNCTIONID
--- peding trnsaction for user ---
select F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO,count(*)
from  fbtb_txnlog_master f,  smtb_function_description b,  STTM_BRANCH C
where f.txnstatus = 'IPR'
and C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE IN ('&DATE')
group by F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO 
order by F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid, ASSIGNEDTO



select * from  fbtb_txnlog_master where POSTINGDATE in ('30/05/2014') and txnstatus='IPR' and makerid ='QMBAKU'

--- Branches which are NOT YET completed with EODM ---
SELECT * FROM  STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from  sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

select * from  sttb_brn_eodm where RUN_DATE='17-dec-2013' order by BRANCH_CODE

--- Branches which are completed with EODM
select branch_code,currentpostingdate,nextpostingdate from  fbtm_branch_info 
where currentpostingdate='&DATE'

select * from fbtm_branch_info  where branch_code='082' for update 
select * from sttm_lcl_holiday where year='2012' /*and branch_code='001'*/ and month=8--082
select * from sttm_dates
select * from  sttm_aeod_dates


--- To view Branches ready for EODM run
select branch_code from 
(
  select branch_code
  from  sttm_branch
  where branch_code not in (SELECT D.BRANCH_CODE
                             FROM  FBTB_TILL_MASTER d
                            WHERE D.BALANCED_IND = 'N'
                            GROUP BY D.BRANCH_CODE)
   MINUS 
   select branch_code from  sttb_brn_eodm where run_date = '31/05/2012'    
)               

-- EOD Completed for below
select * from  sttb_brn_eodm where run_date = '28-may-2013'

 
-- Host Pending items   
select * from  eivw_pending_items XA where xa.id = 'CSUNYIN'
select * from  eivw_pending_items XA

-- Branches EOD Stage  //run this when some package is Aborted
SELECT * FROM  AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE  
SELECT * FROM  AETB_EOC_BRANCHES WHERE EOC_STATUS='C' ORDER BY BRANCH_CODE
SELECT * FROM  AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' and TARGET_STAGE='POSTEOFI' ORDER BY BRANCH_CODE
select * from  Fbtb_Txnlog_Details where xrefid = 'FJB1334001918728'
select * from  FBTB_TXNLOG_MASTER xx
where xx.branchcode='043'
and xx.postingdate='29/05/2012' AND xx.xrefid = 'FJB1214400900751' for update xx.TXNSTATUS='IPR'
select * from  FBTB_TILL_MASTER
WHERE BRANCH_CODE='023'


SELECT * FROM  FBTM_FUNCT
--- Branches EOD Batches Stage //run this when some package is Aborted
SELECT * FROM  AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE  
SELECT * FROM  AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   IN ('C','N') ORDER BY BRANCH_CODE--cndbatch
select * from  ictb_acc_pr where brn='020' and last_calc_dt<>'08/05/2012'
SELECT * FROM  AETB_EOC_PROGRAMS where EOC_batch='ICEOD' and eod_date='30-APR-2012' and  eoc_batch_status<>'C'

select * from  smtb_role_detail
-- EITB 
SELECT * FROM  EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='010'

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, 
DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status
FROM  STTM_DATES A,  STTM_BRANCH B
WHERE A.BRANCH_CODE = B.BRANCH_CODE
ORDER BY STATUS, TODAY, A.BRANCH_CODE


-- EOC Run Chart //run this when some package is Aborted
select * FROM  AETB_EOC_RUNCHART where EOC_STAGE_STATUS='A';
select * from  actb_daily_log dd where dd.external_ref_no = 'FJB1403802037597'
-- SWITCH ON DEBUG

--1 run this first
UPDATE  CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG'

--2 run this second
UPDATE  CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID'
 
--3 run if number of updated rows is 0 on script 2
INSERT INTO  CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM  SMTB_MODULES )


-- Verify if Debug is active for any user

SELECT * FROM  cstb_debug_users xa where xa.debug = 'Y'

-- SWITCH OFF DEBUG check this every times before start the EOD ---

UPDATE  CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID'
UPDATE  CSTB_DEBUG_USERS SET DEBUG='N' WHERE debug='Y'

UPDATE  CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'

-- After Eod check below tables for date befor go to restart ---

select branch_code,end_of_input from  sttm_branch ---end_of_input should be 'N' for all the branch---
select dd.branch_code,dd.currentpostingdate,nextpostingdate from  fbtm_branch_info dd -- currentpostingdate should be next bussiness day
select branch_code,today,prev_working_day,next_working_day from  sttm_dates order by branch_code


select * from  acvw_all_ac_entries ac where ac.LCY_AMOUNT = 74500 and ac.TRN_DT = '02-AUG-2013' and ac.USER_ID = 'INKWAIN'
SELECT * FROM  actb_daily_log where user

select * from  fbtb_txnlog_details ma where ma.
--- extractions mouvement d'un compte
select ac_branch,ac_no,module,user_id,batch_no,ac_entry_sr_no,period_code,trn_dt,value_dt,lcy_amount,trn_code from  ACTB_HISTORY where ac_no='0202820100721430' and module='DE'

SELECT count(*) FROM  actb_daily_log;

---- tyraitement ATM ------
-- Update date de generation des fichiers GIMAC---
select * from  gitm_interface_definition where external_system ='FLEXSWITCH' for update;

select * from aetb

select * from  fbtb_txnlog_master f,

-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

------ Adding Account and CIF in payway-------

select * from Custacc_Temp_09oct2015 for UPDATE ---- Account

select * from Cust_Temp for UPDATE ------ CIF

---------------------------------------------------------------------------------------------------------------

​SELECT * FROM ACVW_ALL_AC_ENTRIES WHERE TRN_DT BETWEEN '01-JUL-2015' AND '31-DEC-2015' AND MODULE='DE' AND TRN_CODE<>'SAL'


select * from acvw_all_ac_entries WHERE TRN_DT BETWEEN '01-JUL-2015' AND '31-DEC-2015' AND MODULE='DE' AND TRN_CODE<>'SAL'

alter system kill session '2724,30305' ;

ALTER SYSTEM KILL SESSION '2184,3';

select * from dba_objects where status='INVALID'; 
