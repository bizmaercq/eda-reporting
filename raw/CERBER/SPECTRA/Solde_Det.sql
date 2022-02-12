--customer Gls

SELECT '&Date_Arrete' Dar,
 substr(cust_ac_no,1,3) age,
 cust_ac_no com,
 null cle, ccy_code dev,customer cli,
 GLCODE2 chap,round(CREDIT-DEBIT) sldd,
 CASE 
   WHEN ccy_code ='XAF' THEN round(CREDIT-DEBIT)
   WHEN ccy_code ='EUR' THEN round((CREDIT-DEBIT)* 655.9)
   WHEN ccy_code ='USD' THEN round((CREDIT-DEBIT)* 604)
   WHEN ccy_code ='GBP' THEN round((CREDIT-DEBIT)* 755)
  END sldcv,
  nationality,
  null res,
   CASE 
   WHEN ccy_code ='XAF' THEN  1
   WHEN ccy_code ='EUR' THEN  655.9
   WHEN ccy_code ='USD' THEN  604
   WHEN ccy_code ='GBP' THEN  755
  END  txb,
  round(cr_mov_lcy) cumc,
  round(dr_mov_lcy) cumd,decode (cust_mis_8,'RESIDENT','001','NRCAMER','002','NRCEMAC','003','NRWORLD','004','001') Chl1,
  (select ma.cobac_code from CERBER_MAPPING_SEC_INST_CIF ma WHERE ma.old_code=cust_mis_1 and nvl(ma.account_class,'1') ='1') Chl2,
  (select ma.cobac_code from CERBER_MAPPING_GRP_ACT ma WHERE ma.old_code=cust_mis_3 ) Chl3,country Chl4,
  (select ma.cobac_branch from CERBER_MAPPING_GRP_ACT ma WHERE ma.old_code=cust_mis_3 )Chl5,
  null Chl6,null Chl7,null Chl8,customer_name1 Chl9,address_line1 Chl10,null Chl11,null Chl12,null Chl13,null Chl14,null Chl15,null Chl16,null Chl17,null Chl18,null Chl19,null Chl20,'&Date_Arrete' dcre, '&Date_Arrete' dmod,'SPECTRA' uticre,'SPECTRA' utimod

  FROM
  (
    select code,gl_code GLCODE2,ccy_code,customer,cust_ac_no,nationality,cr_mov_lcy,dr_mov_lcy,cust_mis_8,cust_mis_1,cust_mis_3,customer_name1,address_line1, country,nvl(DEBIT,0) DEBIT,NVL(CREDIT,0) CREDIT,DR_CBC,CR_CBC
    from
       (
         SELECT
         '1' code,
         B.gl_code,
         ccy_code,
         a.customer,
         cust_ac_no,
         nationality,customer_name1,address_line1,cr_mov_lcy,dr_mov_lcy,cust_mis_8,cust_mis_1,cust_mis_3,country,
         CASE WHEN (SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)) < '0' THEN
                   ABS((SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)))
         END DEBIT,
         CASE WHEN (SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)) >= '0' THEN
                   ABS((SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)))
         END CREDIT,
         B.CBANK_LINE_CR CR_CBC,
          B.CBANK_LINE_DR DR_CBC
    FROM
         ( SELECT ab.gl_code,ab.ccy_code,cp.customer_no customer,ab.cust_ac_no,cp.nationality,cp.customer_name1,cp.address_line1,ab.cr_mov_lcy,ab.dr_mov_lcy,mi.cust_mis_8,mi.cust_mis_1,mi.cust_mis_3, cp.country, SUM(Nvl(ab.Cr_Bal_Lcy, 0)) CR_CLOSING_BALANCE ,sum( Nvl(ab.Dr_Bal_Lcy, 0)) DR_CLOSING_BALANCE
            FROM   xafnfc.Gltbs_Gl_Bal gl,xafnfc.gltb_cust_accbreakup ab,xafnfc.sttm_customer cp,xafnfc.mitm_customer_default mi
            WHERE gl.gl_code = ab.gl_code 
            and cp.customer_no = ab.cust_no
            and mi.customer = ab.cust_no
            and Leaf = 'Y'
            and ab.Period_Code ='&PM_PERIOD_CODE'
            AND ab.Fin_Year = '&PM_FINANCIAL_CYCLE'
            AND    (Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND ab.Ccy_Code = 'XAF'))
     group by  Category,cp.customer_no,ab.Period_Code,ab.Fin_Year,ab.gl_code,ab.ccy_code,ab.cust_ac_no,cp.country,cp.nationality,cp.customer_name1,cp.address_line1,ab.cr_mov_lcy,ab.dr_mov_lcy,mi.cust_mis_8,mi.cust_mis_1,mi.cust_mis_3
 ) A , xafnfc.gltm_glmaster b
