CREATE OR REPLACE VIEW VW_TRIAL_BALANCE AS
select
ACCOUNT_NUMBER,
       DESCRIPTION,
       GLCODE1,
       GLCODE2,
       gl_leaf,
       GL_INTERFACE,
       --gl_closING,
       nvl(CENTRAL_BANK_CODE_a,case
       when gl_closing_balance_B < 0 then
       (select distinct sd.cbank_line_dr
        from gltm_glmaster sd
        where sd.gl_code = glcode2)
       when gl_closing_balance_B > 0 then
       (select distinct sd.cbank_line_cr
        from gltm_glmaster sd
        where sd.gl_code = glcode2)
        else
      nvl((select distinct sd.cbank_line_cr
        from gltm_glmaster sd
         where sd.gl_code = glcode2),
         (select distinct sd.cbank_line_dr
        from gltm_glmaster sd
         where sd.gl_code = glcode2))
                   end) CENTRAL_BANK_CODE,
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
       nvl(AMOUNT,0) AMOUNT,
       CB_SPECIFIC_CLIENTS,
       Line,
       CUST_GL,
       CATEGORY,
       Loc_code,
       CUSTOMER_CAT,
       MODULE,
       FINANCIAL_CYCLE,
       PERIODIC_CODE,
       gl_closing_balance_B gl_closing_balance,
       NVL(gl_opening_balance,(SELECT (sum(open_cr_bal_lcy)-sum(open_dr_bal_lcy)) FROM GLTB_GL_BAL
                           WHERE GL_CODE = GLCODE2 AND FIN_YEAR = '&FINANCIAL_CYCLE' and period_code = '&REPORT_PERIOD_CODE')) gl_opening_balance,
       IB,
       TRN_DT,
       BOOK_DATE
       from
       (

       select

ACCOUNT_NUMBER,
       DESCRIPTION,
       GLCODE1,
       GLCODE2,
       (select leaf from gltm_glmaster where gl_code = GLCODE2) gl_leaf,
       case
       when substr(gl_code2, 1, 2) in ('68', '66', '25') then
        substr(gl_code2, 1, 2)
       when substr(gl_code2, 1, 2) in
            ('20', '19', '28', '69', '93', '98', '99') then
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
       end GL_INTERFACE,
       CENTRAL_BANK_CODE_a,
       '' CENTRAL_BANK_CODE_b,
       RESIDENCE RESIDENCE,
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
       '' FINANCIAL_CYCLE,
       '' PERIODIC_CODE,
       nvl(gl_closing_balance_a,0) gl_closing_balance_a,
       nvl((SELECT (sum(NVL(cr_bal_lcy,0))-sum(NVL(dr_bal_lcy,0))) FROM GLTB_GL_BAL
                           WHERE GL_CODE = GLCODE2 AND GL_CODE = ACCOUNT_NUMBER AND FIN_YEAR = '&FINANCIAL_CYCLE' and period_code = '&REPORT_PERIOD_CODE' ),0) gl_closing_balance_b,

/*(SELECT (sum(NVL(cr_bal_lcy,0))-sum(NVL(dr_bal_lcy,0))) FROM GLTB_GL_BAL
                           WHERE GL_CODE = GLCODE2 AND GL_CODE = ACCOUNT_NUMBER AND FIN_YEAR = 'FY2012' and period_code = 'M04' ) gl_closing_balance_b,
*/       gl_opening_balance,
/*       (SELECT sum(decode(category ,
       '1' ,dr_bal_lcy - cr_bal_lcy,
       '2' ,cr_bal_lcy - dr_bal_lcy,
       '3' ,cr_bal_lcy - dr_bal_lcy,
       '4' ,dr_bal_lcy - cr_bal_lcy,
       '5' ,cr_bal_lcy - dr_bal_lcy,
       '6' ,dr_bal_lcy - cr_bal_lcy,
       '8' ,cr_bal_lcy - dr_bal_lcy,
       '9' ,cr_bal_lcy - dr_bal_lcy
       ,0
)) FROM GLTB_GL_BAL
WHERE GL_CODE = GLCODE2 AND GL_CODE = ACCOUNT_NUMBER AND FIN_YEAR = '&FINANCIAL_CYCLE' and period_code = '&LAST_PERIOD_CODE' ) gl_closing_balance_b,
*/       IB,
       TRN_DT,
       BOOK_DATE

       from
       (

select

      nvl(a.ACCOUNT_NUMBER,b.gl_code) ACCOUNT_NUMBER,
       nvl(a.DESCRIPTION,b.gl_desc) DESCRIPTION,
       NVL(GLCODE1,substr(B.GL_CODE, 1, 5)) GLCODE1,
       b.gl_code gl_code2,
       nvl(a.GLCODE2,b.gl_code) GLCODE2,
       GL_INTERFACE,
       a.CENTRAL_BANK_CODE CENTRAL_BANK_CODE_a,
       a.RESIDENCE RESIDENCE,
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
       nvl(a.CCY,NVL(B.RES_CCY,'XAF')) CCY,
       RATE,
       AMOUNT,
       CB_SPECIFIC_CLIENTS,
       Line,
       nvl(a.CUST_GL,'G') CUST_GL,
       nvl(a.CATEGORY,b.category) category,
       Loc_code,
       CUSTOMER_CAT,
       MODULE,
       gl_opening_balance,
       a.gl_closing_balance gl_closing_balance_a,
       '' gl_closing_balance_b,
       IB,
       TRN_DT,
       BOOK_DATE
       from trial_balance a, gltm_glmaster b
       where a.glcode2 (+) = b.gl_code
       AND B.LEAF = 'Y' ));

