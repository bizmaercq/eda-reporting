-- Reporting by tenor
select duree,sum(Nombre_mois_prec) Nombre_mois_prec,round(sum(Montant_mois_prec)/1000000,2) Montant_mois_prec,sum(Nombre) Nombre,round(Sum(Montant)/1000000,2) Montant
from (
select duree,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then count(*) else 0 end nombre_mois_prec,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then sum(AMOUNT_FINANCED)else 0  end montant_mois_prec,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then count(*)else 0  end Nombre,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then sum(AMOUNT_FINANCED)else 0  end Montant
from (
select case when am.no_of_installments <=24 then 'SHORT TERM WORKING CAPITAL LOANS' 
           when am.no_of_installments between 25 and 120 then 'MEDIUM TERM WORKING CAPITAL LOANS'
           else 'LONG TERM WORKING CAPITAL LOANS' end Duree, am.BOOK_DATE,am.AMOUNT_FINANCED
from cltb_account_master am
)
WHERE BOOK_DATE between add_months('&Start_Date',-1) and '&End_Date'
group by duree,book_date
) group by duree;

-- Reporting by secteur institutionel

select secteur,sum(Nombre_mois_prec) Nombre_mois_prec,round(sum(Montant_mois_prec)/1000000,2) Montant_mois_prec,sum(Nombre) Nombre,round(Sum(Montant)/1000000,2) Montant
from (
select Secteur,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then count(*) else 0 end nombre_mois_prec,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then sum(AMOUNT_FINANCED)else 0  end montant_mois_prec,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then count(*)else 0  end Nombre,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then sum(AMOUNT_FINANCED)else 0  end Montant
from (
select
 (select decode(m.cust_mis_1
       ,'11100','Soci�t� non financi�re publique','11200','Soci�t� non financi�re publique','11300','Soci�t� non financi�re publique Sous Contr�le Etranger'
       ,'12100','Banque Central'
       ,'12211','Institutions de d�p�t mon�taire publiques','12212','Institutions de d�p�t mon�taire Priv�s Nationales','12213','Institutions de d�p�t mon�taire sous controle etranger'
       ,'12301','Interm�diaire Financiers publics','12302','Interm�diaire Financiers priv�s nationaux','12303','Interm�diaire Financiers sous controle etranger'
       ,'12401','Auxiliaires Financiers publics','12402','Auxiliaires Financiers priv�s nationaux','12403','Auxiliaires Financiers sous controle etranger'
       ,'12501','Soci�t�s d''assurance publics','12502','Soci�t�s d''assurance priv�es nationales','12503','Soci�t�s d''assurance sous controle etranger'
       ,'13110','Administration publique Centrale','13120','Administration publique Locale','13130','Administration de securit� sociale'
       ,'14100','Employeurs','14200','Travailleurs pour leur propre compte','14300','Salari�s','14410','Beneficiaires des revenus de propri�t�','14420','B�n�ficiaires de pensions','14430','B�n�ficiaires d''autres transferts'
       ,'15000','Institutions sans but lucratif au service des m�nages','Non Ventile') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) Secteur,
  Book_date,amount_financed
 from xafnfc.cltb_account_master am
)
WHERE BOOK_DATE between add_months('&Start_Date',-1) and '&End_Date'
group by secteur,book_date
) group by secteur;

--- Reporting by Secteur d'activit�s

select secteur,sum(Nombre_mois_prec) Nombre_mois_prec,round(sum(Montant_mois_prec)/1000000,2) Montant_mois_prec,sum(Nombre) Nombre,round(Sum(Montant)/1000000,2) Montant
from (
select Secteur,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then count(*) else 0 end nombre_mois_prec,
case when BOOK_DATE between add_months('&Start_Date',-1) and add_months('&End_Date',-1) then sum(AMOUNT_FINANCED)else 0  end montant_mois_prec,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then count(*)else 0  end Nombre,
case when BOOK_DATE between '&Start_Date' and '&End_Date' then sum(AMOUNT_FINANCED)else 0  end Montant
from (
select
 (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','10','Activivt�s extractives','11','Activivt�s extractives','12','Activivt�s extractives'
       ,'13','Activivt�s extractives','14','Activivt�s extractives','15','Activit�s de fabrication','16','Activit�s de fabrication'
       ,'17','Activit�s de fabrication','18','Activit�s de fabrication','19','Activit�s de fabrication','20','Activit�s de fabrication'
       ,'21','Activit�s de fabrication','22','Activit�s de fabrication','23','Activit�s de fabrication','24','Activit�s de fabrication'
       ,'25','Activit�s de fabrication','26','Activit�s de fabrication','27','Activit�s de fabrication','28','Activit�s de fabrication'
       ,'29','Activit�s de fabrication','30','Activit�s de fabrication','31','Activit�s de fabrication','32','Activit�s de fabrication'
       ,'33','Activit�s de fabrication','34','Activit�s de fabrication','35','Activit�s de fabrication','36','Activit�s de fabrication'
       ,'37','Activit�s de fabrication','40','Production et distribution d''�lectricit�,de gaz et d''eau'
       ,'41','Production et distribution d''�lectricit�,de gaz et d''eau'
       ,'45','Construction','50','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'51','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'52','Commerce,reparation de vehicules automobiles et d''articles domestiques','55','Hotels et restaurants'
       ,'60','Transports,activit�s des auxiliaires de transport et communications','61','Transports,activit�s des auxiliaires de transport et communications'
       ,'62','Transports,activit�s des auxiliaires de transport et communications','63','Transports,activit�s des auxiliaires de transport et communications'
       ,'64','Transports,activit�s des auxiliaires de transport et communications','65','Activit�s financi�res','66','Activit�s financi�res'
       ,'67','Activit�s financi�res','70','Immobilier,locations et services aux entreprises','71','Immobilier,locations et services aux entreprises'
       ,'72','Immobilier,locations et services aux entreprises','73','Immobilier,locations et services aux entreprises'
       ,'74','Immobilier,locations et services aux entreprises','75','Activivt�s d''administration publique','80','Education'
       ,'85','Activit�s de sant� et d''action sociale','90','Activit�s � caract�re collectif ou personnel'
       ,'91','Activit�s � caract�re collectif ou personnel','92','Activit�s � caract�re collectif ou personnel'
       ,'93','Activit�s � caract�re collectif ou personnel','95','Activit�s des m�nages en tant qu''employeurs de personnel domestique'
       ,'99','Activit�s des organisations extraterritoriales','00','Non Ventile','Non Ventile') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) Secteur,
  Book_date,amount_financed
 from xafnfc.cltb_account_master am
)
WHERE BOOK_DATE between add_months('&Start_Date',-1) and '&End_Date'
group by secteur,book_date
) group by secteur;