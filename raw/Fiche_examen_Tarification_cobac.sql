create table Cobac_Tarif as
select '10025' Q1, c.customer_name1 Q2,nvl(m.original_st_date,m.BOOK_DATE) Q3,decode(a.account_class ,'281',1,'282',1,'173',3,2) Q4,
p.product_desc Q5,decode(t.cust_mis_3,'GRP999','93.0',t.cust_mis_3) Q6,
c.loc_code Q7,a.lcy_mtd_tover_cr Q8,c.udf_4 Q9 ,
m.AMOUNT_FINANCED Q10,m.NO_OF_INSTALLMENTS Q11,' ' Q12,u.ude_value/100 Q13,
u1.ude_value+u2.ude_value Q14,' ' Q15,
0 Q16, 1 Q17, s.emi_amount Q18, 1 Q19, decode(m.FREQUENCY_UNIT,'M',1,'Q',2,3) Q20, 
decode (m.USER_DEFINED_STATUS ,'SUBS',2,'NORM',1,'DOC1',4,'CURR',2,'DON3',4,'DON1',4,1) Q21
from cltb_account_comp_bal_breakup b, cltb_account_master m, sttm_customer c, sttm_cust_account a, cltm_product p,mitm_customer_default t,
cltb_account_ude_values u,cltb_account_ude_values u1,cltb_account_ude_values u2 , CLTB_ACCOUNT_COMP_SCH s
where b.account_number = m.ACCOUNT_NUMBER
and m.CUSTOMER_ID = c.customer_no
and m.DR_PROD_AC = a.cust_ac_no
and m.PRODUCT_CODE = p.product_code
and m.CUSTOMER_ID = t.customer
and u.account_number = m.ACCOUNT_NUMBER
and u1.account_number = m.ACCOUNT_NUMBER
and u2.account_number = m.ACCOUNT_NUMBER
and s.account_number = m.ACCOUNT_NUMBER
and a.account_class <> '281'
and u.ude_id ='INTEREST_RATE'
and u1.ude_id ='AMND_CHRG'
and u2.ude_id ='DOCU_FEE_AMT'
and b.component ='PRINCIPAL'
and s.emi_amount <> 0
and nvl(m.original_st_date,m.BOOK_DATE) between '01/01/2011' and '31/12/2012'
and b.lcy_balance <>0;
