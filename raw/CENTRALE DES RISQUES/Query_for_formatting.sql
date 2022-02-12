select c.customer_no reference, nvl(pr.corporate_name,short_name) "RAISON SOCIALE",field_val_2 sigle,substr(c.loc_code,1,2) siege,c.unique_id_value Registre,c.short_name Abrege,pr.c_national_id Numero_Stat,m.cust_mis_2 "FORME JURIDIQUE",to_char(pr.incorp_date,'DD/MM/YYYY') "DATE CREATION",c.cust_classification "NATURE CLIENTELE",
pr.business_description "OBJET SOCIAL", pr.r_address1 Adresse1,c.address_line2 Adresse2,c.address_line3 Adresse3,null "BOITE POSTALE" ,substr(c.loc_code,1,2) Ville ,m.cust_mis_1 "SECTEUR INSTITUTIONNEL",c.fax_number FAX,p.telephone TELEPHONE1,null TELEPHONE2,null TELEPHONE3,
null TELEX,m.cust_mis_3 "GROUPE ACTIVITE"
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
--and c.cif_creation_date > :FromDate


select c.customer_no reference, nvl(pr.corporate_name,short_name) "RAISON SOCIALE",field_val_2 sigle,substr(c.loc_code,1,2) siege,c.unique_id_value Registre,c.short_name Abrege,pr.c_national_id Numero_Stat,m.cust_mis_2 "FORME JURIDIQUE",to_char(pr.incorp_date,'DD/MM/YYYY') "DATE CREATION",c.cust_classification "NATURE CLIENTELE",
pr.business_description "OBJET SOCIAL", pr.r_address1 Adresse1,c.address_line2 Adresse2,c.address_line3 Adresse3,null "BOITE POSTALE" ,substr(c.loc_code,1,2) Ville ,'S.'||substr(m.cust_mis_1,1,3) "SECTEUR INSTITUTIONNEL",c.fax_number FAX,p.telephone TELEPHONE1,null TELEPHONE2,null TELEPHONE3,
null TELEX,m.cust_mis_3 "GROUPE ACTIVITE"
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
