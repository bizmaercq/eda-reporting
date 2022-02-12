select a.TRN_DT, a.AC_NO,a.RELATED_CUSTOMER,a.RELATED_ACCOUNT,c.customer_name1,t.trn_desc, case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries  a , sttm_customer c , sttm_trn_code t
where c.customer_no = a.RELATED_CUSTOMER 
and a.TRN_CODE = t.trn_code
and a.ac_no like '34%'
--and c.customer_no = '012921'
and c.customer_no in ('006514','024497','024568','037676','037902','037676','038728','038217','013009','012921')
order by a.TRN_DT
