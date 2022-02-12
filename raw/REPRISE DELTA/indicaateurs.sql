-- Nombre de mouvements
select count(*)as nombre from mouvement2008
/*where mvtw_cha like '371%'
or mvtw_cha like '372%'
or mvtw_cha like '373%'*/;

select count(*)as nombre from mouvement2009
where mvtw_dco <= to_date ('31/03/2009','DD/MM/YYYY') 
/*and( mvtw_cha like '371%'
or mvtw_cha like '372%'
or mvtw_cha like '373%')*/;

--Nombre de d�p�ts

select count(*)as nombre from mouvement2012
where mvtw_dco <= to_date ('31/03/2009','DD/MM/YYYY') 
and  mvtw_ope ='001'
and( mvtw_cha like '371%'
or mvtw_cha like '372%'
or mvtw_cha like '373%');

select count(*)as nombre from mouvement2008
where mvtw_ope ='001'
and( mvtw_cha like '371%'
or mvtw_cha like '372%'
or mvtw_cha like '373%');

--Nombre de comptes de la client�le

select count(*) as nombre from compte2011
where  (comw_cha like '371%'
or comw_cha like '372%'
or comw_cha like '373%');


-- D�posants
select count(*) from clients 
where cliw_cli in 
(
select distinct comw_cli as nombre from compte2011
where  (comw_cha like '371%'
--or comw_cha like '372%'
or comw_cha like '3735%'
or comw_cha like '36%')
)
and cliw_cli >'000999';


select * from compte2008 where comw_cha like '36%'


select count(*) 
from compte2009
where comw_cha in ;

-- Personnes Physiques
--Depots
select count(*) 
from compte2006
where comw_cha in ('37200','37280','37281','37282','37290','37291','37300','37350','37380','37381','37385','37390')
or 
comw_cha in ('37100','37150','37155','37160','37160','37170','37190','37195','37197')
--and mvtw_age = '41'
--group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;

select count(*) 
from mouvement2012
where comw_cha in ('37200','37280','37281','37282','37290','37291','37300','37350','37380','37381','37385','37390')
or comw_cha in ('37100','37150','37155','37160','37160','37170','37190','37195','37197')



--Empruntss
select count(*) 
from compte2009 co join typeclient2009 tc on co.COMW_CLI = tc.COMW_CLI
where co.COMW_CHA between '30100' and '32999'
and tc.TYPECLI = 'I' 
--and mvtw_age = '41'
--group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;




-- Personnes Morales
select count(*) 
from mouvement2009
where mvtw_cha in ('37100','37150','37155','37160','37160','37170','37190','37195','37197')
--and mvtw_age = '41'
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;

-- Administrattions Publiques
select count(*) 
from mouvement2006
where mvtw_cha in ('37110','37120','37121','37130','37140','37141')
and mvtw_age = '41'
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;


-- Commercants
select count(*) 
from mouvement2006
where mvtw_cha in ('37180','37181')
and mvtw_age = '41'
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;


-- Comptes d'�pargnes Personnes Physiques
select count(*) 
from mouvement2011
where mvtw_cha in ('37300','37350','37380','37381','37390')
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;


-- Comptes d'�pargnes Personnes Morales
select count(*) 
from mouvement2009
where mvtw_cha in ('37385')
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;

-- DAT
select count(*)
from compte2011
where comw_cha between '36000' and '36900'
and comw_dou <'30/09/2011'
--group by comw_age,comw_cha,comw_cli,comw_dou,comw_sde


-- DAV
select count(*)
from compte2011
where comw_cha between '37300' and '37999'
and comw_cli >'000999'
--group by comw_age,comw_cha,comw_cli,comw_dou,comw_sde



