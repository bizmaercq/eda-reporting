
select * from xafnfc.vw_trial_balance


-- Customer Distribution
select Location,sum(Nombre_Credit) Nombre_Credit,sum(Montant_Credit) Montant_Credit,sum(Nombre_Depot) Nombre_Depot,sum(Montant_Depot) Montant_Depot
from
(
select decode(branch,'010','YAOUNDE ','020','YAOUNDE','021','YAOUNDE','022','YAOUNDE','023','YAOUNDE','024','YAOUNDE','030','BAMENDA','031','BAMENDA','040','KUMBA','041','MUYUKA','042','MAMFE','043','BUEA','050','DOUALA','051','DOUALA','YAOUNDE') LOCATION ,
case when central_bank_code in ('C71','C72','C75','C76','C86','C2C','C22','C23','C26','C27','C29','C87','C28','C78','N4D','C2M','C2N','C11','C12','C13','C14','C15','C16','C17','C18','C01','C02','C03','C04','C05','C06','C07','C08','C2D','C2E','C2F','C2G','C2H') then   count(*)  end as Nombre_Credit,
case when central_bank_code in ('C71','C72','C75','C76','C86','C2C','C22','C23','C26','C27','C29','C87','C28','C78','N4D','C2M','C2N','C11','C12','C13','C14','C15','C16','C17','C18','C01','C02','C03','C04','C05','C06','C07','C08','C2D','C2E','C2F','C2G','C2H') then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Montant_Credit,
case when central_bank_code in ('H74','H79','H55','H52','H59','H51','H73','H61','H71','H53','H54','H72','H69') then   count(*)  end as Nombre_Depot,
case when central_bank_code in ('H74','H79','H55','H52','H59','H51','H73','H61','H71','H53','H54','H72','H69') then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Montant_Depot
from xafnfc.vw_trial_balance
group by branch,central_bank_code
) 
group by Location
having nvl(sum(Nombre_Credit),0)<>0 ;


select Location,sum(Nombre_Credit) Nombre_Credit,sum(Montant_Credit) Montant_Credit,sum(Nombre_Depot) Nombre_Depot,sum(Montant_Depot) Montant_Depot
from
(
select nvl(branch,'010') LOCATION ,
case when substr(central_bank_code,1,1) = 'C' then   count(*)  end as Nombre_Credit,
case when substr(central_bank_code,1,1) = 'C' then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Montant_Credit,
case when substr(central_bank_code,1,1) = 'H' then   count(*)  end as Nombre_Depot,
case when substr(central_bank_code,1,1) = 'H' then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Montant_Depot
from xafnfc.vw_trial_balance
group by branch,central_bank_code
)
group by Location
order by Location;



'H74','H79','H55','H52','H59','H51','H73','H61','H71','H53','H54','H72','H69'


-- Accounts Distribution


select Location, sum(Nombre)Nombre 
from
(
  select decode(branch_code,
              '010','YAOUNDE',
              '020','YAOUNDE',
              '021','YAOUNDE',
              '022','YAOUNDE',
              '023','YAOUNDE',
              '024','YAOUNDE',
              '030','BAMENDA',
              '031','BAMENDA',
              '040','KUMBA',
              '041','MUYUKA',
              '042','MAMFE',
              '043','BUEA',
              '050','DOUALA',
              '051','DOUALA',
              'AUTRES') LOCATION ,count(*) Nombre
  from xafnfc.sttm_cust_account
  group by branch_code
  order by branch_code
)
group by Location;

-----

select c.local_branch, count(*) "Number"
from sttm_customer c
group by c.local_branch;

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
 from xafnfc.vw_trial_balance join xafnfc.sttm_customer on customer_id = customer_no
                             join xafnfc.mitm_customer_default m on customer_no = m.customer
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



