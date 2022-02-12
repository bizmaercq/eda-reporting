Select *  from xafnfc.sttm_cust_personal U WHERE U.Last_Name LIKE '%NWAME%' and U.First_Name LIKE '%VICTOR%'
select * from xafnfc.smtb_user P WHERE P.USER_NAME LIKE '%SEVI%' --AND P.Home_Branch = '023'

select U.User_Id, U.User_Name, U.Customer_No, U.Home_Branch from xafnfc.smtb_user U 
WHERE U.Record_Stat = 'O'
order by U.Home_Branch asc, U.START_DATE asc

SELECT b.branch_code||' - '||b.branch_name as branch, b.branch_addr1||' '||b.branch_addr2||' '||b.branch_addr3 as adress  FROM sttm_branch b order by b.branch_code

*************************************************************************************************************************************************************************************


select * from bicim_mapping_account_class where type_compte = '020';

select * from bicim_mapping_account_class where account_class is null;

update bicim_mapping_account_class  set  account_class = '074CAV' where type_compte = '074'
and categorie_client in ('232','233','300','303') 
and account_class is null;


select * from bicim_mapping_account_class where type_compte = '074'
and categorie_client in('300','232','303') 
and account_class = '076CAV';

select * from bicim_mapping_account_class where type_compte = '075'
and categorie_client in ('303','232','320','221','266','203','233','201','300','212','400','120') 
and account_class = '075ATD';

SELECT COUNT(*) FROM bicim_mapping_account_class WHERE account_class = (null);

UPDATE bicim_mapping_account_class
SET account_class = '072LCF'
WHERE racine  = '200377';

select * from smtb_role_master;
************************************************************************************************************************
select * from sttb_upload_cust_account where account_class = '020CSE';

select * from sttb_upload_cust_account where cust_ac_no = '004318201951000XOF'

SELECT * FROM sttb_upload_cust_account where joint_ac_indicator = 'J'

select * from STTMS_ACCLS_CAT_RESTR --where account_class = '020CSE';

select * from sttm_upload_customer where customer_no in ('318201951' ,'318201952');
--update sttb_upload_cust_account SET account_class = '001SPC'--where cust_ac_no = '003700003088000XOF'; 

select * from sttm_upload_customer where short_name = ' joseph traore';

select * from STTMS_CUSTOMER --where customer_category = '004321010067000XOF' ;

select distinct a.joint_ac_indicator from sttb_upload_cust_account a where a.joint_ac_indicator is not null 
and exists (select 1 from sttb_upload_linked_entities b where b.maintenance_seq_no=a.maintenance_seq_no)
and joint_ac_indicator<>'J';  

select * from cltb_account_components;
