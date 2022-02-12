accept FINANCIAL_CYCLE PROMPT 'Enter the Current FINANCIAL_CYCLE >'
accept REPORT_PERIOD_CODE  PROMPT 'Enter the Current REPORT_PERIOD_CODE >'
accept REPORT_PERIOD_END_DT  PROMPT 'Enter the Current REPORT_PERIOD_END_DT (Ex: 31-MAY-2012) >'
set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on

Declare

  cursor c1 is
  
    select
    
     ac_no,
     AC_DESC,
     gl_code1,
     gl_code2,
     gl_int,
     cbf,
     RESIDENCE,
     INSTITUTIONAL_UNIT,
     GEOGRAPHICAL_LOCATION,
     ECONOMIC_ACTIVITY,
     drcr_ind,
     debit,
     credit,
     PLACEMENT_DATE,
     MATURITY_DATE,
     cif_no,
     branch,
     AC_CCY,
     rate,
     amount,
     CB_SPECIFIC_CLIENT,
     LINE,
     cust_gl,
     category,
     Loc_code,
     CUSTOMER_CAT,
     MODULE,
     FINANCIAL_CYCLE,
     PERIODIC_CODE,
     gl_opening_balance,
     gl_closing_balance,
     IB,
     TRN_DT
    
      from (select ac_no,
                   ac_desc,
                   substr(gl_code2, 1, 5) gl_code1,
                   gl_code2,
                   case
                     when substr(gl_code2, 1, 2) in
                         
                          ('68', '66', '25') then
                      substr(gl_code2, 1, 2)
                     when substr(gl_code2, 1, 2) in
                          ('20',
                           '19',
                           '28',
                           '69',
                           
                           '93',
                           '98',
                           '99') then
                      substr(gl_code2, 1, 4)
                     when substr(gl_code2, 1, 3) in
                          ('321',
                           '344',
                           '345',
                           '471',
                           '472',
                           '611',
                           '623',
                           '644',
                           '651',
                           '791') then
                      substr(gl_code2, 1, 4)
                     else
                      substr(gl_code2, 1, 3)
                   end gl_int,
                   case
                     when AMOUNT < 0 then
                      (select distinct sd.cbank_line_dr
                         from xafnfc.gltm_glmaster sd
                        where sd.gl_code = gl_code2)
                     else
                      (select distinct sd.cbank_line_cr
                         from xafnfc.gltm_glmaster sd
                        where sd.gl_code = gl_code2)
                   end cbf,
                   RESIDENCE,
                   case
                     when AMOUNT < 0 then
                      'D'
                     else
                      'C'
                   end drcr_ind,
                   '' INSTITUTIONAL_UNIT,
                   '' GEOGRAPHICAL_LOCATION,
                   ECONOMIC_ACTIVITY,
                   PLACEMENT_DATE,
                   MATURITY_DATE,
                   '' Line,
                   '' gl_opening_balance,
                   '' gl_closing_balance,
                   '' Debit,
                   '' Credit,
                   CIF_NO,
                   Loc_code,
                   branch,
                   ac_CCY,
                   RATE,
                   amount,
                   CB_SPECIFIC_CLIENT,
                   cust_gl,
                   (select category from xafnfc.gltm_glmaster where gl_code = gl_code2) category,
                   CUSTOMER_CAT,
                   MODULE,
                   '' FINANCIAL_CYCLE,
                   '' PERIODIC_CODE,
                   IB,
                   '' TRN_DT
              from (select ac_no,
                           ac_desc,
                           RESIDENCE,
                           ECONOMIC_ACTIVITY,
                           PLACEMENT_DATE,
                           MATURITY_DATE,
                           decode(cust_gl,
                                  'A',
                                  decode
                                  
                                  (substr(amount, 1, 1),
                                   '-',
                                   
                                   (select sc.dr_gl
                                    
                                      from xafnfc.sttm_cust_account sc
                                    
                                     where sc.cust_ac_no = ac_no),
                                   
                                   (select sc.cr_gl
                                    
                                      from xafnfc.sttm_cust_account sc
                                    
                                     where sc.cust_ac_no = ac_no)),
                                  ac_no)
                           
                           gl_code2,
                           CB_SPECIFIC_CLIENT,
                           CIF_NO,
                           branch,
                           ac_ccy,
                           RATE,
                           AMOUNT,
                           cust_gl,
                           category,
                           Loc_code,
                           CUSTOMER_CAT,
                           MODULE,
                           IB
                      from (select DISTINCT b.ac_gl_no   ac_no,
                                             B.AC_GL_DESC ac_desc,
                                             --DRCR_IND,
                                             decode(cust_gl,
                                                    'A',
                                                    decode((select
                                                           
                                                           distinct resident_status
                                                             from xafnfc.sttm_cust_personal
                                                            where
                                                           
                                                            customer_No =
                                                            B.CUST_NO),
                                                           'N',
                                                           '0',
              'R','1'))
                                             
                                             RESIDENCE,
                                             (SELECT SUBSTR
                                                     
                                                     (CUST_MIS_3, 1, 1)
                                                FROM xafnfc.MITM_CUSTOMER_DEFAULT
                                               WHERE CUSTOMER
                                                    
                                                     = B.CUST_NO)
                                             
                                             ECONOMIC_ACTIVITY,
                                             (SELECT TO_DATE
                                                     
                                                     (SYSDATE, 'DD-MM-YYYY')
                                                FROM DUAL)
                                             
                                             PLACEMENT_DATE,
                                             (SELECT
                                              
                                               TD_Maturity_date
                                                FROM xafnfc.TDVW_TD_DETAILS
                                               WHERE
                                              
                                               ACCOUNT_NO = AC_NO) MATURITY_DATE,
                                             CASE
                                               WHEN (SELECT
                                                     
                                                      DECODE(CUST_MIS_4,
                                                             'F1121',
                                                             'F1121')
                                                       FROM xafnfc.MITM_CUSTOMER_DEFAULT
                                                      WHERE
                                                     
                                                      CUSTOMER = B.CUST_NO) =
                                                    'F1121' THEN
                                                'F1121'
                                               WHEN (SELECT
                                                     
                                                      DECODE(CUST_MIS_5,
                                                             'F1122',
                                                             'F1122')
                                                       FROM xafnfc.MITM_CUSTOMER_DEFAULT
                                                      WHERE
                                                     
                                                      CUSTOMER = B.CUST_NO) =
                                                    'F1122' THEN
                                                'F1122'
                                               ELSE
                                                ''
                                             END
                                             
                                             CB_SPECIFIC_CLIENT,
                                             B.CUST_NO CIF_NO,
                                             z.AC_BRANCH
                                             
                                             branch,
                                             Z.AC_CCY ac_ccy,
                                             '' RATE,
                                             DECODE(CUST_GL,
                                                    'A',
                                                    
                                                    xafnfc.BIPKS_REPORT.fn_get_ACCBAL_AS_DT(b.ac_gl_no,
                                                                                     
                                                                                     to_date
                                                                                     
                                                                                     ('&REPORT_PERIOD_END_DT',
                                                                                      
                                                                                      'dd-MM-yyyy')),
                                                    0) AMOUNT,
                                             cust_gl,
                                             '' category,
                                             (select loc_code
                                                from xafnfc.sttm_customer
                                               where
                                              
                                               customer_no = B.CUST_NO) Loc_code,
                                             B.CUSTOMER_CAT,
                                             '' MODULE,
                                             '' IB
                               from xafnfc.acvws_all_ac_entries Z, xafnfc.sttb_account B
                              WHERE
                             
                              B.AC_GL_NO =
                             
                              Z.AC_NO
                           and balance_upd = 'U'
                           AND AC_BRANCH =
                             
                              AC_BRANCH
                             --AND IB IS NOT NULL
                           and ((module =
                              
                              'CL' and cust_gl = 'A') or module <> 'CL')
                             
                           AND cust_gl = 'A'
                           and NVL(IB, 'N') =
                             
                              'N'
                           AND
                             
                              Z.FINANCIAL_CYCLE = '&FINANCIAL_CYCLE'
                           AND Z.PERIOD_CODE <=
                             
                              '&REPORT_PERIOD_CODE')));

