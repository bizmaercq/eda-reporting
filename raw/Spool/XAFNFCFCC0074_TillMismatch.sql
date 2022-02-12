set serveroutput on size 1000000
set buffer 10000000
set array 1
set pau off
set head on
set feedback on
set lines 32767
set pagesize 50000
set echo on
set trimspool on
set colsep ";"
set long 2000000000
set time on
set timing on
set verify on
set numformat 999,999,999,999,999,999,999.99

column tm new_value file_time noprint

select to_char(sysdate, 'DDMMYYYYHH24MISS') tm from dual;

spool c:\XAFNFCFCC0074_TillMismatch.spl

SELECT * FROM V$INSTANCE;
Show User

select * from sttm_dates;

CREATE TABLE fbtb_till_txn_detail_backup_30thOct2012
  AS (SELECT * FROM fbtb_till_txn_detail where POSTINGDATE = '26/10/2012');

CREATE TABLE fbtb_till_totals_backup_30thOct2012
  AS (SELECT * FROM fbtb_till_totals where POSTINGDATE = '26/10/2012');


select * from fbtb_till_txn_detail where POSTINGDATE = '26/10/2012';

UPDATE fbtb_till_txn_detail set POSTINGDATE='29/10/2012' where POSTINGDATE = '26/10/2012';

select * from fbtb_till_totals where POSTINGDATE ='26/10/2012';

UPDATE fbtb_till_totals set POSTINGDATE='29/10/2012' where POSTINGDATE = '26/10/2012';

commit;

select * from fbtb_till_txn_detail where POSTINGDATE = '29/10/2012';

select * from fbtb_till_totals where POSTINGDATE ='29/10/2012';


spool off
