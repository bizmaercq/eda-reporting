select distinct a.AC_BRANCH, a.AC_NO,a.TRN_DT, a.TRN_REF_NO, t.TRN_DESC,l.cif_id,c.customer_name1,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a ,sttm_trn_code t, lctb_contract_master l, sttm_customer c
where a.TRN_CODE = t.trn_code
and l.contract_ref_no = a.TRN_REF_NO
and l.cif_id = c.customer_no
--and a.AC_NO ='0301730102042426'
--and a.trn_ref_no ='024GTBB132770001'
and a.AC_NO in (
'924001000',
'924002000',
'924003000',
'924003100',
'924004000',
'924005000',
'924006000')
and a.VALUE_DT <='31/12/2013'
and a.TRN_REF_NO in 
(select aa.TRN_REF_NO
from acvw_all_ac_entries aa
--and a.AC_NO ='0301730102042426'
where aa.AC_NO in (
'924001000',
'924002000',
'924003000',
'924003100',
'924004000',
'924005000',
'924006000')
and aa.VALUE_DT <='31/12/2013'
group by aa.TRN_REF_NO
having count(*) =1 or count(*) =3) 

order by a.VALUE_DT;


select * from acvw_all_ac_entries where aa.trn_ref_no ='024GTBB132770001'
