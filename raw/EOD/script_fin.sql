﻿--- checking the desequilibrate batch ---
select * FROM xafnfc.actb_daily_log lo where lo.batch_no = '1026'
SELECT * FROM getm_liab WHERE id = '91822'; 

--- --- checking the validated desequiliFbrate batch --- ---
select*from xafnfc.fbtb_txnlog_master ff where ff.txnactdet='0231720101560102' and ff.txnamtdet='8785000.' --for update
select * from xafnfc.actb_daily_log dd where dd.auth_stat = 'U' and dd.module = 'CG'
select * from xafnfc.actb_history hi where hi.batch_no = '7210'--- and hi.txn_init_date = '31-OCT-2017' and hi.ac_branch='010'
select * from xafnfc.actb_history where external_ref_no ='FJB1334001918728'and trn_dt ='&date'
select * from xafnfc.actb_history where txn_init_date = '17-july-2012' and lcy_amount = '100000'
xafnfc.acvw_all_ac_entries_fin

--- petite requete perso ---
select ac.brancmh_code,ac.cust_ac_no,ac.ac_desc,ac.ac_open_date,ac.maker_id from xafnfc.sttm_cust_account ac
where ac.date_last_cr not between to_date('&start_date','DD/MM/YYYY') and to_date('&end_date','DD/MM/YYYY')
and ac.account_type in ('U','S') and ac.auth_stat = 'A'

select ac.branch_code, ac.cust_no, ac.cust_ac_no, ac.ac_desc, ac.ac_open_date, ac.alt_ac_no from xafnfc.sttm_cust_account ac
where ac.branch_code='023' order by cust_no, cust_ac_no
 
select *  from xafnfc.sttm_cust_account a

select a.branch_code,a.cust_ac_no,a.ac_desc,a.cust_no  from xafnfc.sttm_cust_account a where substr(cust_ac_no,4,5)='28101'

--- VOIR TOUTES LES SIGNATURES non autorisées

SELECT * FROM xafnfc.svtm_acc_sig_master cc where cc.auth_stat = 'U'
SELECT * FROM xafnfc.svtm_acc_sig_master cc where cc.MAKER_DT_STAMP='&DATE'
SELECT * FROM xafnfc.svtm_acc_sig_det cc where cc.SIG_MSG <> 'A'
select * from xafnfc.svtm_cif_sig_master dd where dd.auth_stat = 'X'
-- 
select * from xafnfc.sttb_record_log where auth_stat = 'U' order by KEY_ID ---for update;
----------------------------------------------------------------------------------------------------
-------------------------------------- EOD Checks --------------------------------------------------
select * from aetb_eoc_branches_history where branch_code='042';

--- users release  ---
select * from xafnfc.smtb_user 
select * from xafnfc.smtb_current_users ---for update 

select * from smtb_current_users for update --- DANS NFCSUP
select * from xafnfc.smtb_current_users where user_id ='DYONOU' for update 
-- Branches which are NOT YET completed with EODM ---
SELECT * FROM xafnfc.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from xafnfc.sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'  ORDer by branch_code

SELECT * FROM xafnfc.cstb_debug_users xa where xa.debug = 'Y'
---- extraction compte client flexcube ----
select a.branch_code,a.cust_ac_no,a.ac_desc,a.cust_no  from xafnfc.sttm_cust_account a where substr(cust_ac_no,4,5)='28101'
SELECT * FROM xafnfc.sttm_trncode
-- Host Pending items   
select * from xafnfc.eivw_pending_items XA where xa.id = 'SYSTAC'
select * from xafnfc.eivw_pending_items XA 
SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'  ORDer by branch_code
---- afficher une maintenance de compte non autorisée
SELECT * FROM sttb_record_log where AUTH_STAT='U'-- for update;
SELECT * FROM sttb_record_log where maker_id='GNJUHSOP'---- for update;
-- Host Pending salaire
select * from smtb_current_users c where c.current_branch = '010' or c.home_branch = '010' for update

 ---- Vérifier si un debug est activé ------
