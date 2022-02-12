select * 
from acvw_all_ac_entries a 
where a.TRN_CODE in ('FXP','FXS')
and substr(a.AC_NO,1,2) not in ('57','47')

