accept ACC PROMPT 'Pls enter the account no. ==> '
set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\ac_tod_det.spl


select * FROM sttms_cust_account WHERE cust_ac_no = '&ACC';
select * FROM sttbs_account WHERE ac_gl_no = '&ACC';
select * FROM acvws_all_ac_entries WHERE ac_no = '&ACC';
select * FROM actb_daily_log WHERE ac_no = '&ACC';
select * FROM actbs_accbal_history WHERE account = '&ACC';
SELECT * FROM CATMS_AMOUNT_BLOCKS WHERE ACCOUNT  ='&ACC';
SELECT * FROM ACTBS_FUNCOL WHERE account  ='&ACC';
SELECT SUM(DECODE(DRCR_IND,'D',-LCY_AMOUNT,LCY_AMOUNT)) FROM ACVW_ALL_AC_ENTRIES WHERE AC_NO = '&ACC';
select * FROM actbs_vd_bal WHERE acc = '&ACC';
select * from STTBS_CUST_TOD_HIST where account_no='&ACC';
select * from sttbs_cust_salary  where cust_ac_no='&ACC';

select  ACCOUNT_NO  , APPL_DATE, sum(sal_amount) SAL_AMOUNT,TOD_END_DATE	
from  STTBS_CUST_TOD_HIST A
where STATUS ='U'  and appl_date >='24-JUL-2012'
group by  ACCOUNT_NO  , APPL_DATE ,TOD_END_DATE);

select * from ictm_over_draft_annual_fee;

SELECT LAST_DDL_TIME FROM USER_OBJECTS WHERE OBJECT_NAME='DEPKS_UPLOAD';

PROMPT DEPKS_UPLOAD FIX CHECK

SELECT TEXT FROM USER_SOURCE WHERE NAME IN UPPER('DEPKS_UPLOAD');




spool off