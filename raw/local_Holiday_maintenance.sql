SELECT add_months('20/04/2021',96) from dual


SELECT * FROM sttm_lcl_hol_master hm WHERE hm.year = 2029 FOR UPDATE NOWAIT; 

insert into sttm_lcl_holiday
SELECT * FROM sttm_lcl_holiday lh WHERE lh.year =2029 

