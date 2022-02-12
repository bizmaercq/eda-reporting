-- Joint accounts in the system
SELECT ca.branch_code,ca.cust_no,ca.cust_ac_no, ca.ac_desc,ca.lcy_curr_balance FROM 
sttm_cust_account ca
WHERE ca.joint_ac_indicator ='J';

-- joint accounts of civil servants
SELECT ca.branch_code,pf.fon_matricule,ca.cust_no,ca.cust_ac_no, ca.ac_desc,ca.lcy_curr_balance FROM 
sttm_cust_account ca, (SELECT cust_no FROM sttm_cust_account WHERE account_class ='282') c, paie_fonctionnaire@delta_link pf
WHERE c.cust_no = ca.cust_no 
and substr(pf.fon_fcubs_account,9,6)=ca.cust_no
and ca.joint_ac_indicator ='J'
