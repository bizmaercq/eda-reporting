 -- Branches EOD Stage  and verification of batches execution
SELECT * FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE ---FOR UPDATE-- NOWAIT;
SELECT BRANCH_code,eod_date,branch_date,curr_stage,target_stage,running_stage,eoc_status,error_code FROM xafnfc.AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE--- FOR UPDATE NOWAIT;
-- Current batches running and their status/SELECT * FROM xafnfc.AETB_EOC_PROGRAMS  WHERE EOC_BATCH_STATUS NOT IN ('C','N')  ORDER BY BRANCH_CODE ---- for update;
SELECT * FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE ---for update ---nowait;

--- Batches pending execution by branches/Etat des batches restant en execution par 
SELECT branch_code,count(*) FROM xafnfc.AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   ='N' group by branch_code ORDER BY BRANCH_CODE;--cndbatch

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status FROM xafnfc.STTM_DATES A, xafnfc.STTM_BRANCH B  WHERE A.BRANCH_CODE = B.BRANCH_CODE ORDER BY STATUS, TODAY, A.BRANCH_CODE;

select * from eitb_pending_programs where run_stat = 'W' ORDER BY BRANCH_CODE;

select * from V$SESSION where SID='400';

SELECT * FROM GV$SQL WHERE SQL_ID IN (SELECT SQL_ID FROM V$SESSION where SID='400')

select * from dba_blockers;

SELECT * FROM DBA_DML_LOCKS

select * from aetb_eoc_runchart c where c.eoc_stage_status = 'W' --for update
--SELECT * FROM sttm_branch FOR UPDATE NOWAIT; 

-- Script1:

CREATE TABLE GLTB_GL_BAL_19MAY AS 
select * from GLTB_GL_BAL 
WHERE FIN_YEAR = 'FY2017' AND PERIOD_CODE = 'M05';

 select * from GLTB_GL_BAL_19MAY
-- Script2:

CREATE TABLE STTM_BRANCH_19MAY AS
SELECT * FROM STTM_BRANCH;
select * from STTM_BRANCH_19MAY

---* killing session
ALTER SYSTEM KILL SESSION '1911,3'; 

ALTER SYSTEM KILL SESSION '1167,3'; 

ALTER SYSTEM KILL SESSION '26,3'; 

ALTER SYSTEM KILL SESSION '782,3';

ALTER SYSTEM KILL SESSION '2680,3';

---- YOU HAVE THE FLOOR