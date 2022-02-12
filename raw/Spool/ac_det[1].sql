accept ACC PROMPT 'Pls enter the account no. ==> '
set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\ac_det1.spl

select * FROM sttms_cust_account WHERE cust_ac_no = '&ACC';
select * FROM sttbs_account WHERE ac_gl_no = '&ACC';
select * FROM acvws_all_ac_entries WHERE ac_no = '&ACC';
select * FROM actb_daily_log WHERE ac_no = '&ACC';
select * FROM actbs_accbal_history WHERE account = '&ACC';
SELECT * FROM CATMS_AMOUNT_BLOCKS WHERE ACCOUNT  ='&ACC';
SELECT * FROM ACTBS_FUNCOL WHERE account  ='&ACC';
SELECT SUM(DECODE(DRCR_IND,'D',-LCY_AMOUNT,LCY_AMOUNT)) FROM ACVW_ALL_AC_ENTRIES WHERE AC_NO = '&ACC';
select * FROM actbs_vd_bal WHERE acc = '&ACC';


spool off