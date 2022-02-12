begin
for i in (
select ACCOUNT_NO , APPL_DATE, sum(sal_amount) SAL_AMOUNT,TOD_END_DATE
from STTBS_CUST_TOD_HIST
where APPL_DATE = '&Value_Date' 
group by ACCOUNT_NO , APPL_DATE ,TOD_END_DATE)
loop


update STTBS_CUST_TOD_HIST set
TOD_AMOUNT = trunc((i.sal_amount) * (50 / 100) )
where APPL_DATE = '&Value_Date' and
tod_amount is null and account_no =i.account_no ;


UPDATE sttm_cust_account
SET tod_limit = trunc((i.sal_amount) * (50 / 100) ),
TOD_START_DATE = '&Value_Date' ,
TOD_LIMIT_START_DATE = '&Value_Date' ,
TOD_END_DATE = i.tod_end_date,
TOD_LIMIT_END_DATE =i.tod_end_date
where cust_ac_no =i.account_no;

UPDATE STTBS_CUST_TOD_HIST SET STATUS='P'
where APPL_DATE = '&Value_Date' and
account_no =i.account_no ;

commit;

end loop;
commit;

end;
