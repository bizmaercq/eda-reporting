-- Loans whose frequency is not monthly
SELECT am.BRANCH_CODE,am.ACCOUNT_NUMBER,am.CUSTOMER_ID,cu.customer_name1,am.BOOK_DATE, am.MATURITY_DATE,uv.ude_value RATE,
decode(am.FREQUENCY_UNIT,'M','MONTHLY','B','BIMONTHLY','Q','QUATERLY','H','HALFYEARLY','') FREQUENCY,am.AMOUNT_FINANCED,am.NO_OF_INSTALLMENTS 
FROM cltb_account_master am, sttm_customer cu,cltb_account_ude_values uv
where am.CUSTOMER_ID = cu.customer_no
and am.ACCOUNT_NUMBER = uv.account_number
and am.FREQUENCY_UNIT <>'M'
and uv.ude_id ='INTEREST_RATE';

-- Loans whose interest rate is less than 12%
SELECT am.BRANCH_CODE,am.ACCOUNT_NUMBER,am.CUSTOMER_ID,cu.customer_name1,am.BOOK_DATE, am.MATURITY_DATE,uv.ude_value RATE,
decode(am.FREQUENCY_UNIT,'M','MONTHLY','B','BIMONTHLY','Q','QUATERLY','H','HALFYEARLY','') FREQUENCY,am.AMOUNT_FINANCED,am.NO_OF_INSTALLMENTS 
FROM cltb_account_master am, sttm_customer cu,cltb_account_ude_values uv
where am.CUSTOMER_ID = cu.customer_no
and am.ACCOUNT_NUMBER = uv.account_number
and uv.ude_id ='INTEREST_RATE'
and uv.ude_value <12;
