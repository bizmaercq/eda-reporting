select customer_account ,SUM(GL_711001000),SUM(GL_712001000),SUM(GL_712004100),SUM(GL_713001000),SUM(GL_713004100),SUM(GL_714001000),SUM(GL_717003000),SUM(GL_717004000),SUM(GL_717006100),SUM(GL_719001000),SUM(GL_719002000),SUM(GL_719003000),SUM(GL_719006000),
SUM(GL_720101000),
SUM(GL_721001000),
SUM(GL_721003000),
SUM(GL_728301000),
SUM(GL_728340000),
SUM(GL_728402000),
SUM(GL_729001000),
SUM(GL_729001100),
SUM(GL_729001200),
SUM(GL_729001500),
SUM(GL_729002000),
SUM(GL_729006000),
SUM(GL_729006400),
SUM(GL_729009300) from
(
select ACCOUNT_COSTOMER customer_account,
case when GL = '711001000' then sum(SOLDE) else 0 end GL_711001000,
case when GL = '712001000' then sum(SOLDE) else 0 end GL_712001000,
case when GL = '712004100' then sum(SOLDE) else 0 end GL_712004100,
case when GL = '713001000' then sum(SOLDE) else 0 end GL_713001000,
case when GL = '713004100' then sum(SOLDE) else 0 end GL_713004100,
case when GL = '714001000' then sum(SOLDE) else 0 end GL_714001000,
case when GL = '717003000' then sum(SOLDE) else 0 end GL_717003000, 
case when GL = '717004000' then sum(SOLDE) else 0 end GL_717004000,
case when GL = '717006100' then sum(SOLDE) else 0 end GL_717006100, 
case when GL = '719001000' then sum(SOLDE) else 0 end GL_719001000,
case when GL = '719002000' then sum(SOLDE) else 0 end GL_719002000,
case when GL = '719003000' then sum(SOLDE) else 0 end GL_719003000,
case when GL = '719006000' then sum(SOLDE) else 0 end GL_719006000,
case when GL = '720101000' then sum(SOLDE) else 0 end GL_720101000,
case when GL = '721001000' then sum(SOLDE) else 0 end GL_721001000,
case when GL = '721003000' then sum(SOLDE) else 0 end GL_721003000,
case when GL = '728301000' then sum(SOLDE) else 0 end GL_728301000,
case when GL = '728340000' then sum(SOLDE) else 0 end GL_728340000,
case when GL = '728402000' then sum(SOLDE) else 0 end GL_728402000,
case when GL = '729001000' then sum(SOLDE) else 0 end GL_729001000,
case when GL = '729001100' then sum(SOLDE) else 0 end GL_729001100,
case when GL = '729001200' then sum(SOLDE) else 0 end GL_729001200,
case when GL = '729001500' then sum(SOLDE) else 0 end GL_729001500,
case when GL = '729002000' then sum(SOLDE) else 0 end GL_729002000,
case when GL = '729006000' then sum(SOLDE) else 0 end GL_729006000,
case when GL = '729006400' then sum(SOLDE) else 0 end GL_729006400,
case when GL = '729009300' then sum(SOLDE) else 0 end GL_729009300  
from(
select  a.AC_BRANCH BRANCH, a.AC_NO GL,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,a.LCY_AMOUNT SOLDE,a.RELATED_ACCOUNT ACCOUNT_COSTOMER--case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a,sttm_cust_account l
where a.RELATED_CUSTOMER=l.cust_no
and l.record_stat='O'
and  substr(a.AC_NO,1,9) in 
('711001000',
'712001000',
'712004100',
'713001000',
'713004100',
'714001000',
'717003000',
'717004000',
'717006100',
'719001000',
'719002000',
'719003000',
'719006000',
'720101000',
'721001000',
'721003000',
'728301000',
'728340000',
'728402000',
'729001000',
'729001100',
'729001200',
'729001500',
'729002000',
'729006000',
'729006400',
'729009300') 
and substr (a.RELATED_ACCOUNT,4,3) in ('282','285')
and a.TRN_DT between '01/01/2017'  and  '31/12/2017')
group by ACCOUNT_COSTOMER,GL)
group by customer_account 


































