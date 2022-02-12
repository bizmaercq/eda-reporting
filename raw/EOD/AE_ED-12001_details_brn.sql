accept Branch PROMPT 'Enter the Branch Code ==> '
set numformat 999,999,999,999,999,999,999.999
set linesize 10000
set serveroutput on
set echo on
set colsep ";"
set trimspool on
set pagesize 50000
spool AE_ED-12001_details_brn_&BRANCH..spl

EXEC GLOBAL.pr_init('&Branch','SYSTEM');

PROMPT VDBAL_UPDATE PARAM

SELECT * FROM CSTB_PARAM WHERE PARAM_NAME = 'VDBAL_UPDATE';

PROMPT STTM_DATES

SELECT * from sttm_dates WHERE branch_code = '&Branch';

Prompt Branch Details

select a.branch_code "BRN",a.prev_working_day "PREV DATE",today " TODAY",a.next_working_day "NEXT DATE", 
decode(end_of_input,'N','Transaction Input','T','EOTI','F','EOFI','E','EOD','B','BOD',end_of_input) status,
b.branch_lcy "LCY",b.current_period "PER",b.current_cycle "FINCY",DECODE(b.cod_start_tank,'N','Not Started','Started') "Tanking", 
b.suspense_glsl SUS_GL,b.contingent_suspense_glsl CONT_SUS
from sttm_dates a,sttm_branch b where a.branch_code = b.branch_code and
a.branch_code = '&Branch';

PROMPT DAILY LOG SUMMARY

select 
module,
sum(decode(category,5,0,6,0,7,0,8,0,9,0,decode(drcr_ind,'D',lcy_amount,0))) Real_Dr,
sum(decode(category,5,0,6,0,7,0,8,0,9,0,decode(drcr_ind,'C',lcy_amount,0))) Real_Cr,
(sum(decode(category,5,0,6,0,7,0,8,0,9,0,decode(drcr_ind,'D',lcy_amount,0)))-sum(decode(category,5,0,6,0,7,0,8,0,9,0,decode(drcr_ind,'C',lcy_amount,0)))) DR_MINUS_CR,
sum(decode(category,1,0,2,0,3,0,4,0,7,0,8,0,9,0,decode(drcr_ind,'D',lcy_amount,0))) Cont_Dr,
sum(decode(category,1,0,2,0,3,0,4,0,7,0,8,0,9,0,decode(drcr_ind,'C',lcy_amount,0))) Cont_Cr,
sum(decode(category,1,0,2,0,3,0,4,0,5,0,6,0,8,0,9,0,decode(drcr_ind,'D',lcy_amount,0))) Memo_Dr,
sum(decode(category,1,0,2,0,3,0,4,0,5,0,6,0,8,0,9,0,decode(drcr_ind,'C',lcy_amount,0))) Memo_Cr,
sum(decode(category,1,0,2,0,3,0,4,0,5,0,6,0,7,0,decode(drcr_ind,'D',lcy_amount,0))) Posn_Dr,
sum(decode(category,1,0,2,0,3,0,4,0,5,0,6,0,7,0,decode(drcr_ind,'C',lcy_amount,0))) Posn_Cr,
financial_cycle, period_code
FROM ACTBS_DAILY_LOG
WHERE ac_branch='&Branch'AND 
balance_upd <> 'T' AND 
NVL(delete_stat,'X') <> 'D'
GROUP BY module,financial_cycle, period_code
ORDER BY module,financial_cycle, period_code;

PROMPT Internal GL (GLTB_GL_BAL VS ACVW_ALL_AC_ENTRIES)

SELECT *
  FROM (SELECT   ac_branch,
                 ac_no,
                 ac_ccy,
                 SUM(lcy_bal) lcybal,
                 (SELECT SUM(a.cr_bal_lcy - a.dr_bal_lcy)
                    FROM gltb_gl_bal a,
                         sttm_branch x
                   WHERE 
                      a.branch_code = '&Branch'
                     AND a.branch_code = z.ac_branch
                     AND a.gl_code = z.ac_no
                     AND a.ccy_code = z.ac_ccy
                     AND a.period_code = x.current_period
                     AND a.fin_year = x.current_cycle
                     AND a.branch_code = x.branch_code
                     AND (   a.CATEGORY IN('1', '2', '5', '6', '7', '8', '9')
                          OR (    a.CATEGORY IN('3', '4')
                              AND ccy_code = x.branch_lcy))) gllcy
            FROM (SELECT   /*+ PARALLEL(A, 2) */
                           ac_branch,
                           ac_no,
                           CASE
                              WHEN(    (   CATEGORY = '3'
                                        OR CATEGORY = '4'))
                                         THEN GLOBAL.LCY
                             ELSE ac_ccy
                           END "AC_CCY",
                           SUM(DECODE(drcr_ind, 'D', -1, 1) * lcy_amount) lcy_bal
                      FROM acvw_all_ac_entries a,
                         sttm_branch x
                     WHERE balance_upd = 'U'
		      and ((a.FINANCIAL_CYCLE = x.current_cycle and a.period_code <> 'FIN') 
		      OR a.FINANCIAL_CYCLE <> x.current_cycle)
                      and a.ac_branch= '&Branch'
		      and a.ac_branch = x.branch_code
                      and a.cust_gl ='G'
                  GROUP BY ac_branch,
                           ac_no,
                           ac_ccy,
                           CATEGORY) z
        GROUP BY ac_branch,
                 ac_no,
                 ac_ccy)
