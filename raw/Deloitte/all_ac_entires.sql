SELECT ae.TRN_REF_NO ID_Transaction ||'|'|| acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,
                                                   ae.MODULE,
                                                   'TXN',
                                                   ae.TRN_CODE,
                                                   'ENG',
                                                   Ae.AC_NO,
                                                   Ae.AC_BRANCH,
                                                   ae.ac_ccy,
                                                   ae.trn_dt,
                                                   Ae.LCY_AMOUNT) "Description"
           ||'|'|| ae.TRN_DT "date de la transaction"||'|'||ae.VALUE_DT "Date de valeur"||'|'||ae.USER_ID||'|'||
           ae.AUTH_ID||'|'|| ae.AC_ENTRY_SR_NO "Ligne journal"||'|'||ae.AC_NO "Compte grand-livre"||'|'||
           case when ae.DRCR_IND ='D' then ae.LCY_AMOUNT end "DEBIT" ||'|'||
           case when ae.DRCR_IND ='C' then ae.LCY_AMOUNT end "CREDIT" 
             FROM acvw_all_ac_entries ae WHERE  ae.module ='DE' AND  ae.VALUE_DT between '01-01-2016' and '30-06-2016'
  order by ae.TRN_REF_NO ASC ;
  
  
  select  a.AC_BRANCH, a.AC_NO,a.TRN_DT, ae.VALUE_DT,ae.USER_ID,ae.AUTH_ID, a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9)  LIKE '453%'
and  a.VALUE_DT between '01/01/2018' and '30/06/2018' order by a.AC_BRANCH,a.AC_NO ;

