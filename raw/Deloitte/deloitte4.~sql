select R.TRN_REF_NO,R.ac_branch,acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,r.MODULE,'TXN',r.TRN_CODE,'ENG',r.AC_NO,r.AC_BRANCH,r.ac_ccy,r.trn_dt,r.LCY_AMOUNT)TXT_TXN_DESC,
       r.TRN_DT,
       r.VALUE_DT,
       r.USER_ID,
       r.AUTH_ID,
       r.AC_CCY,
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
       r.AC_ENTRY_SR_NO,
       r.AC_NO,
       nvl(a.ac_natural_gl,a.ac_gl_no) GL,
       R.MODULE

  from acvw_all_ac_entries R,sttb_account a

 WHERE r.AC_NO = a.ac_gl_no
 and R.TRN_DT BETWEEN '01-JAN-2017' AND '31-JAN-2017';

------- Sums
select count(*), sum(debit), sum(credit) from
(select R.TRN_REF_NO,R.ac_branch,acpks_stmt.fn_get_rtl_narrative_desc(r.TRN_REF_NO,r.MODULE,'TXN',r.TRN_CODE,'ENG',r.AC_NO,r.AC_BRANCH,r.ac_ccy,r.trn_dt,r.LCY_AMOUNT)TXT_TXN_DESC,
       r.TRN_DT,
       r.VALUE_DT,
       r.USER_ID,
       r.AUTH_ID,
       r.AC_CCY,
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
       r.AC_ENTRY_SR_NO,
       r.AC_NO,       nvl(a.ac_natural_gl,a.ac_gl_no) GL,
       R.MODULE

  from acvw_all_ac_entries R,sttb_account a

 WHERE r.AC_NO = a.ac_gl_no
 and R.TRN_DT BETWEEN '01-JAN-2017' AND '31-JAN-2017');

