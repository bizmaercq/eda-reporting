-- Teller Journal
select h.ac_branch,h.trn_dt,h.value_dt,h.external_ref_no,h.trn_ref_no,h.trn_code,h.ac_no,h.drcr_ind,h.lcy_amount,h.user_id 
from actb_history h 
where h.module ='RT'  
and to_char(h.trn_dt,'DD/MM/YYYY') = '&TransactionDate' 
and h.user_id ='&UserId';


-- Teller Journal with counterparties

select ac_branch,user_id,auth_id,trn_dt,external_ref_no,Narrative,trn_code,max(account_debited) account_debited,max(account_credited) account_credited,lcy_amount 
from
(select h.ac_branch,h.auth_id,h.trn_dt,h.external_ref_no,acpks_stmt.fn_get_rtl_narrative_desc(h.trn_ref_no,h.MODULE,'TXN',h.TRN_CODE,'ENG',h.AC_NO,h.AC_BRANCH,h.ac_ccy,h.trn_dt,h.LCY_AMOUNT) ||' / ' || 'Teller Ref No:' ||(SELECT XREF FROM DETB_RTL_TELLER where TRN_REF_NO = h.TRN_REF_NO)
 Narrative,h.trn_code,case when h.drcr_ind='D' then h.ac_no else null end account_debited,case when h.drcr_ind='C' then h.ac_no else null end account_credited,h.lcy_amount,h.user_id 
from actb_history h 
where h.module ='RT'  
and to_char(h.trn_dt,'DD/MM/YYYY') = '&TransactionDate' 
and h.user_id ='&UserId')
group by ac_branch,auth_id,trn_dt,external_ref_no,Narrative,trn_code, lcy_amount,user_id
order by external_ref_no;

-- query  using detb_retail teller

SELECT d.maker_id USER_ID, d.xref EXTERNAL_REF_NO,d.txn_trn_code TXN_CODE,d.trn_dt TXN_DATE,d.narrative,
case when h.drcr_ind ='D' then d.txn_amount end DEBIT,
case when h.drcr_ind ='C' then d.txn_amount end CREDIT,
d.txn_acc
FROM DETB_RTL_TELLER d ,actb_history h
where d.trn_ref_no = h.trn_ref_no
and d.trn_dt='07/06/2012' 
and d.branch_code='043'
and d.maker_id ='JNYA'
ORDER BY d.maker_id,d.txn_acc;


SELECT aa.maker_id USER_ID, aa.xref EXTERNAL_REF_NO,aa.txn_trn_code TXN_CODE,aa.trn_dt TXN_DATE,aa.narrative NARRATIVE,aa.txn_acc, aa.ofs_acc
FROM XAFNFC.DETB_RTL_TELLER aa
where aa.trn_dt='07/06/201' 
and aa.branch_code='043'
and aa.maker_id ='JNYA'
ORDER BY aa.maker_id,aa.txn_acc




select * from smtb_user where user_name like '%YUNKUNG%'

select * from actb_history


acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,A.LCY_AMOUNT) ||' / ' || 'Teller Ref No:' ||(SELECT XREF FROM DETB_RTL_TELLER TRN_REF_NO = a.TRN_REF_NO)
