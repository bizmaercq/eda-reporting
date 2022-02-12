select '31-JAN-2021' dar, 
'00010' age, 
cb.glcode  com,
'01' cle,
'XAF' dev,
'999999' cli,
cb.glcode_5_digit chap,
(cb.cr_open - cb.dr_open) sldd,
(cb.cr_open - cb.dr_open) sldcvd,
cb.cr_mov cumcd,
cb.cr_mov cumccv,
cb.dr_mov cumdd,
cb.dr_mov cumdcv,
(cb.cr_end_balance - cb.dr_end_balance) sldf,
(cb.cr_end_balance - cb.dr_end_balance) sldcvf,
1 txb,
'31-JAN-2021' dcre,
'31-JAN-2021' dmod,
'CERBER' uticre,
'CERBER' utimod
from cerber_bal cb 
WHERE cb.glcode not in ('475001000','475002000','475005000','475007000','560422000','560411000')
union
select
 '31-JAN-2021' dar, 
'00010' age, 
gb.gl_code  com,
'01' cle,
gb.ccy_code dev,
'999999' cli,
substr(gb.gl_code,1,5) chap,
sum((gb.open_cr_bal-gb.open_dr_bal)) sldd,
sum((gb.open_cr_bal_lcy-gb.open_dr_bal_lcy)) sldcvd,
sum(gb.cr_mov) cumcd,
sum(gb.cr_mov_lcy) cumccv,
sum(gb.dr_mov) cumdd,
sum(gb.dr_mov_lcy) cumdcv,
(sum(gb.cr_bal-gb.dr_bal)) sldf,
sum((gb.cr_bal_lcy-gb.dr_bal_lcy)) sldcvf,
round(max((gb.cr_bal_lcy-gb.dr_bal_lcy)/(gb.cr_bal-gb.dr_bal))) txb,
'31-JAN-2021' dcre,
'31-JAN-2021' dmod,
'CERBER' uticre,
'CERBER' utimod
from xafnfc.gltb_gl_bal gb 
WHERE gb.gl_code  in ('475001000','475002000','475005000','475007000','560422000','560411000')
and (gb.cr_bal-gb.dr_bal)<>0
and  gb.fin_year ='FY2021' and gb.period_code='M01'
group by gb.gl_code ,gb.ccy_code ;

