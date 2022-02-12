------------------------------------------------------------------------------
---       Génération du fichier des personnes physiques                   ----
------------------------------------------------------------------------------
SELECT c.customer_no IdInterneClt, 
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1))  NomNaiClt,
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)) NomMtlClt,
p.first_name PrenomClt,
p.sex Sexe,
p.date_of_birth DatNai,
null NomPere,
null PrenomPere,
null NomNaiMere,
null PrmMre,
c.udf_2 VilleNai,
(select country from xafnfc.sttm_country_isocodes i where c.country = i.iso2_code ) PaysNai,
(select country from xafnfc.sttm_country_isocodes i where c.country = i.iso2_code ) NatClt,
c.udf_4 Profession,
(select code_desc from xafnfc.gltm_mis_code mc where mc.mis_class ='GRPACT' and mc.mis_code = decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3) ) ActEcon,
case when (c.frozen ='N' and c.deceased ='N') then '00'
  else
     case when c.frozen ='Y' then '02' else '01' end 
end  StatutClt,
null SitJudiciaire,
null DateDebIJ,
null DateFinIJ,
null DatEvent,
null Comntr,
decode(c.unique_id_name,'NAT_ID_CARD','01','PASSPORT','02','RES_PERMIT','03','04') typePiece,
p.p_national_id numPiece,
p.ppt_iss_date ,
c.udf_2 LieuEmiPiece,
c.nationality PaysEmiPiece,
p.ppt_exp_date FinValPiece
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='I'
and c.record_stat ='O'
order by c.customer_no;


------------------------------------------------------------------------------
---       Génération du fichier des personnes morales                     ----
------------------------------------------------------------------------------

-- For CIP

select c.customer_no IdinterneClt,
c.full_name RAISONSOCIALE,
to_char(pr.incorp_date,'DD/MM/YYYY') DATECREAT,
field_val_2 sigle,
(select country from xafnfc.sttm_country_isocodes i where c.country = i.iso2_code ) PaysSiegeSocial,
decode(substr(c.loc_code,1,2),'10','YAOUNDE','11','DOUALA','12','GAROUA','13','LIMBE','14','NKONGSAMBA','15','BAFOUSSAM','17','NGAOUNDERE','18','BAMENDA','AUTRES VILLES DU CAMEROUN' ) VILLEsiegeSOCIAL,
c.unique_id_value RegCommerce,
pr.c_national_id CarteContribuable,
decode(m.cust_mis_2,'FOR999','SA',m.cust_mis_2) FORMEJURIDIQUE,
(select code_desc from xafnfc.gltm_mis_code where mis_class ='GRPACT' and mis_code = decode(m.cust_mis_3,'GRP999','90.3',m.cust_mis_3) ) ActEcon
from xafnfc.sttm_customer c join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
and c.record_stat ='O';

-- Declaration des comptes

SELECT decode(c.customer_type,'I','01','02') typeclt,
a.ccy Coddev,
1002500||a.cust_ac_no RIB,
case when c.customer_type = 'I' then decode(a.joint_ac_indicator,'Y','Joint','Individuel')
  else decode(m.cust_mis_2,'EURL','Professionel','Entreprise') 
end Natcpte, 
case when c.customer_type = 'I' then decode(substr(a.account_class,1,1),'3','Epargne','Dépôt à Vue')
  else 'Courant' 
end Typecpte,
c.address_line1 Adresse,
null BoitePostale,
decode(substr(c.loc_code,1,2),'10','YAOUNDE','11','DOUALA','12','GAROUA','13','LIMBE','14','NKONGSAMBA','15','BAFOUSSAM','17','NGAOUNDERE','18','BAMENDA','AUTRES VILLES DU CAMEROUN' ) VILLEresid,
(select country from xafnfc.sttm_country_isocodes i where c.country = i.iso2_code ) Pays
FROM xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.mitm_customer_default m
WHERE a.cust_no = c.customer_no
and c.customer_no = m.customer
and a.record_stat ='O';




