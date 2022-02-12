accept sch prompt 'Enter the schema name==>'
accept Account PROMPT 'Enter the Account >'
accept Branch  PROMPT 'Enter the Branch  >'
set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on
set colsep ";"
set trimspool on
set numformat 99999999999999999999.9999
spool c:\ic_details.spl

SELECT * FROM &sch..STTM_DATES WHERE BRANCH_CODE='&branch';

prompt ictms_product_definition
select * from &sch..ictms_product_definition
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account')
order by product_code
/

prompt ictbs_acc_pr
select * from &sch..ictbs_acc_pr where acc = '&Account'
/
prompt accpr history 
select * from &sch..ICTB_ACC_PR_HISTORY  where acc = '&Account'
/

prompt icvws_acc_pr
select * from &sch..icvws_acc_pr where acc = '&Account'
/

prompt acc_action
select * from &sch..ictbs_acc_action where acc = '&Account'
/


PROMPT ICTBS_MAINT_QUEUE
select * from &sch..ictbs_maint_queue
/

prompt action log
select * from &sch..ictbs_action_log 
/

prompt icvw_line_Det
select * from &sch..icvw_line_Det where brn ='&branch' and acc = '&account';

prompt entries
select * from &sch..ictbs_entries where acc = '&Account'
/
prompt entries history
select * from &sch..ictbs_entries_history where acc = '&Account' order by ent_dt
/

prompt vd_bal
select * from &sch..actbs_vd_bal where acc = '&Account'
order by val_dt
/

prompt is_vals
select * from &sch..ictbs_is_vals where acc = '&Account'
/

prompt acvw_all_ac_entries
select * from &sch..acvws_all_ac_entries where ac_branch='&Branch'
and ( ac_no = '&Account' or related_account = '&account')
and module='IC' 
order by trn_dt desc 
/		

prompt udevals
select * from &sch..ictbs_udevals where cond_key like '%'||(select account_class||ccy from &sch..sttm_cust_account
                                                 where cust_ac_no like  '&Account') ||'%'
/

prompt ictbs_udevals
select * from &sch..ictbs_udevals 
where cond_key like '%&Account%' order by prod 	,ude_eff_dt
/

prompt ictbs_udevals_hist
select * from &sch..ictbs_udevals_history 
where cond_key like '%&Account%' order by prod,ude_eff_dt
/

prompt ictms_acc
select * from &sch..ictms_acc where acc = '&Account'
/
prompt ictms_acc_pr
select * from &sch..ictms_acc_pr where acc = '&Account'
/
prompt acc_udevals
select * from &sch..ictms_acc_udevals where acc = '&Account'
/

prompt ictms_pr_int
select * from &sch..ictms_pr_int 
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account') 
order by product_code
/

prompt ictbs_pr_int_aclass
select * from &sch..ictms_pr_int_aclass 
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account')
order by product_code
/

select * from &sch..cstms_product where product_code in (select distinct prod from &sch..icvws_acc_pr 
where brn ='&branch' and acc = '&account')
/


select * from &sch..icvws_acc_sde where  brn='&branch' and acc = '&account'
/

prompt cust_account
select * from &sch..sttms_cust_account where cust_ac_no = '&Account'
/

SELECT * FROM &sch..STTMS_CUSTOMER WHERE CUSTOMER_NO IN ( SELECT CUST_NO FROM 
&sch..sttms_cust_account where cust_ac_no = '&Account')
/

prompt sttbs_account
select * from &sch..sttbs_account where ac_gl_no = '&Account'
/

prompt ictms_acc_effdt
select * from &sch..ictms_acc_effdt where acc = '&Account'
/

prompt ictbs_xlog
select * from &sch..ictbs_xlog  where acc = '&Account'
/

prompt ictbs_book_err
select * from &sch..ictbs_book_err  where acc = '&Account'
/

prompt ictbs_calc_err
select * from &sch..ictbs_calc_err  where acc = '&Account'
/
prompt ictbs_resolution_err
select * from &sch..ICTBS_RESOLUTION_ERROR 
/

PROMPT cstms_product_event_acct_entry
SELECT * FROM &sch..CStms_PRODUCT_EVENT_ACCT_ENTRY 
WHERE product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account') 
ORDER BY product_code,event_code, amt_tag, dr_cr_indicator
/

