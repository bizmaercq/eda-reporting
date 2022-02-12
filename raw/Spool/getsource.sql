SET HEAD OFF
SET LINE 3000
SET TRIMSPOOL ON
SET PAGESIZE 10000
SET LONG 10000
SET ECHO OFF

SPOOL c:\cspkaccserv.spl
SELECT TEXT FROM USER_SOURCE WHERE NAME IN UPPER('Cspks_Acc_Service');
SPOOL OFF
/


SPOOL c:\sttbacclosure.spl
select * from Sttb_Cust_Ac_Closure where ac_no = '0403830102568590'
/
SPOOL OFF
/