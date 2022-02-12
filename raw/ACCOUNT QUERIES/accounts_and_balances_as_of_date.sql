-- Accounts in debit as of a date Detail
select a1.branch_code,a1.account,cu.customer_name1, ca.ac_desc,bkg_date last_txn_date ,a1.lcy_closing_bal , ca.acc_status
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu
where a1.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <=&As_Of_Date)
and a1.bkg_date <= &As_Of_Date
and a1.lcy_closing_bal <0
and length(a1.account) = 16
order by a1.lcy_closing_bal;

-- Accounts in debit as of a date Summary
select cu.customer_type,count(*) "Count"
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu
where a1.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <=&As_Of_Date)
and a1.bkg_date <= &As_Of_Date
and a1.lcy_closing_bal <0
and length(a1.account) = 16
group by cu.customer_type;

-- Accounts in credit as of a date Detail
select a1.branch_code,a1.account,cu.customer_name1, ca.ac_desc,bkg_date last_txn_date ,a1.lcy_closing_bal 
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu
where a1.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <=&As_Of_Date)
and a1.bkg_date <= &As_Of_Date
and a1.lcy_closing_bal > 0
and length(a1.account) = 16
order by a1.lcy_closing_bal desc;

-- Accounts in credit as of a date Summary
select cu.customer_type,count(*) "Count"
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu
where a1.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <=&As_Of_Date)
and a1.bkg_date <= &As_Of_Date
and a1.lcy_closing_bal >0
and length(a1.account) = 16
group by cu.customer_type;