SELECT * FROM xafnfc.cstb_debug_users xa where xa.debug = 'Y'
---- avant de commencer EOD -----
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'Y' WHERE JOB = 'EOD';

----- après EOD ----
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'N' WHERE JOB = 'EOD';

--- To clear all the login user --- 
 delete xafnfc.SMTB_CURRENT_USERS where user_id='&user_id'
  commit;

CREATE TABLE DAILY_log_01_07_2015 as select * from xafnfc.actb_daily_log a where a.ac_branch='023' and AUTH_STAT='U';
select * from xafnfc.actb_daily_log a where a.ac_branch='024' and AUTH_STAT='U' ---for update;
---------------------------------------------code transaction
select * from sttm_trn_code where substr(trn_code,2,1)=''
select * from sttm_trn_code where trn_code='SIO'
select * from gltm_glmaster where gl_code like '72%'


--- ff / VAULT CHECKS --- ---

SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y'  ORDer by branch_code
SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y' AND BRANCH_CODE='043' ORDer by branch_code
SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BRANCH_CODE='024' ORDer by branch_code

select branch_code, end_of_input,time_level from sttm_branch where branch_code='020'; 
 --- Txn Log pending
SELECT * FROM XAFNFC.FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') -- AND BRANCHCODE='002'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE --for update

--UPDATE FBTB_TXNLOG_MASTER SET TXNSTATUS='DIS',STAGESTATUS='DIS' WHERE TXNSTATUS NOT IN ('COM','DIS','REV','FAL')discAD

select * from fbtb_txnlog_master where xrefid ='FJB1900905618535' --for update nowait;
select * from XAFNFC.eivw_pending_items cd where cd.MD <> 'MA'
select * from xafnfc.sttb_record_log where auth_stat = 'U'

--- To view Pending WB Teller Transactions ---
select branchcode, FUNCTIONID, b.sub_menu_2, count(*)
  from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b
 where f.txnstatus = 'IPR'
   and f.functionid not in ('TVCL', 'TVQR', 'EODM')
   and b.function_id = F.functionid
   and F.POSTINGDATE='&Date'
 group by branchcode, FUNCTIONID, b.sub_menu_2
 order by BRANCHCODE, F.FUNCTIONID
--- peding trnsaction for user & Teller Transactions---
select F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO,count(*)
from xafnfc.fbtb_txnlog_master f, xafnfc.smtb_function_description b, xafnfc.STTM_BRANCH C
where f.txnstatus = 'IPR'
and C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE IN ('&DATE')
group by F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO 
order by F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid, ASSIGNEDTO
--- Recherche des sites dont la cession est bloquee
UPDATE Aetb_Eoc_Runchart 
SET EOC_STAGE_STATUS='C',error_code=NULL,ERROR_PARAM=NULL,ERROR=NULL
WHERE BRANCH_CODE ='024' AND EOC_STAGE='POSTEOTI';

UPDATE EITB_PENDING_PROGRAMS 
SET RUN_STAT='C'
WHERE BRANCH_CODE ='010' AND RUN_STAT='E' AND EOC_GROUP='T' AND  FUNCTION_ID='GIDPRSIF' ;

UPDATE  AETB_EOC_PROGRAMS 
SET EOC_BATCH_STATUS='C'
WHERE BRANCH_CODE ='010' AND EOC_BATCH_STATUS='A' AND  EOC_BATCH='GIDPRSIF';

UPDATE AETB_eOC_BRANCHES 
SET RUNNING_STAGE='POSTEOTI',EOC_STATUS='C',ERROR_CODE=NULL, ERROR=NULL
WHERE BRANCH_CODE ='010';

select l1.sid, ' IS BLOCKING ', l2.sid
from v$lock l1, v$lock l2
where l1.block =1 and l2.request > 0
and l1.id1=l2.id1
and l1.id2=l2.id2;
---- afficher une maintenance de compte non autorisée
SELECT * FROM sttb_record_log where AUTH_STAT='U';

