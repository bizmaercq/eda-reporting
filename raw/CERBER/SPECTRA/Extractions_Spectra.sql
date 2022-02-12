---- Building the Account Trial Balance
truncate table account_trial_balance;
insert into account_trial_balance
select  '31/12/2019' dar, ac.branch_code age,ac.cust_ac_no compte,'00' cle,ac.ccy dev,ac.ac_desc client, substr(ac.dr_gl,1,5) cha,
0 slddd,
0 sldcvdd,
0 sldcd,
0 sldcvcd,
(select nvl(sum(ah.acy_dr_tur),0) from actb_accbal_history ah WHERE ah.account = ac.cust_ac_no)  sumd,
(select nvl(sum(ah.lcy_dr_tur),0) from actb_accbal_history ah WHERE ah.account = ac.cust_ac_no)  sumcvd,
(select nvl(sum(ah.acy_cr_tur),0) from actb_accbal_history ah WHERE ah.account = ac.cust_ac_no)  sumc,
(select nvl(sum(ah.lcy_cr_tur),0) from actb_accbal_history ah WHERE ah.account = ac.cust_ac_no)  sumcvc,
0 sldfd,
0 sldcvfd,
0 sldfc,
0 sldcvfc
from
xafnfc. sttm_cust_account ac;
insert into account_trial_balance
select  '31/12/2019' dar, ac.branch_code age,ac.cust_ac_no compte,'00' cle,ac.ccy dev,ac.ac_desc client, substr(ac.dr_gl,1,5) cha,
case when aa.acy_closing_bal <0 then -nvl(aa.lcy_opening_bal,0) end slddd,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_opening_bal,0) end sldcvdd,
case when aa.acy_closing_bal >0 then nvl(aa.lcy_opening_bal,0) end sldcd,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_opening_bal,0) end sldccvd,
0  sumd,
0  sumcvd,
0  sumc,
0  sumcvc,
0 sldfd,
0 sldcvfd,
0 sldfc,
0 sldcvfc
from
xafnfc.actb_accbal_history aa ,xafnfc. sttm_cust_account ac
where aa.account = ac.cust_ac_no
and aa.bkg_date = (select max(a.bkg_date) from xafnfc.actb_accbal_history a
                   where a.bkg_date <= '01/12/2019'
                   and a.account = aa.account);
                   
insert into account_trial_balance
select  '31/12/2019' dar, ac.branch_code age,ac.cust_ac_no compte,'00' cle,ac.ccy dev,ac.ac_desc client, substr(ac.dr_gl,1,5) cha,
0 slddd,
0 sldcvdd,
0 sldcd,
0 sldccvd,
0 sumd,
0  sumcvd,
0  sumc,
0  sumcvc,
case when aa.acy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end sldfd,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end sldcvfd,
case when aa.acy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end  sldfc,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end  sldcvfc
from
xafnfc.actb_accbal_history aa ,xafnfc. sttm_cust_account ac
where aa.account = ac.cust_ac_no
and aa.bkg_date = (select max(a.bkg_date) from xafnfc.actb_accbal_history a
                   where a.bkg_date <= '31/12/2019'
                   and a.account = aa.account);



