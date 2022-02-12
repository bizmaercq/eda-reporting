 -- Branches EOD Stage  and verification of batches execution
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE;-- FOR UPDATE NOWAIT;
---- Branches EOD Stage  and verification of batches shurt execution 
SELECT BRANCH_code agence,eoc_ref_no,eod_date,branch_date,curr_stage,target_stage,running_stage,eoc_status FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE
-- Current batches running and their status/Etat des batches en cour par branche en execution
SELECT * FROM AETB_EOC_PROGRAMS  WHERE EOC_BATCH_STATUS NOT IN ('C','N')  ORDER BY BRANCH_CODE ---for update;

--- Batches pending execution by branches/Etat des batches restant en execution par 
SELECT branch_code,count(*) FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   ='N' group by branch_code ORDER BY BRANCH_CODE;--cndbatch

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status FROM STTM_DATES A, STTM_BRANCH B  WHERE A.BRANCH_CODE = B.BRANCH_CODE ORDER BY STATUS, TODAY, A.BRANCH_CODE;

--SELECT * FROM sttm_branch FOR UPDATE NOWAIT; 

-- Mettre le ONLINE BANKING OFF avant le EOD 
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'Y' WHERE JOB = 'EOD';

-- Mettre le ONLINE BANKING ON apres le EOD
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'N' WHERE JOB = 'EOD';

--SELECT * FROM aetb_eoc_branches FOR UPDATE NOWAIT; 





