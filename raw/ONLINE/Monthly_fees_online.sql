SELECT AC_BRANCH,RELATED_CUSTOMER,customer_name1,AC_NO, sum(AUG_2018) AUG_2018, sum(SEP_2018) SEP_2018, sum(OCT_2018) OCT_2018, sum(NOV_2018) NOV_2018, sum(DEC_2018) DEC_2018, sum(JAN_2019) JAN_2019, sum(FEB_2019) FEB_2019
from
(SELECT distinct ae.AC_BRANCH,ae.RELATED_CUSTOMER,cu.customer_name1,ae.AC_NO,
case when to_char(ae.TRN_DT,'MON-RRRR') ='AUG-2018' then ae.LCY_AMOUNT else 0 end AUG_2018, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='SEP-2018' then ae.LCY_AMOUNT else 0 end SEP_2018, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='OCT-2018' then ae.LCY_AMOUNT else 0 end OCT_2018, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='NOV-2018' then ae.LCY_AMOUNT else 0 end NOV_2018, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='DEC-2018' then ae.LCY_AMOUNT else 0 end DEC_2018, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='JAN-2019' then ae.LCY_AMOUNT else 0 end JAN_2019, 
case when to_char(ae.TRN_DT,'MON-RRRR') ='FEB-2019' then ae.LCY_AMOUNT else 0 end FEB_2019 
FROM acvw_all_ac_entries ae, sttm_customer cu ,TEK_CORPORATE_USER@online_link ol
WHERE cu.customer_no = ae.RELATED_CUSTOMER
and ae.TRN_CODE ='IBS'
and ae.AC_NO <> '728402000'
and ae.RELATED_CUSTOMER in (SELECT distinct  cu.cif_id FROM TEK_CORPORATE_USER@online_link cu, sttm_customer sc
WHERE cu.cif_id = sc.customer_no)
)
group by  AC_BRANCH,RELATED_CUSTOMER,customer_name1,AC_NO
