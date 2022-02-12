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



select * from getb_utils where liab_id = '&LIAB' order by util_id, version_no ;

select * from getm_liab where id = '&LIAB' ;

select * from getm_liab_cust where liab_id = '&LIAB' ;

select * from getm_facility where liab_id = '&LIAB' ;

select * from getb_utils_log where liab_id ='&LIAB' order by serial_no;

select * from eltb_util_txn_log where liab_id in (select liab_no from getm_liab where id = '&LIAB') order by start_timestamp ;

select * from geth_utils where liab_id = '&LIAB' order by util_id, version_no ;

select * from getb_utils where liab_id =(select id from getm_liab where liab_no= '&LIAB') order by  util_id, version_no
/
select * from getm_liab where id = (select id from getm_liab where liab_no= '&LIAB')
/
select * from getm_liab_cust where liab_id = (select id from getm_liab where liab_no= '&LIAB')
/
select * from getm_facility where liab_id = (select id from getm_liab where liab_no= '&LIAB')
/
select * from getb_utils_log where liab_id =(select id from getm_liab where liab_no= '&LIAB') order by serial_no
/
select * from eltb_util_txn_log where liab_id in (select liab_no from getm_liab where id = '&LIAB') order by start_timestamp
/
select * from eltb_util_txn_log where liab_id in (select liab_no from getm_liab where id = '&LIAB') order by start_timestamp
/
SELECT * FROM getm_pool where liab_id = (select id from getm_liab where liab_no= '&LIAB')
/
SELECT * FROM getm_pool_coll_linkages where liab_id = (select id from getm_liab where liab_no= '&LIAB')
/
SELECT * FROM getm_collat where liab_id = (select id from getm_liab where liab_no= '&LIAB')
/

set echo off
spool off
