set array 1
set head on
set linesize 10000
set pagesize 50000
set long 10000
set feedback on
set trimspool on
set numformat 9999999999999999.999
set echo on
set colsep ';'
SPOOL C:\del_acserv_batch_020_023.SPL


DECLARE
	CURSOR CUR_ACC IS
		SELECT 	TRN_REF_NO,
				EVENT_SR_NO,
				AC_CCY,	
				AC_BRANCH,USER_ID
		FROM 		ACTB_DAILY_LOG
		WHERE 	BATCH_NO	= '1559'
		and  AC_ENTRY_SR_NO IN ('53874773','53874771','53873511','53874772')
		and auth_stat='U' and delete_stat<>'D';
		
	PERRCODE 	VARCHAR2(100);
	PPARAM 	VARCHAR2(1000);

	I 		NUMBER ;

BEGIN
	
      i := 0 ;
	FOR C1 IN CUR_ACC LOOP
		GLOBAL.PR_INIT(C1.AC_BRANCH,'SYSTEM');
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

select * from actbs_daily_log where auth_stat = 'U' and delete_stat <> 'D';


Spool off