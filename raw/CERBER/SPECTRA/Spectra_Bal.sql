SELECT '31/12/2019' Dar, BRANCH_CODE,GLCODE2 compte,'00' cle,CCY_CODE dev,'999999' client,GLCODE1,DESCRIPTION,
NVL(DR_OPEN,0) sldd,
NVL(DR_OPEN_LCY,0)  sldcvd,
NVL(CR_OPEN,0)  sldc,
NVL(CR_OPEN_LCY,0)  sldcvc,
NVL(DR_MOV,0) cumdd,
NVL(DR_MOV_LCY,0) cumdcdv,
NVL(CR_MOV,0) cumcd,
NVL(CR_MOV_LCY,0)  cumccv,
NVL(DR_CLOSING_BALANCE,0)  slfd,
NVL(DR_CLOSING_BALANCE_LCY,0)  sldfcvd,
NVL(CR_CLOSING_BALANCE,0)  slfc,
NVL(CR_CLOSING_BALANCE_LCY,0)  slfcvc,
1 taux,
'31/12/2019' dcre,
'31/12/2019' dmod,
'FATEKWANA' uticre,
'DKOUNA' utimod --- recalculer pour obtenir CV/DEV
 FROM 
(SELECT '1' CODE,ccy_code,
GLCODE2,
GLCODE1,
BRANCH_CODE,
DESCRIPTION,
CASE
WHEN OPENING_BALANCE < '0' THEN
ABS(NVL(OPENING_BALANCE,0))
END DR_OPEN,
CASE
WHEN OPENING_BALANCE < '0' THEN
ABS(NVL(OPENING_BALANCE,0))
END DR_OPEN_LCY,
CASE
WHEN OPENING_BALANCE >= '0' THEN
ABS(NVL(OPENING_BALANCE,0))
END CR_OPEN,
CASE
WHEN OPENING_BALANCE >= '0' THEN
ABS(NVL(OPENING_BALANCE,0))
END CR_OPEN_LCY,
MOV_BALANCE_dr DR_Mov,
MOV_BALANCE_dr_lcy DR_Mov_lcy,
MOV_BALANCE_cr CR_Mov,
MOV_BALANCE_cr_LCY CR_Mov_LCY,
CASE
WHEN CLOSINGING_BALANCE < '0' THEN
ABS(NVL(CLOSINGING_BALANCE,0))
END DR_CLOSING_BALANCE,
CASE
WHEN CLOSINGING_BALANCE_LCY < '0' THEN
ABS(NVL(CLOSINGING_BALANCE_LCY,0))
END DR_CLOSING_BALANCE_LCY,
CASE
WHEN CLOSINGING_BALANCE >= '0' THEN
ABS(NVL(CLOSINGING_BALANCE,0))
END CR_CLOSING_BALANCE,
CASE
WHEN CLOSINGING_BALANCE_LCY >= '0' THEN
ABS(NVL(CLOSINGING_BALANCE_LCY,0))
END CR_CLOSING_BALANCE_LCY
from
(
select GL_CODE GLCODE2,SUBSTR(GL_CODE,1,5) glcode1,BRANCH_CODE,t.ccy_code,
(SELECT GL_DESC FROM GLTM_GLMASTER WHERE GL_CODE = T.GL_CODE) description,
DECODE(&PM_PRE_CYCLE_CODE,'M04',nvl('',0),(select  (SUM(NVL(CR_BAL_LCY,0)) - SUM(NVL(DR_BAL_LCY,0))) from gltb_gl_bal
 where GL_CODE = T.GL_CODE AND BRANCH_CODE = T.BRANCH_CODE AND PERIOD_CODE = SUBSTR(&PM_PRE_CYCLE_CODE,8,3) AND
FIN_YEAR = SUBSTR(&PM_PRE_CYCLE_CODE,1,6)  
--AND CCY_CODE='XAF' 
and (Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND Ccy_Code = 'XAF'))))  OPENING_BALANCE,
DECODE(&PM_PRE_CYCLE_CODE,'M04',nvl('',0),(select  (SUM(NVL(CR_BAL_LCY,0)) - SUM(NVL(DR_BAL_LCY,0))) from gltb_gl_bal
 where GL_CODE = T.GL_CODE AND BRANCH_CODE = T.BRANCH_CODE AND PERIOD_CODE = SUBSTR(&PM_PRE_CYCLE_CODE,8,3) AND
FIN_YEAR = SUBSTR(&PM_PRE_CYCLE_CODE,1,6)  
--AND CCY_CODE='XAF' 
and (Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND Ccy_Code = 'XAF'))))  OPENING_BALANCE_LCY,
SUM(NVL(Cr_MOV_lcy,0))  MOV_BALANCE_cr,
SUM(NVL(Cr_MOV_lcy,0))  MOV_BALANCE_cr_LCY,
SUM(NVL(dr_MOV_lcy,0))  MOV_BALANCE_dr,
SUM(NVL(dr_MOV_lcy,0))  MOV_BALANCE_dr_LCY,
SUM(NVL(CR_BAL_LCY,0))-SUM(NVL(DR_BAL_LCY,0))  CLOSINGING_BALANCE,  
SUM(NVL(CR_BAL_LCY,0))-SUM(NVL(DR_BAL_LCY,0))  CLOSINGING_BALANCE_LCY  
from gltb_gl_bal T
where 
t.leaf = 'Y' AND
(gl_code BETWEEN NVL(&FROM_GL,GL_CODE) and NVL(&TO_GL,GL_CODE) )and
(Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND Ccy_Code = 'XAF')) and
(branch_code BETWEEN nvl(&FROM_branch,branch_code) and nvl(&TO_branch,branch_code) )and
PERIOD_CODE = SUBSTR(&PM_FINANCIAL_CYCLE_PERIOD,8,3) AND
FIN_YEAR = SUBSTR(&PM_FINANCIAL_CYCLE_PERIOD,1,6)
--PERIOD_CODE = 'M05' AND
--FIN_YEAR = 'FY2012'
group by ccy_code,GL_CODE, BRANCH_CODE,FIN_YEAR , PERIOD_CODE))
ORDER BY GLCODE2, BRANCH_CODE;

