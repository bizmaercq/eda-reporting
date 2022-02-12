set echo on
set head on
set line 3000
set page 2000
set feedback on
set colsep ";"
spool c:\pend.spl

Select	substr(a.contract_ref_no,1,3) br, a.module md,
		a.contract_ref_no rn, '' mt, b.event_descr ev, maker_id id
from	cstbs_contract_event_log a, cstbs_event b
where	a.event_code = b.event_code
	and a.module = b.module and a.contract_status <> 'H'
	and	a.module <> 'SI' and a.event_seq_no =
					(
					Select	min(event_seq_no)
					from	cstbs_contract_event_log
					where	contract_ref_no = a.contract_ref_no
					and		auth_status = 'U'
					) ;

Select	branch_code br, 'MA' md, object_desc rn,'' mt, '' ev, '' id
from	stvws_unauth_forms ;

select * from sttb_record_log where auth_stat = 'U';

select "BR","MD","RN","MT","EV","ID" from devws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from cyvws_pending_items ;

select distinct brn,'IC',NULL,NULL,eipkss.get_txt('IC-ED0006'),NULL
from icvws_inv_acc0 ;

select "BR","MD","RN","MT","EV","ID" from lqvws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from cavws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from sivws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from mivws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from acvws_pending_items ;

select 	branch_code br,'DE' md, batch_no||nvl(description,'  '||description) rn, '' mt,'Unauthorized' ev,last_oper_id id
	from detbs_batch_master where auth_stat = 'U';

select 	branch_code br,'DE' md, till_id||' '||tv_name rn,
	''mt,eipkss.get_txt('DE-TB01') ev, user_id
	from detms_til_vlt_master where balanced_ind = 'N';

select * from actbs_daily_log where auth_stat = 'U' and delete_stat <> 'D';

select auth_stat, count(*) from sttb_record_log group by auth_stat;

select auth_stat,function_id, count(*) from sttb_record_log 
where auth_stat='U'
group by auth_stat,function_id;

select * from sttb_record_log where auth_stat='U';



spool off




