SELECT GL_CODE,BRANCH_CODE,CUST_AC_NO,AC_DESC,CUST_NO,director_name,business_description,secteur,period_code,FIN_YEAR,
(CR_CLOSE_BAL-DR_CLOSE_BAL+DR_MOV_BAL-CR_MOV_BAL) OPEN_BAL,DR_MOV_BAL ,CR_MOV_BAL ,
CR_CLOSE_BAL-DR_CLOSE_BAL CLOSE_BAL,"Provision_Amount"
FROM 
(select GL_CODE,SC.BRANCH_CODE,SC.CUST_AC_NO,SC.AC_DESC,SC.CUST_NO,cd.director_name,cc.business_description ,
(select CODE_DESC from xafnfc.gltm_mis_code where mis_code = (select cust_mis_1 from xafnfc.mitm_customer_default where customer =Sc.cust_no) ) SECTEUR,
period_code,FIN_YEAR,
SUM(CR_MOV_LCY) CR_MOV_BAL,SUM(DR_MOV_LCY) DR_MOV_BAL,SUM(DR_BAL_LCY) DR_CLOSE_BAL,
SUM(CR_BAL_LCY) CR_CLOSE_BAL,Nvl((Select Sum(Decode(a.Drcr_Ind, 'D', Nvl(-a.Lcy_Amount, 0), Nvl(a.Lcy_Amount, 0)))
                   From   Tb_Provisions a
                   Where  a.Cust_No = Sc.Cust_No
                   And    (a.Instrument_Code||A.LCY_AMOUNT) In
                          (Select (De.Instrument_No||DE.AMOUNT)
                            From   Detb_Upload_Detail_History De
                            Where  De.Batch_No = '3936'
                            And    De.Fin_Cycle >= 'FY2014'
                            And    De.Instrument_No = a.Instrument_Code
                            And    De.Addl_Text Like 'Provision for%'
                            And    De.Addl_Text Not Like 'Provision for Loan%')
                   Group  By Cust_No)
                  ,0) As "Provision_Amount"
from gltb_cust_acc_breakup GC , STTM_CUST_ACCOUNT SC,sttm_corp_directors CD,sttm_cust_corporate cc
where sc.cust_no = cd.customer_no(+)
and sc.cust_no = cc.customer_no(+)
and GC.CUST_AC_NO = SC.CUST_AC_NO AND
(gl_code like '34%' or gl_code in ('583001000','583011000')) and period_code = 'M11' AND FIN_YEAR = 'FY2017'
GROUP BY GL_CODE,SC.BRANCH_CODE,SC.CUST_AC_NO,SC.AC_DESC,SC.CUST_NO,cd.director_name,cc.business_description,period_code,FIN_YEAR)
ORDER BY GL_CODE,BRANCH_CODE
