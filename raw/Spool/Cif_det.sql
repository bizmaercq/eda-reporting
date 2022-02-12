set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\cif_det.spl


select * from SVVW_ACC_SIG_DET where acc_no = '0302820102407528';

select * from FBTB_SIGNATORY where cif_id = '024075';

select * from SVVW_CIF_SIG_DET where cif_id = '024075';

select * from SVVW_CIF_SIG_MASTER where cif_id = '024075';


spool off