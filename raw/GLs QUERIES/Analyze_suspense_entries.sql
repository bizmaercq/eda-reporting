SELECT * FROM acvw_all_ac_entries ae WHERE ae.TRN_REF_NO ='010ZRSP191920001';
SELECT trunc(bm.last_auth_dt_stamp) Batch_date,bm.batch_no,bm.last_oper_id,bm.last_auth_id,bm.dr_ent_total,bm.cr_ent_total, bm.dr_ent_total - bm.cr_ent_total Desequilibrum FROM detb_batch_master_hist bm WHERE  bm.dr_ent_total <> bm.cr_ent_total and trunc(bm.last_auth_dt_stamp) ='11/07/2019';
SELECT * FROM acvw_all_ac_entries ae WHERE ae.BATCH_NO ='9633'and ae.TRN_DT ='11/07/2019';
SELECT * FROM acvw_all_ac_entries ae WHERE ae.BATCH_NO ='9635'and ae.TRN_DT ='11/07/2019';
SELECT * FROM acvw_all_ac_entries ae WHERE ae.BATCH_NO ='9624'and ae.TRN_DT ='11/07/2019';

