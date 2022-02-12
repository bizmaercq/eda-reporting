Prompt Please Specify Branch:  
accept Branch

set numformat 999,999,999,999,999,999,999.999
set linesize 10000
set serveroutput on
set echo on
set colsep ";"
set trimspool on
set pagesize 50000
spool AE_ED-12001_summary_&Branch..spl

Prompt Please Specify Local Currency of the branch:  
accept lcy

exec global.pr_init('&Branch','SYSTEM');

Prompt Giving totals for customer and  internal GLs from gltbs_gl_bal by period

SELECT GLOBAL.LCY FROM DUAL
/

PROMPT Branch Status when BRCHK Run... (Please check the branch status before concluding anything about brchk)
select end_of_input from sttms_branch where branch_code = '&Branch'
/


select p.pc_start_date,a.fin_year,a.period_code,
decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
			'5','CONTINGENT','6','CONTINGENT',
			'7','MEMO',
			'8','POSITION','9','POSITION') CATEGORY,
decode(b.customer,'C','Customer','I','Internal',b.customer) c , 
NVL(sum(NVL(a.cr_bal_lcy,0) - NVL(a.dr_bal_lcy,0) ),0) from 
gltbs_gl_bal a, gltms_glmaster b ,sttms_branch c,sttms_period_codes p -- , sttms_bank k
where
a.gl_code = b.gl_code
and
a.branch_code = '&Branch'
and
a.branch_code = c.branch_code
and
(a.category in ('1','2','5','6','7','8','9')
or
(a.category in ('3','4') and a.ccy_code = upper('&lcy')))
and a.leaf = 'Y'
and p.period_code=a.period_code
and p.fin_cycle=a.fin_year
group by p.pc_start_date,a.fin_year,a.period_code, decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
'5','CONTINGENT','6','CONTINGENT','7','MEMO','8','POSITION','9','POSITION'), b.customer
order by p.pc_start_date,a.fin_year,a.period_code, decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
'5','CONTINGENT','6','CONTINGENT','7','MEMO','8','POSITION','9','POSITION') DESC, b.customer ASC
/

Prompt Giving totals for customer and  internal GLs from acvws_all_ac_entries till date
select decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
			'5','CONTINGENT','6','CONTINGENT',
			'7','MEMO',
			'8','POSITION','9','POSITION') CATEGORY,
decode(a.CUST_GL,'A','Customer','G','Internal',a.cust_gl) c
,sum(decode(a.drcr_ind,'D' , -1,1)*a.lcy_amount), period_code , financial_cycle 
from 
acvws_all_ac_entries a-- , sttms_period_codes p
where ac_branch = '&Branch' and balance_upd='U'
group by decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
'5','CONTINGENT','6','CONTINGENT','7','MEMO','8','POSITION','9','POSITION'), cust_gl , period_code , financial_cycle 
order by financial_cycle , period_code 
/

Prompt Giving totals for cust a/cs from sttms_account_BAL_TOV and internal GLs from gltbs_gl_bal for current period. 

select branch_code , 'Customer' rr,  sum(lcy_curr_balance)
from sttms_account_BAL_TOV
where branch_code = '&Branch'
group by branch_code
union all
select z.branch_code ,  'Internal' rr, sum(cr_bal_lcy-dr_bal_lcy) 
from gltbs_gl_bal x, sttms_branch z , gltms_glmaster a --, sttms_bank y 
where
x.leaf = 'Y'
and
a.customer = 'I'
and
(
x.category in ('1','2','5','6','8','9')
or
(x.category in ('3','4') and x.ccy_code = upper('&lcy'))
)
and
x.branch_code = z.branch_code
and
x.period_code = z.current_period
and
x.fin_year = z.current_cycle
and
x.gl_code = a.gl_code
and
z.branch_code = '&Branch'
Group by z.branch_code
order by 1
/
--Check for actbs_daily_log

select decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
			'5','CONTINGENT','6','CONTINGENT',
			'7','MEMO',
			'8','POSITION','9','POSITION') CATEGORY,
decode(a.CUST_GL,'A','Customer','G','Internal',a.cust_gl) c
,sum(decode(a.drcr_ind,'D' , -1,1)*a.lcy_amount), module, period_code , financial_cycle , batch_no
from 
actbs_daily_log a-- , sttms_period_codes p
where ac_branch = '&Branch' and balance_upd='U'
and delete_stat <>'D' and auth_stat ='A' 
group by decode(a.category,'1','REAL','2','REAL','3','REAL','4','REAL',
'5','CONTINGENT','6','CONTINGENT','7','MEMO','8','POSITION','9','POSITION'), cust_gl, module, period_code , financial_cycle,batch_no
order by module  
/

Prompt Internal GL mapped with CR/DR GL in STTM_CUST_ACCOUNT
select *
  from gltm_glmaster gg
 where gg.customer = 'I'
   and exists (select 1
          from sttm_cust_account sca
         where sca.dr_gl = gg.gl_code
            OR sca.cr_gl = gg.gl_code)
/

set echo off
spool off