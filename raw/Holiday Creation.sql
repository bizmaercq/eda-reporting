--insert into sttm_lcl_hol_master
select hm.auth_stat,'032' branch_code,hm.year,hm.mod_no,hm.record_stat,hm.weekly_holidays,hm.checker_dt_stamp,hm.checker_id,hm.maker_dt_stamp,hm.maker_id,hm.once_auth,hm.unexp_hol
 from sttm_lcl_hol_master hm where hm.branch_code ='010'
 and hm.year = '2028'

--insert into sttm_lcl_holiday
select '032' branch_code,h.year,h.month,h.holiday_list from sttm_lcl_holiday h
 where h.branch_code = '010'
 and h.year = '2028'
