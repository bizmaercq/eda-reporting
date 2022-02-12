---- Accounts debited by SIs

create table si_debit_2014 as
SELECT distinct cd.dr_account 
FROM xafnfc.sitb_cycle_detail cd
WHERE cd.event_code ='SUXS'
and substr(cd.dr_account,4,3) ='282'
and cd.retry_date between '01/01/2014' and '31/12/2014';


----------------- transaction passed
Create table customer_induced_debit_2014 as
SELECT distinct ae.AC_NO 
from xafnfc.acvw_all_ac_entries ae, si_debit_2014 de
WHERE ae.AC_NO = de.dr_account
and ae.TRN_CODE in ('ACW','CCW','CCQ','CHW')

-------- Differences
SELECT ca.branch_code, ca.cust_no, ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance
FROM si_debit_2014 de, xafnfc.sttm_cust_account ca
WHERE ca.cust_ac_no = de.dr_account 
and de.dr_account not in (select ac_no from  customer_induced_debit_2014 ci);


--------- 2015 ------

drop table  si_debit_2018 ;
create table si_debit_2018 as
SELECT distinct cd.dr_account,cd.cr_account
FROM xafnfc.sitb_cycle_detail cd
WHERE cd.event_code ='SUXS'
and substr(cd.dr_account,4,3) ='282'
and cd.retry_date between '01/01/2018' and '31/12/2018';


----------------- transaction passed---
Drop table customer_induced_debit_2018;
Create table customer_induced_debit_2018 as
SELECT distinct ae.AC_NO 
from xafnfc.acvw_all_ac_entries ae, si_debit_2018 de
WHERE ae.AC_NO = de.dr_account
and ae.TRN_CODE in ('ACW','CCW','CCQ','CHW');

-------- Differences
SELECT ca.branch_code, ca.cust_no,pf.fon_matricule, ca.cust_ac_no,ca.ac_desc dr_account_desc,de.cr_account,(select dc.ac_desc from xafnfc.sttm_cust_account dc WHERE dc.cust_ac_no=de.cr_account) cr_account_desc,ca.lcy_curr_balance
FROM si_debit_2018 de, xafnfc.sttm_cust_account ca, paie_fonctionnaire@delta_link pf
WHERE ca.cust_ac_no = de.dr_account 
and pf.fon_fcubs_account=ca.cust_ac_no
and de.dr_account not in (select ac_no from  customer_induced_debit_2018 ci);
