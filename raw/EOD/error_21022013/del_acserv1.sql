SET NUMFORMAT 999,999,999,999,999,999,999.999
SET LINE 10000
SET TRIMSPOOL ON
SET ECHO ON
SET PAGESIZE 50000
set colsep ';'
SPOOL c:\XAFN_125.spl


select * from actb_daily_log where trn_ref_no = '023ZRSP130520001' and ac_branch='023' and batch_no='8999';

DECLARE
	CURSOR CUR_ACC IS
	select * from actb_daily_log where trn_ref_no = '023ZRSP130520001' and ac_branch='023' and batch_no='8999';
	PERRCODE 	VARCHAR2(100);
	PPARAM 	VARCHAR2(1000);

	I 		NUMBER ;
BEGIN

	GLOBAL.PR_INIT('023','SYSTEM');
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
select * from actb_daily_log where trn_ref_no = '023ZRSP130520001' and ac_branch='023' and batch_no='8999';

SET ECHO OFF
SPOOL OFF