select count(*), nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)  as solde 
from mouvement2011
where mvtw_cha between '36000' and '36900'
--and mvtw_dco <'30/09/2012'
union
select count(*), nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)  as solde 
from mouvement2011
where mvtw_cha between '37300' and '37399'
--and mvtw_dco <'31/12/2011'
--group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf
--having nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)>0
union
select count(*), nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)  as solde 
from mouvement2011
where mvtw_cha between '30100' and '32999'
union
select count(*), nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)  as solde 
from mouvement2011
where mvtw_cha between '37200' and '37299'

-- DAT Individus
select count(*) 
from mouvement2012
where mvtw_cha in( '36115','36129','36135','36141','36280','36380','36480','36850')
--group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;

-- Comptes ch�ques personnes morales
select count(*) 
from mouvement2009
where mvtw_cha between '37100' and '37199'
and mvtw_cha <> '37180'
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;


-- Comptes ch�ques personnes physiques
select count(*) 
from mouvement2011
where mvtw_cha between '37200' and '37299'
or mvtw_cha = '37180'
group by mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf, mvtw_let;

select distinct comw_cha
from compte2006
where substr(comw_cha, 1,3) = '371';

--- Nombre de clients et r�partitions par agence ---

select cliw_age, count(*) as nombre
from clients
where cliw_cli >'000999'
group by cliw_age;

create or replace view account_repart as

select  
co.comw_age,
case when (co.COMW_CHA  between '37100' and '37179') or (co.COMW_CHA  between '37190' and '37199') then count(*) end as Checking_accounts_Corporate,
case when co.COMW_CHA  between '37180' and '37189' then count(*) end as Checking_accounts_Non_Salary,
case when co.COMW_CHA  between '37280' and '37280' then count (*) end as Current_accounts_CC,
case when co.COMW_CHA  between '37281' and '37289' then count (*) end as Current_accounts_non_CC,
case when co.COMW_CHA  between '37290' and '37299' then count (*) end as Current_accounts_Staff,
case when co.COMW_CHA  between '37300' and '37399' then count(*) end as Saving_Accounts,
case when co.COMW_CHA  between '36115' and '36850' then count(*) end as Term_Deposits,
case when co.COMW_CHA  between '30100' and '32999' then count(*) end as Loans
from compte2011 co
where co.COMW_CLI>'000999'
and co.COMW_CHA between '30100' and '37399'
group by co.COMW_AGE, co.COMW_CHA;


select * from balance000

select ar.COMW_AGE, 
sum (ar.CHECKING_ACCOUNTS_CORPORATE) as CHECKING_ACCOUNTS_CORPORATE,
sum (ar.CHECKING_ACCOUNTS_NON_SALARY) as CHECKING_ACCOUNTS_NON_SALARY,
sum (ar.CURRENT_ACCOUNTS_CC) as CURRENT_ACCOUNTS_CC,
sum (ar.CURRENT_ACCOUNTS_NON_CC) as CURRENT_ACCOUNTS_NON_CC,
sum (ar.CURRENT_ACCOUNTS_STAFF) as CURRENT_ACCOUNTS_STAFF,
sum (ar.SAVING_ACCOUNTS) as SAVING_ACCOUNTS,
sum(ar.TERM_DEPOSITS ) as TERM_DEPOSITS,
sum(ar.LOANS ) as LOANS
from 
(
select 
co.comw_age,
case when (co.COMW_CHA  between '37100' and '37179') or (co.COMW_CHA  between '37190' and '37199') then count(*) end as Checking_accounts_Corporate,
case when co.COMW_CHA  between '37180' and '37189' then count(*) end as Checking_accounts_Non_Salary,
case when co.COMW_CHA  between '37280' and '37280' then count (*) end as Current_accounts_CC,
case when co.COMW_CHA  between '37281' and '37289' then count (*) end as Current_accounts_non_CC,
case when co.COMW_CHA  between '37290' and '37299' then count (*) end as Current_accounts_Staff,
case when co.COMW_CHA  between '37300' and '37399' then count(*) end as Saving_Accounts,
case when co.COMW_CHA  between '36115' and '36850' then count(*) end as Term_Deposits,
case when co.COMW_CHA  between '30100' and '32999' then count(*) end as Loans
from compte2011 co
where co.COMW_CLI>'000999'and co.comw_ife ='N'
and co.COMW_CHA between '30100' and '37399'
group by co.COMW_AGE, co.COMW_CHA
) ar
group by ar.COMW_AGE;


