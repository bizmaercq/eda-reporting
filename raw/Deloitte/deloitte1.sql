--- Term Deposits

SELECT ACCOUNT_NO,
       CUSTOMER_NAME,
       TO_CHAR(TRUNC(DATE_OF_OPEN), 'dd-MON-RRRR') ,
       bipks_report.fn_get_TD_Rate(branch_code,account_no),
       DEPOSIT_AMOUNT,
       TO_CHAR(TRUNC(TD_MATURITY_DATE), 'dd-MON-RRRR') ,
       TOTAL_INTEREST_PAYABLE,
       MATURITY_AMOUNT, TD.branch_code, TD.product_code, TD.Product_Title
 FROM TDVW_TD_DETAILS TD
 WHERE /*TRUNC(CHECKER_DT)*/TRUNC(TD.TD_Maturity_date) BETWEEN
       NVL('&PM_FROM_DATE', CHECKER_DT) AND
       NVL('&PM_TO_DATE', CHECKER_DT)  AND
 RECORD_STAT = 'O' 
 --DEPOSIT_AMOUNT <> MATURITY_AMOUNT
 ORDER BY BRANCH_NAME, PRODUCT_CODE;
 

 select p.gl_code, p.cust_ac_no, p.branch_code,f.ac_desc,f.ac_open_date,t.TD_Maturity_date,t.Deposit_amount,t.Total_interest_Payable  
 from GLTB_CUST_ACCBREAKUP P, sttm_cust_account f , tdvw_td_details t
  WHERE p.cust_ac_no = f.cust_ac_no and f.cust_ac_no = t.Account_no and P.GL_CODE LIKE '54%' and t.record_stat = 'O' 
 and p.period_code='M10' and p.fin_year='FY2017'

-- TD with Interest payable
SELECT distinct y.branch_code,y.gl_code,y.cust_ac_no,x.customer_Name,x.Date_of_Open, x.Deposit_amount,ss.ude_value INTEREST_RATE,x.Total_interest_Payable
FROM gltb_cust_accbreakup y, tdvw_td_details x,ictm_acc_udevals ss 
where y.gl_code like '54%'-- and y.period_code='M06'
--and y.fin_year='FY2016' --and y.cr_bal_lcy<>'0'
and ss.ude_id='INT_RATE'
and x.TD_Maturity_date >'31-dec-2018'
and y.cust_ac_no=x.Account_no
AND X.Account_no= ss.acc;
