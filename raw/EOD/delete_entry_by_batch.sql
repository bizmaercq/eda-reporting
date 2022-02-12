SELECT * FROM detb_batch_master b where b.last_oper_id ='LTAH' and b.batch_no ='9839' FOR UPDATE NOWAIT; 

select * from detb_upload_detail w where w.batch_no = '9839' and w.branch_code='050' FOR UPDATE NOWAIT; 


select * from detb_upload_master d where d.batch_no = '9839' and d.branch_code='050'  for update nowait;

SELECT * FROM actb_daily_log d WHERE d.batch_no ='9839' and d.ac_branch='050' FOR UPDATE NOWAIT; 
delete FROM actb_daily_log d WHERE d.batch_no ='9839'
select * from acvw_all_ac_entries s where s.BATCH_NO = '9839' and s.TRN_DT = '28/12/2020'  

SELECT * FROM sttb_record_log rl WHERE rl.auth_stat ='U'


SELECT *from actb_daily_log dl WHERE dl.batch_no ='9839' and dl.ac_branch  ='050'
SELECT * FROM sttm_dates



SELECT COUNT(*) from user_objects
