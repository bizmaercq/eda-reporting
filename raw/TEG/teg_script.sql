-- 1- to extract loans 

select decode(c.customer_type,'I',1,3) "TYPE DE BENEFICIAIRE", customer_name1 BENEFIAIRE, null "CHIFFRES D''AFFAIRE"
    , case when no_of_installments <=24 then 'SHORT TERM WORKING CAPITAL LOANS' 
           when no_of_installments between 25 and 120 then 'MEDIUM TERM WORKING CAPITAL LOANS'
           else 'LONG TERM WORKING CAPITAL LOANS' end "NATURE DU PRET"
    , case when c.customer_type='C' and (substr(am.dr_prod_ac,4,3) in ('151','164','173') or substr(am.dr_prod_ac,4,2) like '28%') then 'PME' 
           when c.customer_type='C' and substr(am.dr_prod_ac,4,3) not in ('151','164','173') and substr(am.dr_prod_ac,4,2) like '28%' then 'GE'
           else 'PARTICULIERS' end "TYPE BENEFICIAIRE"
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
       ,'01','A','02','A','05','B','10','C','11','C','12','C','13','C','14','C','15','D','16','D','17','D','18','D','19','D','20','D','21','D','22','D'
       ,'23','D','24','D','25','D','26','D','27','D','28','D','29','D','30','D','31','D','32','D','33','D','34','D','35','D','36','D','37','D','40','E'
       ,'41','E','45','F','50','G','51','G','52','G','55','H','60','I','61','I','62','I','63','I','64','I','65','J','66','J','67','J','70','K','71','K'
       ,'72','K','73','K','74','K','75','L','80','M','85','N','90','O','91','O','92','O','93','O','95','P','99','Q','00') 
    from xafnfc.mitm_customer_default m where substr(am.dr_prod_ac,9,6) = m.customer) section
 , (select decode(substr(replace(m.cust_mis_3,'.',''),length(replace(m.cust_mis_3,'.',''))-3,2)
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
order by  section,"NATURE DU PRET","TYPE BENEFICIAIRE";



-- 2- to extract overdrafts 



select decode(c.customer_type,'I',1,3) "TYPE DE BENEFICIAIRE", c.customer_name1 BENEFIAIRE
--, a.cust_ac_no
,'Avance sur d�compte' "NATURE DE PRET", nvl(x.a_tod_amount,a.tod_limit) "MONTANT DU PRET"
, nvl(x.m_appl_date,a.tod_limit_start_date) "DATE DE MISE EN PLACE"--, a.tod_limit_end_date
, round(months_between(a.tod_limit_end_date, m_appl_date),2) "DUREE DU PRET EN MOIS"
    , case when x.a_tod_amount  < 50000000 then 25000 
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100) "FRAIS ET COMMISSION"
,2 "MODE DE REMBOURSEMENT", 1 "MODE DE DEBLOCAGE DES FONDS"
, nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15) "TAUX D'INTERET NOMINAL"
--,  a.acy_avl_bal
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where appl_date between &date1 and &date2 group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between &date1 and &date2 and a.tod_limit >0 
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between &date1 and &date2
)
order by decode(c.customer_type,'I',1,3);
