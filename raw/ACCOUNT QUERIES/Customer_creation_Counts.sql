-- clients a date du 31/12/2014
SELECT count(*)  FROM sttm_customer c WHERE c.cif_creation_date <='31/12/2014' and c.record_stat ='O';

-- types de compte
SELECT decode(substr(account_class,1,1),'1','CURRENT','2','CURRENT','3','SAVING','5','DEPOSITS','WALKIN') TYPE,sum(R_Count) R_Count
from
 (
  SELECT cl.account_class,cl.description, count(*) R_Count
  FROM sttm_cust_account ac, sttm_account_class cl 
  WHERE ac.account_class = cl.account_class
  group by cl.account_class,cl.description
  order by cl.account_class
 )
 group by decode(substr(account_class,1,1),'1','CURRENT','2','CURRENT','3','SAVING','5','DEPOSITS','WALKIN') ; 

-- Average customer creation per month
SELECT to_char(cu.cif_creation_date,'MON-RRRR') Period,count(*) R_count
FROM sttm_customer cu
where  cu.record_stat ='O'
and cu.cif_creation_date between '01-jan-2018' and '17-sep-2018' 
group by to_char(cu.cif_creation_date,'MON-RRRR');

SELECT to_char(ca.ac_open_date,'MON-RRRR') Period,count(*) R_count
FROM sttm_cust_account ca
where ca.ac_open_date between '01/01/2014' and '31/12/2014' 
group by to_char(ca.ac_open_date,'MON-RRRR');

----liste des clients par agences avec number phone
select c.full_name, c.address_line3, c.liab_br FROM sttm_customer c where c.liab_br = '051';
