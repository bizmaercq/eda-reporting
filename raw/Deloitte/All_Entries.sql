-- All accouting entries passed in system for the year
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

SPOOL /home/oracle/SPOOL/Accounting_Entries.spl

SELECT a.AC_ENTRY_SR_NO || '|' ||
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Teller Ref No:' ||
          (SELECT distinct XREF FROM DETB_RTL_TELLER WHERE TRN_REF_NO = a.TRN_REF_NO)
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Debit Customer:' ||
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Payment Details' ||        
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Payment Details ' ||        
          (SELECT DISTINCT CUST_AC_NO
             FROM STTM_CUST_ACCOUNT B
            WHERE B.CUST_AC_NO = A.AC_no
              AND ACCOUNT_CLASS LIKE '5%')      
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Payment Details ' ||        
          (select distinct BB.fft_ins_descr
             from lctb_ffts BB
            where BB.CONTRACT_REF_NO = a.TRN_REF_NO)      
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
                                               A.LCY_AMOUNT) || ' / ' ||
          'Loan Liquidation No ' ||       
          (select DISTINCT schedule_no
             from cltb_account_schedules sc
            where sc.account_number = a.AC_NO
              and a.related_account = account_number)
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
       end || '|'||
       a.TXN_INIT_DATE||'|'||
       a.TRN_DT||'|'||
       a.USER_ID||'|'||
       a.CURRNO||'|'||
       a.AC_NO||'|'||
       case
         when a.DRCR_IND = 'D' then
          a.LCY_AMOUNT
         else
          0
       end||'|'||
       case
         when a.DRCR_IND = 'C' then
          a.LCY_AMOUNT
         else
          0
       end ||'|'||
       a.USER_ID||'|'||
       a.AUTH_ID
  FROM acvw_all_ac_entries a
  WHERE a.TRN_DT between '01/01/2014' and '31/01/2014';
/