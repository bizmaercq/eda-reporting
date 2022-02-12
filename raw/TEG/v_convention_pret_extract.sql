create or replace view v_convention_pret_extract as
select
'00'||am.BRANCH_CODE code_agence,
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
       ,'99','Q','O')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'A' code_nature_pret,
case when no_of_installments <=24 then 'CC'
           when no_of_installments between 25 and 120 then 'CM'
           else 'CL' end code_type_credit,
decode(frequency_unit,'M',1,'Q',2,'H',3,'Y',4,4) periodicite_remboursement,
 no_of_installments duree_pret,
 amount_disbursed montant_ht,
(select round(sum(amount_due)/1.1925) from xafnfc.cltb_account_schedules
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%')) frais_connexes,
(select ude_value from xafnfc.cltb_account_ude_values uv where ude_id = 'INTEREST_RATE' and uv.account_number = am.ACCOUNT_NUMBER
        and effective_date =
        (select max(uv1.effective_date) from xafnfc.cltb_account_ude_values uv1 where uv.account_number = uv1.account_number and uv1.ude_id = 'INTEREST_RATE')) taux_nominal,
am.BOOK_DATE date_mise_en_place,
value_date date_echeance_effet,
0 agios,
0 nombres_debiteurs,
case when no_of_installments <=24 then 2
           when no_of_installments between 25 and 120 then 2
           else 5 end type_credit_beac,
case when no_of_installments <=24 then '32'
           when no_of_installments between 25 and 120 then '31'
           else '30' end Chapitre_comptable,
(select case when substr(m.cust_mis_1,1,2) in ('13') then '1'
             when substr(m.cust_mis_1,1,3) in ('111') then '2'
             when substr(m.cust_mis_1,1,3) in ('112','113') then '3'
             when substr(m.cust_mis_1,1,3) in ('125') then '4'
             when substr(m.cust_mis_1,1,3) in ('121','122','123','124') then '5'
             when substr(m.cust_mis_1,1,3) in ('141','142','143','144') then '6'
             when substr(m.cust_mis_1,1,2) in ('15') then '7'
             else '8' end from xafnfc.mitm_customer_default m where m.customer = c.customer_no) type_client_beac,
substr(c.address_line1,1,30) lieu_implantation_client,
0 chiffre_affaire,
0 nombre_employes,
nvl(c.udf_4,'N/A') profession,
round(months_between(am.first_ins_date,am.value_date)) nombre_mois_differe,
decode(frequency_unit,'M',1,'Q',2,'H',3,'Y',4,1) frequence_remboursements_beac,
round ((select sum(amount_due) from xafnfc.cltb_account_schedules
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%'))/1.1925) frais_dossier_commissions,
1 modalite_paiement_assurance,
0 cout_assurance,
1 mode_remboursement_beac,
(select ceil(sum(amount_due)/am.no_of_installments) amount_due_avg from xafnfc.cltb_account_schedules
       where account_number = am.account_number and component_name in ('PRINCIPAL','MAIN_INT')) montant_annuite_constante,
1 mode_deblocage_fonds,
case when
          (select count(*) from xafnfc.cltb_account_schedules ll where ll.ACCOUNT_NUMBER = am.account_number and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0) <> no_of_installments
           and USER_DEFINED_STATUS IN ('NORM')
           then 1 else 4 end  situation_creance,
0 decouvert_montant_autorise,
0 decouvert_police_assur_exigee,
0 decouvert_police_assur_montant,
0 montant_ht_interets,
0 inclure_assurance_ds_calc_teg,
round(teg(am.account_number,0,0,1)*100*12,2) teg_proportionnel_assujetti
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR')
--- Overdrafts
union
select
'00'||a.branch_code code_agence,
a.cust_ac_no numero_compte,
a.ac_desc intitule_compte,
case when c.customer_type='C' and (substr(a.cust_ac_no,4,3) in ('151','164','173') or substr(a.cust_ac_no,4,2) like '28%') then 'PME'
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) in ('161','162','163','164') and substr(a.cust_ac_no,4,2) like '28%' then 'ADM'
           when c.customer_type='C' and substr(a.cust_ac_no,4,3) not in ('151','164','173') and substr(a.cust_ac_no,4,2) like '28%' then 'ENT'
           else 'PAR' end code_type_client,
a.cust_ac_no compte_gestion_credit,
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
       ,'99','Q','O')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'N' code_nature_pret,
'DC' code_type_credit,
4 periodicite_remboursement,
round(months_between(a.tod_limit_end_date, m_appl_date),2) duree_pret,
 nvl(x.a_tod_amount,a.tod_limit) montant_ht,
0 frais_connexes,
nvl((select ude_value from xafnfc.ICTM_ACC_UDEVALS u where a.cust_ac_NO = u.acc  and u.ude_id = 'OD_RATE'),15) taux_nominal,
 nvl(x.m_appl_date,a.tod_limit_start_date) date_mise_en_place,
a.tod_limit_end_date date_echeance_effet,
0 agios,
0 nombres_debiteurs,
9 type_credit_beac,
'37'  Chapitre_comptable,
(select case when substr(m.cust_mis_1,1,2) in ('13') then '1'
             when substr(m.cust_mis_1,1,3) in ('111') then '2'
             when substr(m.cust_mis_1,1,3) in ('112','113') then '3'
             when substr(m.cust_mis_1,1,3) in ('125') then '4'
             when substr(m.cust_mis_1,1,3) in ('121','122','123','124') then '5'
             when substr(m.cust_mis_1,1,3) in ('141','142','143','144') then '6'
             when substr(m.cust_mis_1,1,2) in ('15') then '7'
             else '8' end from xafnfc.mitm_customer_default m where m.customer = c.customer_no) type_client_beac,
substr(c.address_line1,1,30) lieu_implantation_client,
0 chiffre_affaire,
0 nombre_employes,
nvl(c.udf_4,'N/A') profession,
0 nombre_mois_differe,
4 frequence_remboursements_beac,
case when x.a_tod_amount  < 50000000 then 25000
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100) frais_dossier_commissions,
1 modalite_paiement_assurance,
0 cout_assurance,
2 mode_remboursement_beac,
 nvl(x.a_tod_amount,a.tod_limit) montant_annuite_constante,
