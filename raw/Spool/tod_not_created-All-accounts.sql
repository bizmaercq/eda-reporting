set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\TOD_CREATION.spl

select  ACCOUNT_NO  , APPL_DATE, sum(sal_amount) SAL_AMOUNT,TOD_END_DATE	
 from  STTBS_CUST_TOD_HIST A
 where STATUS ='U'  and appl_date >='24/08/2012'
 group by  ACCOUNT_NO  , APPL_DATE ,TOD_END_DATE;



begin
for i in ( 
 select  ACCOUNT_NO  , APPL_DATE, sum(sal_amount) SAL_AMOUNT,TOD_END_DATE	
 from  STTBS_CUST_TOD_HIST A
 where STATUS ='U'  and appl_date >='24/08/2012'
 group by  ACCOUNT_NO  , APPL_DATE ,TOD_END_DATE)
  loop
  
  
  update STTBS_CUST_TOD_HIST set 
  TOD_AMOUNT = trunc((i.sal_amount) * (50 / 100) )
  where  APPL_DATE =  i.APPL_DATE
  and account_no =i.account_no ;
 
 
                    UPDATE sttm_cust_account
                     SET tod_limit          = trunc((i.sal_amount) * (50 / 100) ),
                       TOD_START_DATE =  i.APPL_DATE,
                       TOD_LIMIT_START_DATE =  i.APPL_DATE ,
                       TOD_END_DATE       = i.tod_end_date,
                       TOD_LIMIT_END_DATE =i.tod_end_date
                       where cust_ac_no =i.account_no;

                  UPDATE STTBS_CUST_TOD_HIST SET STATUS='P' 
                  where APPL_DATE = i.APPL_DATE   and 
                  account_no =i.account_no ;

		  update sttbs_cust_salary 
		  set salary_amt = i.sal_amount
		  where cust_ac_no = i.account_no
		  and  last_salary_dt = i.APPL_DATE;
                   
  commit;
                 
 end loop;
commit;

--update STTBS_CUST_TOD_HIST set 
--STATUS ='P' 
--where appl_date <'24/08/2012';
--commit;
end;
/
select  ACCOUNT_NO  , APPL_DATE, sum(sal_amount) SAL_AMOUNT,TOD_END_DATE	
 from  STTBS_CUST_TOD_HIST A
 where STATUS ='U'  and appl_date >='24/08/2012'
 group by  ACCOUNT_NO  , APPL_DATE ,TOD_END_DATE;


spool off
