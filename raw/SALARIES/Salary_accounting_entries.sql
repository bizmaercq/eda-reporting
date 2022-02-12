select * from acvw_all_ac_entries 
WHERE trn_dt >= '20-DEC-2018' 
and trn_code='SAL'
and ac_branch ='022' and substr(ac_no,4,3) in ('282','173','151','283','285','152','172'); --and a.AUTH_STAT = 'U';


SELECT count(*)  from actb_daily_log dl WHERE dl.batch_no ='1111'   and dl.auth_stat ='U'


SELECT * FROM smtb_current_users cu WHERE cu.user_id ='FATEKWANA' FOR UPDATE NOWAIT; 
