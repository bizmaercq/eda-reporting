accept custacno prompt 'Please enter the customer account number => '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SPOOL /home/oracle/custacc.spl

select * from xafnfc.sttm_cust_account where cust_ac_no = '&custacno'
/

select * from xafnfc.STTM_AC_STAT_CHANGE where cust_ac_no ='&custacno'
/

select * from xafnfc.sttm_cust_account_dormancy where cust_ac_no ='&custacno'
/

select * from xafnfc.sttb_account where ac_gl_no = '&custacno'
/

SELECT * FROM xafnfc.acvw_all_ac_entries where ac_no='&custacno' or related_account='&custacno'
/

SELECT * FROM xafnfc.actb_daily_log where ac_no='&custacno' or related_account='&custacno'
/

select ac_branch, drcr_ind, auth_stat, sum(fcy_amount), sum(lcy_amount)
from xafnfc.actb_daily_log
where delete_stat <> 'D'
and ac_no = '&custacno'
group by ac_branch, drcr_ind, auth_stat
/

select ac_branch, drcr_ind, auth_stat, sum(fcy_amount), sum(lcy_amount)
from xafnfc.acvws_all_ac_entries
where ac_no = '&custacno'
group by ac_branch, drcr_ind, auth_stat
/

select * FROM xafnfc.actbs_accbal_history WHERE account = '&custacno'
/

SELECT * FROM xafnfc.CATMS_AMOUNT_BLOCKS WHERE ACCOUNT = '&custacno'
/

SELECT * FROM xafnfc.ACTBS_FUNCOL WHERE account  = '&custacno'
/

select * FROM xafnfc.actbs_vd_bal WHERE acc = '&custacno'
/

select * from xafnfc.sttms_account_class where account_class = (select account_class from
xafnfc.sttm_cust_account where cust_ac_no = '&custacno')
/

select * from xafnfc.sttms_dates
/

select * from xafnfc.sttb_record_log where key_id like '%&custacno%'
/

select * from xafnfc.sttb_field_log where key_id like '%&custacno%'
/

select * from xafnfc.sttb_record_log_hist where key_id like '%&custacno%'
/

select * from xafnfc.mstm_cust_acc_address  where cust_ac_no = '&custacno'
/

select * from xafnfc.mstms_cust_address WHERE customer_no = (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno')
/

select * from xafnfc.mstms_msg_address WHERE customer_no = (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno')
/

select * from xafnfc.iftm_card_acc_param where atm_cust_ac_no like '%&custacno'
/

select * from xafnfc.fbtb_cust_account where cust_ac_no = '&custacno'
/

SELECT * FROM xafnfc.fbtb_customer WHERE CUSTOMER_NO in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno')
/

DESC xafnfc.fbtb_cust_account;

DESC xafnfc.fbtb_customer;


SELECT * FROM xafnfc.Sttm_Passbook where acc = '&custacno'
/

SELECT * FROM xafnfc.actw_passbook_entries where acc = '&custacno'
/

SELECT * FROM xafnfc.ICTB_TD_LOG where acc = '&custacno'
/

SELECT * FROM xafnfc.Sttm_Passbook where acc = '&custacno'
/

SELECT 	BIC_CODE 
FROM 	xafnfc.ISTM_BIC_DIRECTORY
WHERE 	CUSTOMER_NO = (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno')
/

SELECT * FROM xafnfc.STTM_CUSTOMER WHERE CUSTOMER_NO= (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno')
/

select * from xafnfc.sttbS_provision_detail where cust_ac_no ='&custacno'
/

select * from xafnfc.STTBS_PROVISION_HISTORY where cust_ac_no ='&custacno'
/

select * from xafnfc.sttm_account_bal_tov where cust_ac_no ='&custacno'
/

-- SIGNATURE SPECIFIC TABLES ADDED
select branch,acc_no,cif_sig_id,sig_type,approval_limit,solo_sufficient from xafnfc.FBTB_ACC_SIGNATURE WHERE acc_no ='&custacno';

select * from xafnfc.SVTM_ACC_SIG_DET WHERE acc_no ='&custacno';

select * from xafnfc.SVTM_ACC_SIG_MASTER WHERE acc_no ='&custacno';

select * from xafnfc.SVTM_UPLOAD_ACC_SIG_DET WHERE acc_no ='&custacno';

select * from xafnfc.SVTM_UPLOAD_ACC_SIG_MASTER WHERE acc_no ='&custacno';

select * from xafnfc.FBTB_CIF_SIGNATURE WHERE cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');

select * from xafnfc.FBTB_SIGNATORY WHERE cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');

select * from xafnfc.SVTM_CIF_SIG_BRANCHES WHERE cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');

select 	cif_id,cif_sig_id,specimen_no,specimen_seq_no,signature,record_stat,file_type 
from 	xafnfc.SVTM_CIF_SIG_DET WHERE cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');

select * from xafnfc.SVTM_CIF_SIG_MASTER WHERE cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');

select 	CIF_ID,CIF_SIG_ID,SPECIMEN_NO,SPECIMEN_SEQ_NO,SIGNATURE,RECORD_STAT from xafnfc.SVTM_CIF_SIG_NEW
WHERE 	cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');


SELECT 	CIF_ID, CIF_SIG_ID, SPECIMEN_NO, SPECIMEN_SEQ_NO, SIGNATURE, RECORD_STAT from xafnfc.SVTW_CIF_SIG_DET 
WHERE 	cif_id  in (SELECT CUST_NO
FROM 	xafnfc.sttm_cust_account WHERE CUST_AC_NO = '&custacno');



set echo off
spool off