SELECT * FROM Aetb_Eoc_Branches WHERE BRANCH_cODE='040';
SELECT * FROM AETB_eOC_RUNCHART WHERE  BRANCH_cODE='040' AND EOC_STAGE='POSTEOTI';
SELECT * FROM AETB_EOC_PROGRAMS WHERE BRANCH_CODE='040' AND EOC_BATCH_status='W';
SELECT * FROM EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='040' AND FUNCTION_ID='SIAUTOPR' ;

---- Changement de status
UPDATE Aetb_Eoc_Runchart 
SET EOC_STAGE_STATUS='A',error_code=NULL,ERROR_PARAM=NULL,ERROR=NULL
WHERE BRANCH_CODE ='010' AND EOC_STAGE='POSTEOTI';

UPDATE EITB_PENDING_PROGRAMS 
SET RUN_STAT='E'
WHERE BRANCH_CODE ='010' AND RUN_STAT='E' AND EOC_GROUP='T';

UPDATE  AETB_EOC_PROGRAMS 
SET EOC_BATCH_STATUS='A'
WHERE BRANCH_CODE ='010' AND EOC_BATCH_STATUS='C' AND  EOC_BATCH='GIDPRSIF';

UPDATE AETB_eOC_BRANCHES 
SET RUNNING_STAGE='POSTEOTI',EOC_STATUS='A'
WHERE BRANCH_CODE ='010';
----- cASE TILL NON FERME---
-- ALLER AU FONT END   
--Drop EOTI from front-end for branch 020
select branch_code, end_of_input,time_level from sttm_branch where branch_code='020'; 

update sttm_branch 
set time_level =0 
where branch_code='020'; 

select * from xafnfc.fbtb_txnlog_master where POSTINGDATE in ('30/05/2014') and txnstatus='IPR' and makerid ='QMBAKU'

--- Branches which are NOT YET completed with EODM ---
SELECT * FROM xafnfc.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from xafnfc.sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

select * from XAFNFC.sttb_brn_eodm where RUN_DATE='17-dec-2013' order by BRANCH_CODE

--- Branches which are completed with EODM
select branch_code,currentpostingdate,nextpostingdate from XAFNFC.fbtm_branch_info 
where currentpostingdate='&DATE'

select * from fbtm_branch_info  where branch_code='082' for update 
select * from sttm_lcl_holiday where year='2012' /*and branch_code='001'*/ and month=8--082
select * from sttm_dates
select * from xafnfc.sttm_aeod_dates


--- To view Branches ready for EODM run
select branch_code from 
(
  select branch_code
  from xafnfc.sttm_branch
  where branch_code not in (SELECT D.BRANCH_CODE
                             FROM xafnfc.FBTB_TILL_MASTER d
                            WHERE D.BALANCED_IND = 'N'
                            GROUP BY D.BRANCH_CODE)
   MINUS 
   select branch_code from xafnfc.sttb_brn_eodm where run_date = '31/05/2012'    
)               

-- EOD Completed for below
select * from xafnfc.sttb_brn_eodm where run_date = '28-may-2013'

 
-- Host Pending items   
select * from xafnfc.eivw_pending_items XA where xa.id = 'CSUNYIN'
select * from xafnfc.eivw_pending_items XA

-- Branches EOD Stage  //run this when some package is Aborted
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE  
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS='C' ORDER BY BRANCH_CODE
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' and TARGET_STAGE='POSTEOFI' ORDER BY BRANCH_CODE
select * from XAFNFC.Fbtb_Txnlog_Details where xrefid = 'FJB1717004584576' for update
select * from XAFNFC.FBTB_TXNLOG_MASTER xx
where xx.branchcode='043'
and xx.postingdate='25/09/2017' AND xx.xrefid = 'JB1726804763127' for update xx.TXNSTATUS='IPR'
select * from xafnfc.FBTB_TILL_MASTER
WHERE BRANCH_CODE='023'


