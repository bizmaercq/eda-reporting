--- customers having account in 151 
SELECT cu.local_branch,cu.customer_no, cu.customer_name1,ca.cust_ac_no,ca.ac_desc , ca.lcy_curr_balance,ca.record_stat
FROM sttm_cust_account ca, sttm_customer cu 
WHERE ca.cust_no = cu.customer_no
and ca.cust_no in (SELECT ac.cust_no FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
and ca.record_stat ='O'
order by cu.customer_no; 

---- standing instructions crediting microfinance accounts

SELECT cm.cr_acc_br,ac.cust_ac_no,ac.ac_desc,cm.contract_ref_no,cm.si_expiry_date,cm.si_amt 
FROM sitb_contract_master cm , sttm_cust_account ac
WHERE cm.cr_account = ac.cust_ac_no
and cm.cr_account in (SELECT ac.cust_ac_no FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
and cm.si_expiry_date > sysdate;


---- standing instructions debiting microfinance accounts

SELECT cm.dr_acc_br,ac.cust_ac_no,ac.ac_desc,cm.contract_ref_no,cm.si_expiry_date,cm.si_amt 
FROM sitb_contract_master cm , sttm_cust_account ac
WHERE cm.dr_account = ac.cust_ac_no
and cm.dr_account in (SELECT ac.cust_ac_no FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
and cm.si_expiry_date > sysdate;

---- Salaries credited into microfinace accounts

SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc, pf.fon_matricule, pf.fon_intitule
FROM paie_fonctionnaire@delta_link pf, sttm_cust_account ca
WHERE ca.cust_ac_no = pf.fon_fcubs_account
and ca.cust_ac_no in (SELECT ac.cust_ac_no FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
order by ca.cust_ac_no;


---- loans booked in the accounts
SELECT ac.branch_code,am.ACCOUNT_NUMBER,am.DR_PROD_AC,ac.ac_desc,am.AMOUNT_FINANCED,am.MATURITY_DATE FROM cltb_account_master am, sttm_cust_account ac
WHERE am.DR_PROD_AC = ac.cust_ac_no
and am.DR_PROD_AC in (SELECT ac.cust_ac_no FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
and am.MATURITY_DATE > sysdate;


----- Cautions

SELECT substr(cm.contract_ref_no,1,3) Branch,cu.customer_no,cu.customer_name1,cm.contract_ref_no, cm.guarantee_type,cm.contract_amt,cm.expiry_date
FROM lctb_contract_master cm,sttm_customer cu
WHERE cm.cif_id = cu.customer_no 
and cu.customer_no in (SELECT substr(ac.cust_ac_no,9,6) FROM sttm_cust_account ac WHERE ac.cust_no in (SELECT ca.cust_no  FROM sttm_cust_account ca WHERE ca.account_class='151'))
and cm.expiry_date> sysdate
order by cu.customer_no;


