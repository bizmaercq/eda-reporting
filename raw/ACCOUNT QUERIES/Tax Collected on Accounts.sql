SELECT a.TRN_DT, a.TRN_REF_NO,a.AC_NO,
case
           when a.module in ('RT') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Teller Ref No:' ||
            (SELECT distinct XREF
               FROM DETB_RTL_TELLER
              WHERE TRN_REF_NO = a.TRN_REF_NO)
           when a.module in ('SI') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Debit Customer:' ||
            (SELECT distinct CUSTOMER_NAME1
               FROM STTM_CUSTOMER
              WHERE CUSTOMER_NO =
                    (SELECT distinct SUBSTR(DR_ACCOUNT, 9, 6)
                       FROM Sitb_contract_master
                      WHERE Contract_ref_no = a.TRN_REF_NO))
                      
                      
                      when a.module in ('FT') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Payment Details' ||
          
                      
                      (SELECT distinct payment_details1
                       FROM FTTB_CONTRACT_MASTER
                      WHERE Contract_ref_no = a.TRN_REF_NO)
                      
                      
                       
                      when a.module in ('IC') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Payment Details ' ||
                                
                      (SELECT  distinct CUST_AC_NO
                       FROM STTM_CUST_ACCOUNT B
                      WHERE  B.CUST_AC_NO = A.AC_no AND ACCOUNT_CLASS LIKE   '5%')
                      
                      
                                            
                      when a.module in ('LC') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Payment Details ' ||
                               
                      (select  distinct BB.fft_ins_descr from lctb_ffts BB where BB.CONTRACT_REF_NO=a.TRN_REF_NO)
                      
                      
                      
                                            
                      when a.module in ('CL') THEN
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT) ||
            ' / ' || 'Loan Liquidation No '||
                               
                      (select DISTINCT schedule_no from cltb_account_schedules where account_number = a.AC_NO
                      and  a.related_account = account_number)
                      
                      -----------------
           else
            acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,
                                                 a.MODULE,
                                                 'TXN',
                                                 a.TRN_CODE,
                                                 'ENG',
                                                 A.AC_NO,
                                                 A.AC_BRANCH,
                                                 a.ac_ccy,
                                                 a.trn_dt,
                                                 A.LCY_AMOUNT)
         end TXT_TXN_DESC ,a.DRCR_IND,a.LCY_AMOUNT
FROM acvw_all_ac_entries a 
WHERE a.ac_no ='0231720101523727' and a.trn_code ='TAX' 
and a.trn_dt between '01/05/2012' and '30/04/2015';