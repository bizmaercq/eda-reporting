select * 
from acvw_all_ac_entries 
where ac_no in ('452101000','451101000')
and nvl(ib,'X')<>'Y' 
and trn_dt between '01/04/2014' and '31/05/2014'
