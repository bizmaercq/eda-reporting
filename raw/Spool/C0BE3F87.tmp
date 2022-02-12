set array 1
set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000

spool c:\UAHPRAFCC0165_024S12S122220002.spl

SELECT * FROM cltbs_account_schedules WHERE account_number = '024S12S122220002'  AND branch_code    = '024';
SELECT * FROM cltbs_account_comp_balances WHERE account_number = '024S12S122220002'  AND branch_code    = '024' AND component_name = 'PRINCIPAL_EXPECTED';
select * from cltb_amount_recd where account_number='024S12S122220002';


DECLARE

  l_account        cltbs_account_apps_master.account_number%TYPE;
  l_brn            cltbs_account_apps_master.branch_code%TYPE;
  l_balance        cltbs_account_comp_balances.balance%TYPE := 0;
  l_amort_count    NUMBER := 0;
  l_rec_account    cltbs_account_master%ROWTYPE;
  l_recalc_st_date DATE;
  l_mainint_date   DATE;
  l_principal_date DATE;
  p_err_code	   VARCHAR2(400);
  p_err_param	   VARCHAR2(400);

  CURSOR C_PRIN_MOVEMENTS_NONAMRT(l_account cltb_account_apps_master.account_number%type, l_brn cltb_account_apps_master.branch_code%type) IS
    SELECT Paid_Date,
           Nvl(SUM(Nvl(Amount_Paid, 0) + Nvl(Amount_Waived, 0)), 0) Amt_Paid,
           'P' PAY_RECV
      FROM Cltb_Amount_Paid
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
       AND PAID_DATE >= l_rec_account.VALUE_DATE
       and paid_status = 'P'
       AND DUE_DATE > PAID_DATE
     GROUP BY Paid_Date
    UNION ALL
    SELECT RECD_DATE PAID_DATE,
           NVL(SUM(AMOUNT_RECD), 0) AMT_PAID,
           'D' PAY_RECV
      FROM CLTB_AMOUNT_RECD
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
       AND recd_date >= l_rec_account.VALUE_DATE
     GROUP BY RECD_DATE
    UNION ALL
    SELECT SCHEDULE_DUE_DATE PAID_DATE,
           (NVL(SUM(AMOUNT_DUE), 0) -
           (SELECT NVL(SUM(Nvl(Amount_Paid, 0)), 0)
               FROM CLTB_AMOUNT_PAID B
              WHERE Account_Number = l_account
                AND Branch_Code = l_brn
                AND Component_Name = 'PRINCIPAL'
                AND DUE_DATE = SCHEDULE_DUE_DATE
                AND PAID_DATE >= l_rec_account.VALUE_DATE
                AND PAID_DATE < DUE_DATE
                AND paid_status = 'P')) AMT_PAID,
           'S' PAY_RECV
      FROM CLTB_ACCOUNT_SCHEDULES A
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
     GROUP BY SCHEDULE_DUE_DATE
    UNION ALL
    SELECT SCHEDULE_DUE_DATE PAID_DATE,
           NVL(SUM(NVL(AMOUNT_DUE, 0)), 0) -
           NVL(SUM(NVL(AMOUNT_SETTLED, 0)), 0) AMT_PAID,
           'S' PAY_RECV
      FROM CLTB_ACCOUNT_SCHEDULES
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND NVL(capitalized, 'N') = 'Y'
       AND Component_Name <> 'PRINCIPAL'
     GROUP BY SCHEDULE_DUE_DATE
    HAVING NVL(SUM(NVL(AMOUNT_DUE, 0) - NVL(AMOUNT_SETTLED, 0)), 0) <> 0
     ORDER BY 1, 3;

  CURSOR C_PRIN_MOVEMENTS_AMRT(l_account cltb_account_apps_master.account_number%type, l_brn cltb_account_apps_master.branch_code%type) IS
    SELECT Paid_Date,
           Nvl(SUM(Nvl(Amount_Paid, 0) + Nvl(Amount_Waived, 0)), 0) Amt_Paid,
           'P' PAY_RECV
      FROM Cltb_Amount_Paid
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
       AND PAID_DATE >= l_rec_account.VALUE_DATE
       and paid_status = 'P'
       AND DUE_DATE > PAID_DATE
     GROUP BY Paid_Date
    UNION ALL
    SELECT RECD_DATE PAID_DATE,
           NVL(SUM(AMOUNT_RECD), 0) AMT_PAID,
           'D' PAY_RECV
      FROM CLTB_AMOUNT_RECD
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
       AND recd_date >= l_rec_account.VALUE_DATE
     GROUP BY RECD_DATE
    UNION ALL
    SELECT SCHEDULE_DUE_DATE PAID_DATE,
           NVL(SUM(AMOUNT_DUE), 0) AMT_PAID,
           'S' PAY_RECV
      FROM CLTB_ACCOUNT_SCHEDULES
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND Component_Name = 'PRINCIPAL'
     GROUP BY SCHEDULE_DUE_DATE
    UNION ALL
    SELECT SCHEDULE_DUE_DATE PAID_DATE,
           NVL(SUM(NVL(AMOUNT_DUE, 0) - NVL(AMOUNT_SETTLED, 0)), 0) AMT_PAID,
           'S' PAY_RECV
      FROM CLTB_ACCOUNT_SCHEDULES
     WHERE Branch_Code = l_brn
       AND Account_Number = l_account
       AND NVL(capitalized, 'N') = 'Y'
       AND Component_Name <> 'PRINCIPAL'
     GROUP BY SCHEDULE_DUE_DATE
    HAVING NVL(SUM(NVL(AMOUNT_DUE, 0) - NVL(AMOUNT_SETTLED, 0)), 0) <> 0
     ORDER BY 1, 3;

  TYPE ty_tb_movements_in_period IS TABLE OF C_PRIN_MOVEMENTS_AMRT%ROWTYPE INDEX BY PLS_INTEGER;
  l_tb_movements_in_period ty_tb_movements_in_period;

  PROCEDURE dbg(p_l VARCHAR2) IS
  BEGIN
    debug.pr_debug('CL', 'REBUILD_COMP_BALANCES->' || p_l);
  END dbg;

