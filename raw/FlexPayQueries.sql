--Global Statistics on FlexPay
select aa.ac_branch,sum(Number_Received) Number_Received,sum(aa.Received) Received,sum(aa.commission) Commission, sum(aa.tax) Tax,sum(Number_Paid) Number_Paid ,sum(aa.paid) paid
from
(
select a.AC_BRANCH, 
case when a.TRN_CODE = 'TTI' then count(*) else 0 end as Number_Received,
case when a.TRN_CODE = 'TTI' then sum(a.LCY_AMOUNT) else 0 end as Received,
case when a.TRN_CODE = 'TTC' then sum(a.LCY_AMOUNT) else 0 end as Commission,
case when a.TRN_CODE = 'TAX' then sum(a.LCY_AMOUNT) else 0 end as Tax,
case when a.TRN_CODE = 'TTL' then count(*) else 0 end as Number_Paid,
case when a.TRN_CODE = 'TTL' then sum(a.LCY_AMOUNT) else 0 end as Paid
from acvw_all_ac_entries a
where  a.trn_ref_no like '%TTIW%'
and a.AC_NO not in ('571110000','452101000')
and a.TRN_DT between '&Start_Date' and '&End_Date'
group by a.AC_BRANCH,a.TRN_CODE
) aa
group by aa.ac_branch
order by aa.ac_branch;

-- Detail Statistics on FlexPay

select aa.home_branch TRN_BRANCH,aa.TRN_DT TRN_DATE,aa.TRN_REF_NO,aa.USER_ID,sum(aa.Received) Received,sum(aa.commission) Commission, sum(aa.tax) Tax, sum(aa.Paid) Paid
from
(
select u.home_branch,a.TRN_DT, a.TRN_REF_NO,u.USER_ID,
case when a.TRN_CODE = 'TTI' then sum(a.LCY_AMOUNT) else 0 end as Received,
case when a.TRN_CODE = 'TTC' then sum(a.LCY_AMOUNT) else 0 end as Commission,
case when a.TRN_CODE = 'TAX' then sum(a.LCY_AMOUNT) else 0 end as Tax,
case when a.TRN_CODE = 'TTL' then sum(a.LCY_AMOUNT) else 0 end as Paid
from acvw_all_ac_entries a , smtb_user u
where a.USER_ID = u.user_id
and a.trn_ref_no like '%TTIW%'
and a.AC_NO not in ('571110000','452101000')
and a.TRN_DT between '&Start_Date' and '&End_Date'
group by u.home_branch,a.TRN_CODE,a.TRN_DT,a.TRN_REF_NO,u.USER_ID
) aa
group by aa.home_branch,aa.TRN_DT,aa.TRN_REF_NO,aa.USER_ID
order by aa.TRN_REF_NO,aa.trn_dt,aa.USER_ID;






