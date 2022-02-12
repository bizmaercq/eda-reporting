accept BRN PROMPT 'Enter the branch code ==> '
set numformat 999,999,999,999,999,999,999.999
set line 10000
set trimspool on
set echo off
set pagesize 50000
set head on
set array 1
set colsep ';'

spool c:\AC-FINBLNEW.SPL

Prompt 'Check for Tanked Entries'

SELECT	module,financial_cycle, period_code,lcy_amount, balance_upd
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('T')
AND 	NVL(delete_stat,'X') <> 'D'
/

SELECT	balance_upd, module,financial_cycle, period_code,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) !=
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY module,financial_cycle, period_code,balance_upd;



PROMPT  REAL Dr AND Cr MISMATCH BY MODULE

SELECT	module,financial_cycle, period_code,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) !=
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY module,financial_cycle, period_code;


PROMPT CONTINGENT Dr AND Cr MISMATCH BY MODULE

SELECT	module,financial_cycle, period_code,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,	
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0)))!=
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY module,financial_cycle, period_code;


PROMPT MEMO Dr AND Cr MISMATCH BY MODULE
SELECT	module,financial_cycle, period_code,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) memo_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) memo_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0)))!=
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY module,financial_cycle, period_code;


PROMPT POSITION Dr AND Cr MISMATCH BY MODULE

SELECT	module,financial_cycle, period_code,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'D',lcy_amount,0))) pos_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'C',lcy_amount,0))) pos_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'D',lcy_amount,0)))!=
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0, DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY module,financial_cycle, period_code;


PROMPT REAL Dr AND Cr MISMATCH BY TRANSACTION

SELECT 	trn_ref_no,financial_cycle, period_code,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,	
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	module != 'DE'
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) !=
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY trn_ref_no,financial_cycle, period_code;


PROMPT REAL Dr AND Cr MISMATCH BY BATCH FOR DE

SELECT 	batch_no, financial_cycle, period_code,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) Difference	
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	module = 'DE'
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) !=
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY batch_no, financial_cycle, period_code;


PROMPT CONTINGENT Dr AND Cr MISMATCH BY TRANSACTION

SELECT 	trn_ref_no,financial_cycle, period_code,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,	
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	module != 'DE'
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0)))!=
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY trn_ref_no,financial_cycle, period_code;


PROMPT CONTINGENT Dr AND Cr MISMATCH BY BATCH FOR DE

SELECT 	batch_no, financial_cycle, period_code,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) -
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) Difference
FROM 	actbs_daily_log
WHERE 	ac_branch='&BRN'
AND 	NVL(balance_upd,'D') IN ('D','U','R')
AND 	module = 'DE'
AND 	NVL(delete_stat,'X') <> 'D'
having 	SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0)))!=
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0)))
GROUP BY batch_no, financial_cycle, period_code;



PROMPT MARK EOFI stage query
sELECT ac_branch,SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr, 
SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
 SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr
 , SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0, DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,
  financial_cycle, period_code FROM ACTBS_DAILY_LOG
   WHERE ac_branch='&BRN' 
   AND 	NVL(balance_upd,'D') IN ('D','U','R')
    AND NVL(delete_stat,'X') <> 'D' GROUP BY ac_branch,financial_cycle, period_code; 


PROMPT BRANCH DETAILS

SELECT branch_code,X.SUSPENSE_GLSL,X.CONTINGENT_SUSPENSE_GLSL,X.BRANCH_LCY FROM STTM_BRANCH X WHERE X.BRANCH_CODE = '&BRN';


SELECT amount_tag,event,trn_code FROM actbs_daily_log where rownum<2;

PROMPT Total Entries Details
select module,count(*) from actb_daily_log where ac_branch = '&BRN'
AND 	balance_upd='U' 
AND 	NVL(delete_stat,'X') <> 'D'
group by module;


PROMPT Entries with Balance_upd<>U
select * from actb_daily_log where balance_upd<>'U' and ac_branch ='&BRN';


spool off