BEGIN

  l_account := '024S12S122220002';
  l_brn     := '024';
   global.pr_init(l_brn,'SYSTEM');
  dbg('account is == > ' || l_account);
  l_rec_account := clpkss_cache.fn_account_master(l_account, l_brn);

  BEGIN
    SELECT MIN(SCHEDULE_ST_DATE)
      INTO l_mainint_date
      FROM CLTB_ACCOUNT_SCHEDULES
     WHERE ACCOUNT_NUMBER = l_account
       AND BRANCH_CODE = l_brn
       AND COMPONENT_NAME = 'MAIN_INT'
       AND NVL(AMOUNT_DUE, 0) <> NVL(AMOUNT_SETTLED, 0)
       AND NVL(AMOUNT_SETTLED, 0) = 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN

      dbg('inside No data found while selecting main_int date');
      SELECT MIN(SCHEDULE_ST_DATE)
        INTO l_mainint_date
        FROM CLTB_ACCOUNT_SCHEDULES
       WHERE ACCOUNT_NUMBER = l_account
         AND BRANCH_CODE = l_brn
         AND COMPONENT_NAME = 'MAIN_INT'
         AND NVL(AMOUNT_DUE, 0) <> NVL(AMOUNT_SETTLED, 0);
  END;
  dbg('Main int date ==>' || l_mainint_date);
  BEGIN
    SELECT MIN(SCHEDULE_ST_DATE)
      INTO l_principal_date
      FROM CLTB_ACCOUNT_SCHEDULES
     WHERE ACCOUNT_NUMBER = l_account
       AND BRANCH_CODE = l_brn
       AND COMPONENT_NAME = 'PRINCIPAL'
       AND NVL(AMOUNT_DUE, 0) <> NVL(AMOUNT_SETTLED, 0)
       AND NVL(AMOUNT_SETTLED, 0) = 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN

      dbg('inside No data found while selecting principal date');
      SELECT MIN(SCHEDULE_ST_DATE)
        INTO l_principal_date
        FROM CLTB_ACCOUNT_SCHEDULES
       WHERE ACCOUNT_NUMBER = l_account
         AND BRANCH_CODE = l_brn
         AND COMPONENT_NAME = 'PRINCIPAL'
         AND NVL(AMOUNT_DUE, 0) <> NVL(AMOUNT_SETTLED, 0);
  END;
  dbg('principal date ==>' || l_principal_date);

  l_recalc_st_date := greatest(l_mainint_date, l_principal_date);

  dbg('Recalc start date ==> ' || l_recalc_st_date);

  IF C_PRIN_MOVEMENTS_NONAMRT%ISOPEN THEN
    CLOSE C_PRIN_MOVEMENTS_NONAMRT;
  END IF;

  IF C_PRIN_MOVEMENTS_AMRT%ISOPEN THEN
    CLOSE C_PRIN_MOVEMENTS_AMRT;
  END IF;
  dbg('l_rec_account.amortized ==> ' || l_rec_account.amortized);

  IF l_rec_account.amortized is null or
     l_rec_account.amortized not in ('N', 'Y') THEN

    BEGIN

      SELECT 1
        INTO l_amort_count
        FROM cltbs_account_comp_sch
       WHERE account_number = l_account
         AND branch_code = l_brn
         AND component_name = 'PRINCIPAL'
         AND schedule_type = 'P'
         AND ROWNUM < 2;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dbg('In no data found' || l_amort_count);
        l_amort_count := 0;
    END;
    dbg('GET AMORT COUNT HERE ==>' || l_amort_count);
    IF l_amort_count <> 0 then
      l_rec_account.amortized := 'N';
    ELSE
      l_rec_account.amortized := 'Y';
    END IF;
  END IF;

  IF l_rec_account.amortized = 'N' THEN
    OPEN C_PRIN_MOVEMENTS_NONAMRT(l_account, l_brn);
    FETCH C_PRIN_MOVEMENTS_NONAMRT BULK COLLECT
      INTO l_tb_movements_in_period;
    CLOSE C_PRIN_MOVEMENTS_NONAMRT;

  ELSIF l_rec_account.amortized = 'Y' THEN
    OPEN C_PRIN_MOVEMENTS_AMRT(l_account, l_brn);
    FETCH C_PRIN_MOVEMENTS_AMRT BULK COLLECT
      INTO l_tb_movements_in_period;
    CLOSE C_PRIN_MOVEMENTS_AMRT;

  END IF;

  dbg('l_tb_movements_count' || l_tb_movements_in_period.COUNT);
  IF l_tb_movements_in_period.COUNT > 0 THEN

    FOR i IN l_tb_movements_in_period.FIRST .. l_tb_movements_in_period.LAST LOOP

      dbg('PAY_RECV ==>' || l_tb_movements_in_period(i).PAY_RECV);
      dbg('PAID_DATE==>' || l_tb_movements_in_period(i).paid_date);
      dbg('AMT_PAID ==>' || l_tb_movements_in_period(i).Amt_Paid);
      dbg('BALANCE ==> ' || l_balance);

      IF l_tb_movements_in_period(i).PAY_RECV = 'D' THEN
        l_balance := l_balance + l_tb_movements_in_period(i).Amt_Paid;
      ELSE
        l_balance := l_balance - l_tb_movements_in_period(i).Amt_Paid;
      END IF;

      dbg('CHECK BALANCE HERE ==> ' || l_balance);
      IF l_balance < 0 THEN
        l_balance := 0;
      END IF;

      BEGIN
        INSERT INTO CLTB_ACCOUNT_COMP_BALANCES
          (branch_code, account_number, component_name, val_date, balance)
        VALUES
          (l_brn,
           l_account,
           'PRINCIPAL_EXPECTED',
           l_tb_movements_in_period(i).paid_date,
           l_balance);
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          UPDATE CLTB_ACCOUNT_COMP_BALANCES
             SET BALANCE = l_balance
           WHERE ACCOUNT_NUMBER = l_account
             AND branch_code = l_brn
             AND component_name = 'PRINCIPAL_EXPECTED'
             AND VAL_DATE = l_tb_movements_in_period(i).paid_date;

      END;
    END LOOP;

    dbg('Comp_balances has been rebuilt now call recalc');
    dbg('now print comp bal');
    FOR j IN (select *
                from cltb_account_comp_balances
               where account_number = l_account
                 and branch_code = l_brn
                 and component_name = 'PRINCIPAL_EXPECTED') LOOP
      dbg(' val_date :: ' || j.val_date || ' balance :: ' || j.balance);
    END LOOP;

    update cltb_account_master
       set calc_reqd = 'Y', recalc_action_code = 'E'
     where branch_code = l_brn
       AND ACCOUNT_NUMBER = l_account;

    dbg('now calling fn_recalc_for_an_account ' || l_recalc_st_date);
    if not clpkss_recalc.fn_recalc_for_an_account(l_account,
                                                  l_brn,
                                                  l_recalc_st_date,
                                                  p_err_code,
                                                  p_err_param) THEN

      dbg('failure ' || p_err_code || '::' || p_err_param || '::' ||
          SQLERRM);
      rollback;
    ELSE
      dbg('success');
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    dbg('In when others' || SQLERRM);
    p_err_param := SUBSTR(SQLERRM,1,80);
    rollback;

END;
/

SELECT * FROM cltbs_account_schedules WHERE account_number = '024S12S122220002'  AND branch_code    = '024';
SELECT * FROM cltbs_account_comp_balances WHERE account_number = '024S12S122220002'  AND branch_code    = '024';
SELECT * FROM CLTB_AMOUNT_RECD WHERE ACCOUNT_NUMBER='024S12S122220002';

ROLLBACK;

spool off