1 mode_deblocage_fonds,
case when  a.acc_status in ('NORM') then 1 else 4 end situation_creance,
a.tod_limit decouvert_montant_autorise,
0 decouvert_police_assur_exigee,
0 decouvert_police_assur_montant,
0 montant_ht_interets,
0 inclure_assurance_ds_calc_teg,
round(decode(c.customer_type,'I',8.5,15) + (case when x.a_tod_amount  < 50000000 then 25000
           when x.a_tod_amount between 50000000 and 99999999 then 50000
           else 100000 end + round(1.5*a.tod_limit/100) ) / nvl(x.a_tod_amount,a.tod_limit)*100/12,2) teg_proportionnel_assujetti
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where h.tod_amount <>0 and appl_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR') group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR') and a.tod_limit >0
and a.tod_limit<>0
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR')
)
--- Commercial effects
union
select
'00'||am.BRANCH_CODE code_agence,
am.DR_PROD_AC numero_compte,
'Escompte d''Effet '||c.customer_name1  intitule_compte,
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
       ,'99','Q','O')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'N' code_nature_pret,
'EE' code_type_credit,
4 periodicite_remboursement,
round(months_between(am.MATURITY_DATE,am.BOOK_DATE)) duree_pret,
 amount_disbursed montant_ht,
