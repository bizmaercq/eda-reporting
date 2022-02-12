SELECT T.AC_BRANCH,t.RELATED_CUSTOMER,p.cust_ac_no, t.TRN_DT,t.RELATED_ACCOUNT, t.DRCR_IND,t.LCY_AMOUNT ,y.lcy_balance
FROM ACVW_ALL_AC_ENTRIES T, sttm_cust_account P, cltb_account_comp_bal_breakup y  
WHERE T.AC_NO LIKE '98%' AND T.TRN_CODE<>'CNV' 
AND T.TRN_DT BETWEEN '01-jan-2016' AND '30-JUN-2016'
and t.RELATED_CUSTOMER=p.cust_no
and t.RELATED_ACCOUNT=y.account_number
and y.component='PRINCIPAL'
