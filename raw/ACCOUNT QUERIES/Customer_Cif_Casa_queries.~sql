-- List of customers as at a specific date

select c.local_branch,c.customer_no,c.customer_name1,c.cif_creation_date
from sttm_customer c
where c.cif_creation_date <= to_date('&CreationDate','DD/MM/YYYY')
and c.record_stat ='O'
and c.customer_no<900000;

-- List of customers as at a specific date

select c.local_branch,c.customer_no,c.customer_name1,c.cif_creation_date
from sttm_customer c
where c.cif_creation_date <= to_date('&CreationDate','DD/MM/YYYY')
and c.record_stat ='O'
and c.customer_no<900000
and c.customer_type ='I';

-- List of customers as at a specific date

select c.local_branch,c.customer_no,c.customer_name1,c.cif_creation_date
from sttm_customer c
where c.cif_creation_date <= to_date('&CreationDate','DD/MM/YYYY')
and c.record_stat ='O'
and c.customer_no<900000
and c.customer_type ='C';

select c.customer_type,count(*)
from sttm_customer c
where c.cif_creation_date <= to_date('&CreationDate','DD/MM/YYYY')
and c.record_stat ='O'
--and c.customer_no<900000
group by c.customer_type ;

-- List of customers as at a specific date

select c.local_branch,c.customer_no,c.customer_name1,c.cif_creation_date
from sttm_customer c
where c.cif_creation_date <= to_date('&CreationDate','DD/MM/YYYY')
and c.record_stat ='O'
and c.customer_no<900000
and c.customer_type ='B';


-- List of deposit accounts

select td.branch_code, td.Account_no, td.customer_no, td.Account_no,td.customer_Name, td.Deposit_amount, td.MATURITY_AMOUNT, td.Date_of_Open, td.TD_Maturity_date 
from tdvw_td_details td 
where td.Date_of_Open <='&DateCreation'
and td.record_stat = 'O';

-- New customers by type and by branch

select c.local_branch,decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK') Customer_Type, count(*) "COUNT"
from sttm_customer c
where c.cif_creation_date between '&Start_Date' and '&End_Date'
and c.record_stat ='O'
group by c.local_branch,decode(c.customer_type,'I','INDIVIDUAL','C','CORPORATE','BANK')
order by c.local_branch;

