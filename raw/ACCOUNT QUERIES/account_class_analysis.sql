-----dormant account
select l.branch_code,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance,l.date_last_cr_activity
from sttm_cust_account l
where  l.ac_stat_dormant like 'Y'
order by l.branch_code
----- -- New customers 
SELECT nvl(to_char(cu.cif_creation_date,'YYYY'),'2012') YEAR,
decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') customer_type,
count(*)  "NEW CUSTOMERS"
FROM  sttm_customer cu
WHERE  cu.record_stat ='O'
group by to_char(cu.cif_creation_date,'YYYY'),
  decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE')
order by nvl(to_char(cu.cif_creation_date,'YYYY'),'2012');



----- -- New customers with loans 
SELECT nvl(to_char(cu.cif_creation_date,'YYYY'),'2012') YEAR,
decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') customer_type,
count(*)  "NEW CUSTOMERS"
FROM  sttm_customer cu, cltb_account_master am
WHERE cu.customer_no =   am.CUSTOMER_ID
--and to_char(am.BOOK_DATE,'YYYY')='2012'
and cu.record_stat ='O'
group by nvl(to_char(cu.cif_creation_date,'YYYY'),'2012'),
  decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE')
order by nvl(to_char(cu.cif_creation_date,'YYYY'),'2012');




----- -- Accounts opened and amounts by account class type 
SELECT to_char(ca.ac_open_date,'YYYY') YEAR,
--ca.branch_code,
ac.description, 
decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') customer_type,
count(*)  "ACCOUNTS OPENED", sum(ca.lcy_curr_balance) AMOUNT
FROM sttm_cust_account ca, sttm_account_class ac, sttm_customer cu
WHERE ca.account_class = ac.account_class 
and ca.cust_no = cu.customer_no
--and substr(ca.account_class,1,1) in ('2','3') 
--and ca.account_class ='&Account_Class'
--and ca.account_class ='&Account_Class'
--and ca.ac_open_date >='01/01/2012'
and ca.record_stat ='O'
group by --ca.branch_code,
ac.description,
  to_char(ca.ac_open_date,'YYYY'),
  decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE')
order by to_char(ca.ac_open_date,'YYYY');
--,ca.branch_code;

-- Customer accounts
select a.branch_code, a.account_class, c.description,cu.customer_no,cu.customer_name1
from sttm_cust_account a  , sttm_account_class c, sttm_customer cu
where a.account_class = c.account_class
and a.cust_no = cu.customer_no
and a.branch_code ='&Branch' 
and a.record_stat ='O'
order by a.branch_code,c.account_class;
-- Summary of Customer accounts
select a.branch_code, a.account_class, c.description,count(*) "COUNT", sum(a.lcy_curr_balance) Encours
from sttm_cust_account a  , sttm_account_class c
where a.account_class = c.account_class
and a.record_stat ='O'
and a.branch_code ='&Branch'
group by a.branch_code, a.account_class, c.description
order by a.account_class,a.branch_code;

-- Count of Customers
select c.local_branch, decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK') CATEGORY, count(*) "COUNT" 
from sttm_customer c 
where c.record_stat = 'O'
and c.local_branch ='&Branch'
group by c.local_branch, c.customer_type
order by c.local_branch;

--- Loans
select  decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK') CATEGORY,p.product_description ,decode(l.ACCOUNT_STATUS,'L','LIQUIDATE','V','V','ACTIVE') STATUS ,count(*) "COUNT", sum(b.lcy_balance) Encours
from sttm_customer c , cltb_account_master l, cltb_account_comp_bal_breakup b , cstm_product p
where c.customer_no = l.CUSTOMER_ID
and l.PRODUCT_CODE = p.product_code
and l.ACCOUNT_NUMBER = b.account_number
and c.record_stat = 'O'
and l.BOOK_DATE <= '&Date'
and c.local_branch ='&Branch'
and l.ACCOUNT_STATUS ='A'
group by c.customer_type,p.product_description,l.ACCOUNT_STATUS
order by decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK');

--- Loans by micro finces
/*select  decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK') CATEGORY,p.product_description ,decode(l.ACCOUNT_STATUS,'L','LIQUIDATE','V','V','ACTIVE') STATUS ,count(*) "COUNT", sum(b.lcy_balance) Encours
from sttm_customer c , cltb_account_master l, cltb_account_comp_bal_breakup b , cstm_product p, sttm_cust_account ca
where c.customer_no = l.CUSTOMER_ID
and l.PRODUCT_CODE = p.product_code
and l.ACCOUNT_NUMBER = b.account_number
and l.DR_PROD_AC = ca.cust_ac_no
and ca.account_class ='151'
and c.record_stat = 'O'
and l.BOOK_DATE <= '&Date'
and l.ACCOUNT_STATUS ='A'
group by c.customer_type,p.product_description,l.ACCOUNT_STATUS
order by decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK');
*/


/*-- count
 SELECT customer_type,count(*) FROM 
 (SELECT distinct am.CUSTOMER_ID, sc.customer_type FROM cltb_account_master am, sttm_customer sc
 WHERE am.CUSTOMER_ID = sc.customer_no
 and am.BOOK_DATE <='31/12/2015')
 group by customer_type;*/
/*
-- Loans Status and 
select  decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK') CATEGORY,decode(l.ACCOUNT_STATUS,'L','LIQUIDATE','V','V','ACTIVE') STATUS ,count(*) "COUNT", sum(b.lcy_balance) Encours
from sttm_customer c , cltb_account_master l, cltb_account_comp_bal_breakup b , cstm_product p
where c.customer_no = l.CUSTOMER_ID
and l.PRODUCT_CODE = p.product_code
and l.ACCOUNT_NUMBER = b.account_number
and c.record_stat = 'O'
and l.BOOK_DATE <='&Enddate'
group by  c.customer_type,p.product_description,l.ACCOUNT_STATUS
order by decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK');

*/

