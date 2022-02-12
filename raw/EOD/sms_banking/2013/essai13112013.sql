SELECT c.ACCOUNT_NUMBER Loan_Account,ac.DR_PROD_AC Customer_Account,ac.PRIMARY_APPLICANT_NAME Customer_Name, COMPONENT_NAME, min(balance) balance
FROM xafnfc.cltb_account_comp_balances c,xafnfc.cltb_account_master ac
where ac.ACCOUNT_NUMBER = c.ACCOUNT_NUMBER and COMPONENT_NAME='PRINCIPAL_OUTSTAND'
and c.VAL_DATE <= :ddate
group by c.ACCOUNT_NUMBER,ac.DR_PROD_AC,ac.PRIMARY_APPLICANT_NAME, COMPONENT_NAME

select * from xafnfc.cltb_account_master