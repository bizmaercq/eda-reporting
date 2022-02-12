-- Nom de naissance 
-- Female
update sttm_customer c set c.udf_3 ='Nomdejeunefille' WHERE c.customer_no = (SELECT * FROM sttm_cust_personal p WHERE p.customer_no = 'CIF' and p.sex ='F');
-- Male 
update sttm_cust_personal p set p.last_name = 'NomNaissance' WHERE p.customer_no = (SELECT * FROM sttm_cust_personal p WHERE p.customer_no = 'CIF' and p.sex ='M');

-- Prenoms

update sttm_cust_personal p set p.first_name = 'Prenom' WHERE p.customer_no = 'cif';

-- Nom Marital
update sttm_cust_personal p set p.last_name = 'NomMarital' WHERE p.customer_no = 'CIF' and p.sex ='F' and p.customer_no in ;

-- Pieces d'identit�

update sttm_cust_personal p set p.passport_no ='NumPiece', p.ppt_iss_date =to_date('DateDelivrance','DDMMYYYY') WHERE p.customer_no = 'CIF';

-- UDF Fields

update CSTM_FUNCTION_USERDEF_FIELDS ud set ud.field_val_1 ='NomMere',ud.field_val_2 ='NomPere',ud.field_val_3 ='LieuDelivrance',ud.field_val_5 ='PreomMere',ud.field_val_7 ='PreomPere' WHERE uf.function_id ='STDCIF' and  substr(ud.rec_key,1,6) ='CIF';


-- End date for id cards

update sttm_cust_personal p set p.ppt_exp_date = add_months(p.ppt_iss_date,120) WHERE p.ppt_exp_date is null and p.ppt_iss_date is not null;
--SELECT p.ppt_iss_date from sttm_cust_personal p WHERE p.ppt_exp_date is null and p.ppt_iss_date is not null FOR UPDATE NOWAIt ;

-- synchronize national id and passport
SELECT p.p_national_id,p.passport_no,p.ppt_iss_date FROM sttm_cust_personal p WHERE p.p_national_id  not like '1%'
update sttm_cust_personal p set p.p_national_id = p.passport_no WHERE p.passport_no is not null and substr(p.p_national_id,1,1)    in ('C')