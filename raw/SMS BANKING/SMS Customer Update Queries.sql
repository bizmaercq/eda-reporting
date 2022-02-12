-- Basic Maintenance for all type of customers

-- Activate Sms Alert for a customer account
insert into SMS_CUSTACC_ALERTS (customer_number, customer_name, account_number, account_currency, alert, sms_chg_amt, accounts_txns, cust_acct_alert, check_book, s_instructions, clearance, mobile_no)
select cu.CUSTOMER_NO customer_number,cu.CUSTOMER_NAME1 customer_name,ca.CUST_AC_NO account_number,'XAF' account_currency,'Y' alert,0 sms_chg_amt,'N' accounts_txns,'N' cust_acct_alert,'N' check_book,'N' s_instructions,'N' clearance,null mobile_no 
from sms_cust_account ca ,sms_customer cu
where ca.CUST_NO = cu.CUSTOMER_NO
and ca.CUST_AC_NO= '&account';

-- Corporate customer Maintenance
-- Add a corporate customer account
insert into sms_trncode_map
select tx.TRN_CODE Transaction_code,tx.TRN_DESC Transaction_description,0 minimal_limit_amount,10000000 maximum_limit_amount,substr('&account',9,6) customer_number,'&account' account_number
from sms_trn_code tx
where tx.TRN_CODE in ('IDT','IIF','IIP','CIT','IBS','TRF','TBB','TFD','TSW','TTI','TDB','LSC','BCI','BCG','BCW','BWO','BWT','MCQ','ILT','TIL','SIP','IFT','OFT','CCQ','LQP','CSD','CHW');


-- Individual Customer Maintenance
-- Add a Full Service customer account
SELECT * FROM sms_trncode_map cm WHERE cm.account_number ='&account';
insert into sms_trncode_map
select tx.TRN_CODE Transaction_code,tx.TRN_DESC Transaction_description,0 minimal_limit_amount,10000000 maximum_limit_amount,substr('&account',9,6) customer_number,'&account' account_number
from sms_trn_code tx
where tx.TRN_CODE in ('IDT','IIF','IIP','CIT','IBS','TRF','TBB','TFD','TSW','TTI','TDB','LSC','SAL','BCI','BCG','BCW','BWO','BWT','MCQ','ILT','TIL','SIP','IFT','OFT','CCQ','LQP','CSD','CHW');

-- Add a basic Service customer account
SELECT * FROM sms_trncode_map cm WHERE cm.account_number ='&account';
insert into sms_trncode_map
select tx.TRN_CODE Transaction_code,tx.TRN_DESC Transaction_description,0 minimal_limit_amount,10000000 maximum_limit_amount,substr('&account',9,6) customer_number,'&account' account_number
from sms_trn_code tx 
where tx.TRN_CODE in ('IDT','IIF','IIP','CIT','IBS','SAL','CCQ','CSD','CHW','ACW');

-- Add a Staff Salary account
insert into sms_trncode_map
select tx.TRN_CODE Transaction_code,tx.TRN_DESC Transaction_description,0 minimal_limit_amount,10000000 maximum_limit_amount,substr('&account',9,6) customer_number,'&account' account_number
from sms_trn_code tx
where tx.TRN_CODE in ('IDT','IIF','IIP','CIT','IBS','SAL','CCQ','CSD','CHW','S13','AVS','ACW');


-- Update a telephone number for individual
SELECT * FROM xafnfc.sttm_cust_personal cp WHERE customer_no ='&Customer_no' FOR UPDATE NOWAIT; 


---- 
insert into sms_trncode_map
select 'IIP' Transaction_code,'INTERNET BILL PAYMENT' Transaction_description,0 minimal_limit_amount,10000000 maximum_limit_amount,substr(ca.cust_ac_no,9,6) customer_number,ca.cust_ac_no account_number
from  xafnfc.sttm_cust_account ca 
WHERE ca.account_class ='281'



SELECT * FROM 