WHERE lcybal != gllcy
/

PROMPT Customer GL (GLTB_cust_acc_breakup VS sttm_cust_account)

SELECT *
  FROM (SELECT   ac_branch,
                 ac_no,
                 ac_ccy,
                 SUM(lcy_bal) lcybal,
                 (SELECT SUM(a.cr_bal_lcy - a.dr_bal_lcy)
                    FROM GLTBS_CUST_ACC_BREAKUP  a,
                         sttm_branch x
                   WHERE 
                      a.branch_code = '&Branch'
                     AND a.branch_code = z.ac_branch
                     AND a.branch_code = x.branch_code
                     AND a.period_code = x.current_period
                     AND a.fin_year = x.current_cycle
                     AND a.gl_code = z.ac_no
                     AND a.ccy_code = z.ac_ccy
                     ) gllcy
            FROM (SELECT   /*+ PARALLEL(sttm_cust_account, 2) */
        sttms_cust_account.branch_code AC_BRANCH,
				decode (sign(acy_curr_balance), -1, dr_gl,
							   		   0, (decode(sttms_account_class.natural_gl_sign, 'D', dr_gl, 'C', cr_gl)),
							   		   1, cr_gl) AC_NO,
				ccy AC_CCY,
				sum(decode(sttms_cust_account.ccy, GLOBAL.LCY, 0, acy_curr_balance)) acy_bal,
				sum(lcy_curr_balance) lcy_bal,
				sum(acy_uncollected) uncol_bal,
				sign(acy_curr_balance) sgn
		FROM 		sttms_cust_account, sttms_account_class
		WHERE 	sttms_cust_account.branch_code = '&Branch'
		AND		sttms_cust_account.account_class = sttms_account_class.account_class
		GROUP BY 	sttms_cust_account.branch_code,
				decode (sign(acy_curr_balance), -1, dr_gl,
						   			   0, (decode(sttms_account_class.natural_gl_sign, 'D', dr_gl, 'C', cr_gl)),
									   1, cr_gl),
				ccy,
				sign(acy_curr_balance)) z
        GROUP BY ac_branch,
                 ac_no,
                 ac_ccy)
WHERE lcybal != gllcy
/


PROMPT Customer ACCOUNT BALANCE VERIFICATION (acvw_all_ac_entries VS sttm_cust_account)

SELECT *
  FROM (SELECT   ac_branch,
                 ac_no,
                 ac_ccy,
                 SUM(lcy_bal) lcybal,
                 (SELECT lcy_curr_balance
                    FROM sttms_cust_account A
                   WHERE 
                      a.branch_code = '&Branch'
                     AND a.branch_code = z.ac_branch
                     AND a.cust_ac_no = z.ac_no
                     AND a.ccy = z.ac_ccy
         ) gllcy
            FROM (SELECT   /*+ PARALLEL(A, 2) */
                           ac_branch,
                           ac_no,
                           AC_CCY,
                           SUM(DECODE(drcr_ind, 'D', -1, 1) * lcy_amount) lcy_bal
                      FROM acvw_all_ac_entries a
                     WHERE balance_upd = 'U'
                      and a.ac_branch = '&Branch'
                      and a.cust_gl ='A'
                  GROUP BY ac_branch,
                           ac_no,
                           ac_ccy) z
        GROUP BY ac_branch,
                 ac_no,
                 ac_ccy)
WHERE lcybal != gllcy;


PROMPT Customer ACCOUNT BALANCE VERIFICATION (GLTB_GL_BAL VS GLTBS_CUST_ACC_BREAKUP)

