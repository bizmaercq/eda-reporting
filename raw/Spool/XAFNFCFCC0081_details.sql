set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000
spool c:\XAFNFCFCC0081_det.spl

select * from acvw_all_ac_entries where trn_ref_no='050MGLD123320001' ;

select * from actb_recon_master  where branch='050'and 
account='381001000' ;

SELECT * FROM   gltm_glmaster WHERE  gl_code = '381001000';

spool off