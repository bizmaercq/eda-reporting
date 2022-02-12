CREATE OR REPLACE FUNCTION fn_untank_parent_txn
      (
		 pbranch    IN  	sttms_branch.branch_code%TYPE,
		 plcy       IN    cytms_ccy_defn.ccy_code%TYPE,
		 P_TRN_REF_NO IN ACTBS_DAILY_LOG.TRN_REF_NO%TYPE,
		 perrcode   OUT   ertbs_msgs.err_code%TYPE,
		 pdate      IN    DATE,
		 pparams    OUT   VARCHAR2
       )
RETURN BOOLEAN IS
CURSOR


	cr_tank(pbranch IN sttms_branch.branch_code%TYPE) IS
		SELECT l.*, p.pc_start_date, p.pc_end_date
		FROM actbs_daily_log l, sttms_period_codes p
		WHERE balance_upd = 'T'
		AND ac_branch = pbranch
		AND p.period_code=l.period_code
		AND p.fin_cycle=l.financial_cycle
		And NVL(delete_stat,'X') <> 'D'
		AND TRN_REF_NO =p_TRN_REF_NO
		ORDER BY ac_no;


l_balrec          sttms_account_bal_tov%ROWTYPE;
l_gl_flag         sttms_bank.online_gl_update%TYPE;
err_upd           EXCEPTION;
no                NUMBER;
l_freq            NUMBER;
l_period          sttms_branch.current_period%TYPE;
l_cycle           sttms_branch.current_cycle%TYPE;

l_locked          BOOLEAN := FALSE;
l_retry           NUMBER;
l_maxtry          NUMBER :=16;
i			actbs_daily_log%ROWTYPE ; --Oracle 8 change
BEGIN
-- Select flag from on line update
SELECT
    online_gl_update
INTO
    l_gl_flag
FROM sttms_bank;
--
-- select the current period and cycle
SELECT

    current_period,
    current_cycle
INTO
    l_period,
    l_cycle
FROM
   sttms_branch
WHERE
    branch_code = pbranch;
Debug.pr_debug('AC','The values selected are :
                     Online update: '||l_gl_flag||
                     'Current period :'||l_period||
                     'Current Cycle: '||l_cycle);

--
FOR DUMMY IN cr_tank(pbranch)
LOOP
	BEGIN
	SAVEPOINT save_upd;
	l_retry:=0;
	l_locked:=FALSE;
   WHILE (l_locked = FALSE)
   LOOP
     BEGIN
       SELECT * INTO i
	    FROM actbs_daily_log
	    WHERE

	    ac_entry_sr_no = DUMMY.ac_entry_sr_no
	    FOR UPDATE NOWAIT;
       l_locked:=TRUE;
     EXCEPTION
       WHEN OTHERS THEN
         IF SQLCODE=-54 THEN
            l_retry := l_retry + 1;
            IF l_retry = l_maxtry THEN
               Debug.pr_debug('AC','Account already locked : Exitting after
                                     '||TO_CHAR(l_retry)|| ' attempts');
               perrcode:='AC-UPD02';
               RETURN FALSE;
            END IF;

         ELSE
           Debug.pr_debug('AC','Error '||SQLERRM||' while locking the account: '


			  ||i.ac_branch ||' '||i.ac_no);
           perrcode:='AC-UPD02';
           RETURN FALSE;
         END IF;
	   END;
   END LOOP;
   Debug.pr_debug('AC','Will untank the account :'||i.ac_no);
  IF i.cust_gl <> 'G' THEN
      IF NOT acpkss_eod.fn_untank_child(i,pdate,plcy) THEN

         RAISE err_upd;
      ELSE
         UPDATE actbs_daily_log
         SET
            balance_upd = 'U',
            trn_dt = pdate,
            period_code = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,period_code,l_period),
            financial_cycle = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,financial_cycle,l_cycle)
         WHERE
            ac_entry_sr_no = i.ac_entry_sr_no;
      END IF;
   ELSE
      IF l_gl_flag = 'Y' THEN

         UPDATE actbs_daily_log
         SET
            balance_upd = 'R',
            trn_dt = pdate,
            period_code = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,period_code,l_period),
            financial_cycle = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,financial_cycle,l_cycle)
         WHERE
            ac_entry_sr_no = i.ac_entry_sr_no;
      ELSE
         UPDATE actbs_daily_log
         SET
            balance_upd = 'D',
            trn_dt = pdate,
            period_code = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,period_code,l_period),
            financial_cycle = DECODE(SIGN(DUMMY.pc_end_date-i.txn_init_date),-1,financial_cycle,l_cycle)
         WHERE
            ac_entry_sr_no = i.ac_entry_sr_no;
      END IF;
   END IF;
   EXCEPTION
		WHEN err_upd THEN
			ROLLBACK TO save_upd;
	END;
Debug.pr_debug('AC','Will commit now...');
COMMIT;
END LOOP;

Debug.pr_debug('AC','Finished all. Will exit successfully');
RETURN TRUE;
EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END fn_untank_parent_txn;
/
sho err
