select '31-JAN-2021' dar, 
r.branch_code age,
r.cust_ac_no,
'01' cle, 
r.ccy_code dev,
m.customer_name1 cli,
substr(r.gl_code,1,5)  chap,
(r.cr_bal_lcy-r.dr_bal_lcy) sldd,
 (r.cr_bal_lcy-r.dr_bal_lcy) sldcv,
 m.nationality nat,
 j.resident_status res,
 '1' txb,
 r.cr_mov_lcy cumc,
 r.dr_mov_lcy cumd,
'chap1' chap1,
'chap2' chap2,
'chap3' chap3,
m.country chap4,
'chap5' chap5,
'chap6' chap6,
'chap7' chap7,
'chap8' chap8,
'chap9' chap9,
'chap10' chap10,
'chap11' chap11,
'chap12' chap12,
'chap13' chap13,
'chap14' chap14,
'chap15' chap15,
'chap16' chap16,
'chap17' chap17,
'chap18' chap18,
'chap19' chap19,
'chap20' chap20,
'31-JAN-2021' dcre,
'31-JAN-2021' dmod,
'CERBER' uticre,
'CERBER' utimod
from gltb_cust_accbreakup r ,sttm_cust_personal j,sttm_customer m
where substr(r.cust_ac_no,9,6)=j.customer_no
and  substr(r.cust_ac_no,9,6)=m.customer_no
and r.fin_year='FY2021'
 and r.period_code='M01'
 and r.gl_code like '37%'
 order by r.branch_code
 




 
 
 
 
 
 
 
 select * from mitm_customer_default j
 
 select * from sttm_cust_personal j
select * from sttm_customer
select * from gltb_cust_accbreakup r

























