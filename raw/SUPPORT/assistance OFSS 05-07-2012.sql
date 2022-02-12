select count( *) from actb_daily_log where ac_branch = '040' and delete_stat <> 'D' and balance_upd <>'U';

select sum(decode(drcr_ind,'C',lcy_amount,-lcy_amount))
from actb_daily_log where ac_branch='040' and batch_no='8999' and delete_stat<>'D';

select sum(decode(drcr_ind,'C',lcy_amount,-lcy_amount))
from actb_daily_log where ac_branch='040' and batch_no='8999' and delete_stat<>'D' and auth_stat='A';

select sum(decode(drcr_ind,'C',lcy_amount,-lcy_amount))
from actb_daily_log where ac_branch='040' and batch_no='8999' and delete_stat<>'D';

select sum(decode(drcr_ind,'C',lcy_amount,-lcy_amount))
from actb_daily_log where ac_branch='040' and batch_no='8999' and delete_stat<>'D' and auth_stat='A';


select * from actb_daily_log where delete_stat = 'D' and trn_ref_no = '040ZRSP121870001'

 select trn_ref_no
from actb_daily_log where ac_branch='040' and batch_no='8999'

select delete_stat,balance_upd from actb_daily_log where delete_stat = 'D' and trn_ref_no = '040ZRSP121870002'

select delete_stat,balance_upd from actb_daily_log where trn_ref_no = '040ZRSP121870002'


select *
from actb_daily_log where ac_branch='040' and batch_no='8999'

select trn_ref_no,delete_stat
from actb_daily_log where ac_branch='040' and batch_no='8999'

select trn_ref_no,delete_stat
from actb_daily_log where ac_branch='040' and batch_no='8999'


update Sttms_Branch set Suspense_Entry_Reqd ='N' where Branch_Code ='040'

commit;

select * from sttm_branch 
