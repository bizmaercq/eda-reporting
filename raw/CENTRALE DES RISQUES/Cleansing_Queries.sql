-- Corporate Customers and their names for review and verification
select c.local_branch, c.customer_no, c.full_name, co.corporate_name ,c.customer_name1,c.short_name, co.c_national_id, c.unique_id_value 
from sttm_customer c , sttm_cust_corporate co  
where  c.customer_no = co.customer_no and customer_type ='C'
order by c.local_branch;
-- Customers staring with space
select cu.local_branch,cu.customer_name1,cu.short_name,cu.full_name
from sttm_customer cu
where cu.customer_name1 like ' %'
order by cu.local_branch,cu.customer_name1;
------
update sttm_customer cu set cu.customer_name1 = ltrim(cu.customer_name1) WHERE cu.customer_name1 like ' %';
update sttm_customer cu set cu.short_name = ltrim(cu.short_name) WHERE cu.short_name like ' %';
update sttm_customer cu set cu.full_name = ltrim(cu.full_name) WHERE cu.full_name like ' %';



-- Spouses without maiden Name
select cu.local_branch, cu.customer_no, cp.customer_prefix,cu.full_name, cu.customer_name1,cp.first_name,cp.middle_name,cp.last_name,cu.udf_3 NOM_JEUNE_FILLE
from sttm_customer cu, sttm_cust_personal cp
where cu.customer_no = cp.customer_no
and cp.customer_prefix ='MME'
and cu.udf_3 is null

-- Corporate customer without Objet Social
select cu.local_branch,cu.customer_no,cu.customer_name1,co.corporate_name,co.business_description
from sttm_customer cu , sttm_cust_corporate co
where cu.customer_no = co.customer_no
and cu.customer_type ='C'
and co.business_description is null
order by cu.local_branch,cu.customer_name1;
