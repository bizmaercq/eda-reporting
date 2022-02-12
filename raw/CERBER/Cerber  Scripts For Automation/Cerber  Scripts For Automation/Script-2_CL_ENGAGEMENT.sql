accept FINANCIAL_CYCLE PROMPT 'Enter the Current FINANCIAL_CYCLE >'
accept REPORT_PERIOD_CODE  PROMPT 'Enter the Current REPORT_PERIOD_CODE >'
accept REPORT_MONTH_END_DT  PROMPT 'Enter the Current REPORT_MONTH_END_DT (Ex: 31-MAY-2012) >'
set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on

Declare

  cursor c1 is
  
    select ac_no,
           AC_DESC,
           gl_code1,
           gl_code2,
           gl_int,
           cbf,
           RESIDENCE,
           INSTITUTIONAL_UNIT,
           GEOGRAPHICAL_LOCATION,
           DECODE(ECONOMIC_ACTIVITY,'G','9') ECONOMIC_ACTIVITY,
           drcr_ind,
           debit,
           credit,
           PLACEMENT_DATE,
           MATURITY_DATE,
           cif_no,
           branch,
           AC_CCY,
           rate,
           (-amount) amount,
           CB_SPECIFIC_CLIENT,
           LINE,
           cust_gl,
           category,
           substr(Loc_code,1,2) Loc_code,
           CUSTOMER_CAT,
           MODULE,
           FINANCIAL_CYCLE,
           PERIODIC_CODE,
           gl_opening_balance,
           gl_closing_balance,
           ib,
           trn_dt,
 	   (SELECT BOOK_DATE FROM CLTB_ACCOUNT_MASTER WHERE ACCOUNT_NUMBER = ac_no ) BOOK_DATE    
      from (select ac_no,
                   AC_DESC,
                   gl_code1,
                   gl_code2,
                   gl_int,
                   (select distinct sd.cbank_line_dr
                      from gltm_glmaster sd
                     where sd.gl_code = gl_code2) cbf,
                   nvl(RESIDENCE,1) RESIDENCE,
                   INSTITUTIONAL_UNIT,
                   GEOGRAPHICAL_LOCATION,
                   ECONOMIC_ACTIVITY,
                   case
                     when AMOUNT < 0 then
                      'D'
                     else
                      'C'
                   end drcr_ind,
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
                   (SELECT CATEGORY
                      FROM GLTM_GLMASTER
                     WHERE GL_CODE = GL_CODE2) category,
                   Loc_code,
                   CUSTOMER_CAT,
                   MODULE,
                   FINANCIAL_CYCLE,
                   PERIODIC_CODE,
                   gl_opening_balance,
                   gl_closing_balance,
                   ib,
                   trn_dt
              from (select distinct RELATED_ACCOUNT ac_no,
                                    (select product_desc
                                       from cltm_product
                                      where product_code =
                                            substr(RELATED_ACCOUNT, 4, 4)) ac_desc,
                                    substr(EE.GL_CODE, 1, 5) gl_code1,
                                    EE.GL_CODE gl_code2,
                                    case
                                      when substr(EE.GL_CODE, 1, 2) in
                                           ('68', '66', '25') then
                                       substr(EE.GL_CODE, 1, 2)
                                      when substr(EE.GL_CODE, 1, 2) in
                                           ('20',
                                            '19',
                                            '28',
                                            '69',
                                            '93',
                                            '98',
                                            '99') then
                                       substr(EE.GL_CODE, 1, 4)
                                      when substr(EE.GL_CODE, 1, 3) in
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
                                       substr(EE.GL_CODE, 1, 4)
                                      else
                                       substr(EE.GL_CODE, 1, 3)
                                    end gl_int,
                                    decode((select distinct resident_status
                                             from sttm_cust_personal
                                            where customer_No =
                                                  EE.CUSTOMER_ID),
                                           'N',
                                           '0','R','1') RESIDENCE,
                                    '' INSTITUTIONAL_UNIT,
                                    '' GEOGRAPHICAL_LOCATION, -- SAME AS LOC_CDE       
                                    (SELECT SUBSTR(CUST_MIS_3, 1, 1)
                                       FROM MITM_CUSTOMER_DEFAULT
                                      WHERE CUSTOMER = EE.CUSTOMER_ID) ECONOMIC_ACTIVITY,
                                    '' drcr_ind,
                                    '' DEBIT,
                                    '' CREDIT,
                                    (SELECT TO_DATE(SYSDATE, 'DD-MM-YYYY')
                                       FROM DUAL) PLACEMENT_DATE,
                                    (SELECT MATURITY_DATE
                                       FROM CLTB_ACCOUNT_MASTER
                                      WHERE ACCOUNT_NUMBER = S.RELATED_ACCOUNT) MATURITY_DATE,
                                    EE.CUSTOMER_ID CIF_NO,
                                    SUBSTR(S.RELATED_ACCOUNT, 1, 3) BRANCH,
                                    s.AC_CCY,
                                    bipks_report_loan.fn_get_loan_intrate(RELATED_ACCOUNT) rate,
                                    BIPKS_REPORT_LOAN.fn_get_Principal_arrears_ASdt(RELATED_ACCOUNT,
                                                                                    TO_DATE('&REPORT_MONTH_END_DT',
                                                                                            'dd-MM-yyyy')) amount,
                                    CASE
                                      WHEN (SELECT DECODE(CUST_MIS_4,
                                                          'F1121',
                                                          'F1121')
                                              FROM MITM_CUSTOMER_DEFAULT
                                             WHERE CUSTOMER =
                                                   EE.CUSTOMER_ID) =
                                           'F1121' THEN
                                       'F1121'
                                      WHEN (SELECT DECODE(CUST_MIS_5,
                                                          'F1122',
                                                          'F1122')
                                              FROM MITM_CUSTOMER_DEFAULT
                                             WHERE CUSTOMER =
                                                   EE.CUSTOMER_ID) =
                                           'F1122' THEN
                                       'F1122'
                                      ELSE
                                       ''
                                    END CB_SPECIFIC_CLIENT,
                                    '' LINE,
                                    s.CUST_GL,
                                    '' CATEGORY,
                                    (select loc_code
                                       from sttm_customer
                                      where customer_no = EE.CUSTOMER_ID) Loc_code,
                                    (SELECT DISTINCT CUSTOMER_CATEGORY
                                       FROM STTM_CUSTOMER
                                      WHERE CUSTOMER_NO = EE.CUSTOMER_ID) CUSTOMER_CAT,
                                    S.MODULE,
                                    '' FINANCIAL_CYCLE,
                                    '' PERIODIC_CODE,
                                    '' gl_opening_balance,
                                    '' gl_closing_balance,
                                    '' ib,
                                    '' trn_dt
                    
                      from acvw_all_ac_entries s,
                           (SELECT A.ACCOUNT_NUMBER, A.GL_CODE, D.CUSTOMER_ID
                              from CLTB_ACCOUNT_COMP_BAL_BREAKUP A,
                                   CLTB_ACCOUNT_MASTER           D
                             where A.ACCOUNT_NUMBER = D.ACCOUNT_NUMBER
                               AND A.STATUS_CODE = D.USER_DEFINED_STATUS
                               AND A.BRANCH_CODE = D.BRANCH_CODE
                               AND A.GL_CODE = A.GL_CODE
                               AND A.COMPONENT = 'PRINCIPAL'
                               AND CREATION_DATE = (SELECT MAX(CREATION_DATE) FROM CLTB_ACCOUNT_COMP_BAL_BREAKUP WHERE ACCOUNT_NUMBER = A.ACCOUNT_NUMBER AND CREATION_DATE <= '&REPORT_MONTH_END_DT' AND
COMPONENT = 'PRINCIPAL' and STATUS_CODE = A.STATUS_CODE)) EE
                     where S.MODULE = 'CL'
                       AND S.RELATED_ACCOUNT = EE.ACCOUNT_NUMBER
                       AND AC_BRANCH = AC_BRANCH
                       AND s.CUST_GL = 'G'
                       AND DRCR_IND = 'D'
                       and s.event = 'DSBR'
                       AND NVL(IB, 'N') = 'N'
                       AND S.FINANCIAL_CYCLE = '&FINANCIAL_CYCLE'
                       AND S.PERIOD_CODE <= '&REPORT_PERIOD_CODE')); --6857

begin

  for var_c1 in c1 loop
  
    insert into TRIAL_BALANCE
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
       ib,
       trn_dt,
	BOOK_DATE)
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
       var_c1.ib,
       var_c1.trn_dt,
	var_c1.BOOK_DATE);
  
  end loop;

  COMMIT;
end;
/