begin

  for var_c1 in c1 loop
  
    insert into xafnfc.trial_balance
      (ACCOUNT_NUMBER,
       DESCRIPTION,
       GLCODE1,
       GLCODE2,
       GL_INTERFACE,
       CENTRAL_BANK_CODE,
       RESIDENCE,
       INSTITUTIONAL_UNIT,
       GEOGRAPHICAL_LOCATION,
       ECONOMIC_ACTIVITY,
       drcr_ind,
       DEBIT,
       CREDIT,
       PLACEMENT_DATE,
       MATURITY_DATE,
       CUSTOMER_ID,
       BRANCH,
       CCY,
       RATE,
       AMOUNT,
       CB_SPECIFIC_CLIENTS,
       Line,
       CUST_GL,
       CATEGORY,
       Loc_code,
       CUSTOMER_CAT,
       MODULE,
       FINANCIAL_CYCLE,
       PERIODIC_CODE,
       gl_closing_balance,
       gl_opening_balance,
       IB,
       TRN_DT)
    
    values
      (var_c1.ac_no,
       var_c1.AC_DESC,
       var_c1.gl_code1,
       var_c1.gl_code2,
       var_c1.gl_int,
       var_c1.cbf,
       var_c1.RESIDENCE,
       var_c1.INSTITUTIONAL_UNIT,
       var_c1.GEOGRAPHICAL_LOCATION,
       var_c1.ECONOMIC_ACTIVITY,
       var_c1.drcr_ind,
       var_c1.debit,
       var_c1.credit,
       var_c1.PLACEMENT_DATE,
       var_c1.MATURITY_DATE,
       var_c1.cif_no,
       var_c1.branch,
       var_c1.AC_CCY,
       var_c1.rate,
       var_c1.amount,
       var_c1.CB_SPECIFIC_CLIENT,
       var_c1.Line,
       var_c1.CUST_GL,
       var_c1.CATEGORY,
       var_c1.Loc_code,
       VAR_C1.CUSTOMER_CAT,
       VAR_C1.MODULE,
       VAR_C1.FINANCIAL_CYCLE,
       VAR_C1.PERIODIC_CODE,
       var_c1.gl_closing_balance,
       var_c1.gl_opening_balance,
       VAR_C1.IB,
       VAR_C1.TRN_DT);
  
  end loop;

  COMMIT;
end;
/