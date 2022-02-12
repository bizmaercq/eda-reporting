create table account_map
(fcubs_ac_no varchar2(20),
delta_ac_no varchar2(20));

create table loan_account_map
(fcubs_ac_no varchar2(20),
delta_ac_no varchar2(20));

create table Deloitte_accounts (
Branch_code varchar2(3),
fcubs_ac_no varchar2(20),
delta_ac_no varchar2(20),
GL_code	varchar2(9),
Chapitre varchar2(9),
Cust_ID varchar2(6),
Customer_name	 varchar2(100),
outstanding_balance number,
Provision_NFC number);



update deloitte_accounts da set da.delta_ac_no = (select  delta_ac_no from account_map am  where am.fcubs_ac_no = '0'||da.fcubs_ac_no);

update deloitte_accounts da set da.delta_ac_no = (select  delta_ac_no from loan_account_map am  where am.fcubs_ac_no = da.fcubs_ac_no and am.delta_ac_no is null);


select * from deloitte_accounts;

select * from loan_account_map where fcubs_ac_no in (select fcubs_ac_no from deloitte_accounts )
