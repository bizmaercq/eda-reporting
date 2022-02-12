select a.AC_BRANCH, a.AC_NO,a.TRN_DT,
a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT 
from acvw_all_ac_entries a where a.AC_NO like '37400%'

SELECT gl.branch_code,gl.CUST_AC_NO,ca.AC_DESC ,gl.gl_code,gl.ccy_code ,gl.dr_bal_lcy,gl.cr_bal_lcy 
FROM sttm_cust_account ca ,gltb_cust_accbreakup gl
WHERE ca.CUST_AC_NO = gl.CUST_AC_NO
and gl.fin_year= :Financial_Year
and gl.period_code = :Period_Code
and gl.gl_code = '434005000'
order by gl.branch_code;

select * from gltb_cust_accbreakup C
SELECT * from acvw_all_ac_entries cc where cc.ac_no = '434005000'
select c.BRANCH_CODE,c.CUST_AC_NO,c.AC_DESC,c.CUST_NO,c.AC_OPEN_DATE,c.DATE_LAST_DR ,c.LCY_CURR_BALANCE,c.AC_STAT_DORMANT,c.DORMANCY_DATE,c.DORMANCY_DAYS 
from sttm_cust_account c 
where c.DATE_LAST_DR_ACTIVITY < '21/08/2016' and c.ACCOUNT_CLASS = '282' 