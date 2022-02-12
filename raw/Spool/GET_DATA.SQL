
SET ARRAY 1
SET HEAD ON
SET FEEDBACK ON
SET LINE 10000
SET PAGESIZE 10000
SET ECHO ON
SET COLSEP ";"
SET TRIMSPOOL ON
SET NUMFORMAT 99999999999999999999.9999
SPOOL C:\GET_DATA.SPL

SELECT a.account_number
FROM cltb_account_apps_master a
WHERE LTRIM(RTRIM(a.account_number)) IN (select LTRIM(RTRIM(cust_ac_no)) from sttm_cust_account)
/

SELECT a.account_number
FROM cltb_account_apps_master a
WHERE LTRIM(RTRIM(a.alt_acc_no)) IN  (select LTRIM(RTRIM(cust_ac_no)) from sttm_cust_account)
/

SELECT a.account_number
FROM cltb_account_apps_master a
WHERE LTRIM(RTRIM(a.application_num))  IN (select LTRIM(RTRIM(cust_ac_no)) from sttm_cust_account)
/

SELECT a.account_number
FROM cltc_account_master a
WHERE LTRIM(RTRIM(a.account_number))  IN (select LTRIM(RTRIM(cust_ac_no)) from sttm_cust_account)
/

SELECT a.account_number
FROM cltc_account_master a
WHERE LTRIM(RTRIM(a.alt_acc_no)) IN (select LTRIM(RTRIM(cust_ac_no)) from sttm_cust_account)
/

SPOOL OFF

