DECLARE
	CURSOR CUR_ACC IS
		SELECT 	TRN_REF_NO,
				EVENT_SR_NO,
				AC_CCY,	
				AC_BRANCH,USER_ID
		FROM 		ACTB_DAILY_LOG
		WHERE 	trn_ref_no 	= '040ZRSP121870001';
		
	PERRCODE 	VARCHAR2(100);
	PPARAM 	VARCHAR2(1000);

	I 		NUMBER ;

BEGIN

	GLOBAL.PR_INIT('040');
      i := 0 ;
	FOR C1 IN CUR_ACC LOOP

		IF ACPKSS.fn_acservice
   			(
			C1.AC_BRANCH,
			global.application_date,
			global.lcy, -- C1.AC_CCY Changed the parameter to global.lcy
			C1.trn_ref_no,
			C1.event_sr_no,
			'D',
			C1.USER_ID,
			pErrCodE,
			pParam	
		   	) 
		THEN
		   	
			DEBUG.PR_DEBUG('AC','SUCCESS - '||C1.trn_ref_no);
		ELSE
		    	DEBUG.PR_DEBUG('AC','ERROR - '||C1.trn_ref_no || SQLERRM);
		END IF;

		I:=I+1;

		DEBUG.PR_DEBUG('AC','FINAL COUNT'||I);

	END LOOP;

	commit;

EXCEPTION
	WHEN OTHERS
	THEN debug.pr_debug('AC','DELACSERV-WOT - ' || SQLERRM);
	ROLLBACK;
END;
/