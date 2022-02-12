
-- 1- to extract loans 

select 'NFC BANK' "Etablissement",
'10025' "Code banque",
Book_date "Date de mise en place du pr�t",
case when no_of_installments <=24 then 'SHORT TERM WORKING CAPITAL LOANS' 
           when no_of_installments between 25 and 120 then 'MEDIUM TERM WORKING CAPITAL LOANS'
           else 'LONG TERM WORKING CAPITAL LOANS' end "Nature du pr�t",
case when no_of_installments <=24 then '32' 
           when no_of_installments between 25 and 120 then '31'
           else '30' end "Chapitre comptable du pr�t",
 customer_name1 "Nom ou d�nomination",
decode(c.customer_type,'I','PARTICULIER','PME') "Type de b�n�ficiaire",
null "Lieu de r�sidence", 

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
       ,'99','Activit�s des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) "Secteur d�activit�",
 null "Chiffre d'affaires",
 null "Nombre d'employ�s",
 c.udf_4 " Profession (si particulier)",
 amount_disbursed "Montant du pr�t",
 no_of_installments "DUREE DU PRET",
 round(months_between(am.first_ins_date,am.value_date))  "Nombre de mois de diff�r�",
 decode(frequency_unit,'M','1','Q','2','H','3','Y','4') "Fr�quence de remboursement",
 (select ude_value from xafnfc.cltb_account_ude_values uv where ude_id = 'INTEREST_RATE' and uv.account_number = am.ACCOUNT_NUMBER
        and effective_date =  
        (select max(uv1.effective_date) from xafnfc.cltb_account_ude_values uv1 where uv.account_number = uv1.account_number and uv1.ude_id = 'INTEREST_RATE')) 
      "TAUX INTERET NOMINAL",
  (select sum(amount_due) from xafnfc.cltb_account_schedules 
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%'))"FRAIS DE DOSSIER ET COMMISSION",
 1 "MODE DE DEBLOCAGE DES FONDS",    
 null "Modalit� des frais d�assurance",null "Co�t de l�assurance ", null "Frais annexes",    
 1 " Mode de remboursement ", 
 (select ceil(sum(amount_due)/am.no_of_installments) amount_due_avg from xafnfc.cltb_account_schedules
       where account_number = am.account_number and component_name in ('PRINCIPAL','MAIN_INT')) "MENSUALITE",
 
 1 " Mode de d�blocage des fonds",
case when 
          (select count(*) from xafnfc.cltb_account_schedules ll where ll.ACCOUNT_NUMBER = am.account_number and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0)/* UNPAID_INSTALLMENTS*/ <> no_of_installments 
           and USER_DEFINED_STATUS IN ('NORM')
           then '1' else '4' end "SITUATION DE LA CREANCE",
 teg(am.account_number,0,0,1)*100*12 "TEG calcul� par la banque"
     
 from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between &date1 and &date2-- and c.customer_type='C'
and am.ACCOUNT_NUMBER in ('022S14S182290006','023S13S183530002','050S11K182340001','050S11K182280001','023S11K182560003','024S11K183250001')
--and  ( (no_of_installments >=6) /*or (am.PRODUCT_CODE not in ('S01K','S08K') )*/ ) 
and substr(am.DR_PROD_AC,4,3) <>'281'
order by "Secteur d�activit�","Nature du pr�t";


-- 2- to extract overdrafts 
select'NFC BANK' "Etablissement",
'10025' "Code banque",
nvl(x.m_appl_date,a.tod_limit_start_date) "DATE DE MISE EN PLACE",
 c.customer_name1 BENEFIAIRE,
 decode(c.customer_type,'I','PARTICULIER','PME') "TYPE DE BENEFICIAIRE",
 null "LIEU IMPLANTATION",
  (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','J','C','K','C','L','C','M','C','N','C','O','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','J','Activivt�s extractives','K','Activivt�s extractives','L','Activivt�s extractives'
       ,'M','Activivt�s extractives','N','Activivt�s extractives','O','Activit�s de fabrication','16','Activit�s de fabrication'
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
       ,'99','Activit�s des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) "SECTEUR ACTIVITE",
    nvl(x.a_tod_amount,a.tod_limit) "MONTANT AUTORISATION",
     decode(c.customer_type,'I',8.5,15) "TAUX NOMINAL",
     'Non' "SOUSCRIPTION ASSURANCE?",
     0 ASSURANCE,
 decode(c.customer_type,'I',0, case when x.a_tod_amount  < 50000000 then 25000 
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100)) "FRAIS ET COMMISSION",
 0 "FRAIS ANNEXES",
decode(c.customer_type,'I',8.5,15 + (case when x.a_tod_amount  < 50000000 then 25000 
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100) ) / nvl(x.a_tod_amount,a.tod_limit)*100/12) "TEG"
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where h.tod_amount <>0 and appl_date between &date1 and &date2 group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between &date1 and &date2 and a.tod_limit >0 
and a.tod_limit<>0
and a.cust_no = cc.customer_no
and a.account_class <>'281'
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between &date1 and &date2
)
order by   "SECTEUR ACTIVITE","TYPE DE BENEFICIAIRE";

