select ac_branch,user_id,auth_id,trn_dt,external_ref_no,Narrative,trn_code,max(account_debited) account_debited,max(account_credited) account_credited,lcy_amount 
from
(select h.ac_branch,h.auth_id,h.trn_dt,h.external_ref_no,acpks_stmt.fn_get_rtl_narrative_desc(h.trn_ref_no,h.MODULE,'TXN',h.TRN_CODE,'ENG',h.AC_NO,h.AC_BRANCH,h.ac_ccy,h.trn_dt,h.LCY_AMOUNT) ||' / ' || 'Teller Ref No:' ||(SELECT XREF FROM DETB_RTL_TELLER where TRN_REF_NO = h.TRN_REF_NO)
 Narrative,h.trn_code,case when h.drcr_ind='D' then h.ac_no else null end account_debited,case when h.drcr_ind='C' then h.ac_no else null end account_credited,h.lcy_amount,h.user_id 
from actb_history h 
where h.module ='RT'  
and to_char(h.trn_dt,'DD/MM/YYYY') = :TransactionDate 
and h.user_id = :UserId)
group by ac_branch,auth_id,trn_dt,external_ref_no,Narrative,trn_code, lcy_amount,user_id
order by external_ref_no;

