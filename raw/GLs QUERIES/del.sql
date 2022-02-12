​select R.TRN_REF_NO,

      R.ac_branch,

        case

          when r.module in ('RT') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Teller Ref No:' ||

           (SELECT XREF FROM DETB_RTL_TELLER WHERE TRN_REF_NO = r.TRN_REF_NO)

          when r.module in ('SI') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Debit Customer:' ||

           (SELECT CUSTOMER_NAME1

              FROM STTM_CUSTOMER

             WHERE CUSTOMER_NO =

                   (SELECT distinct SUBSTR(DR_ACCOUNT, 9, 6)

                      FROM Sitb_contract_master

                     WHERE Contract_ref_no = r.TRN_REF_NO))



          when r.module in ('FT') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Payment Details' ||



           (SELECT payment_details1

              FROM FTTB_CONTRACT_MASTER

             WHERE Contract_ref_no = r.TRN_REF_NO)



          when r.module in ('IC') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Payment Details ' ||



           (SELECT CUST_AC_NO

              FROM STTM_CUST_ACCOUNT B

             WHERE B.CUST_AC_NO = r.AC_no

              AND ACCOUNT_CLASS LIKE '5%')



          when r.module in ('LC') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Payment Details ' ||



           (select distinct BB.fft_ins_descr

              from lctb_ffts BB

             where BB.CONTRACT_REF_NO = r.TRN_REF_NO)



          when r.module in ('CL') THEN

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,
                                                r.AC_BRANCH,
                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT) || ' / ' ||

           'Loan Liquidation No ' ||



           (select DISTINCT schedule_no
           

              from cltb_account_schedules sc

             where sc.account_number = r.AC_NO

               and r.related_account = account_number)



        -----------------

          else

           acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,

                                                r.MODULE,

                                                'TXN',

                                                r.TRN_CODE,

                                                'ENG',

                                                r.AC_NO,

                                                r.AC_BRANCH,

                                                r.ac_ccy,

                                                r.trn_dt,

                                                r.LCY_AMOUNT)

        end TXT_TXN_DESC,

        r.TRN_DT,

        r.VALUE_DT,

        r.USER_ID,

        case

          when r.DRCR_IND = 'D' then

           r.LCY_AMOUNT

          else

           0

        end Debit,

        case

          when r.DRCR_IND = 'C' then

           r.LCY_AMOUNT

          else

           0

        end Credit,

        r.AC_NO

   from acvw_all_ac_entries R

 WHERE R.MODULE = 'DE'

    AND R.TRN_DT BETWEEN '01-Jan-2016' AND '31-Dec-2016'

   AND R.AC_No BETWEEN '191001000' AND '193720000'
   
​
