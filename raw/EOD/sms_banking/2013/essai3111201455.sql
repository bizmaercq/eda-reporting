select kk.CUSTOMER_ID,
DECODE(KK.FREQUENCY_UNIT,'M','MONTHLY','Q','QUATERLY','H','HALFEARLY','Y','YEARLY') FREQUENCY,
(select cust_cat_desc from STTM_CUSTOMER_CAT where cust_cat = cust.customer_category) cat_DESC,
      (select ac_desc from sttm_cust_account where cust_ac_no = kk.DR_PROD_AC) ac_desc,
       kk.account_number LOAN_CONT_NO,
       (select product_description from cstm_product where product_code = kk.PRODUCT_CODE ) PRODUCT_DESC,
       kk.AMOUNT_FINANCED,
       to_char(kk.BOOK_DATE,'dd-MON-yyyy') BOOK_DATE,
       (select sum(nvl(amount_due, 0) - nvl(amount_settled, 0))
          from cltb_account_schedules ll
         where ll.ACCOUNT_NUMBER = kk.account_number
           and ll.component_name = 'PRINCIPAL') AMOUNT_OUTSTANDING,
       kk.NO_OF_INSTALLMENTS,
       (select count(*)
          from cltb_account_schedules ll
         where ll.ACCOUNT_NUMBER = kk.account_number
           and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0) UNPAID_INSTALLMENTS,
       al.linkage_type,
      al.linkage_amount,
       kk.BRANCH_CODE,
       (select ude_value
          from cltb_account_ude_values KL
         where ude_id = 'INTEREST_RATE'
           and kl.account_number = kk.ACCOUNT_NUMBER
           and effective_date =
               (select max(KL1.effective_date)
                  from cltb_account_ude_values KL1
                 where kl.account_number = kl1.account_number
                   and kl1.ude_id = 'INTEREST_RATE')) INTEREST_RATE,
      (select DECODE(nvl(nj.resident_status, 'R'),'R','Residence','Non-Residence')
        from sttm_cust_personal nj
         where nj.customer_no = cust.customer_no) POLITICAL_NONRESIDENT,
       (select mc.cust_mis_1
          from mitm_customer_default mc
         where mc.customer = cust.customer_no) SECTOR_OF_ACTIVITY
  from cltb_account_master kk, sttm_customer cust, cltb_account_linkages AL
 where kk.CUSTOMER_ID = cust.customer_no
 and cust.customer_category in (select cust_cat from STTM_CUSTOMER_CAT where TRIM(cust_cat_desc) = TRIM(nvl(:PM_CUST_CAT,cust_cat_desc)))
   and kk.BRANCH_CODE = nvl(:PM_BRANCH_CODE,kk.BRANCH_CODE)
   and kk.BOOK_DATE between :PM_FROM_DATE AND :PM_TO_DATE
   and kk.ACCOUNT_NUMBER = al.account_number(+)