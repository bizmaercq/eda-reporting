set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SPOOL C:\Product_Details.SPL

 select * from cltm_product_status_level;

set echo off
spool off