select distinct comw_cha from compte2012


select cliw_cli, cliw_int from clients
where cliw_cli>'000999'
and cliw_age ='99';


select count(*)
from compte2011
where COMW_CHA  between '30100' and '32999';
--where comw_cha between '30100' and '32999';

select count(*) 
from compte2011 
where

----- ---- ---- ---- ---- RMBATCHA ---- ---- ---- Ne rien modifier dans cette rubrique SVP!!---- ---- ---- ---- ---- 
-- LIKE, "%" et "_" :
-- SELECT Vil_Nom FROM Villes WHERE Vil_Nom LIKE '_i%' (permet de trouver toutes les villes dont le 2eme caractere est un i)
--- Creation de l'instance ---
userid: SYSTEM
password: AGL

--- Creation d'une base de donnee ---
create user user_support 
            identified by support 
            default tablespace users 
            temporary tablespace temp;
--- l'instruction GRANT CONNECT est indispensable pour que l'utilisateur 'user_support' puisses se connecter 
--  au serveur oracle ---             
            grant connect to user_support;
-- grant-resource gives unlimited tablespace privilege
            grant resource to user_support;
-- mise a jour des enregistrements dans la table ---             
insert into modules  (module_code,module_description)
            values('SI','Standing_Instruction') 
update modules
       set module_description ='Standing Instaruction'
       where module_code= 'SI' 
delete from modules
       where module_code ='cl'            
--- Creation de la table 'issue_register' dans user_support ---  
create table issue_register1
(
  branch_code number(3)not null,
  uat_stage varchar(5),
  module_code varchar(2),
  module_description varchar2(25),
  report_name varchar2(15)not null,
  defect_origination_date date, 
  defect_descrition varchar2(500),
  function_id_affected varchar2(25),
  logical_day number(1), 
  severity_code  varchar(1),
  severity_code_description varchar(100),
  priority varchar(10) not null,
  defect_status varchar2(10),
  support_name varchar(10),
  support_remarks varchar(500),
  testing_status varchar2(15),
  sfr_closure_date date
);
  
 --- Creation de la table 'reference_table' dans user_support 
 create table reference_table
(
  ref_field varchar2(30)not null,
  ref_code   char(02)not null,
  ref_value varchar2(50)
  
);  
 --- Creation de la table 'modules' dans user_support 
 create table modules
(
  module_code char(02)not null,
  module_description varchar(30)not null
  
);  
-- Creation de la table 'support' dans user_support
 create table support
(
  support_id char(02)not null,
  support_description varchar(30)not null
  
); 
-- Creation de la table 'users' dans user_support
 create table users
(
  user_id varchar(25)not null,
  user_support varchar(30)not null,
  user_function varchar(50)not null,
  user_branch number(030)
  
);  
               
--- modification du type d'une colonne dans la table
ALTER TABLE table
MODIFY (col1 type1, col2 type2, ...)
---  
alter table reference_table 
      modify (ref_code char(02))              
--- --- --- Consultation des champs dans les tables --- --- ---
select * from xafnfc.sttm_customer
select * from xafnfc.sttm_cust_account
select * from issue_register
select * from reference_table
select * from modules
select * from users
--- vider la table
delete from issue_register
--- supprimer la table
drop table issue_register
--- Consulter la liste des colonnes d'une table 
describe "nom_de_la_table"
--- --- Consulter tout les tables dans une BD --- ---
select * from user_tables
select * from user_tablespaces
--- Transfert des donnees de la table issue_register de la base user_support@DELTA vers la base gescom@AGL
grant select 
copy from issue_register/user_support@DELTA to issue_register1/gescom@AGL
insert into gescom.issue_register1
            select* from user_support.issue_register