SELECT *
  FROM (SELECT   ac_branch,
                 ac_no,
                 ac_ccy,
                 prd,
                 finyr,
                 (lcy_bal) lcybal,
                 (SELECT SUM(a.cr_bal_lcy - a.dr_bal_lcy)
                    FROM Gltbs_Cust_Accbreakup  a,
                         sttm_branch x
                   WHERE 
                      a.branch_code = '&Branch'
                     AND a.branch_code = z.ac_branch
                     AND a.branch_code = x.branch_code
                     AND a.period_code = x.current_period
                     AND a.fin_year = x.current_cycle
                     AND a.period_code = z.prd
                     AND a.fin_year = z.finyr                     
                     AND a.gl_code = z.ac_no
                     AND a.ccy_code = z.ac_ccy
                     ) gllcy
            FROM (SELECT   /*+ PARALLEL(s, 2) */
        s.branch_code ac_branch,
        s.gl_code ac_no,
        s.ccy_code ac_ccy,
        s.period_code prd,
        s.fin_year finyr,
        (s.cr_bal - s.dr_bal) acy_bal,
        (s.cr_bal_lcy - s.dr_bal_lcy) lcy_bal
    FROM     gltbs_gl_bal s, sttm_branch x, gltm_glmaster l
    WHERE   s.branch_code = '&Branch'
    and s.branch_code = x.branch_code
    and s.leaf='Y'
    and s.gl_code = l.gl_code
    and l.customer = 'C'
     AND S.period_code = x.current_period
     AND S.fin_year = x.current_cycle
    AND (S.CATEGORY IN('1', '2', '5', '6', '7', '8', '9')
                          OR (    S.CATEGORY IN('3', '4')
                              AND ccy_code = GLOBAL.LCY))    ) z
                              )
WHERE lcybal != gllcy;

PROMPT Internal and Customer GL total from GLTB_GL_BAL
SELECT /*+ PARALLEL(24) */ p.pc_start_date
      ,a.fin_year
      ,a.period_code
      ,decode(a.category, '1', 'REAL', '2', 'REAL', '3', 'REAL', '4', 'REAL', '5', 'CONTINGENT', '6', 'CONTINGENT', '7', 'MEMO', '8', 'POSITION', '9', 'POSITION') category
      ,decode(b.customer, 'C', 'Customer', 'I', 'Internal', b.customer) c
      ,to_char(nvl(SUM(nvl(a.cr_bal_lcy, 0) - nvl(a.dr_bal_lcy, 0)), 0), '999,999,999,999,999,999.999') balance
  FROM gltbs_gl_bal       a
      ,gltms_glmaster     b
      ,sttms_branch       c
      ,sttms_period_codes p
 WHERE a.gl_code = b.gl_code
   AND a.branch_code = '&Branch'
   AND a.branch_code = c.branch_code
   AND (a.category IN ('1', '2', '5', '6', '7', '8', '9') OR (a.category IN ('3', '4') AND a.ccy_code = c.branch_lcy))
   AND a.leaf = 'Y'
   AND a.period_code = c.current_period
   AND a.fin_year = c.current_cycle
   AND a.period_code = p.period_code
   AND a.fin_year = p.fin_cycle
 GROUP BY p.pc_start_date
         ,a.fin_year
         ,a.period_code
         ,decode(a.category, '1', 'REAL', '2', 'REAL', '3', 'REAL', '4', 'REAL', '5', 'CONTINGENT', '6', 'CONTINGENT', '7', 'MEMO', '8', 'POSITION', '9', 'POSITION')
         ,b.customer
/

PROMPT Internal and Customer GL total from acvw_all_ac_entries
SELECT /*+ PARALLEL(24) */ decode(a.category, '1', 'REAL', '2', 'REAL', '3', 'REAL', '4', 'REAL', '5', 'CONTINGENT', '6', 'CONTINGENT', '7', 'MEMO', '8', 'POSITION', '9', 'POSITION') category
      ,decode(a.cust_gl, 'A', 'Customer', 'G', 'Internal', a.cust_gl) c
      ,to_char(SUM(decode(a.drcr_ind, 'D', -1, 1) * a.lcy_amount), '999,999,999,999,999,999.999') balance
  FROM acvws_all_ac_entries a
 WHERE a.ac_branch = '&Branch'
   AND a.balance_upd = 'U'
 GROUP BY decode(a.category, '1', 'REAL', '2', 'REAL', '3', 'REAL', '4', 'REAL', '5', 'CONTINGENT', '6', 'CONTINGENT', '7', 'MEMO', '8', 'POSITION', '9', 'POSITION')
         ,a.cust_gl
/

set echo off
spool off




