accept LIAB PROMPT 'Enter the CL Liability No ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SPOOL c:\ELCM.SPL
 
select * from xafnfc.getb_utils where liab_id = '&LIAB' order by util_id, version_no ;  --LMTB_LINE_UTILS
 
select * from xafnfc.getm_liab where id = '&LIAB' ; --LMTM_LIAB
select * from xafnfc.getm_liab_cust where liab_id = '&LIAB' ; 
select * from xafnfc.getm_facility where liab_id = '&LIAB' ;  --LMTM_LIMITS
select * from xafnfc.getb_utils_log where liab_id ='&LIAB' order by serial_no;
--select * from xafnfc.eltb_util_txn_log where liab_id in (select liab_no from getm_liab where id = '&LIAB') order by start_timestamp ;
select * from xafnfc.geth_utils where liab_id = '&LIAB' order by util_id, version_no ; --LMTB_LINE_UTILS HISTORY
select * from xafnfc.geth_facility where liab_id = '&LIAB' ;  --LMTM_LIMITS HISTORY

set echo off
spool off
