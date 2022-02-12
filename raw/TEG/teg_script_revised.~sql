-- 1- to extract loans 

select decode(c.customer_type,'I',1,3) "TYPE DE BENEFICIAIRE", customer_name1 BENEFIAIRE, null "CHIFFRES D''AFFAIRE"
    , case when no_of_installments <=24 then 'SHORT TERM WORKING CAPITAL LOANS' 
           when no_of_installments between 25 and 120 then 'MEDIUM TERM WORKING CAPITAL LOANS'
           else 'LONG TERM WORKING CAPITAL LOANS' end "NATURE DU PRET"
    , case when c.customer_type='C' and (substr(am.dr_prod_ac,4,3) in ('151','164','173') or substr(am.dr_prod_ac,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) in ('161','162','163','164') and substr(am.dr_prod_ac,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) not in ('151','164','173') and substr(am.dr_prod_ac,4,2) like '28%' then 'ENT'
           else 'PAR'  end "TYPE BENEFICIAIRE"
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','J','C','K','C','L','C','M','C','N','C','O','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','J','Activivtés extractives','K','Activivtés extractives','L','Activivtés extractives'
       ,'M','Activivtés extractives','N','Activivtés extractives','O','Activités de fabrication','16','Activités de fabrication'
       ,'17','Activités de fabrication','18','Activités de fabrication','19','Activités de fabrication','20','Activités de fabrication'
       ,'21','Activités de fabrication','22','Activités de fabrication','23','Activités de fabrication','24','Activités de fabrication'
       ,'25','Activités de fabrication','26','Activités de fabrication','27','Activités de fabrication','28','Activités de fabrication'
       ,'29','Activités de fabrication','30','Activités de fabrication','31','Activités de fabrication','32','Activités de fabrication'
       ,'33','Activités de fabrication','34','Activités de fabrication','35','Activités de fabrication','36','Activités de fabrication'
       ,'37','Activités de fabrication','40','Production et distribution d''électricité,de gaz et d''eau'
       ,'41','Production et distribution d''électricité,de gaz et d''eau'
       ,'45','Construction','50','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'51','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'52','Commerce,reparation de vehicules automobiles et d''articles domestiques','55','Hotels et restaurants'
       ,'60','Transports,activités des auxiliaires de transport et communications','61','Transports,activités des auxiliaires de transport et communications'
       ,'62','Transports,activités des auxiliaires de transport et communications','63','Transports,activités des auxiliaires de transport et communications'
       ,'64','Transports,activités des auxiliaires de transport et communications','65','Activités financières','66','Activités financières'
       ,'67','Activités financières','70','Immobilier,locations et services aux entreprises','71','Immobilier,locations et services aux entreprises'
       ,'72','Immobilier,locations et services aux entreprises','73','Immobilier,locations et services aux entreprises'
       ,'74','Immobilier,locations et services aux entreprises','75','Activivtés d''administration publique','80','Education'
       ,'85','Activités de santé et d''action sociale','90','Activités à caractère collectif ou personnel'
       ,'91','Activités à caractère collectif ou personnel','92','Activités à caractère collectif ou personnel'
       ,'93','Activités à caractère collectif ou personnel','95','Activités des ménages en tant qu''employeurs de personnel domestique'
       ,'99','Activités des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) section_lib
    , amount_disbursed "MONTANT DU PRET"
    ,(select ude_value from xafnfc.cltb_account_ude_values uv where ude_id = 'INTEREST_RATE' and uv.account_number = am.ACCOUNT_NUMBER
        and effective_date =  
        (select max(uv1.effective_date) from xafnfc.cltb_account_ude_values uv1 where uv.account_number = uv1.account_number and uv1.ude_id = 'INTEREST_RATE')) 
      "TAUX INTERET NOMINAL", no_of_installments "DUREE DU PRET"
    , (select ceil(sum(amount_due)/am.no_of_installments) amount_due_avg from xafnfc.cltb_account_schedules
       where account_number = am.account_number and component_name in ('PRINCIPAL','MAIN_INT')) "MENSUALITE"
    , (select sum(amount_due) from xafnfc.cltb_account_schedules 
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%'))"FRAIS DE DOSSIER ET COMMISSION"
    , null ASSURANCE, teg(am.account_number,0,0,1)*100 "TAUX PERIODIQUE %", teg(am.account_number,0,0,1)*100*12 "TEG %"
    , decode(frequency_unit,'M','MONTHLY','Q','QUATERLY','H','HALFEARLY','Y','YEARLY') "MODE DE REMBOURSEMENT", 1 "MODE DE DEBLOCAGE DES FONDS"
    , value_date "DATE DE MISE EN PLACE", c.udf_4 PROFESSION, pr.business_description 
    , (select CODE_DESC from xafnfc.gltm_mis_code where mis_code = (select cust_mis_1 from xafnfc.mitm_customer_default where customer =am.customer_id) ) 
    "SECTEUR "
    , case when 
          (select count(*) from xafnfc.cltb_account_schedules ll where ll.ACCOUNT_NUMBER = am.account_number and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0)/* UNPAID_INSTALLMENTS*/ <> no_of_installments 
           and USER_DEFINED_STATUS IN ('NORM')
           then 'SAIN' else 'NON SAIN' end "SITUATION DE LA CREANCE"
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between &date1 and &date2-- and c.customer_type='C'
--order by  section,"NATURE DU PRET","TYPE BENEFICIAIRE";

union
-- 2- to extract overdrafts 
select decode(c.customer_type,'I',1,3) "TYPE DE BENEFICIAIRE", c.customer_name1 BENEFIAIRE
, cc.capital "CHIFFRES D''AFFAIRE"
,'OVERDRAFT' "NATURE DU PRET"
,case when c.customer_type='C' and (substr(a.cust_ac_no,4,3) in ('151','164','173') or substr(a.cust_ac_no,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) in ('161','162','163','164') and substr(a.cust_ac_no,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) not in ('151','164','173') and substr(a.cust_ac_no,4,2) like '28%' then 'ENT'
           else 'PAR'  end "TYPE BENEFICIAIRE"
--,case when c.customer_type in ('C','B') then 'PME' else 'PARTICULIER' end "TYPE BENEFICIAIRE"
, (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','J','C','K','C','L','C','M','C','N','C','O','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','Agriculture,chasse et sylviculture','02','Agriculture,chasse et sylviculture'
       ,'05','Peche,pisciculture,aquaculture','J','Activivtés extractives','K','Activivtés extractives','L','Activivtés extractives'
       ,'M','Activivtés extractives','N','Activivtés extractives','O','Activités de fabrication','16','Activités de fabrication'
       ,'17','Activités de fabrication','18','Activités de fabrication','19','Activités de fabrication','20','Activités de fabrication'
       ,'21','Activités de fabrication','22','Activités de fabrication','23','Activités de fabrication','24','Activités de fabrication'
       ,'25','Activités de fabrication','26','Activités de fabrication','27','Activités de fabrication','28','Activités de fabrication'
       ,'29','Activités de fabrication','30','Activités de fabrication','31','Activités de fabrication','32','Activités de fabrication'
       ,'33','Activités de fabrication','34','Activités de fabrication','35','Activités de fabrication','36','Activités de fabrication'
       ,'37','Activités de fabrication','40','Production et distribution d''électricité,de gaz et d''eau'
       ,'41','Production et distribution d''électricité,de gaz et d''eau'
       ,'45','Construction','50','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'51','Commerce,reparation de vehicules automobiles et d''articles domestiques'
       ,'52','Commerce,reparation de vehicules automobiles et d''articles domestiques','55','Hotels et restaurants'
       ,'60','Transports,activités des auxiliaires de transport et communications','61','Transports,activités des auxiliaires de transport et communications'
       ,'62','Transports,activités des auxiliaires de transport et communications','63','Transports,activités des auxiliaires de transport et communications'
       ,'64','Transports,activités des auxiliaires de transport et communications','65','Activités financières','66','Activités financières'
       ,'67','Activités financières','70','Immobilier,locations et services aux entreprises','71','Immobilier,locations et services aux entreprises'
       ,'72','Immobilier,locations et services aux entreprises','73','Immobilier,locations et services aux entreprises'
       ,'74','Immobilier,locations et services aux entreprises','75','Activivtés d''administration publique','80','Education'
       ,'85','Activités de santé et d''action sociale','90','Activités à caractère collectif ou personnel'
       ,'91','Activités à caractère collectif ou personnel','92','Activités à caractère collectif ou personnel'
       ,'93','Activités à caractère collectif ou personnel','95','Activités des ménages en tant qu''employeurs de personnel domestique'
       ,'99','Activités des organisations extraterritoriales','00') 
    from xafnfc.mitm_customer_default m where c.customer_no = m.customer) section_lib
, nvl(x.a_tod_amount,a.tod_limit) "MONTANT DU PRET"
, nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15) "TAUX D''INTERET NOMINAL"
, round(months_between(a.tod_limit_end_date, m_appl_date),2) "DUREE DU PRET EN MOIS"
, 1 as "MENSUALITE"
, case when x.a_tod_amount  < 50000000 then 25000 
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100) "FRAIS ET COMMISSION"
,0 ASSURANCE
, nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15)/12 "TAUX PERIODIQUE"
, nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15) "TEG"
,'YEARLY' "MODE DE REMBOURSEMENT", 1 "MODE DE DEBLOCAGE DES FONDS"
, nvl(x.m_appl_date,a.tod_limit_start_date) "DATE DE MISE EN PLACE"--, a.tod_limit_end_date
,null "PROFESSION"
,cc.business_description 
, (select CODE_DESC from xafnfc.gltm_mis_code where mis_code = (select cust_mis_1 from xafnfc.mitm_customer_default where customer =c.customer_no) ) "SECTEUR"
,case when  a.acc_status in ('NORM') then 'SAIN' else 'NON SAIN' end  "SITUATION DE LA CREANCE"
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where appl_date between &date1 and &date2 group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between &date1 and &date2 and a.tod_limit >0 
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between &date1 and &date2
)
order by   section,"NATURE DU PRET","TYPE BENEFICIAIRE";



