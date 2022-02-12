-- Branches EOD Stage  and verification of batches execution
SELECT * FROM AETB_EOC_BRANCHES WHERE EOC_STATUS<>'C' ORDER BY BRANCH_CODE ;-- FOR UPDATE NOWAIT;

-- Current batches running and their status/Etat des batches en cour par branche en execution
SELECT * FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS NOT IN ('C','N') ORDER BY BRANCH_CODE;-- for update nowait;

--- Batches pending execution by branches/Etat des batches restant en execution par branche
SELECT branch_code,count(*) FROM AETB_EOC_PROGRAMS WHERE EOC_BATCH_STATUS   ='N' group by branch_code ORDER BY BRANCH_CODE;--cndbatch

-- Branches Status & Date
SELECT A.BRANCH_CODE,A.TODAY, DECODE(B.End_Of_Input,'N','Txn Input','T','End of Input','F','End of Fin Input','E','EOD Mark','B','BOD',B.End_Of_Input) Status FROM STTM_DATES A, STTM_BRANCH B  WHERE A.BRANCH_CODE = B.BRANCH_CODE ORDER BY STATUS, TODAY, A.BRANCH_CODE;


SELECT * FROM smtb_user WHERE user_id = 'WNZOUATOUM' FOR UPDATE NOWAIT; 
SELECT * FROM smtb_current_users FOR UPDATE NOWAIT; 
