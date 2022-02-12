set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\Sig_details.spl


select * from SVTMS_ACC_SIG_DET where acc_no = '0302820102407528' and branch = '030' and cif_sig_id = '024075';


spool off