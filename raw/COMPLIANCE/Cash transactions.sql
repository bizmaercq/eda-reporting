select  ac.trn_dt as Transaction_date,substr(ac.TRN_REF_NO,1,3) as branch,substr(ac.TRN_REF_NO,4,4) as trn_TYPE, ac.ac_no as Account_number,customer_name1,
case   substr(ac.TRN_REF_NO,4,4) when 'CHWL' then ac.lcy_amount  end as CASH_WIDTHRAWAL, 
case   substr(ac.TRN_REF_NO,4,4) when 'CHDP' then ac.lcy_amount  end as CASH_DEPOSIT
from xafnfc.acvw_all_ac_entries ac join xafnfc.sttm_customer c on substr(ac.AC_NO,9,6) = c.customer_no 
where 
ac.auth_stat = 'A'
and substr(ac.TRN_REF_NO,1,3) = nvl(:branch_code,substr(ac.TRN_REF_NO,1,3))
and substr(ac.TRN_REF_NO,4,4) in ('CHWL','CHDP')
and ac.cust_gl = 'A'
and ac.trn_dt between :begining_date and :end_date
and ac.lcy_amount >= to_number(:mini)


select * from xafnfc.acvw_all_ac_entries 