(select round(sum(amount_due)/1.1925) from xafnfc.cltb_account_schedules
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%')) frais_connexes,
taux_effet(am.ACCOUNT_NUMBER) taux_nominal,
am.BOOK_DATE date_mise_en_place,
value_date date_echeance_effet,
0 agios,
0 nombres_debiteurs,
9 type_credit_beac,
case when no_of_installments <=24 then '32'
           when no_of_installments between 25 and 120 then '31'
           else '30' end Chapitre_comptable,
(select case when substr(m.cust_mis_1,1,2) in ('13') then '1'
             when substr(m.cust_mis_1,1,3) in ('111') then '2'
             when substr(m.cust_mis_1,1,3) in ('112','113') then '3'
             when substr(m.cust_mis_1,1,3) in ('125') then '4'
             when substr(m.cust_mis_1,1,3) in ('121','122','123','124') then '5'
             when substr(m.cust_mis_1,1,3) in ('141','142','143','144') then '6'
             when substr(m.cust_mis_1,1,2) in ('15') then '7'
             else '8' end from xafnfc.mitm_customer_default m where m.customer = c.customer_no) type_client_beac,
substr(c.address_line1,1,30) lieu_implantation_client,
0 chiffre_affaire,
0 nombre_employes,
nvl(c.udf_4,'N/A') profession,
round(months_between(am.first_ins_date,am.value_date)) nombre_mois_differe,
decode(frequency_unit,'M',1,'Q',2,'H',3,'Y',4,1) frequence_remboursements_beac,
round ((select sum(amount_due) from xafnfc.cltb_account_schedules
       where account_number = am.account_number and (component_name like '%FEE%' or component_name like '%PROC%'))/1.1925) frais_dossier_commissions,
1 modalite_paiement_assurance,
0 cout_assurance,
1 mode_remboursement_beac,
(select ceil(sum(amount_due)/am.no_of_installments) amount_due_avg from xafnfc.cltb_account_schedules
       where account_number = am.account_number and component_name in ('PRINCIPAL','MAIN_INT')) montant_annuite_constante,
1 mode_deblocage_fonds,
case when
          (select count(*) from xafnfc.cltb_account_schedules ll where ll.ACCOUNT_NUMBER = am.account_number and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0) <> no_of_installments
           and USER_DEFINED_STATUS IN ('NORM')
           then 1 else 4 end  situation_creance,
0 decouvert_montant_autorise,
0 decouvert_police_assur_exigee,
0 decouvert_police_assur_montant,
0 montant_ht_interets,
0 inclure_assurance_ds_calc_teg,
teg_effet(am.ACCOUNT_NUMBER) teg_proportionnel_assujetti
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR')
and am.NO_OF_INSTALLMENTS =1

---- Cautions
union
select
'00'||substr(co.contract_ref_no,1,3) code_agence,
co.contract_ref_no numero_compte,
'Caution '||c.customer_name1  intitule_compte,
'PME' code_type_client,
co.contract_ref_no compte_gestion_credit,
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
       ,'99','Q','O')from xafnfc.mitm_customer_default m where c.customer_no = m.customer) id_secteur_activite,
'N' code_nature_pret,
'CA' code_type_credit,
4 periodicite_remboursement,
to_number(replace(co.tenor,'D','')) duree_pret,
co.contract_amt montant_ht,
0 Frais_connexes,
round(cm.total_comms_for_period*4/co.contract_amt*100,2) taux_nominal,
co.issue_date date_mise_en_place,
co.effective_date date_echeance_effet,
0 agios,
0 nombres_debiteurs,
9 type_credit_beac,
'92' Chapitre_comptable,
(select case when substr(m.cust_mis_1,1,2) in ('13') then '1'
             when substr(m.cust_mis_1,1,3) in ('111') then '2'
             when substr(m.cust_mis_1,1,3) in ('112','113') then '3'
             when substr(m.cust_mis_1,1,3) in ('125') then '4'
             when substr(m.cust_mis_1,1,3) in ('121','122','123','124') then '5'
             when substr(m.cust_mis_1,1,3) in ('141','142','143','144') then '6'
             when substr(m.cust_mis_1,1,2) in ('15') then '7'
             else '8' end from xafnfc.mitm_customer_default m where m.customer = c.customer_no) type_client_beac,
substr(c.address_line1,1,30) lieu_implantation_client,
0 chiffre_affaire,
0 nombre_employes,
nvl(c.udf_4,'N/A') profession,
0 nombre_mois_differe,
4 frequence_remboursements_beac,
20000 frais_dossier_commissions,
1 modalite_paiement_assurance,
0 cout_assurance,
1 mode_remboursement_beac,
co.contract_amt montant_annuite_constante,
1 mode_deblocage_fonds,
case when  USER_DEFINED_STATUS IN ('NORM') then 1 else 4 end  situation_creance,
0 decouvert_montant_autorise,
0 decouvert_police_assur_exigee,
0 decouvert_police_assur_montant,
(cm.total_comms_for_period*4) montant_ht_interets,
0 inclure_assurance_ds_calc_teg,
round( (cm.total_comms_for_period*4+20000)/co.contract_amt*360/365*100,2) teg_proportionnel_assujetti
from  xafnfc.LCTB_COMMISSION_Master cm ,  xafnfc.lctb_contract_master co , xafnfc.sttm_customer c
where cm.contract_ref_no = co.contract_ref_no
and c.customer_no = co.cif_id
and co.effective_date between to_date('01-01-2019','DD-MM-RRRR') and to_date('30-06-2019','DD-MM-RRRR')
;