----

select distinct  '31/12/2019' dar,aa.bkg_date, ac.branch_code age,ac.cust_ac_no compte,'00' cle,ac.ccy dev,ac.ac_desc, substr(ac.dr_gl,1,5) cha,
case when get_bal_date(ac.cust_ac_no,'01/12/2019') <0 then -nvl(get_bal_date(ac.cust_ac_no,'01/12/2019'),0) end slddd,
  
case when get_bal_lcy_date(ac.cust_ac_no,'01/12/2019') <0 then -nvl(get_bal_lcy_date(ac.cust_ac_no,'01/12/2019'),0) end sldcvdd,

case when get_bal_date(ac.cust_ac_no,'01/12/2019') >0 then nvl(get_bal_date(ac.cust_ac_no,'01/12/2019'),0) end sldcd,
case when get_bal_lcy_date(ac.cust_ac_no,'01/12/2019') >0 then nvl(get_bal_lcy_date(ac.cust_ac_no,'01/12/2019'),0) end sldcvdc,

case when get_bal_date(ac.cust_ac_no,'31/12/2019') <0 then -nvl(get_bal_date(ac.cust_ac_no,'31/12/2019'),0) end sldfd,
case when get_bal_lcy_date(ac.cust_ac_no,'31/12/2019') <0 then -nvl(get_bal_lcy_date(ac.cust_ac_no,'31/12/2019'),0) end sldcvfd,
  
case when get_bal_date(ac.cust_ac_no,'31/12/2019') >0 then nvl(get_bal_date(ac.cust_ac_no,'31/12/2019'),0) end slcfc,
case when get_bal_lcy_date(ac.cust_ac_no,'31/12/2019') >0 then nvl(get_bal_lcy_date(ac.cust_ac_no,'31/12/2019'),0) end sldcvfc,
  (select sum(nvl(ae.fcy_amount,ae.lcy_amount)) from xafnfc.acvw_all_ac_entries ae 
where ae.ac_no=ac.cust_ac_no
and ae.trn_dt between '01/12/2019' and '31/12/2019'
and ae.drcr_ind='D') sumd,
(select sum(ae.lcy_amount) from xafnfc.acvw_all_ac_entries ae 
where ae.ac_no=ac.cust_ac_no
and ae.trn_dt between '01/12/2019' and '31/12/2019'
and ae.drcr_ind='D') sumcvd,
(select sum(nvl(ae.fcy_amount,ae.lcy_amount)) from xafnfc.acvw_all_ac_entries ae 
where ae.ac_no=ac.cust_ac_no
and ae.trn_dt between '01/12/2019' and '31/12/2019'
and ae.drcr_ind='C') sumc,
(select sum(ae.lcy_amount) from xafnfc.acvw_all_ac_entries ae 
where ae.ac_no=ac.cust_ac_no
and ae.trn_dt between '01/12/2019' and '31/12/2019'
and ae.drcr_ind='C') sumcvc,
  1 taux,
