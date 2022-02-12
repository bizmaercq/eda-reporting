
--- References 
SELECT * FROM gltm_mis_code mc WHERE mc.mis_class ='SECINST';
SELECT * FROM gltm_mis_code mc WHERE mc.mis_class ='GRPACT';
SELECT * FROM gltm_mis_code mc WHERE mc.mis_class ='RESIDENT';
--- Template for Staff
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , 'RESIDENT' Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, '14300' Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, 'GRP999' Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, (select distinct ca.cust_no from sttm_cust_account ca WHERE ca.account_class in ('281','284') ) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;


--- Template for civil servants
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , 'RESIDENT' Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, '14300' Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, 'GRP999' Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, (select distinct ca.cust_no from sttm_cust_account ca WHERE ca.account_class in ('282') ) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;
--- Template for Salary earners non civil servants
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , null Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, '14300' Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, 'GRP999' Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, (select distinct ca.cust_no from sttm_cust_account ca WHERE ca.account_class in ('285') ) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;
--- Template for non Salary earners 
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , null Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, '14300' Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, 'GRP999' Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, (select distinct ca.cust_no from sttm_cust_account ca WHERE ca.account_class in ('283') ) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;

--- Template for other Individuals 
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , null Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, '14300' Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, 'GRP999' Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, 
(select distinct ca.cust_no from sttm_cust_account ca WHERE substr(ca.account_class,1,2) in ('38','58') --36688
MINUS
select distinct ca.cust_no from sttm_cust_account ca WHERE substr(ca.account_class,1,1) in ('1','2')--35227
) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;

--- Template for Corporates 
SELECT cu.local_branch, decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') Customer_Type,cu.customer_no,cu.customer_name1,
decode( nvl(cp.resident_status,'R'),'R','RESIDENT','NON RESIDENT') Actual_Residency_status , null Projected_Residency_status,
cd.cust_mis_1 Actual_Intitutional_Unit, null Projected_institutional_unit,
cd.cust_mis_3 Actual_Economic_Activity, null Projected_Economic_Activity
FROM mitm_customer_default cd,sttm_customer cu, sttm_cust_personal cp, 
(select distinct ca.cust_no from sttm_cust_account ca WHERE substr(ca.account_class,1,1) in ('1') ) cr
WHERE cd.customer = cu.customer_no
and cp.customer_no =cu.customer_no
and cd.customer = cu.customer_no
and cr.cust_no = cu.customer_no
and cu.record_stat ='O'
order by cu.local_branch,cu.customer_no;

--- Updates for customers

update mitm_customer_default cd set cd.cust_mis_1 ='New_Institutional_Unit', cd.cust_mis_3 = 'New_Economic_Activity', cd.cust_mis_8 ='New_Residency_Status' WHERE cd.customer ='Customer_CIF';
