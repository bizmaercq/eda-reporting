-- User and roles
select distinct aa.user_name, aa.user_id,ro.role_description , aa.start_date, decode (aa.user_status,'E','ENABLED','D','DISABLED','L','LOCKED','HOLD') Status, aa.status_changed_on,aa.last_signed_on,aa.pwd_changed_on,bb.branch_name
from smtb_user aa , smtb_user_role rr , SMTB_ROLE_MASTER ro, sttm_branch bb
where rr.user_id = aa.user_id
and rr.role_id = ro.role_id
and bb.branch_code = aa.home_branch
and  aa.record_stat='O'
order by user_id;

-- roles descriptions

select distinct rd.role_id, rd.role_function,fd.main_menu, fd.sub_menu_1, fd.sub_menu_2, fd.description 
from smtb_role_detail rd , smtb_function_description fd
where rd.role_function = fd.function_id
order by rd.role_id;

-- Audit Trail of activity for the 
select l.sequence_no,l.start_time, l.end_time, decode(l.exit_flag,0,'Logged in',1,'Signed Off','Inactive' ) Exit_flag,l.user_id,fd.Function_Id, fd.description,b.branch_name
from SMTB_SMS_LOG l, smtb_function_description fd, sttm_branch b
where l.function_id = fd.function_id
and l.branch_code = b.branch_code
--and l.start_time between '01-JUL-2017' and '31-DEC-2017'
order by l.start_time desc;

SELECT * FROM sttb_record_log_hist
---

SELECT l.user_id, max(l.start_time) Last_connect 
FROM smtb_sms_log_hist l, smtb_user u
WHERE u.user_id = l.user_id(+)
and u.user_status ='E'
group by l.user_id
having max(l.start_time)<= '31-dec-2017'
order by last_connect asc
