-------------- Script 1 ----------
select CU.customer_no MATRICULE, CU.customer_name1 NOM, CU.NATIONALITY NATIONALITE, '' GROUPE, '' COTE, CP.RESIDENT_STATUS RÈSIDENT, CP.D_COUNTRY PAYS_RÈSIDENCE, CU.LOCAL_BRANCH AGENCE, decode(MC.cust_mis_3,'GRP999','93.0',MC.cust_mis_3) CODE_ACTIVITÈ, CU.UDF_4 CATEGORIE, MC.cust_mis_1 CODE_UI
, case when CU.CUSTOMER_TYPE ='C' then'MORALE' ELSE 'PHYSIQUE' end TYPE_PERS
from sttm_customer CU, sttm_cust_personal CP, mitm_customer_default MC
WHERE CP.CUSTOMER_NO = CU.CUSTOMER_NO 
AND CU.CUSTOMER_NO = MC.CUSTOMER
--and CUSTOMER_TYPE = 'C'
;



-------------- Script 2 ----------
select distinct ca.cust_no Matricule, ca.branch_code Agence, ca.cust_ac_no Num_compte, cu.customer_name1 Nom_client, '' Groupe, substr(ca.dr_gl,1,3) chapitre , 
CASE when a1.lcy_closing_bal < 0 then -a1.lcy_closing_bal else 0 end Solde_deb,
CASE when a1.lcy_closing_bal > 0 then a1.lcy_closing_bal else 0 end Solde_cred,
/*  (
      Select DISTINCT NVL(RTRIM(SUBSTR(NEW_VAL, 5), '~'), 0) NEW_TOD from ictb_acc_action ia
      where 
      ia.brn_date >= all (select brn_date from ictb_acc_action a2 where ia.acc = a2.acc and a2.brn_date <= '29/02/2016')
      and ia.brn_date <= '29/02/2016'
      and ia.acc = ca.cust_ac_no
      AND KEY_VAL LIKE '%ACCOUNT_TOD%'
  ) autorisation
 , 
  (
      Select DISTINCT ia.brn_date from ictb_acc_action ia
      where 
      ia.brn_date >= all (select brn_date from ictb_acc_action a2 where ia.acc = a2.acc and a2.brn_date <= '29/02/2016')
      and ia.brn_date <= '29/02/2016'
      and ia.acc = ca.cust_ac_no
      AND KEY_VAL LIKE '%ACCOUNT_TOD%'
  ) echeance
  ,*/
  (
    select DISTINCT ia.trn_dt from actb_history ia
    where 
    ia.trn_dt >= all (select trn_dt from actb_history a2 where ia.ac_no = a2.ac_no and a2.trn_dt <= '29/02/2016'and a2.drcr_ind = 'D')
    and ia.trn_dt <= '29/02/2016'
    and ia.ac_no = ca.cust_ac_no
    and ia.drcr_ind = 'D'
  ) DDMD
  ,
  (
    select DISTINCT ia.trn_dt from actb_history ia
    where 
    ia.trn_dt >= all (select trn_dt from actb_history a2 where ia.ac_no = a2.ac_no and a2.trn_dt <= '29/02/2016'and a2.drcr_ind = 'C')
    and ia.trn_dt <= '29/02/2016'
    and ia.ac_no = ca.cust_ac_no
    and ia.drcr_ind = 'C'
  ) DDMC
  ,
  (
    select DISTINCT ia.trn_dt from actb_history ia
    where 
    ia.trn_dt >= all (select trn_dt from actb_history a2 where ia.ac_no = a2.ac_no and a2.trn_dt <= '29/02/2016'and a2.drcr_ind = 'D')
    and ia.trn_dt <= '29/02/2016'
    and ia.ac_no = ca.cust_ac_no
    and ia.drcr_ind = 'D'
    and ia.module <> 'IC'
  ) DDMDHA
  ,
  (
    select DISTINCT ia.trn_dt from actb_history ia
    where 
    ia.trn_dt >= all (select trn_dt from actb_history a2 where ia.ac_no = a2.ac_no and a2.trn_dt <= '29/02/2016'and a2.drcr_ind = 'C')
    and ia.trn_dt <= '29/02/2016'
    and ia.ac_no = ca.cust_ac_no
    and ia.drcr_ind = 'C'
    and ia.module <> 'IC'
  ) DDMCHA
  
from xafnfc.sttm_cust_account ca, sttm_customer cu, actb_accbal_history a1
WHERE cu.customer_no = ca.cust_no
and a1.account = ca.cust_ac_no
and a1.bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <='29/02/2016')
and a1.bkg_date <= '29/02/2016'
--and ca.branch_code = '032'
;


-------------- Script 2 v2 ----------
select m.BRANCH_CODE,m.ACCOUNT_NUMBER LOAN_ACCOUNT,m.DR_PROD_AC CUST_ACCOUNT,c.customer_name1, m.MATURITY_DATE,MIN(b.balance)
from cltb_account_comp_balances b, cltb_account_master m , sttm_cust_account a, sttm_customer c
where b.account_number = m.ACCOUNT_NUMBER
and a.cust_ac_no = m.DR_PROD_AC
and a.cust_no = c.customer_no
and val_date between  '01/02/2016' and '29/02/2016' and component_name ='PRINCIPAL_OUTSTAND' 
and m.BRANCH_CODE = '024'
group by m.BRANCH_CODE,m.ACCOUNT_NUMBER ,m.DR_PROD_AC,c.customer_name1, m.MATURITY_DATE
having MIN(b.balance) > 0




















select * from gltb_cust_accbreakup ga where ga.cust_ac_no = '0322850105039058' and ga.Period_Code = 'M02' AND ga.Fin_Year = 'FY2016'



--- SOlde des comptes ‡ une date donnÈe
select * from xafnfc.gltb_cust_accbreakup ACB WHERE ACB.Period_Code = 'M02' AND ACB.Fin_Year = 'FY2016'
SELECT * FROM sttm_cust_account

SELECT * FROM mitm_customer_default


select DISTINCT * from ictb_acc_action ia where ia.acc = '0322830104700626'

SELECT ia.new_val FROM ictb_acc_action ia

 SELECT DISTINCT BRN,
               ACC,
               BRN_DATE,
               NVL(RTRIM(SUBSTR(OLD_VAL, 5), '~'), 0) OLD_TOD,
               NVL(RTRIM(SUBSTR(NEW_VAL, 5), '~'), 0) NEW_TOD
FROM ictb_acc_action
WHERE BRN = '&BRANCH'
--AND ACC = '&ACCOUNT'
and BRN_DATE <=  '29/02/2016'
AND KEY_VAL LIKE '%ACCOUNT_TOD%'
ORDER BY BRN_DATE DESC;
 









