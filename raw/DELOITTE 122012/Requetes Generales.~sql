select * from sttm_account_class
--General Documents 
--1 List of all current accounts opened in Flexcube as at 02/05/2012
select * from sttm_cust_account ca 
where account_class between '500' and '599'
and ca.dormancy_date >='30/10/2012'
and ca.ac_open_date >='25/01/2017';
--- Compte staff ouvert entre 2 periodes
select * from smtb_cust_account ca 
where account_class ='281'--between '500' and '599'
--and ca.dormancy_date >='30/10/2012'
and ca.ac_open_date between '01-JAN-2016' and '25-JAN-2017'
order by branch_code,ac_open_date,cust_no;

-- List compte utilisateurs Flexcube entre 2 périodes

select * from smtb_current_users ca where substr(start_time,1,10) between '01-JAN-2016' and '25-JAN-2017'
order by home_branch,start_time;


select am.BRANCH_CODE,am.CUSTOMER_ID,am.PRODUCT_CODE,am.BOOK_DATE,am.VALUE_DATE,am.MATURITY_DATE,am.AMOUNT_FINANCED,uv.ude_value "INTEREST RATE",am.ORIGINAL_ST_DATE,am.ACCOUNT_NUMBER
from cltb_account_master am 
join CLTB_ACCOUNT_UDE_VALUES uv on  am.ACCOUNT_NUMBER = uv.account_number
where am.BOOK_DATE >= '02/05/2012'
and  uv.ude_id = 'INTEREST_RATE';

select * from cltb_account_components

select * from user_tables where table_name like '%TXN%'

select * from GLTB_TXN_MIS


select * from sttm_account_class

select * from actb_history where ac_no like '34%'

and length(ac_no) = 9 

select distinct ac.AC_BRANCH,ac.RELATED_CUSTOMER,cu.customer_name1,substr(ac.RELATED_ACCOUNT,4,4),ac.RELATED_ACCOUNT,cm.DR_PROD_AC,ac.AC_NO GL,
nvl(sum(decode(ac.DRCR_IND,'C', ac.LCY_AMOUNT,0)),0) - nvl(sum(decode(ac.DRCR_IND,'D', ac.LCY_AMOUNT,0)),0) BALANCE
from cltb_account_master cm, acvw_all_ac_entries ac,sttm_customer cu
where cm.ACCOUNT_NUMBER = ac.RELATED_ACCOUNT
and ac.AC_NO like '34%'
and cm.CUSTOMER_ID = cu.customer_no
and ac.VALUE_DT <= '31/10/2012'
group by ac.AC_BRANCH,ac.RELATED_CUSTOMER,cu.customer_name1,substr(ac.RELATED_ACCOUNT,4,4),ac.RELATED_ACCOUNT,cm.DR_PROD_AC,ac.AC_NO