SELECT * FROM XAFNFC.FBTM_FUNCT
--- Branches EOD Batches Stage //run this when some package is Aborted
SELECT * FROM xafnfc.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE  
SELECT * FROM xafnfc.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   IN ('C','N') ORDER BY BRANCH_CODE--cndbatch
select * from xafnfc.ictb_acc_pr where brn='020' and last_calc_dt<>'08/05/2012'
SELECT * FROM xafnfc.AETB_EOC_PROGRAMS where EOC_batch='ICEOD' and eod_date='30-APR-2012' and  eoc_batch_status<>'C'

select * from xafnfc.smtb_role_detail
-- EITB 
SELECT * FROM xafnfc.EITB_PENDING_PROGRAMS WHERE BRANCH_CODE='010'

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, 
DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status
FROM xafnfc.STTM_DATES A, xafnfc.STTM_BRANCH B
WHERE A.BRANCH_CODE = B.BRANCH_CODE
ORDER BY STATUS, TODAY, A.BRANCH_CODE


-- EOC Run Chart //run this when some package is Aborted
select * FROM xafnfc.AETB_EOC_RUNCHART where EOC_STAGE_STATUS='A';
select * from xafnfc.actb_daily_log dd where dd.external_ref_no = 'FJB1717004584576'
-- SWITCH ON DEBUG

--1 run this first
UPDATE XAFNFC.CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG'

--2 run this second
UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID'
UPDATE CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID' ---- DANS NFCSUP
--3 run if number of updated rows is 0 on script 2
INSERT INTO XAFNFC.CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM XAFNFC.SMTB_MODULES )


-- Verify if Debug is active for any user

SELECT * FROM xafnfc.cstb_debug_users xa where xa.debug = 'Y'

SELECT * FROM cstb_debug_users xa where xa.debug = 'Y'
-- SWITCH OFF DEBUG check this every times before start the EOD ---

UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID'

UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='N' WHERE debug='Y'
UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE debug='Y'
UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID'
UPDATE XAFNFC.CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'

-- After Eod check below tables for date befor go to restart ---

select branch_code,end_of_input from xafnfc.sttm_branch ---end_of_input should be 'N' for all the branch---
select dd.branch_code,dd.currentpostingdate,nextpostingdate from xafnfc.fbtm_branch_info dd -- currentpostingdate should be next bussiness day
select branch_code,today,prev_working_day,next_working_day from xafnfc.sttm_dates order by branch_code


select * from xafnfc.acvw_all_ac_entries ac where ac.LCY_AMOUNT = 74500 and ac.TRN_DT = '02-AUG-2013' and ac.USER_ID = 'INKWAIN'
SELECT * FROM xafnfc.actb_daily_log where user

select * from xafnfc.acvw_all_ac_entries ac where ac.TRN_REF_NO = '043ZRSP171140001' ---and ac.USER_ID = 'INKWAIN'

select * from xafnfc.fbtb_txnlog_details ma where ma.
--- extractions mouvement d'un compte
select ac_branch,ac_no,module,user_id,batch_no,ac_entry_sr_no,period_code,trn_dt,value_dt,lcy_amount,trn_code from xafnfc.ACTB_HISTORY where ac_no='0202820100721430' and module='DE'
--- extraction d'un batch de la journnée en cours 'kmh' 
SELECT  user_id    ,substr(trn_reF_no,1,3) posting_branch,ac_branch,trn_reF_no,  AC_NO ,ac_ccy, DRCR_IND,  DECODE(DRCR_IND ,'D', nvl(fCY_AMOUNT,0),0) dr_amount_fcy, DECODE(DRCR_IND ,'D', LCY_AMOUNT,0) dr_amount_lcy  ,
DECODE(DRCR_IND ,'C', nvl(fCY_AMOUNT,0) ,0) cr_amount_fcy, DECODE(DRCR_IND ,'C', LCY_AMOUNT,0) cr_amount_lcy ,
to_char(TRN_DT,'dd-MON-yyyy') POSTING_DATE, to_char(value_dt,'dd-MON-yyyy')  VALUE_DATE 
FROM ACVW_ALL_AC_ENTRIES
WHERE 
TRN_DT='&PM_TRN_DATE'
 AND nvl(BATCH_NO,'xxxx')='&PM_BATCH_NUM' 
 AND 
  substr(trn_reF_no,1,3) ='&PM_BRANCH_CODE'
