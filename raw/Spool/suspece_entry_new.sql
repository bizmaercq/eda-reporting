SPOOL C:\ACENTRY_new.SPL
set echo off verify off
SET SERVEROUTPUT ON

DECLARE

-- Enter the details. 
-- LD accouting entries are posted as Unauthorised entries.

l_init_acc_hoff		actbs_handoff%ROWTYPE;
l_acc_hoff		acpkss.tbl_achoff;
l_hoff_count		INTEGER :=1;
L_error_code		VARCHAR2(200);
L_error_parameter 	VARCHAR2(200);

l_contract_ref_no 	cstbs_contract.contract_ref_no%TYPE 		:= '040SUSP06072012'; --Contratc number
l_event_sr_no		cstbs_contract_event_log.event_seq_no%TYPE	:= '1';               ---Dont change  
l_ac_no			sttm_cust_account.cust_ac_no%TYPE		:= '454101000'; ---get suspence Gl from user 
l_ac_ccy			sttm_cust_account.ccy%TYPE		:= 'XAF'; ---local ccy
l_lcy_amount		actbs_daily_log.lcy_amount%TYPE			:=  7965;  -- diff amount
l_counterparty		sttm_cust_account.cust_no%TYPE			:= '';
l_mishead			actbs_daily_log.mis_head%TYPE		:= '';
l_amount_tag		actbs_daily_log.amount_tag%TYPE		  	:= 'TXN_AMT';      ---get it from spool file
l_event			actbs_daily_log.event%TYPE			:= 'INIT';   --get it from spool file
l_drcrind			VARCHAR2(1)				:= 'D';  --C for crdit,  D for Debit
l_trn_code			sttms_trn_code.trn_code%TYPE		:= 'SUS';  --get it from spool file
l_period_code			actbs_daily_log.period_code%TYPE	:= 'M07';  --get it from spool file

BEGIN
		global.pr_init ('040','SYSTEM');  --CHANGE THE BRANCH CODE

		l_init_acc_hoff := NULL;

		l_acc_hoff(l_hoff_count) := l_init_acc_hoff;

		l_acc_hoff(l_hoff_count).module := 'DE' ; 

		l_acc_hoff(l_hoff_count).trn_ref_no := l_contract_ref_no;

		l_acc_hoff(l_hoff_count).event_sr_no := l_event_sr_no;

		l_acc_hoff(l_hoff_count).event := l_event;

		l_acc_hoff(l_hoff_count).ac_branch := global.current_branch;

		l_acc_hoff(l_hoff_count).ac_no 	:= l_ac_no;

		l_acc_hoff(l_hoff_count).ac_ccy	:= l_ac_ccy;

		l_acc_hoff(l_hoff_count).drcr_ind := l_drcrind;

		l_acc_hoff(l_hoff_count).trn_code := l_trn_code;

		l_acc_hoff(l_hoff_count).amount_tag := l_amount_tag;

		l_acc_hoff(l_hoff_count).fcy_amount := NULL;

		l_acc_hoff(l_hoff_count).exch_rate := NULL;

		l_acc_hoff(l_hoff_count).lcy_amount :=  l_lcy_amount;

		l_acc_hoff(l_hoff_count).related_customer :=   l_counterparty;

		l_acc_hoff(l_hoff_count).trn_dt := global.application_date;

		l_acc_hoff(l_hoff_count).value_dt := global.application_date;

		l_acc_hoff(l_hoff_count).period_code := l_period_code;

		l_acc_hoff(l_hoff_count).instrument_code := NULL;

		l_acc_hoff(l_hoff_count).netting_ind := 'N';

		l_acc_hoff(l_hoff_count).user_id := global.user_id;

		l_acc_hoff(l_hoff_count).mis_head := l_mishead;

	
		IF NOT acpkss.fn_achandoff
				( l_contract_ref_no,
				1,
				global.application_date,
				l_acc_hoff,
				'B',
				'Y',		--suspense
				'N',		--balancing
				global.user_id,
				l_error_code,
				l_error_parameter )
		THEN
			DBMS_OUTPUT.PUT_LINE('failed in accounting handoff function');
			DBMS_OUTPUT.PUT_LINE('error code --> '||l_error_code);
			DBMS_OUTPUT.PUT_LINE('error parameter --> '||l_error_parameter);
			rollback;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Success - ACC ENTRY');
			DBMS_OUTPUT.PUT_LINE('error code --> '||l_error_code);
			DBMS_OUTPUT.PUT_LINE('error parameter --> '||l_error_parameter);

			commit;
		END IF;
END;
/


SELECT * FROM ACTB_DAILY_LOG WHERE TRN_REF_NO = '040SUSP06072012';

SPOOL OFF