'31/12/2019' dcre,
'31/12/2019' dmod,
'FATEKWANA' uticre,
'DKOUNA' utimod 
from
xafnfc.actb_accbal_history aa , xafnfc.sttm_cust_account ac
where aa.account = ac.cust_ac_no 
and aa.bkg_date between '01/12/2019' and '31/12/2019'

------fichier client 
select distinct ll.branch_code age,ll.cust_ac_no,hh.last_name nom ,hh.first_name prenom,'SIGLE' "sig",nvl(hh.last_name,regexp_substr(hh.last_name,'[^ ]+',1)) rso,ll.ac_desc nomc,
c.customer_type typ,'pppp' nper,'prpr' prper,'mmmm' nmer,'merme' prmer,hh.date_of_birth dnai,rpad(nvl(c.udf_2,' '),50,' ') lnai,c.unique_id_name typpie,c.unique_id_value numpie,
 hh.ppt_iss_date ddel,hh.d_address1 ldel,hh.ppt_exp_date dexp,'contribuable' ncc ,'ffff' nrc,'nnn' dnrc,'S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3)  sec,
substr(m.cust_mis_1,1,3) catn,'S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3) naema,hh.resident_status res,
 hh.p_country nat,hh.mobile_number tel1,'tel' tel2,'tel3' tel3,'tttt' tel4,'trt' tel5,'rere' tel6,hh.fax fax1,'Fax 2' Fax2,'fff' Fax3,
'dsds' Fax4,'xcxc' Fax5,'zaza' Fax6,'adr1' adr1,'adr1' adr2,'dfdf' adr3,'adr14' adr4,'adr16' adr5,
'adr16' adr6,hh.e_mail email1,'email2' email2,'email1' email3,'chl1' chl1,'chl2' chl2,'chl13' chl3,'chl14' chl4,'chl15' chl5,'chl16' chl6,
'chl17' chl7,'chl8' chl8,'chl19' chl9,'chl10' chl10,ll.ac_open_date dcre,trunc(ll.maker_dt_stamp) dmod,ll.maker_id uticre,ll.maker_id  utimod
 from sttm_cust_account ll, sttm_cust_personal hh,sttm_customer c,mitm_customer_default m,sttm_cust_professional pr,CSTM_FUNCTION_USERDEF_FIELDS ud ,sttm_country_isocodes i
where ll.cust_no=hh.customer_no
and c.customer_no = m.customer
and c.customer_no = hh.customer_no
and c.customer_no = pr.customer_no
and c.customer_no = substr(ud.rec_key,1,6)
and c.country = i.iso2_code
union
select distinct ll.branch_code age,ll.cust_ac_no,hh.last_name nom ,hh.first_name prenom,'SIGLE' "sig",nvl(hh.last_name,regexp_substr(hh.last_name,'[^ ]+',1)) rso,ll.ac_desc nomc,
c.customer_type typ,'pppp' nper,'prpr' prper,'mmmm' nmer,'merme' prmer,hh.date_of_birth dnai,rpad(nvl(c.udf_2,' '),50,' ') lnai,c.unique_id_name typpie,c.unique_id_value numpie,
 hh.ppt_iss_date ddel,hh.d_address1 ldel,hh.ppt_exp_date dexp,'contribuable' ncc ,'ffff' nrc,'nnn' dnrc,'S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3)  sec,
substr(m.cust_mis_1,1,3) catn,'S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3) naema,hh.resident_status res,
 hh.p_country nat,hh.mobile_number tel1,'tel' tel2,'tel3' tel3,'tttt' tel4,'trt' tel5,'rere' tel6,hh.fax fax1,'Fax 2' Fax2,'fff' Fax3,
'dsds' Fax4,'xcxc' Fax5,'zaza' Fax6,'adr1' adr1,'adr1' adr2,'dfdf' adr3,'adr14' adr4,'adr16' adr5,
'adr16' adr6,hh.e_mail email1,'email2' email2,'email1' email3,'chl1' chl1,'chl2' chl2,'chl13' chl3,'chl14' chl4,'chl15' chl5,'chl16' chl6,
'chl17' chl7,'chl8' chl8,'chl19' chl9,'chl10' chl10,ll.ac_open_date dcre,trunc(ll.maker_dt_stamp) dmod,ll.maker_id uticre,ll.maker_id  utimod
 from sttm_cust_account ll, sttm_cust_personal hh,sttm_customer c,mitm_customer_default m,sttm_cust_corporate pr,CSTM_FUNCTION_USERDEF_FIELDS ud ,sttm_country_isocodes i
where ll.cust_no=hh.customer_no
and c.customer_no = m.customer
and c.customer_no = hh.customer_no
and c.customer_no = pr.customer_no
and c.customer_no = substr(ud.rec_key,1,6)
and c.country = i.iso2_code





