------ Commercial Effects


select distinct 'NFC BANK' "Etablissement",
'10025' "Code banque",
Book_date  "DATE DE MISE EN PLACE",
 c.customer_name1 BENEFIAIRE,
 decode(c.customer_type,'I','PARTICULIER','PME') "TYPE DE BENEFICIAIRE",
 null "LIEU IMPLANTATION",
  (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','J','C','K','C','L','C','M','C','N','C','O','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','J','Activivt�s extractives','K','Activivt�s extractives','L','Activivt�s extractives'
       ,'M','Activivt�s extractives','N','Activivt�s extractives','O','Activit�s de fabrication','16','Activit�s de fabrication'
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
       ,'99','Activit�s des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) "Secteur d�activit�",
 amount_disbursed "Montant de l'effet",
 Maturity_date-value_date "Dur�e de l'effet (en jours)",
 taux_effet(am.ACCOUNT_NUMBER) "Taux Nominal (%)",
  (select sum(amount_due) from xafnfc.cltb_account_schedules 
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%')) "Frais et Commissions",
   teg_effet(am.ACCOUNT_NUMBER) Teg_Annuel
 from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between &date1 and &date2-- and c.customer_type='C'
and  ( (no_of_installments <=5) /*or (am.PRODUCT_CODE in ('S01K','S08K') )*/ ) 
order by "Secteur d�activit�";



------ To extract Bank Guarantees

select distinct 'NFC BANK' "Etablissement",
'10025' "Code banque",
cm.start_date "DATE DE MISE EN PLACE",
 c.customer_name1 BENEFIAIRE,
 decode(c.customer_type,'I','PARTICULIER','PME') "TYPE DE BENEFICIAIRE",
 null "LIEU IMPLANTATION",
  (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','J','C','K','C','L','C','M','C','N','C','O','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','J','Activivt�s extractives','K','Activivt�s extractives','L','Activivt�s extractives'
       ,'M','Activivt�s extractives','N','Activivt�s extractives','O','Activit�s de fabrication','16','Activit�s de fabrication'
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
       ,'99','Activit�s des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) "SECTEUR ACTIVITE",

    round(co.contract_amt) "MONTANT CAUTION",
    replace(co.tenor,'D','') "DUREE EN JOURS",
     2  "TAUX NOMINAL",
     round(cm.total_commission_amt) "FRAIS ET COMMISSIONS",
     0 "FRAIS ANNEXES",

  case when cm.basis_amount<> 0 then (cm.total_commission_amt/cm.basis_amount)*100 *12/ceil(months_between(co.stop_date,co.effective_date)) else 0 end TEG

from  xafnfc.LCTB_COMMISSION_Master cm ,  xafnfc.lctb_contract_master co , xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc

where cm.contract_ref_no = co.contract_ref_no
and c.customer_no = co.cif_id
and co.effective_date between &date1 and &date2  


order by   "SECTEUR ACTIVITE","TYPE DE BENEFICIAIRE";