-- View for External TEG Computations
--- Loans
create or replace view v_convention_pret as
select
am.BRANCH_CODE code_agence,
am.DR_PROD_AC numero_compte,
case when no_of_installments <=24 then 'SHORT TERM WORKING CAPITAL LOANS '||c.customer_name1 
           when no_of_installments between 25 and 120 then 'MEDIUM TERM WORKING CAPITAL LOANS '||c.customer_name1
           else 'LONG TERM WORKING CAPITAL LOANS '||c.customer_name1 end intitule_compte,
case when c.customer_type='C' and (substr(am.dr_prod_ac,4,3) in ('151','164','173') or substr(am.dr_prod_ac,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) in ('161','162','163','164') and substr(am.dr_prod_ac,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) not in ('151','164','173') and substr(am.dr_prod_ac,4,2) like '28%' then 'ENT'
           else 'PAR' end code_type_client,
am.ACCOUNT_NUMBER compte_gestion_credit,
(select  decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A'
       ,'05','B','J','C','K','C','L','C'
       ,'M','C','N','C','O','D','16','D'
       ,'17','D','18','D','19','D','20','D'
       ,'21','D','22','D','23','D','24','D'
       ,'25','D','26','D','27','D','28','D'
       ,'29','D','30','D','31','D','32','D'
       ,'33','D','34','D','35','D','36','D'
       ,'37','D','40','E'
       ,'41','E'
       ,'45','F','50','G'
       ,'51','G'
       ,'52','G','55','H'
       ,'60','I','61','I'
       ,'62','I','63','I'
       ,'64','I','65','J','66','J'
       ,'67','J','70','K','71','K'
       ,'72','K','73','K'
       ,'74','K','75','L','80','M'
       ,'85','N','90','O'
       ,'91','O','92','O'
       ,'93','O','95','P'
       ,'99','Q','0')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'A' code_nature_pret,      
decode(frequency_unit,'M',1,'Q',2,'H',3,'Y',4,4) code_mode_remboursement,
case when no_of_installments <=24 then 'CC' 
           when no_of_installments between 25 and 120 then 'CM'
           else 'CL' end code_type_credit,
 no_of_installments duree_pret,
 amount_disbursed montant_ht,
(select sum(amount_due) from xafnfc.cltb_account_schedules 
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%')) frais_connexes,
(select ude_value from xafnfc.cltb_account_ude_values uv where ude_id = 'INTEREST_RATE' and uv.account_number = am.ACCOUNT_NUMBER
        and effective_date =  
        (select max(uv1.effective_date) from xafnfc.cltb_account_ude_values uv1 where uv.account_number = uv1.account_number and uv1.ude_id = 'INTEREST_RATE')) taux_nominal,       
value_date date_mise_en_place
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR')
union
-- Overdrafts
select
a.branch_code code_agence,
a.cust_ac_no numero_compte,
a.ac_desc intitule_compte,
case when c.customer_type='C' and (substr(a.cust_ac_no,4,3) in ('151','164','173') or substr(a.cust_ac_no,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) in ('161','162','163','164') and substr(a.cust_ac_no,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) not in ('151','164','173') and substr(a.cust_ac_no,4,2) like '28%' then 'ENT'
           else 'PAR' end code_type_client,
a.cust_ac_no compte_gestion_credit,
(select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A'
       ,'05','B','J','C','K','C','L','C'
       ,'M','C','N','C','O','D','16','D'
       ,'17','D','18','D','19','D','20','D'
       ,'21','D','22','D','23','D','24','D'
       ,'25','D','26','D','27','D','28','D'
       ,'29','D','30','D','31','D','32','D'
       ,'33','D','34','D','35','D','36','D'
       ,'37','D','40','E'
       ,'41','E'
       ,'45','F','50','G'
       ,'51','G'
       ,'52','G','55','H'
       ,'60','I','61','I'
       ,'62','I','63','I'
       ,'64','I','65','J','66','J'
       ,'67','J','70','K','71','K'
       ,'72','K','73','K'
       ,'74','K','75','L','80','M'
       ,'85','N','90','O'
       ,'91','O','92','O'
       ,'93','O','95','P'
       ,'99','Q','0')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'N' code_nature_pret,       
4 code_mode_remboursement,
'DC' code_type_credit,
nvl(round(months_between(a.tod_limit_end_date, x.m_appl_date)),1) duree_pret,
nvl(x.a_tod_amount,a.tod_limit) montant_ht,
 case when x.a_tod_amount  < 50000000 then 25000 
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100)  frais_connexes,
nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15) taux_nominal,       
 nvl(x.m_appl_date,a.tod_limit_start_date) date_mise_en_place
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where appl_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR') group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR') and a.tod_limit >0 
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR')
)
union
--- Commercial effects
select
am.BRANCH_CODE code_agence,
am.DR_PROD_AC numero_compte,
'Escompte d''effet'||c.customer_name1 intitule_compte,
case when c.customer_type='C' and (substr(am.dr_prod_ac,4,3) in ('151','164','173') or substr(am.dr_prod_ac,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) in ('161','162','163','164') and substr(am.dr_prod_ac,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) not in ('151','164','173') and substr(am.dr_prod_ac,4,2) like '28%' then 'ENT'
           else 'PAR' end code_type_client,
am.ACCOUNT_NUMBER compte_gestion_credit,
(select  decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A'
       ,'05','B','J','C','K','C','L','C'
       ,'M','C','N','C','O','D','16','D'
       ,'17','D','18','D','19','D','20','D'
       ,'21','D','22','D','23','D','24','D'
       ,'25','D','26','D','27','D','28','D'
       ,'29','D','30','D','31','D','32','D'
       ,'33','D','34','D','35','D','36','D'
       ,'37','D','40','E'
       ,'41','E'
       ,'45','F','50','G'
       ,'51','G'
       ,'52','G','55','H'
       ,'60','I','61','I'
       ,'62','I','63','I'
       ,'64','I','65','J','66','J'
       ,'67','J','70','K','71','K'
       ,'72','K','73','K'
       ,'74','K','75','L','80','M'
       ,'85','N','90','O'
       ,'91','O','92','O'
       ,'93','O','95','P'
       ,'99','Q','0')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'N' code_nature_pret,      
4 code_mode_remboursement,
'EE' code_type_credit,
months_between(am.BOOK_DATE,am.MATURITY_DATE) duree_pret,
 amount_disbursed montant_ht,
(select sum(amount_due) from xafnfc.cltb_account_schedules 
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%')) frais_connexes,
(select ude_value from xafnfc.cltb_account_ude_values uv where ude_id = 'INTEREST_RATE' and uv.account_number = am.ACCOUNT_NUMBER
        and effective_date =  
        (select max(uv1.effective_date) from xafnfc.cltb_account_ude_values uv1 where uv.account_number = uv1.account_number and uv1.ude_id = 'INTEREST_RATE')) taux_nominal,       
value_date date_mise_en_place
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR')
and no_of_installments =1;

---- Vue déblocage des Fonds
create or replace view v_deblocage as
--- Loans
SELECT am.BRANCH_CODE code_agence,
am.DR_PROD_AC numero_compte,
am.ACCOUNT_NUMBER compte_gestion_credit,
am.AMOUNT_DISBURSED montant_deblocage,
am.BOOK_DATE date_deblocage
FROM xafnfc.cltb_account_master am
where value_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR')
-- Overdrafts 
union
SELECT a.branch_code code_agence,a.cust_ac_no numero_compte,a.cust_ac_no compte_gestion_credit,x.a_tod_amount montant_deblocage,a.tod_start_date date_deblocage
from xafnfc.sttm_cust_account a,(select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where appl_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR') group by h.account_no) x
WHERE a.cust_ac_no =x.account_no   
and a.tod_limit_start_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR') and a.tod_limit >0 
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and h.bkg_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR'));


----- Vues des amortissement de crédits
create or replace view v_amortissement as
SELECT am.BRANCH_CODE code_agence,am.DR_PROD_AC numero_compte,am.ACCOUNT_NUMBER compte_gestion_credit,
(select ceil(sum(amount_due)/am.no_of_installments) amount_due_avg from xafnfc.cltb_account_schedules
       where account_number = am.account_number and component_name in ('PRINCIPAL','MAIN_INT')) montant_echeance
       , sc.schedule_due_date date_echeance
FROM xafnfc.cltb_account_schedules sc, xafnfc.cltb_account_master am
WHERE am.ACCOUNT_NUMBER = sc.account_number
and component_name ='PRINCIPAL'
and value_date between to_date('01-01-2017','DD-MM-RRRR') and to_date('30-06-2017','DD-MM-RRRR');














