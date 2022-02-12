select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,
 a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) between '600000000' and '799999999' 
and a.FINANCIAL_CYCLE ='FY2016';

select * from gltb_gl_bal g where g.gl_code = '713001000' and g.fin_year = 'FY2016'
