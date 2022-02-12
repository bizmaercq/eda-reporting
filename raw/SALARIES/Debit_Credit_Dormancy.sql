-- Importing matricule mapping
SELECT 'insert into mat_cif_mapping values ('''|| pf.fon_matricule||''','''||substr(pf.fon_fcubs_account,9,6)||''');' FROM paie_fonctionnaire pf WHERE pf.fon_fcubs_account is not null
--- Deceased accounts having salaries Schema is delta23@delta
select fon_matricule,fon_intitule,fon_fcubs_account,fon_date_dernier_salaire,max(balance) ac_balance from(
SELECT pf.fon_matricule,pf.fon_intitule, pf.fon_fcubs_account, pf.fon_date_dernier_salaire,balance_deceased Balance 
FROM paie_fonctionnaire pf,fcubs_deceased fd 
WHERE substr(fon_fcubs_account,9,6) = fd.cif_deceased
--and pf.fon_date_dernier_salaire is not null
) group by fon_matricule,fon_intitule,fon_fcubs_account,fon_date_dernier_salaire;
-- Extracting Dormancy
SELECT cu.local_branch, mc.matricule,mc.cif,cu.customer_name1, ca.cust_ac_no,ca.date_last_dr, round((sysdate-ca.date_last_dr)/30) DR_DORMANCY, ca.date_last_cr, round((sysdate-ca.date_last_cr)/30) CR_DORMANCY, ca.lcy_curr_balance  
FROM xafnfc.sttm_cust_account ca, xafnfc.sttm_customer cu,mat_cif_mapping mc 
WHERE ca.cust_no = cu.customer_no
and mc.cif = cu.customer_no
and ca.account_class ='282'
and ca.date_last_dr <='30-SEP-2017'
order by ca.date_last_dr desc

 
---
 SELECT 'Insert into fcubs_deceased values ('''|| cu.customer_no||''','||ac.lcy_curr_balance||');' FROM sttm_customer cu, sttm_cust_account ac  WHERE cu.customer_no = ac.cust_no and cu.deceased = 'Y';
