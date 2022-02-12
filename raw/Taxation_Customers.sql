
--- Personnes physiques
select 
null NIU,
rpad(nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)),30,' ') Nom,
rpad(nvl(p.first_name,' '),30,' ') prenoms,
p.p_national_id CNI,
p.date_of_birth date_naissance,
c.udf_2 Lieu_naissance,
ud.field_val_2 Pere,
ud.field_val_1 nom_m�re,
decode(c.loc_code,'10','YAOUNDE','11','DOUALA','12','GAROUA','13','LIMBE','14','NKONGSAMBA','15','BAFOUSSAM','17','NGAOUNDERE','18','BAMENDA','AUTRES') ville,
c.address_line1 quartier,
c.address_line2 lieu_dit,
p.mobile_number telephone
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='I'
and c.record_stat ='O';

-- Personnes Morales
select distinct rpad(pr.c_national_id,15,' ') NIU,
rpad(c.full_name,100,' ')raison_sociale,
rpad(nvl(field_val_7,' '),20,' ') sigle,
rpad(replace(c.unique_id_value,'/',''),15,' ') Numero_authorisation,
(select  cd.director_name from sttm_corp_directors cd WHERE cd.customer_no =c.customer_no and rownum =1) nom_dirigeant,
to_char(pr.incorp_date,'DD/MM/YYYY') date_creation,
decode(c.loc_code,'10','YAOUNDE','11','DOUALA','12','GAROUA','13','LIMBE','14','NKONGSAMBA','15','BAFOUSSAM','17','NGAOUNDERE','18','BAMENDA','AUTRES')ville ,
rpad(nvl(pr.r_address1,' '),30,' ') Quartier,
rpad(nvl(c.address_line1,' '),30,' ') Lieu_dit,
c.address_line3 telephone1
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
                     join sttm_corp_directors cd on cd.customer_no = c.customer_no
where c.customer_type ='C'
and c.record_stat ='O';



