accept ACC PROMPT 'Pls enter the account no. ==> '
set array 1
set head on
set colsep ";"
set feedback on
set linesize 25000
set pagesize 25000
set long 25000
set echo on
set trimspool on
spool c:\vac_det.spl

PROMPT selecting sttm_cust_account
SELECT * 
FROM STTMS_CUST_ACCOUNT 
WHERE cust_ac_no = '&ACC';

PROMPT selecting sttb_account
SELECT * 
FROM STTBS_ACCOUNT 
WHERE ac_gl_no = '&ACC';

PROMPT selecting accounting entries
SELECT * 
FROM ACVWS_ALL_AC_ENTRIES 
WHERE ac_no = '&ACC' 
ORDER BY ac_entry_sr_no desc;

PROMPT selecting actb_daily_log
SELECT * 
FROM ACTB_DAILY_LOG 
WHERE ac_no = '&ACC' 
ORDER BY ac_entry_sr_no desc;

PROMPT selecting Acc_bal_history
SELECT * 
FROM ACTBS_ACCBAL_HISTORY 
WHERE account = '&ACC' 
ORDER BY bkg_date desc;

PROMPT selecting vd_bal
SELECT * 
FROM ACTBS_VD_BAL 
WHERE acc = '&ACC' 
ORDER BY val_dt desc;

PROMPT selecting Amount Blocks
SELECT * 
FROM CATMS_AMOUNT_BLOCKS 
WHERE account  ='&ACC';

PROMPT selecting funcol
SELECT * 
FROM ACTBS_FUNCOL 
WHERE account  ='&ACC';

PROMPT selecting sum of acvw
SELECT SUM(DECODE(drcr_ind,'D',-lcy_amount,lcy_amount)) 
FROM ACVW_ALL_AC_ENTRIES 
WHERE ac_no = '&ACC'
ORDER BY ac_entry_sr_no desc;

PROMPT slecting ictm_acc
SELECT I.*,T.*
FROM ICTM_ACC I, STTM_CUST_ACCOUNT T
WHERE (I.BOOK_BRN = T.BRANCH_CODE AND I.BOOK_ACC = T.CUST_AC_NO AND I.BOOK_CCY <> T.CCY) OR 
      (I.CHARGE_BOOK_BRN = T.BRANCH_CODE AND I.CHARGE_BOOK_ACC = T.CUST_AC_NO AND I.CHARGE_BOOK_CCY <> T.CCY);

PROMPT selecting account class
SELECT *
FROM STTM_ACCOUNT_CLASS 
WHERE account_class = (SELECT account_class FROM STTM_CUST_ACCOUNT WHERE cust_ac_no='&ACC');

PROMPT RECON_MASTER
SELECT *
FROM ACTBS_RECON_MASTER
WHERE ACCOUNT='&ACC';

PROMPT Selecting TD Record
SELECT * FROM ICTB_DEPOSIT_INSTRUCTION
where account_no='&ACC'
/

prompt Auto Settle block selection
SELECT * FROM CSTB_AUTO_SETTLE_BLOCK
where account_No ='&ACC'
order by book_date
/

spool off