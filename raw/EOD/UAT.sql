 -- Verify if Debug is active for any user
SELECT * FROM cstb_debug_users xa where xa.debug = 'Y'

SELECT * FROM STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE
--- Branches which are NOT YET completed with EODM ---
SELECT * FROM STTM_BRANCH WHERE BRANCH_CODE NOT IN ( select BRANCH_CODE from sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE

select * from eivw_pending_items XA

SELECT * FROM FBTB_TILL_MASTER WHERE BALANCED_IND<>'Y' ORDer by branch_code

select * from smtb_current_users order by HOME_BRANCH  for update

select * from sttb_record_log where auth_stat = 'U'

SELECT * FROM cstb_clearing_master q where q.auth_stat = 'U'
(select rn from eivw_pending_items XA) for update

UPDATE Actb_Daily_Log SET DELEETwhere trn_ref_no in
(select rn from eivw_pending_items XA)
and auth_stat = 'U' 

---------------------------------------------------------------------------------------------------------------------------
-- Branches EOD Stage  and verification of batches execution
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODe --FOR UPDATE NOWAIT;
-- Current batches running and their status/Etat des batches en cour par branche en execution
SELECT * FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE;--for update;
--- Batches pending execution by branches/Etat des batches restant en execution par branche
SELECT branch_code,count(*) FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   ='N' group by branch_code ORDER BY BRANCH_CODE;--cndbatch
-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status FROM STTM_DATES A, STTM_BRANCH B  WHERE A.BRANCH_CODE = B.BRANCH_CODE ORDER BY TODAY, STATUS,  A.BRANCH_CODE;


SELECT * FROM CSTB_PARAM 

---- SWITCH ON DEBUG
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
UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE debug='Y'
UPDATE CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'



--- User in system
select * from smtb_current_users order by HOME_BRANCH  for update



