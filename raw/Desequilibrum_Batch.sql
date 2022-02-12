SELECT bm.last_auth_dt_stamp "DATE",bm.branch_code,bm.batch_no,bm.dr_ent_total,bm.cr_ent_total,bm.dr_ent_total-bm.cr_ent_total Difference,bm.last_oper_id Maker,bm.last_auth_id checker 
FROM detb_batch_master_hist bm 
WHERE bm.last_oper_dt_stamp ='29/07/2019' 
and bm.dr_ent_total <> bm.cr_ent_total
