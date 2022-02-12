accept liab_no PROMPT 'Enter the Liability no.=> '

set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999

SPOOL c:\ELCM_Details.SPL

SELECT * FROM STTM_CUSTOMER WHERE CUSTOMER_NO = '&liab_no';

SELECT *
  FROM STTM_CUST_ACCOUNT
 WHERE CUST_NO IN
       (SELECT CUSTOMER_NO FROM STTM_CUSTOMER WHERE LIABILITY_NO = '&liab_no');

SELECT * FROM GETM_LIAB WHERE LIAB_NO = '&liab_no';

SELECT *
  FROM GETM_FACILITY
 WHERE LIAB_ID = (SELECT ID FROM GETM_LIAB WHERE LIAB_NO = '&liab_no');

SELECT * FROM ELVWS_LIMITS_INT WHERE LIAB_ID = '&liab_no';

SELECT * FROM ELVWS_LINE_UTILS_INT WHERE CUST_ID = '&liab_no';

SELECT *
  FROM GETB_UTILS
 WHERE LIAB_ID = (SELECT ID FROM GETM_LIAB WHERE LIAB_NO = '&liab_no');

SELECT *
  FROM GETB_UTILS_LOG
 WHERE LIAB_ID = (SELECT ID FROM GETM_LIAB WHERE LIAB_NO = '&liab_no');

set echo off
spool off
