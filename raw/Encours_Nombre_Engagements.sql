-- summary and count 
select c.customer_type,count(*) from
actb_accbal_history aa , sttm_customer c
where substr(aa.account,9,6) = c.customer_no 
and aa.bkg_date =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&Date' 
and a.account = aa.account)
and aa.lcy_closing_bal <0
--and aa.account = '&Account'
--and aa.account in (select ac.cust_ac_no from sttm_cust_account ac where ac.account_class = '281' and ac.record_stat ='O')
group by c.customer_type;

-- new contracts 
select c.customer_type,count(*),sum(aa.lcy_closing_bal)/1000000 from
actb_accbal_history aa , sttm_customer c, sttm_cust_account a
where substr(aa.account,9,6) = c.customer_no 
and a.cust_ac_no = aa.account
and aa.bkg_date =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&End_Date' 
and a.account = aa.account)
and aa.lcy_closing_bal <0
and a.ac_open_date between '&Start_Date' and '&End_Date'
--and aa.account = '&Account'
--and aa.account in (select ac.cust_ac_no from sttm_cust_account ac where ac.account_class = '281' and ac.record_stat ='O')
group by c.customer_type;



-- loans

SELECT cu.customer_type,count(*) 
FROM cltb_account_master am , sttm_customer cu
WHERE am.CUSTOMER_ID = cu.customer_no
and am.MATURITY_DATE between '&Start_Date' and '&End_Date' 
and substr(am.PRODUCT_CODE,1,1) in ('M','L','S')
group by cu.customer_type;

---- Loans by Gender
SELECT nvl(cp.sex,'C') GENDER,count(*) "COUNT" , sum(am.AMOUNT_FINANCED) AMOUNT
FROM cltb_account_master am , sttm_customer cu, sttm_cust_personal cp
WHERE am.CUSTOMER_ID = cu.customer_no
and cu.customer_no = cp.customer_no
and am.BOOK_DATE between '&Start_Date' and '&End_Date' 
and substr(am.PRODUCT_CODE,1,1) in ('M','L','S')
group by nvl(cp.sex,'C');


---- Loans For Micro finances
SELECT ca.account_class,ac.description,cu.customer_name1, sum(am.AMOUNT_FINANCED) AMOUNT
FROM cltb_account_master am , sttm_customer cu, sttm_cust_account ca, sttm_account_class ac
WHERE am.CUSTOMER_ID = cu.customer_no
and ca.cust_no = cu.customer_no
and ca.account_class = ac.account_class
and ac.account_class ='151'
and am.BOOK_DATE between '&Start_Date' and '&End_Date' 
--and substr(am.PRODUCT_CODE,1,1) in ('M','L')
group by ca.account_class,ac.description,cu.customer_name1 ;



-- New
SELECT cu.customer_type,count(*), sum(am.AMOUNT_FINANCED)/1000000 
FROM cltb_account_master am , sttm_customer cu
WHERE am.CUSTOMER_ID = cu.customer_no
and am.BOOK_DATE between '&Start_Date' and '&End_Date' 
and substr(am.PRODUCT_CODE,1,1) in ('M','L')
group by cu.customer_type;


-- LC Contracts

SELECT cu.customer_type,count(*)
FROM lctb_contract_master cm, sttm_customer cu
WHERE cm.cif_id = cu.customer_no
and cm.expiry_date  between '&Start_Date' and '&End_Date'
group by cu.customer_type;

-- New
SELECT cu.customer_type,count(*),sum(cm.contract_amt) /1000000
FROM lctb_contract_master cm, sttm_customer cu
WHERE cm.cif_id = cu.customer_no
and cm.issue_date  between '&Start_Date' and '&End_Date'
group by cu.customer_type;
