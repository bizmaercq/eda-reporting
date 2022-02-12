SELECT ae.TRN_REF_NO "ID Transaction" ,acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,
                                                   ae.MODULE,
                                                   'TXN',
                                                   ae.TRN_CODE,
                                                   'ENG',
                                                   Ae.AC_NO,
                                                   Ae.AC_BRANCH,
                                                   ae.ac_ccy,
                                                   ae.trn_dt,
                                                   Ae.LCY_AMOUNT) "Description"
           , ae.TRN_DT "date de la transaction",ae.VALUE_DT "Date de valeur",ae.USER_ID,
           ae.AC_ENTRY_SR_NO "Ligne journal",ae.AC_NO "Compte grand-livre",
           case when ae.DRCR_IND ='D' then ae.LCY_AMOUNT end "DEBIT" ,
           case when ae.DRCR_IND ='C' then ae.LCY_AMOUNT end "CREDIT" ,ae.USER_ID,ae.AUTH_ID, ae.MODULE
           FROM acvw_all_ac_entries ae WHERE /* ae.module ='DE'  AND */ ae.trn_DT between '01/05/2016' and '31/05/2016';