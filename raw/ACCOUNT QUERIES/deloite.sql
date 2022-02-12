
------ deloite depot à terme
SELECT ee.branch_code,
      ee.gl_code,
      ee.cust_ac_no,
      aa.ac_desc,
      ee.cr_bal_lcy,
      tt.Date_of_Open,
      tt.TD_Maturity_date,
      tt.Total_interest_Payable,
      tt.Projected_Interest,
      tt.record_stat,
      y.ude_value
 FROM gltb_cust_acc_breakup ee,
      sttm_cust_account     aa,
      tdvw_td_details       tt,
      ictm_acc_udevals      y
where (ee.gl_code like '35%' or ee.gl_code like '36%' or
      ee.gl_code like '37%')
  and ee.fin_year = 'FY2018'
  and ee.period_code = 'M12'
  and ee.cr_bal_lcy <> '0'
  and ee.cust_ac_no = aa.cust_ac_no
  and ee.cust_ac_no = tt.Account_no
  and tt.Account_no = y.acc
  and y.ude_id='INT_RATE'
  ---------gl deloite
  select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb,y.ude_value
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M04'and r.gl_code like '37111%'
---- depot echu avant une periode
SELECT  distinct ee.branch_code,
      ee.gl_code,
      ee.cust_ac_no,
      aa.ac_desc,
      ee.cr_bal_lcy,
      tt.Date_of_Open,
      tt.TD_Maturity_date,
      tt.Total_interest_Payable,
      tt.Projected_Interest,
      tt.record_stat,
      y.ude_value
 FROM gltb_cust_acc_breakup ee,
      sttm_cust_account     aa,
      tdvw_td_details       tt,
      ictm_acc_udevals      y
where ee.gl_code like '54%' 
  and ee.fin_year = 'FY2019'
  --and ee.period_code = 'M06'
  and ee.cr_bal_lcy <> '0'
  and ee.cust_ac_no = aa.cust_ac_no
  and ee.cust_ac_no = tt.Account_no
  and tt.Account_no = y.acc
  and tt.TD_Maturity_date between '01/01/2019' and '30/06/2019'
  and y.ude_id='INT_RATE'
  
  -------autres 
  select distinct q.branch_code,q.gl_code,q.ccy_code,q.dr_bal_lcy,q.cr_bal_lcy,c.TRN_REF_NO,c.TRN_DT
  from gltb_gl_bal q ,acvw_all_ac_entries c
  where q.gl_code=c.AC_NO
 -- and c.RELATED_CUSTOMER=l.cust_no
  and q.gl_code like'63%' 
 -- and c.TRN_DT='26/06/2019'
  and q.fin_year='FY2019' 
  and q.period_code='M06' --and q.dr_bal_lcy<>'0'
and q.leaf='Y' 
and (q.dr_bal_lcy<>'0' or q.cr_bal_lcy<>'0')

----- compte 37400
select q.branch_code,q.gl_code,q.ccy_code,q.dr_bal_lcy,q.cr_bal_lcy
from gltb_gl_bal q
where q.gl_code like'34800%'
and q.fin_year='FY2019'
and q.period_code='M06' --and q.dr_bal_lcy<>'0'
and q.leaf='Y'
and (q.dr_bal_lcy<>'0' or q.cr_bal_lcy<>'0')
order by  q.branch_code
----

select rr.branch_code,rr.gl_code,rr.cust_ac_no,h.ac_desc,rr.dr_bal_lcy DEBIT_BALANCE,rr.cr_bal_lcy CREDIT_BALANCE from gltb_cust_accbreakup rr,sttm_cust_account h
where rr.gl_code like '57%' and rr.fin_year='FY2019' and rr.period_code='M06' and rr.cust_ac_no=h.cust_ac_no
  
--------30800 31800 32800 37800 gl
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.TRN_REF_NO,a.TRN_CODE, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
WHERE a.AC_NO like '31800%'
--WHERE substr(a.AC_NO,1,2) in ('30'/*,'31','32','34','37','38'*/)
--WHERE a.AC_NO = '0241730104811187'
--and a.AC_BRANCH ='022'
and a.TRN_DT <= '30/06/2019';

------gl deloite
select BRANCH,sum(DEBIT),sum(CREDIT) from (
select  a.AC_BRANCH BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a
where substr(a.AC_NO,1,9) like '34%'
--where substr(a.AC_NO,1,9) between '200000000' and '249999999'
and a.TRN_DT  <='30/06/2019' 
order by a.AC_BRANCH,a.trn_dt)
group by BRANCH  ;
