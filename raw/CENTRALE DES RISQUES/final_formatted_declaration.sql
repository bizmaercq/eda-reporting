
------------------------------------------------------------------------------
---       G�n�ration du fichier des personnes physiques                   ----
------------------------------------------------------------------------------

select '"'||c.customer_no||'";"'||rpad(p.customer_prefix,4,' ')||'";"'||rpad(p.customer_prefix1,5,' ')||'";"'||rpad(nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)),30,' ')||'";"'||rpad(nvl(p.first_name,' '),30,' ')||'";'||to_char(date_of_birth,'DD/MM/YYYY')||';"'||rpad(nvl(c.udf_2,' '),50,' ')||'";"'||rpad(nvl(c.udf_3,' '),30,' ')||'";'||'"S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3)||'";"'||rpad(iso3_code,3,' ')||'";"'||rpad(nvl(c.udf_4,' '),50,' ')||'";"'||rpad(c.cust_classification,3,' ')||'";"'||rpad(nvl(c.address_line1,' '),30,' ')||'";"'||rpad(nvl(c.address_line2,' '),30,' ')||'";"'||rpad(nvl(c.address_line3,' '),30,' ')||'";;"'||rpad(substr(c.loc_code,1,2),2,' ')||'   ";"'||field_val_1||'"'
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
                     join xafnfc.sttm_country_isocodes i on i.iso2_code = c.country
where c.customer_type ='I'
and c.checker_dt_stamp >= '01/09/2015' ;



------------------------------------------------------------------------------
---       G�n�ration du fichier des personnes morales                     ----
------------------------------------------------------------------------------

select '"'||c.customer_no||'";"'||rpad(c.full_name,100,' ')||'";"'||rpad(nvl(field_val_2,' '),20,' ')||'";"'||substr(c.loc_code,1,2)||'";"'||rpad(replace(c.unique_id_value,'/',''),15,' ')||'";"'||rpad(nvl(pr.corporate_name,' '),34,' ')||'";"'||rpad(pr.c_national_id,15,' ')||'";"'||rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' ')||'";"'||to_char(pr.incorp_date,'DD/MM/YYYY')||'";"'||rpad(c.cust_classification,5,' ')||'";"'||
rpad(nvl(pr.business_description,' '),100,' ')||'";"'||rpad(nvl(pr.r_address1,' '),30,' ')||'";"'||rpad(nvl(c.address_line2,' '),30,' ')||'";"'||rpad(nvl(c.address_line3,' '),30,' ')||'";'||null||';"'||rpad(substr(c.loc_code,1,2),5,' ')||'";"S.'||decode(substr(m.cust_mis_1,1,3),'SEC','144',substr(m.cust_mis_1,1,3))||'";"'||rpad(c.fax_number,20,' ')||'";"'||rpad(p.telephone,20,' ')||'";"'||null||'";"'||null||'";"'||
null||'";"'||decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3)||' "'
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
and c.checker_dt_stamp  >= '01/09/2015'  ;



------------------------------------------------------------------------------
---                        G�n�ration des encours                         ----
------------------------------------------------------------------------------
select '"'||customer_id||'";"'||rpad(nvl(customer_name1,' '),100,' ')||'";"'||decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3)||' ";'||
sum(Effet_Commerciaux_Locaux)||';'||
ltrim(replace(to_char(sum(Decouverts),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Accompagnements_Marches),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Avances_Court_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Export),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Moyen_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Long_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Impayes),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Douteux),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Agios_Reserves),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Engagement_par_signature),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Dont_Douteux),'99990.90'),'.',','),' ')
from
(
 select customer_id,customer_name1,decode(cust_mis_3,'GRP999','93.0',cust_mis_3) as cust_mis_3,
 case when central_bank_code in ('C2J','C2K','C2L') then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Effet_Commerciaux_Locaux,
 case when central_bank_code in ('C71','C72','C75','C76','C86','C42','C43','C4J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Decouverts,
 case when central_bank_code in ('C2M','C2N') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Accompagnements_Marches,
 case when central_bank_code in ('C2C','C22','C23','C26','C27','C29','C4G','C4H','C87','C28','C78','N4D') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Avances_Court_Terme, 
 case when central_bank_code in ('C2D','C2E','C2F','C2G','C2H') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Export, 
 case when central_bank_code in ('C11','C12','C13','C14','C15','C16','C17','C18','C4D','C4E','C4F') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Moyen_Terme, 
 case when central_bank_code in ('C01','C02','C03','C04','C05','C06','C07','C08') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Long_Terme ,
 case when central_bank_code in ('C41') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Impayes, 
 case when central_bank_code in ('C42','C43','C4C','C4D','C4E','C4F','C4G','C4H','C4J','C46','C47') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Douteux, 
 case when central_bank_code in ('Q8K','Q8L') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Agios_Reserves, 
 case when central_bank_code in ('M21','M22','M23','M24','M25','M29','N43','Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Engagement_par_signature, 
 case when central_bank_code in ('Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Dont_Douteux 
 from vw_trial_balance join sttm_customer on customer_id = customer_no
                             join mitm_customer_default m on customer_no = m.customer
 where length(account_number)<> 9
 group by customer_id,customer_name1,cust_mis_3,central_bank_code
 having sum(amount) <=-10000
 union
SELECT a.cif_id customer_id,A.CUST_NAME customer_name1,M.CUST_MIS_3,
null as Effet_Commerciaux_Locaux,
null as Decouverts,
null as Accompagnements_Marches,
null as Avances_Court_Terme, 
null as Credit_Export, 
null as Credit_Moyen_Terme, 
null as Credit_Long_Terme ,
null as Impayes, 
null as Douteux, 
null as Agios_Reserves, 
trunc(abs (nvl(sum(A.CONTRACT_AMT),0))/1000000,2) as Engagement_par_signature, 
null  as Dont_Douteux 
FROM xafnfc.LCTB_CONTRACT_MASTER A,xafnfc.CSTM_PRODUCT C, xafnfc.lctb_ffts D, xafnfc.cstb_contract cs,mitm_customer_default m 
WHERE A.PRODUCT_CODE=C.PRODUCT_CODE and cs.contract_ref_no = A.contract_ref_no 
and m.customer = a.cif_id
AND cs.curr_event_code <> 'CLOS'
AND   C.PRODUCT_TYPE='G'
AND   A.CONTRACT_REF_NO = D.CONTRACT_REF_NO
AND   A.EVENT_SEQ_NO = (SELECT MAX(D.EVENT_SEQ_NO) FROM xafnfc.LCTB_CONTRACT_MASTER D WHERE D.CONTRACT_REF_NO=A.CONTRACT_REF_NO) and
A.EFFECTIVE_DATE between &PM_FROM_DT AND &PM_TO_DT
group by a.cif_id,A.CUST_NAME,M.CUST_MIS_3
having sum(a.contract_amt) >=10000
)
where customer_id not in ('012918') -- excluding some specific customers
group by customer_id,customer_name1,cust_mis_3
having ( ( sum(Effet_Commerciaux_Locaux) <>0) or (sum(Decouverts) <>0) or(sum(Accompagnements_Marches) <>0) or(sum(Avances_Court_Terme) <>0) or
          (sum(Credit_Export) <>0) or(sum(Credit_Moyen_Terme) <>0) or(sum(Credit_Long_Terme) <>0) or(sum(Impayes) <>0) or
          (sum(Douteux) <>0) or(sum(Agios_Reserves) <>0) or(sum(Engagement_par_signature) <>0) or(sum(Dont_Douteux) <>0)
       ) 
order by customer_id;