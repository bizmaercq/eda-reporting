select e.* , account_number loan_number
from xafnfc.cltb_account_master d ,
(
(SELECT GL_34.gl_code,GL_34.cust_ac_no,GL_34.ac_desc,GL_34.cust_no,GL_34.acy_avl_bal ,gl_39.BALANCE,GL_34.ACC_STATUS FROM
(select distinct gl_code,t.cust_ac_no,t.ac_desc,t.cust_no,t.acy_avl_bal,t.acc_status from
xafnfc.gltb_cust_acc_breakup e , xafnfc.sttm_cust_account t
where gl_code in ('344501000','345002000','344504000','344503000','344502000','345001000','345003000') 
and period_code = '&Current_Period_code' AND FIN_YEAR = '&Current_Fin_Year'
and e.cust_ac_no = t.cust_ac_no 
union 
select r.ac_no gl_code,t.cust_ac_no,t.ac_desc,t.cust_no,t.acy_avl_bal,t.acc_status from xafnfc.sttm_cust_account t,
(select distinct de.AC_NO, de.RELATED_ACCOUNT,
 (select dr_prod_ac from xafnfc.cltb_account_master where account_number = de.RELATED_ACCOUNT) cust_ac
                             from xafnfc.acvw_all_ac_entries de
                            where ac_no in ('344100000','344300000','345110000','345300000') ) r
where t.cust_ac_no = r.cust_ac ) GL_34, 
(select ac_no,sc.cust_ac_no,sc.ac_desc,SC.CUST_NO,sum(DECODE(drcr_ind , 'D',-LCY_AMOUNT,LCY_AMOUNT)) BALANCE,SC.ACC_STATUS
from xafnfc.acvw_all_ac_entries de , xafnfc.sttm_cust_account sc
where ac_no like '39%' and 
sc.cust_ac_no = substr(instrument_code,1,16)
and period_code = '&Current_Period_code' AND FINANCIAL_CYCLE = '&Current_Fin_Year'
GROUP BY ac_no,sc.cust_ac_no,sc.ac_desc,SC.CUST_NO,SC.ACC_STATUS) gl_39
WHERE GL_34.cust_ac_no  = gl_39.cust_ac_no (+) )
union
(SELECT GL_39.gl_code,GL_39.cust_ac_no,GL_39.ac_desc,GL_39.cust_no,GL_34.acy_avl_bal ,gl_39.BALANCE,GL_39.ACC_STATUS FROM
(select distinct gl_code,t.cust_ac_no,t.ac_desc,t.cust_no,t.acy_avl_bal,t.acc_status from
xafnfc.gltb_cust_acc_breakup e , xafnfc.sttm_cust_account t
where gl_code in ('344501000','345002000','344504000','344503000','344502000','345001000','345003000') 
and period_code = '&Current_Period_code' AND FIN_YEAR = '&Current_Fin_Year'
and e.cust_ac_no = t.cust_ac_no 
union 
select r.ac_no gl_code,t.cust_ac_no,t.ac_desc,t.cust_no,t.acy_avl_bal,t.acc_status from xafnfc.sttm_cust_account t,
(select distinct de.AC_NO, de.RELATED_ACCOUNT,
 (select dr_prod_ac from xafnfc.cltb_account_master where account_number = de.RELATED_ACCOUNT) cust_ac
                             from xafnfc.acvw_all_ac_entries de
                            where ac_no in ('344100000','344300000','345110000','345300000') ) r
where t.cust_ac_no = r.cust_ac ) GL_34, 
(select ac_no gl_code,sc.cust_ac_no,sc.ac_desc,SC.CUST_NO,sum(DECODE(drcr_ind , 'D',-LCY_AMOUNT,LCY_AMOUNT)) BALANCE,SC.ACC_STATUS
FROM xafnfc.acvw_all_ac_entries de , xafnfc.sttm_cust_account sc
where ac_no like '39%' and 
sc.cust_ac_no = substr(instrument_code,1,16)
and period_code = '&Current_Period_code' AND FINANCIAL_CYCLE = '&Current_Fin_Year'
GROUP BY ac_no,sc.cust_ac_no,sc.ac_desc,SC.CUST_NO,SC.ACC_STATUS) gl_39
WHERE GL_34.cust_ac_no(+)  = gl_39.cust_ac_no ) )e
where (dr_prod_ac (+) = e.cust_ac_no)  
 
