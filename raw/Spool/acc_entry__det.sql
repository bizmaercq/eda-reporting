set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000
spool c:\acc_entry _det.spl

select * from acvw_all_ac_entries where trn_ref_no='050MGLD123320001' ;

select * from acvw_all_ac_entries where ac_no='381001000'and trn_ref_no like '%MGLD%';

select * from acvw_all_ac_entries where trn_dt <to_date('25-11-2012','mm-dd-yyyy')
and trn_dt> to_date('30-11-2012')
and trn_ref_no like '%MGLD%';

select * from acvw_all_ac_entries where trn_ref_no like '%MGLD%'
and module='SI' and trn_dt <to_date('25-11-2012','mm-dd-yyyy')
and trn_dt> to_date('30-11-2012');

spool off
