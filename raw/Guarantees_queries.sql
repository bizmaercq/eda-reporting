-- Guarantee Periodic fees debited in dormant accounts
SELECT ae.AC_BRANCH,ae.RELATED_CUSTOMER,cu.customer_name1,da.cust_ac_no,da.dormancy_date,ae.TRN_DT, ae.TRN_REF_NO,acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,ae.MODULE,'TXN',ae.TRN_CODE,'ENG',Ae.AC_NO,Ae.AC_BRANCH,ae.ac_ccy,ae.trn_dt,ae.LCY_AMOUNT),ae.DRCR_IND,ae.LCY_AMOUNT 
FROM acvw_all_ac_entries ae, (SELECT ca.cust_ac_no, ca.dormancy_date from sttm_cust_account ca WHERE ca.dormancy_date between '01/01/2018' and '30/06/2019') da, sttm_customer cu
WHERE ae.AC_NO = da.cust_ac_no
and ae.RELATED_CUSTOMER = cu.customer_no
and da.dormancy_date <= ae.TRN_DT
and da.dormancy_date between '01/01/2018' and '30/06/2019'
and ae.TRN_CODE='GPC' and length(ae.ac_no)=16 and ae.TRN_DT between '01/01/2018' and '30/06/2019'
order by ae.AC_BRANCH,ae.AC_NO,ae.TRN_DT
