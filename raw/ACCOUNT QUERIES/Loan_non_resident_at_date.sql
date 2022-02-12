SELECT SA.BRANCH_CODE,
       SA.ACCOUNT_NUMBER LOAN_ACCOUNT,
       AC_NO GL_CDE,
       SA.CUSTOMER_ID,
       SA.USER_DEFINED_STATUS STATUS,
       SA.NO_OF_INSTALLMENTS NB_LOAN_INSTALLMENTS,
       (select v.ude_value
          from cltb_account_ude_values v
         where v.account_number = sa.account_number
           and v.ude_id = 'INTEREST_RATE') interest_rate,
           ST.CUSTOMER_NAME1,
           /*
       (SELECT CUSTOMER_NAME1
          FROM STTM_CUSTOMER ST
         WHERE ST.CUSTOMER_NO = SA.CUSTOMER_ID ) CUSTOMER_NAME1,*/
         ST.NATIONALITY,
       
       ABS(BALANCE) BALANCE,
       SA.AMOUNT_FINANCED,
       SA.BOOK_DATE,
       SA.MATURITY_DATE
  FROM CLTB_ACCOUNT_MASTER SA,
       (SELECT RELATED_ACCOUNT,
               ac_branch,
               AC_NO,
               SUM(DECODE(DRCR_IND, 'D', -LCY_AMOUNT, LCY_AMOUNT)) BALANCE
          FROM ACVW_ALL_AC_ENTRIES
         WHERE AC_NO IN ('301001000',
                         '302001000',
                         '303001000',
                         '304001000',
                         '305001000',
                         '306001000',
                         '306002000',
                         '307001000',
                         '311001000',
                         '312001000',
                         '313001000',
                         '314001000',
                         '315001000',
                         '316001000',
                         '316002000',
                         '316250100',
                         '317001000',
                         '320100000',
                         '320110000',
                         '321100000',
                         '321300000',
                         '322001000',
                         '323001000',
                         '324100000',
                         '324200000',
                         '325100000',
                         '325200000',
                         '325300000',
                         '325400000',
                         '325500000',
                         '326001000',
                         '326002000',
                         '326003000',
                         '326004000',
                         '326005000',
                         '326250100',
                         '327001000',
                         '327101000',
                         '327201000',
                         '329001000')
           and (trn_dt between :PM_FROM_DT and :PM_TO_DT)
           And AC_BRANCH = Nvl(:Pm_Branch_Code, AC_BRANCH)
         GROUP BY AC_NO, ac_branch, RELATED_ACCOUNT) CS,
         STTM_CUSTOMER ST
 WHERE SA.ACCOUNT_NUMBER = CS.RELATED_ACCOUNT
    and ST.CUSTOMER_NO = SA.CUSTOMER_ID
    and ST.nationality NOT IN ('CM')
   and sa.BRANCH_CODE = cs.ac_branch
   And Cs.Balance <> 0
 ORDER BY SA.BRANCH_CODE
