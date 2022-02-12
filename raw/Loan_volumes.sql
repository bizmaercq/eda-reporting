SELECT nvl(cp.sex,'M') Sex,sum(am.AMOUNT_FINANCED) Amount_financed
FROM cltb_account_master am , sttm_cust_personal cp, sttm_customer cu
WHERE am.CUSTOMER_ID = cp.customer_no
and am.CUSTOMER_ID = cu.customer_no
and am.MATURITY_DATE >='31/12/2019'
and am.BOOK_DATE <='31/12/2019'
and substr(am.PRODUCT_CODE,1,1) in  ('S','M')
and cu.customer_type /*<>*/ = 'I'
group by nvl(cp.sex,'M')
