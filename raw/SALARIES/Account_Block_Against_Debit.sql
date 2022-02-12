set array 1
set head OFF
set feedback OFF
set line 10000
set pagesize 10000
set echo OFF
set trimspool on
set numformat 99999999999999999999.9999
spool /home/oracle/scripts/Account_Block.spl


select 'update sttm_cust_account set AC_STAT_NO_DR = ''Y'' where cust_ac_no ='''||dl.ac_no||''';' from actb_history dl  WHERE dl.lcy_amount >= 1000000 and dl.batch_no ='9999' and dl.trn_dt ='24-JUL-2015' and length(dl.ac_no)<>9
order by dl.ac_branch;
select 'commit;' from dual;
select '/' from dual;

spool off
@@Account_Block.spl