PROMPT CSTMS_PRODUCT_ACCROLE
SELECT * FROM &sch..CSTMS_PRODUCT_ACCROLE
WHERE product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account') 
ORDER BY product_code
/

PROMPT ICtms_BRANCH_PARAMETERS
SELECT * FROM &sch..ictms_branch_parameters WHERE branch_CODE = '&Branch'
/

propt calc queue 
select * from &sch..ICTBS_CALC_QUEUE 
where brn ='&Branch' 
and acc = '&Account' 
and prod IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account') 
order by prod
/

prompt ictbs_acqr

select * from &sch..ictbs_acquired_intr where cust_ac_no ='&account' and branch_code ='&branch' 
/

prompt ictbs_adj_interest 

select * from &sch..ictbs_adj_interest where brn='&branch' and acc = '&account' 
/
prompt ictbs_adj_interest_history

select * from &sch..ictbs_adj_interest_history where brn='&branch' and acc = '&account' ;

prompt ictbs_acqr history 

select * from &sch..ictbs_acquired_intr_history  where cust_ac_no ='&account' and branch_code ='&branch' 
/

select * from &sch..ictbs_back_dated_udevals
where cond_key like '%'||(select account_class||ccy from &sch..sttm_cust_account
                                                 where cust_ac_no like  '&Account') ||'%'
/
select * from &sch..ictbs_back_dated_udevals
where cond_key like '%&account%'
/

prompt back valued events

select * from &sch..ictbs_back_dated_events
where acc like '&Account'
/

prompt ictbs_consol_bd_bal
SELECT c.* FROM &sch..ictbs_consol_bd_bal c
WHERE EXISTS ( SELECT 1 FROM &sch..ictms_acc m WHERE m.brn = c.brn AND m.calc_acc = c.acc AND m.acc = '&account')
/

prompt ictbs_consol_vd_bal
SELECT c.* FROM &sch..ictbs_consol_vd_bal c
WHERE EXISTS ( SELECT 1 FROM &sch..ictms_acc m WHERE m.brn = c.brn AND m.calc_acc = c.acc AND m.acc = '&account')
/

prompt ictb_racr
SELECT * FROM &sch..ictbs_racr where brn = '&branch' and acc = '&account'
/

prompt ictms_pr_chg
select * from &sch..ictms_pr_chg where product_code  IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account') 
/

prompt ictms_product_definition
select * from &sch..ictms_product_definition where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account')
/

prompt ictms_pr_int_udevals
select * from &sch..ictms_pr_int_udevals where product_code in ( select prod from &sch..icvws_acc_pr where acc ='&account') 
/

prompt pr_int_effdt 
select * from &sch..ICTMS_PR_INT_EFFDT where product_code in ( select prod from &sch..icvws_acc_pr where acc ='&account')
/
PROMPT 'ALL RULES LINKED TO THE ACCOUNT'

SELECT * FROM &sch..ictms_rule WHERE rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

SELECT * FROM &sch..ictms_rule_frm WHERE rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

SELECT * FROM &sch..ictms_rule_frm_elements WHERE rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

SELECT * FROM &sch..ictms_rule_sde WHERE rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

SELECT * FROM &sch..ictms_rule_ude WHERE rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

select * from &sch..ictm_expr where rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

select * from &sch..ictms_is_fmt_desc where  rule_id IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

SELECT * FROM &sch..ictms_pr_int WHERE rule IN (select RULE from &sch..ictms_pr_int
where product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

PROMPT HOLIDAY

SELECT * FROM &sch..STTM_LCL_HOLIDAY WHERE BRANCH_CODE='&branch' AND YEAR = ( SELECT TO_CHAR(TODAY,'YYYY') 
FROM &sch..STTM_DATES WHERE BRANCH_CODE='&branch');

select * from &sch..sttm_trn_code where trn_code in
(SELECT   transaction_code FROM &sch..cstms_product_event_acct_entry
WHERE product_code IN (select distinct prod from &sch..icvws_acc_pr where brn ='&branch' and acc = '&account'))
/

select * from &sch..ictbs_itm_tov where acc ='&account';

select * from &sch..icvw_line_det  where acc ='&account'
/

spool off