and nvl(IB,'N') ='N'
order by drcr_ind , ac_no
------
SELECT count(*) FROM xafnfc.actb_daily_log;
select * from xafnfc.actb_daily_log l where batch_no='8420' and ac_branch='040' and trn_dt='12-jul-2018';
---- tyraitement ATM ------
-- Update date de generation des fichiers GIMAC---
select * from xafnfc.gitm_interface_definition where external_system ='FLEXSWITCH' --for update;

select * from aetb

select * from xafnfc.fbtb_txnlog_master f,

-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

------ Adding Account and CIF in payway-------

select * from Custacc_Temp_09oct2015 for UPDATE ---- Account

select * from Cust_Temp for UPDATE ------ CIF

---------------------------------------------------------------------------------------------------------------

​SELECT * FROM ACVW_ALL_AC_ENTRIES WHERE TRN_DT BETWEEN '01-JUL-2015' AND '31-DEC-2015' AND MODULE='DE' AND TRN_CODE<>'SAL'

SELECT * FROM ACVW_ALL_AC_ENTRIES
 WHERE TRN_DT='29-JUN-2018' AND ac_branch='051' order by lcy_amount;


select * from acvw_all_ac_entries WHERE TRN_DT BETWEEN '01-JUL-2015' AND '31-DEC-2015' AND MODULE='DE' AND TRN_CODE<>'SAL'

alter system kill session '2038,3' ;

ALTER SYSTEM KILL SESSION '2442,3';

select * from dba_objects where status='INVALID'; 
--- recherche d'informations sur les transactions avec libellé historique non détaillée-- 19/11/2015

select * from detb_rtl_teller_hist ss where ss.product_code='CHDP'  
and ss.trn_dt between '18-NOV-2015' and '20-NOV-2015' and ss.txn_acc='0321640105443075' and SS.LCY_AMOUNT ='50000' 
and ss.narrative like '% ENOW%';

--- recherche N0 2  d'informations sur les transactions avec libellé historique non détaillée et montant connu-- 19/11/2015
select ss.xref as reference_TRN,ss.branch_code,ss.trn_ref_no,ss.txn_branch,ss.txn_amount as montant,ss.txn_acc,ss.ofs_branch,ss.lcy_amount,ss.trn_dt,
ss.rel_customer,ss.maker_id,ss.checker_id,ss.narrative from detb_rtl_teller_hist ss where ss.product_code='CHDP'  
and ss.trn_dt between '18-NOV-2015' and '20-NOV-2015' and ss.txn_acc='0321640105443075' and SS.LCY_AMOUNT ='50000' 
and ss.narrative like '%ENOW%';


----  extraction
SELECT  user_id    ,substr(trn_reF_no,1,3) posting_branch,ac_branch,trn_reF_no,  AC_NO ,ac_ccy, DRCR_IND,  DECODE(DRCR_IND ,'D', nvl(fCY_AMOUNT,0),0) dr_amount_fcy, DECODE(DRCR_IND ,'D', LCY_AMOUNT,0) dr_amount_lcy  ,
DECODE(DRCR_IND ,'C', nvl(fCY_AMOUNT,0) ,0) cr_amount_fcy, DECODE(DRCR_IND ,'C', LCY_AMOUNT,0) cr_amount_lcy ,
to_char(TRN_DT,'dd-MON-yyyy') POSTING_DATE, to_char(value_dt,'dd-MON-yyyy')  VALUE_DATE 
FROM ACVW_ALL_AC_ENTRIES
WHERE 
TRN_DT=&PM_TRN_DATE
 AND nvl(BATCH_NO,'xxxx')=&PM_BATCH_NUM 
 AND 
  substr(trn_reF_no,1,3) =&PM_BRANCH_CODE
and nvl(IB,'N') ='N'
order by drcr_ind , ac_no;