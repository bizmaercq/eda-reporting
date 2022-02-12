select  
a.cust_ac_no "NUMERO DE COMPTE",
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1))  "NOM OU RAISON SOCIALE",
c.customer_no RACINE,
p.first_name PRENOM,
p.customer_prefix QUALITE ,
c.udf_3  "NOM DE JEUNE FILLE",
NULL SIGLE,
c.short_name "NOM ABREGE",
c.cust_classification "NATURE CLIENTELE",
to_char(p.date_of_birth,'DD/MM/YYYY') "DATE NAISSANCE OU DE CREATION",
c.udf_2 "LIEU NAISSANCE",
NULL "SIEGE SOCIAL",
substr(c.loc_code,1,2) VILLE,
p.customer_prefix1 TITRE,
(select iso3_code from sttm_country_isocodes i where c.country = i.iso2_code ) NATIONALITE,
'S.'||decode(substr(m.cust_mis_1,1,3),'SEC','144',substr(m.cust_mis_1,1,3)) "SECTEUR INSTITUTIONNEL",
c.udf_4 "PROFESSION OU OBJET SOCIAL",
NULL "NATURE JURIDIQUE",
NULL "NUMERO DE CONTRIBUABLE",
NULL "NUMERO REGISTRE DE COMMERCE",
decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3) "GROUPE ACTIVITE",
c.address_line1 ADRESSE,
NULL "BOITE POSTALE",
nvl(c.address_line2, p.mobile_number) "NUMERO DE TELEPHONE1",
nvl(c.address_line2, p.mobile_number) "NUMERO DE TELEPHONE2",
NULL "NUMERO DE TELEX",
NULL "NUMERO DE FAX",
to_char(sysdate,'DD/MM/RRRR') "DECLARE LE"
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
                     join sttm_cust_account a on a.cust_no = c.customer_no
where c.customer_type ='I'
union
select 
a.cust_ac_no "NUMERO DE COMPTE",
pr.corporate_name "NOM OU RAISON SOCIALE",
c.customer_no RACINE,
NULL PRENOM,
NULL QUALITE,
NULL "NOM DE JEUNE FILLE",
field_val_2 SIGLE,
c.short_name "NOM ABREGE",
c.cust_classification "NATURE CLIENTELE",
to_char(pr.incorp_date,'DD/MM/YYYY') "DATE NAISSANCE OU DE CREATION",
substr(c.loc_code,1,2) "LIEU NAISSANCE",
substr(c.loc_code,1,2) "SIEGE SOCIAL",
substr(c.loc_code,1,2) VILLE ,
NULL TITRE,
(select iso3_code from sttm_country_isocodes i where c.country = i.iso2_code ) NATIONALITE,
'S.'||decode(substr(m.cust_mis_1,1,3),'SEC','144',substr(m.cust_mis_1,1,3)) "SECTEUR INSTITUTIONNEL",
pr.business_description "PROFESSION OU OBJET SOCIAL", 
m.cust_mis_2 "NATURE JURIDIQUE",
pr.c_national_id "NUMERO DE CONTRIBUABLE",
c.unique_id_value "NUMERO REGISTRE DE COMMERCE",
decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3) "GROUPE ACTIVITE",
pr.r_address1 ADRESSE,
null "BOITE POSTALE" ,
pr.r_address2 "NUMERO DE TELEPHONE1",
pr.r_address2 "NUMERO DE TELEPHONE2",
NULL "NUMERO DE TELEX",
c.fax_number "NUMERO DE FAX",
to_char(sysdate,'DD/MM/RRRR') "DECLARE LE"
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
                     join sttm_cust_account a on a.cust_no = c.customer_no
where c.customer_type ='C'