--- Accounts opened Analysis by branch 
SELECT ac.branch_code,ac.Business_Account,ac.Current_Account,ac.Savings_Account,ac.Microsave_Account,ac.Halal_Savings_Account,nvl(cl.Closed_Accounts,0) Closed_Accounts
 from
(
SELECT branch_code
,sum(Business_Account) Business_Account
,sum(Current_Account) Current_Account
,sum(Savings_Account) Savings_Account
,sum(Microsave_Account) Microsave_Account
,sum(Halal_Savings_Account) Halal_Savings_Account
 FROM 
(
select a.branch_code, 
case when substr(c.account_class,1,1) = '1'   then count(*) else 0 end Business_Account,
case when substr(c.account_class,1,1) = '2'  then count(*) else 0 end Current_Account,
case when c.account_class in ('351','364','370','381','382','383','384')  then count(*) else 0 end Savings_Account,
case when c.account_class in ('386')  then count(*) else 0 end Microsave_Account,
case when c.account_class in ('387')  then count(*) else 0 end Halal_Savings_Account 
from sttm_cust_account a  , sttm_account_class c 
where a.account_class = c.account_class
and a.branch_code ='&Branch'
--and a.ac_open_date between '&Start_Date' and '&End_Date'
and a.ac_open_date <= '&End_Date'
group by a.branch_code,c.account_class,a.cust_ac_no,a.ac_open_date,a.record_stat,a.checker_dt_stamp 
) group by  branch_code ) ac  
left outer join (SELECT branch_code,0 Business_Account,0 Current_Account,0 Savings_Account,0 Microsave_Account,0 Halal_Savings_Account,count(*) Closed_Accounts
FROM sttm_cust_account where record_stat ='C' and  nvl( ( select max(brn_date)  from ictb_acc_action mm where action='C' and mm.acc =cust_ac_no ) , checker_dt_stamp ) <= '&End_Date' 
group by branch_code) cl
on ac.branch_code = cl.branch_code
order by ac.branch_code;

---- by Gender 

--- Accounts opened Analysis by branch 
SELECT /*ac.branch_code,*/ ac.gender,ac.Business_Account,ac.Current_Account,ac.Savings_Account,ac.Microsave_Account,ac.Halal_Savings_Account
 from
(
SELECT/* branch_code,*/gender
,sum(Business_Account) Business_Account
,sum(Current_Account) Current_Account
,sum(Savings_Account) Savings_Account
,sum(Microsave_Account) Microsave_Account
,sum(Halal_Savings_Account) Halal_Savings_Account
 FROM 
(
select/* a.branch_code,*/nvl(cp.sex,'C') gender,
case when substr(c.account_class,1,1) = '1'   then count(*) else 0 end Business_Account,
case when substr(c.account_class,1,1) = '2'  then count(*) else 0 end Current_Account,
case when c.account_class in ('351','364','370','381','382','383','384')  then count(*) else 0 end Savings_Account,
case when c.account_class in ('386')  then count(*) else 0 end Microsave_Account,
case when c.account_class in ('387')  then count(*) else 0 end Halal_Savings_Account 
from sttm_cust_account a  , sttm_account_class c ,sttm_cust_personal cp
where a.account_class = c.account_class
and cp.customer_no = a.cust_no
--and a.branch_code ='&Branch'
--and a.ac_open_date between '&Start_Date' and '&End_Date'
and a.ac_open_date <= '&End_Date'
group by /*a.branch_code,*/cp.sex,c.account_class,a.cust_ac_no,a.ac_open_date,a.record_stat,a.checker_dt_stamp 
) group by  /*branch_code,*/ gender ) ac  
--order by ac.branch_code;


--- Balances by gender








-- Accounts count 
SELECT branch_code,ac.Business_Account,ac.Current_Account,ac.Savings_Account,ac.Microsave_Account,ac.Halal_Savings_Account,nvl(cl.Closed_Accounts,0) Closed_Accounts
 from
(
SELECT sum(Business_Account) Business_Account
,sum(Current_Account) Current_Account
,sum(Savings_Account) Savings_Account
,sum(Microsave_Account) Microsave_Account
,sum(Halal_Savings_Account) Halal_Savings_Account
 FROM 
(
select a.branch_code, 
case when substr(c.account_class,1,1) = '1'   then count(*) else 0 end Business_Account,
case when substr(c.account_class,1,1) = '2'  then count(*) else 0 end Current_Account,
case when c.account_class in ('351','364','370','381','382','383','384')  then count(*) else 0 end Savings_Account,
case when c.account_class in ('386')  then count(*) else 0 end Microsave_Account,
case when c.account_class in ('387')  then count(*) else 0 end Halal_Savings_Account 
from sttm_cust_account a  , sttm_account_class c 
where a.account_class = c.account_class
--and a.branch_code ='&Branch'
--and a.ac_open_date between '&Start_Date' and '&End_Date'
and a.ac_open_date <= '&End_Date'
group by a.branch_code,c.account_class,a.cust_ac_no,a.ac_open_date,a.record_stat,a.checker_dt_stamp 
) group by  branch_code ) ac  
left outer join (SELECT branch_code,0 Business_Account,0 Current_Account,0 Savings_Account,0 Microsave_Account,0 Halal_Savings_Account,count(*) Closed_Accounts
FROM sttm_cust_account where record_stat ='C' and  nvl( ( select max(brn_date)  from ictb_acc_action mm where action='C' and mm.acc =cust_ac_no ) , checker_dt_stamp ) <= '&End_Date' 
group by branch_code) cl
on branch_code = cl.branch_code
order by branch_code;
