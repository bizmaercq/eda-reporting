update account_branch set flex_acc_no = replace(flex_acc_no,' ','');
update account_branch set flex_acc_no = '0'||flex_acc_no WHERE length(flex_acc_no) =15;
update account_branch set flex_acc_no = '0'||branch_code||flex_acc_no WHERE length(flex_acc_no) =13;


SELECT * FROM account_branch WHERE length(flex_acc_no) =14 and substr(flex_acc_no,1,1)<>'0' FOR UPDATE NOWAIT; 

SELECT ca.cust_no,ca.cust_ac_no FROM xafnfc.sttm_cust_account ca WHERE ca.cust_no in 
(SELECT substr(flex_acc_no,8,6) FROM account_branch WHERE length(flex_acc_no) =14 and substr(flex_acc_no,1,1)<>'0')
order by ca.cust_no;
