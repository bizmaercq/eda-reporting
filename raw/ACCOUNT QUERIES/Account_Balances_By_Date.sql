-- Detailed extended to Gls
select substr(ac.dr_gl,1,3) Class, ac.dr_gl DR_GL,ac.cr_gl CR_GL,aa.account,ac.ac_desc,aa.bkg_date LAST_MVT_DATE,'&Date' Period_End_Date,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac
where aa.account = ac.cust_ac_no 
and aa.bkg_date = (select max(a.bkg_date) from actb_accbal_history a 
                    where a.bkg_date <= '&Date' 
                    and a.account = aa.account)
--and substr(ac.cust_ac_no,4,5) ='28102' --- Teller second accounts
--and substr(ac.account_class,1,1) in ('1','2','3','5') -- Normal customer accounts
--and substr(ac.dr_gl,1,3) in ('371','372','373')
--and nvl(aa.lcy_closing_bal,0) > 0
order by aa.branch_code, aa.account;


-- Detailed with correponding Debit or Credit Gls
Select Class,case when debit_balance is not null then dr_gl else cr_gl end GL,nvl(credit_balance,0) - nvl(debit_balance,0) Balance
from (select substr(ac.dr_gl,1,3) Class, ac.dr_gl DR_GL,ac.cr_gl CR_GL,aa.account,ac.ac_desc,'&Date' Period_End_Date,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac
where aa.account = ac.cust_ac_no 
and aa.bkg_date = (select max(a.bkg_date) from actb_accbal_history a 
                    where a.bkg_date <= '&Date' 
                    and a.account = aa.account)
--and substr(ac.cust_ac_no,4,5) ='28102' --- Teller second accounts
--and substr(ac.account_class,1,1) in ('1','2','3','5') -- Normal customer accounts
--and substr(ac.dr_gl,1,3) in ('371','372','373')
--and nvl(aa.lcy_closing_bal,0) > 0
order by aa.branch_code, aa.account);


-- Detailed by value date
select aa.brn,aa.acc,c.customer_name1,'&Date' Period_End_Date, aa.lcy_bal from
ACTB_VD_BAL aa , sttm_customer c
where substr(aa.acc,9,6) = c.customer_no 
and aa.val_dt =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&Date' 
and a.account = aa.acc)
and aa.brn = '021'
--and aa.account = '&Account'
and aa.acc in
(select ac.cust_ac_no from sttm_cust_account ac where (ac.account_class between '110'and '387') and ac.record_stat ='O')
order by aa.brn, aa.acc;


-- summary and count select c.customer_type,cp.sex,count(*),sum(aa.acy_closing_bal)  from
actb_accbal_history aa , sttm_customer c, sttm_cust_personal cp
where substr(aa.account,9,6) = c.customer_no 
and c.customer_no = cp.customer_no
and aa.bkg_date =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&Date' 
and a.account = aa.account)
and aa.lcy_closing_bal >0
--and aa.account = '&Account'
--and aa.account in (select ac.cust_ac_no from sttm_cust_account ac where ac.account_class = '281' and ac.record_stat ='O')
group by c.customer_type,cp.sex;

----

-----COMPTE CLASSE 5

select description, sum(Credit_Balance)/*-sum(Debit_Balance)*/ encours  from(
select ca.account_class Account_class,ca.description,substr(ac.dr_gl,1,3) Class, ac.dr_gl GL,aa.account,ac.ac_desc,aa.bkg_date LAST_MVT_DATE,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac, sttm_account_class ca
where aa.account = ac.cust_ac_no
and ac.account_class=ca.account_class 
and aa.bkg_date = (select max(a.bkg_date) from actb_accbal_history a 
                    where a.bkg_date <= '&Date' 
                    and a.account = aa.account)
--and substr(ac.account_class,1,1) in ('1','2','3','5')
and ca.account_class in ('551','552','553','570','571','572','573','580','581')
and nvl(aa.lcy_closing_bal,0) >0
order by aa.branch_code, aa.account)
group by Account_class,description 
order by  Account_class;


------
-- Detailed extended to Gls sum
select decode(CODE_CLASSE,
'1','Depot de L etat (Administration publique et locale)',
'2','Depot entreprise publique',
'3','Depot secteur prive',
'4','classe 5',
'non ventillé') CODE_CLASSE,round(sum(encours)/1000000,2) Depot from (
select 
CODE_CLASSE,account_class, description, sum(Credit_Balance)/*-sum(Debit_Balance)*/ encours  from(
select decode(ca.account_class,'161','1','162','1','191','1',
'171','2','163','2',
'384','3','370','3','351','3','164','3','112','3','172','3','173','3','174','3','192','3','281','3','282','3','283','3','381','3','382','3','383','3','285','3','386','3','387','3','351','3','151','3','364','3',
'551','4','552','4','553','4','570','4','571','4','572','4','573','4','580','4','581','4','0') 
CODE_CLASSE,
ca.account_class,ca.description,substr(ac.dr_gl,1,3) Class, ac.dr_gl GL,aa.account,ac.ac_desc,aa.bkg_date LAST_MVT_DATE,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac, sttm_account_class ca
where aa.account = ac.cust_ac_no
and ac.account_class=ca.account_class 
and aa.bkg_date = (select max(a.bkg_date) from actb_accbal_history a 
                    where a.bkg_date <= '&Date' 
                    and a.account = aa.account)
--and substr(ac.account_class,1,1) in ('1','2','3','5')
and nvl(aa.lcy_closing_bal,0) >0
order by aa.branch_code, aa.account)
group by CODE_CLASSE,account_class,description 
order by  account_class)
group by CODE_CLASSE
