set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999
SPOOL c:\final_set.SPL

update actb_daily_log set drcr_ind='C' where trn_ref_no='0409100121870051' and ac_no='0403830102911194';
commit;

DECLARE
	CURSOR CUR_ACC IS

select * from actb_daily_log where trn_ref_no in ('040ZRSP121870002','040SUSP06072012') and delete_stat<>'D';

	PERRCODE 	VARCHAR2(100);
	PPARAM 	VARCHAR2(1000);

	I 		NUMBER ;

BEGIN

      i := 0 ;
	FOR C1 IN CUR_ACC LOOP
			GLOBAL.PR_INIT(c1.ac_branch);
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
commit
/

select * from actb_daily_log where trn_ref_no in ('040ZRSP121870002','040SUSP06072012') and delete_stat<>'D';



set echo off
spool off