--- Copier le Contenu d'une base de donnee dans une autre ayant la mm structure sur le mm serveur
INSERT INTO bdd2.la_table
SELECT *
FROM bdd1.latable
                                      
--- Nombre de personnes physiques titulaires d'un compte cheque ---- ---
select count(*)from  xafnfc.sttm_cust_account
               --where( ac_open_date between '01-JAN-2012' and '31-DEC-2012')
               where account_class like'285'
               or account_class like '284'
               or account_class like '282'
               or account_class like '283'
               or account_class like '281'
--- Nombre de personnes physiques titulaires d'un compte d'epargne ---- ----
select count(*)from  xafnfc.sttm_cust_account 
               where account_class like'285'
               or account_class like '383'
               or account_class like '384'
               or account_class like '381'
               or account_class like '382'              
               
--- Deposants ---
--- Nombres de deposants 
select count (*) 
      from xafnfc.sttm_customer where customer_no in 
      (select cust_no 
       from xafnfc.sttm_cust_account)
            
--- --- PME (deposants)--- --- 
select count (*) 
      from xafnfc.sttm_customer where customer_no in 
      (
      select cust_no 
      from xafnfc.sttm_cust_account
      where (account_class like '283'
      --or account_class like '382'
      or account_class like '383')
      );  
 --- Menages (deposants)---
 select count (*) 
      from xafnfc.sttm_customer where customer_no in 
      (
      select cust_no 
      from xafnfc.sttm_cust_account
      where cust_ac_no like '___282%'
      ); 
 --- Depots ---
 --- Nombres de comptes de depots
 select * from xafnfc.sttm_cust_account
          where ac_desc like 'NGAH K%' 
          
 select * from compte2011         
 
 --- PME (depots)
  select * from xafnfc.sttm_cust_account
           where account_class like '382'
 --- Menages (depots)
   select count (*) from  xafnfc.sttm_cust_account
                  where account_class like '283' 
                  or account_class like '382'
            
 ---  Tout les comptes dont le account_class debute par le 'xxx' a partir du 4eme caracteres   
 select * from  xafnfc.sttm_cust_account
                  where account_class like '383' 
               
                    
  select * from  xafnfc.sttm_cust_account
           where cust_ac_no = '0203717021177122'
  select * from xafnfc.sttm_cust_account
           where alt_ac_no = '000413738043414802'             
  select * from xafnfc.sttm_customer c 
           where c.customer_name1 like '%ETS%'
           
           
---   
select count(*) from xafnfc.sttm_customer where customer_no in
 (                        
  select cust_no from xafnfc.sttm_cust_account 
                 where substr(account_class ,1,2)not in ('11','12','13','14','15','16','17','19','35','56','56','57'))
                
  select cust_ac_no,alt_ac_no from xafnfc.sttm_cust_account    
  
  select * from xafnfc.sttm_cust_account
 
--- --- --- Table dans la base Delta --- --- ---
select * from CLIENTS 
         where cliw_red like '%TABI%' 
select * from paie_fonctionnaire where fon_matricule = '059612X'        
--- Reccherche de contrepartie des comptes --- 
select * from mouvement2011 where mvtw_mon='60000000' and mvtw_dco= '01-feb-2011'and mvtw_age = '23' 
select * from mouvement2011 where mvtw_dco between '01-11-2011' and '30-11-2011' and mvtw_mon='255000000'and mvtw_age='23'
select * from mouvement2010 where mvtw_mon ='1314780' and mvtw_dco ='27-sep-2010'and mvtw_age ='20'
select * from mouvement2009 where mvtw_dco ='&date'
select * from mouvement2009 where mvtw_mon ='40000000'and mvtw_dco = '29-nov-2010'and mvtw_age = '22'
select * from mouvement2011 where mvtw_mon= '255000000' and mvtw_age = '10' 


        
         
      
