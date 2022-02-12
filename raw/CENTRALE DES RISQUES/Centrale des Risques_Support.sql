------------------------------------------------------------------------------
---       Génération du fichier des personnes physiques                   ----
------------------------------------------------------------------------------

select c.local_branch Agence, c.customer_no Reference,p.customer_prefix qualite ,p.customer_prefix1 titre, 
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)) Nom ,p.first_name Prenom ,p.date_of_birth "DATE NAISSANCE",c.udf_2 "LIEU NAISSANCE",c.udf_3
 "NOM JEUNE FILLE",'S.'||substr(m.cust_mis_1,1,3) "SECTEUR INSTITUTIONNEL",
 (select iso3_code from sttm_country_isocodes i where c.country = i.iso2_code ) Nationalite,c.udf_4 "PROFESSION",c.cust_classification "NATURE CLIENTELE",c.address_line1 Adresse1,c.address_line2 Adresse2,c.address_line3 Adresse3,null BP,substr(c.loc_code,1,2) Ville,field_val_1 "PRECISION DATE"
from sttm_customer c join sttm_cust_personal p on c.customer_no = p.customer_no
                     join mitm_customer_default m on c.customer_no = m.customer
                     left join sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='I'
--and c.cif_creation_date between '30/04/2012' and '31/05/2012';


------------------------------------------------------------------------------
---       Génération du fichier des personnes morales                     ----
------------------------------------------------------------------------------

select c.customer_no reference, c.full_name "RAISON SOCIALE",field_val_2 sigle,substr(c.loc_code,1,2) siege,c.unique_id_value Registre,pr.corporate_name Abrege,pr.c_national_id Numero_Stat,m.cust_mis_2 "FORME JURIDIQUE",to_char(pr.incorp_date,'DD/MM/YYYY') "DATE CREATION",c.cust_classification "NATURE CLIENTELE",
pr.business_description "OBJET SOCIAL", pr.r_address1 Adresse1,c.address_line2 Adresse2,c.address_line3 Adresse3,null "BOITE POSTALE" ,substr(c.loc_code,1,2) Ville ,'S.'||substr(m.cust_mis_1,1,3) "SECTEUR INSTITUTIONNEL",c.fax_number FAX,p.telephone TELEPHONE1,null TELEPHONE2,null TELEPHONE3,
null TELEX,m.cust_mis_3 "GROUPE ACTIVITE"
from sttm_customer c join sttm_cust_personal p on c.customer_no = p.customer_no
                     join mitm_customer_default m on c.customer_no = m.customer
                     left join sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
and c.cif_creation_date > '30/04/2012'
--and c.cif_creation_date between '30/04/2012' and '31/05/2012' ;
and (m.cust_mis_2 like 'FOR%'
or m.cust_mis_3 = 'GRP999') 
and pr.corporate_name is null;



------------------------------------------------------------------------------
---                        Génération des encours                         ----
------------------------------------------------------------------------------
select customer_id ,customer_name1, cust_mis_3 Sect_Act,
sum(Effet_Commerciaux_Locaux) as Effet_Commerciaux_Locaux,
ltrim(replace(to_char(sum(Decouverts),'99990.90'),'.',','),' ') as Decouverts,
ltrim(replace(to_char(sum(Accompagnements_Marches),'99990.90'),'.',','),' ') as Accompagnements_Marches,
ltrim(replace(to_char(sum(Avances_Court_Terme),'99990.90'),'.',','),' ') as Avances_Court_Terme,
ltrim(replace(to_char(sum(Credit_Export),'99990.90'),'.',','),' ') as Credit_Export,
ltrim(replace(to_char(sum(Credit_Moyen_Terme),'99990.90'),'.',','),' ') as Credit_Moyen_Terme,
ltrim(replace(to_char(sum(Credit_Long_Terme),'99990.90'),'.',','),' ') as Credit_Long_Terme,
ltrim(replace(to_char(sum(Impayes),'99990.90'),'.',','),' ') as Impayes,
ltrim(replace(to_char(sum(Douteux),'99990.90'),'.',','),' ') as Douteux,
ltrim(replace(to_char(sum(Agios_Reserves),'99990.90'),'.',','),' ') as Agios_Reserves,
ltrim(replace(to_char(sum(Engagement_par_signature),'99990.90'),'.',','),' ') as Engagement_par_signature,
ltrim(replace(to_char(sum(Dont_Douteux),'99990.90'),'.',','),' ') as Dont_Douteux
from
(
 select customer_id,customer_name1,decode(cust_mis_3,'GRP999','93.0',cust_mis_3) as cust_mis_3,
 case when central_bank_code in ('C2J','C2K','C2L') then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Effet_Commerciaux_Locaux,
 case when central_bank_code in ('C71','C72','C75','C76','C86') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Decouverts,
 case when central_bank_code in ('C2M','C2N') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Accompagnements_Marches,
 case when central_bank_code in ('C2C','C22','C23','C26','C27','C29','C87','C28','C78','N4D') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Avances_Court_Terme, 
 case when central_bank_code in ('C2D','C2E','C2F','C2G','C2H') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Export, 
 case when central_bank_code in ('C11','C12','C13','C14','C15','C16','C17','C18') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Moyen_Terme, 
 case when central_bank_code in ('C01','C02','C03','C04','C05','C06','C07','C08') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Long_Terme ,
 case when central_bank_code in ('C41') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Impayes, 
 case when central_bank_code in ('C42','C43','C44','C45','C46','C47') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Douteux, 
 case when central_bank_code in ('Q8K','Q8L') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Agios_Reserves, 
 case when central_bank_code in ('M21','M22','M23','M24','M25','M29','N43','Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Engagement_par_signature, 
 case when central_bank_code in ('Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Dont_Douteux 
 from vw_trial_balance join sttm_customer on customer_id = customer_no
                             join mitm_customer_default m on customer_no = m.customer
 where length(account_number)<> 9
 group by customer_id,customer_name1,cust_mis_3,central_bank_code
 having sum(amount) <=-10000
)
group by customer_id,customer_name1,cust_mis_3
having ( ( sum(Effet_Commerciaux_Locaux) <>0) or (sum(Decouverts) <>0) or(sum(Accompagnements_Marches) <>0) or(sum(Avances_Court_Terme) <>0) or
          (sum(Credit_Export) <>0) or(sum(Credit_Moyen_Terme) <>0) or(sum(Credit_Long_Terme) <>0) or(sum(Impayes) <>0) or
          (sum(Douteux) <>0) or(sum(Agios_Reserves) <>0) or(sum(Engagement_par_signature) <>0) or(sum(Dont_Douteux) <>0)
       ) 
order by customer_id;
