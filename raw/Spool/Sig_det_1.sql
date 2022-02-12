set head on
set echo on
set feed on
set lines 10000
set pages 10000
set long 20000
set colsep ';'
spool C:\Sig_det_1.SPL

select * from svtms_acc_sig_det where branch = '043' and acc_no = '0433830204399630'
/
spool off
