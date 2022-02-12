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

spool c:\XAFNFCFCC0074_Corr_&file_time.spl

SELECT * FROM V$INSTANCE;
Show User

select * from sttm_dates;

SELECT branch_code, currentpostingdate, nextpostingdate FROM fbtm_branch_info ORDER BY branch_code;
SELECT module, ac_branch, trn_dt, COUNT(1) FROM actb_daily_log GROUP BY module, ac_branch, trn_dt 
ORDER BY ac_branch, trn_dt;


UPDATE fbtm_branch_info SET currentpostingdate = '29-OCT-2012', nextpostingdate = '30-OCT-2012'
WHERE currentpostingdate <> '29-OCT-2012' OR nextpostingdate <> '30-OCT-2012';

commit;


SELECT branch_code, currentpostingdate, nextpostingdate FROM fbtm_branch_info ORDER BY branch_code;


spool off
