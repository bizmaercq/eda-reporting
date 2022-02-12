SET VERIFY OFF
SET HEAD ON
SET FEEDBACK ON
SET ARRAY 1
SET LINESIZE 20000
SET PAGESIZE 50000
SET LONG 10000
SET ECHO on
SET TRIMSPOOL ON
SET COLSEP ';'
SET NUMFORMAT 9999999999999999.9999

SPOOL C:\CUSTBAL.SPL

Select * from sttm_Cust_account where cust_Ac_no in ('0232810101422938','0222810101158046','0232810104331968','0302820101839884');

select * from sttm_customer where customer_type<>'I' AND ROWNUM <20;

select * from sttm_customer where customer_type='C' AND ROWNUM <20;

Select * from sttm_accls_ccy_balances;

SET ECHO OFF

SPOOL OFF