where a.gl_code(+) =b.gl_code
and b.gl_code in (select distinct t.gl_code from  xafnfc.GLTB_CUST_ACCBREAKUP t WHERE t.fin_year='&PM_FINANCIAL_CYCLE' and t.period_code ='&PM_PERIOD_CODE') 
AND B.LEAF = 'Y'
GROUP BY B.gl_code,b.CBANK_LINE_CR,CBANK_LINE_DR,ccy_code,a.customer,cust_ac_no,country,nationality,customer_name1,address_line1,dr_mov_lcy,cr_mov_lcy,cust_mis_8,cust_mis_1,cust_mis_3)) 

UNION
-- Internal Gls
SELECT '&Date_Arrete' Dar,
 '000' age,
 '0000000'||GLCODE2 com,
 null cle, ccy_code dev,null cli,
 GLCODE2 chap,round(CREDIT-DEBIT) sldd,
 CASE 
   WHEN ccy_code ='XAF' THEN round(CREDIT-DEBIT)
   WHEN ccy_code ='EUR' THEN round((CREDIT-DEBIT)* 655.9)
   WHEN ccy_code ='USD' THEN round((CREDIT-DEBIT)* 604)
   WHEN ccy_code ='GBP' THEN round((CREDIT-DEBIT)* 755)
  END sldcv,
  null nat,
  null res,
  CASE 
   WHEN ccy_code ='XAF' THEN  1
   WHEN ccy_code ='EUR' THEN  655.9
   WHEN ccy_code ='USD' THEN  604
   WHEN ccy_code ='GBP' THEN  755
  END  txb,
  round(cr_mov_lcy) cumc,
  round(dr_mov_lcy) cumd,null Chl1,null Chl2,null Chl3,null Chl4,null Chl5,
  null Chl6,null Chl7,null Chl8,null Chl9,null Chl10,null Chl11,null Chl12,null Chl13,null Chl14,null Chl15,null Chl16,null Chl17,null Chl18,null Chl19,null Chl20,'&Date_Arrete' dcre, '&Date_Arrete' dmod,'SPECTRA' uticre,'SPECTRA' utimod

  FROM
  (
    select code,gl_code GLCODE2,ccy_code,cr_mov_lcy,dr_mov_lcy,nvl(DEBIT,0) DEBIT,NVL(CREDIT,0) CREDIT,DR_CBC,CR_CBC
    from
       (
         SELECT
         '1' code,
         B.gl_code,
         ccy_code,cr_mov_lcy,dr_mov_lcy,
         CASE WHEN (SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)) < '0' THEN
                   ABS((SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)))
         END DEBIT,
         CASE WHEN (SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)) >= '0' THEN
                   ABS((SUM(CR_CLOSING_BALANCE)-SUM(DR_CLOSING_BALANCE)))
         END CREDIT,
         B.CBANK_LINE_CR CR_CBC,
          B.CBANK_LINE_DR DR_CBC
    FROM
         ( SELECT gl.gl_code,gl.ccy_code,gl.cr_mov_lcy,gl.dr_mov_lcy, SUM(Nvl(Cr_Bal_Lcy, 0)) CR_CLOSING_BALANCE , sum( Nvl(Dr_Bal_Lcy, 0)) DR_CLOSING_BALANCE
            FROM   xafnfc.Gltbs_Gl_Bal gl
            WHERE Leaf = 'Y'
            and Period_Code ='&PM_PERIOD_CODE'
            AND Fin_Year = '&PM_FINANCIAL_CYCLE'
            AND    (Category IN ('1', '2','5','6','7','8','9') OR (Category IN ('3', '4') AND Ccy_Code = 'XAF'))
     group by  Category,Period_Code,Fin_Year,gl_code,ccy_code,gl.cr_mov_lcy,gl.dr_mov_lcy
 ) A , xafnfc.gltm_glmaster b
where a.gl_code(+) =b.gl_code
and b.gl_code not in (select distinct t.gl_code from  xafnfc.GLTB_CUST_ACCBREAKUP t WHERE t.fin_year='&PM_FINANCIAL_CYCLE' and t.period_code ='&PM_PERIOD_CODE') 
AND B.LEAF = 'Y'
GROUP BY B.gl_code,b.CBANK_LINE_CR,CBANK_LINE_DR,ccy_code,cr_mov_lcy,dr_mov_lcy)) 