--- GLs Trial Balance
SELECT '31/12/2019' Dar, BRANCH_CODE age,GLCODE2 compte,'00' cle,CCY_CODE dev,'999999' client,GLCODE1 cha,
NVL(CR_OPEN,0)  - NVL(DR_OPEN,0) sldd,
NVL(CR_OPEN_LCY,0) -NVL(DR_OPEN_LCY,0)  sldcvd,
NVL(DR_MOV,0) cumdd,
NVL(DR_MOV_LCY,0) cumcvd,
NVL(CR_MOV,0) cumcd,
NVL(CR_MOV_LCY,0)  cumccv,
NVL(CR_CLOSING_BALANCE,0) - NVL(DR_CLOSING_BALANCE,0)  sldf,
NVL(CR_CLOSING_BALANCE_LCY,0) -NVL(DR_CLOSING_BALANCE_LCY,0)  sldcvf,
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
(SELECT GL_DESC FROM xafnfc.GLTM_GLMASTER WHERE GL_CODE = T.GL_CODE) description,
DECODE(&PM_PRE_CYCLE_CODE,'M04',nvl('',0),(select  (SUM(NVL(CR_BAL_LCY,0)) - SUM(NVL(DR_BAL_LCY,0))) from xafnfc.gltb_gl_bal
 where GL_CODE = T.GL_CODE AND BRANCH_CODE = T.BRANCH_CODE AND PERIOD_CODE = SUBSTR(&PM_PRE_CYCLE_CODE,8,3) AND
FIN_YEAR = SUBSTR(&PM_PRE_CYCLE_CODE,1,6)  
--AND CCY_CODE='XAF' 
and (Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND Ccy_Code = 'XAF'))))  OPENING_BALANCE,
DECODE(&PM_PRE_CYCLE_CODE,'M04',nvl('',0),(select  (SUM(NVL(CR_BAL_LCY,0)) - SUM(NVL(DR_BAL_LCY,0))) from xafnfc.gltb_gl_bal
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
from xafnfc.gltb_gl_bal T
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

UNION
-- Balance des comptes clientèles                   
SELECT tb.dar,tb.age,tb.compte,tb.cle,tb.dev,tb.ac_desc client,tb.cha,
sum(tb.sldcd)-sum(tb.slddd) sldd,
sum(tb.sldcvcd) -sum(tb.sldcvdd) sldcvd,
sum(tb.sumd) cumdd,
sum(tb.sumcvd) cumcvd,
sum(tb.sumc) cumcd,
sum(tb.sumcvc) cumccv,
sum(tb.sldfc)-sum(tb.sldfd) sldf,
sum(tb.sldcvfc)-sum(tb.sldcvfd) sldcvf,
1 txb,
'31/12/2019' dcre,
'31/12/2019' dmod,
'FATEKWANA' uticre,
'FATEKWANA' utimod
FROM account_trial_balance tb
group by tb.dar,tb.age,tb.compte,tb.cle,tb.dev,tb.ac_desc,tb.cha;


--- Balance des Comptes avec Attributs d'identification
select ac.branch_code Age,ac.cust_ac_no com,'00' cle,
ac.ccy dev,
cu.customer_name1 cli,
substr(ac.dr_gl,1,5)	cha,
aa.acy_closing_bal sldd,
aa.lcy_closing_bal sldcv,
cu.nationality nat,
decode(cd.cust_mis_8,'RESIDENT','1','NRCAMER','2','NRCEMAC','3','NRWORLD','4','1') res,
1 txb,
ac.acy_mtd_tover_cr cumc,
ac.acy_mtd_tover_dr cumd,
null chl1,
(select si.cobac_code from cerber_mapping_sec_inst_cif si WHERE si.old_code= cd.cust_mis_1) chl2,
(select ga.cobac_code from cerber_mapping_grp_act ga where ga.old_code =cd.cust_mis_3 ) chl3,
null chl4,
null chl5,
null chl6,
null chl7,
null chl8,
null chl9,
null chl10,
null chl11,
null chl12,
null chl13,
null chl14,
null chl15,
null chl16,
null chl17,
null chl18,
null chl19,
null chl20,
'31/12/2019' dcre,
'31/12/2019' dmod,
'FATEKWANA' uticre,
'FATEKWANA' utimod
from
xafnfc.actb_accbal_history aa ,xafnfc. sttm_cust_account ac, xafnfc. sttm_customer cu,  xafnfc.mitm_customer_default cd
where aa.account = ac.cust_ac_no
and cu.customer_no=cd.customer
and ac.cust_no =cu.customer_no
and aa.bkg_date = (select max(a.bkg_date) from xafnfc.actb_accbal_history a
                   where a.bkg_date <= '31/12/2019'
                   and a.account = aa.account);

