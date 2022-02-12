select dh.branch_code,ac.cust_ac_no FLEX_AC_NO,ac.alt_ac_no DELTA_AC_NO,ac.ac_desc FLEX_AC_DESC,dh.instrument_no DELTA_CUST_NO, dh.amount,dh.addl_text 
from detb_upload_detail_history dh, sttm_cust_account ac
where substr(ac.alt_ac_no,11,6) = dh.instrument_no
and addl_text ='CONVERSION DAY GL BAL'
and account ='374001000'
and dh.amount >50000
order by branch_code asc,dh.amount desc
