set serveroutput on size 1000000
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999

SPOOL C:\cltb_account_apps_master.SPL;

update cltb_account_apps_master
set    alt_acc_no = 'C'||alt_acc_no
where  account_number = '020S12S121700001'
and    branch_code = '020';

update cltb_account_apps_master
set    alt_acc_no = 'C'||alt_acc_no
where  account_number = '043S12S121660002'
and    branch_code = '043';

COMMIT;

SPOOL OFF
