select AC_BRANCH,AC_NO,sum(DEBIT_INTEREST) DEBIT_INTEREST, sum(CREDIT_INTEREST) CREDIT_INTEREST
from 
(
select av.AC_BRANCH,av.AC_NO,case when av.DRCR_IND ='D' then nvl(sum(decode(av.DRCR_IND,'D', av.LCY_AMOUNT,0)),0) end as DEBIT_INTEREST,case when av.DRCR_IND ='C' then nvl(sum(decode(av.DRCR_IND,'C', av.LCY_AMOUNT,0)),0) end as CREDIT_INTEREST 
from acvw_all_ac_entries av
where module ='IC' 
--and trn_code in ('DIN','CRI','INT','ICH','IDM','IAJ','ILP','CDI','FDI','IDM',)
and length(ac_no) =9
group by av.AC_BRANCH,av.AC_NO,av.DRCR_IND
)
group by AC_BRANCH,AC_NO;

select * from sttm_trn_code where trn_desc like '%INTEREST%'
