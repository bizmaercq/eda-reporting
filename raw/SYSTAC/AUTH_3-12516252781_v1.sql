SET SERVEROUTPUT ON SIZE 1000000
SET BUFFER 10000000
SET ARRAY 1
SET PAU OFF
SET HEAD ON
SET FEEDBACK ON
SET LINES 32767
SET PAGESIZE 50000
SET ECHO ON
SET TRIMSPOOL ON
SET COLSEP ","
SET LONG 2000000000
SET TIME ON
SET TIMING ON
SET numformat 999999999999999999999.99
BEGIN
    DBMS_OUTPUT.ENABLE (BUFFER_size => NULL);
END;
/
SPOOL C:\AUTH_3-12528554461_v118042016.SPL

select * from actbs_daily_log where trn_ref_no='010CGOD182010022' AND AC_ENTRY_SR_NO IN ('171340843','171340844','171340845','171340846');

SELECT * FROM Cstb_Clearing_Master WHERE Auth_Stat = 'U' AND reference_no = '010CGOD182010022' AND txn_branch = '010';
--CHANGE THE TRN_REF_NO AND EVENT_SEQ_NO before sending
DECLARE

	CURSOR CUR_ACC IS
		select TRN_REF_NO,EVENT_SR_NO,AC_CCY,AC_BRANCH,USER_ID
		from actbs_daily_log where auth_stat = 'U' AND trn_ref_no='010CGOD182010022' 
		AND AC_ENTRY_SR_NO IN ('171340843','171340844','171340845','171340846');
			
	PERRCODE 	VARCHAR2(100);
	PPARAM 	VARCHAR2(1000);

	I 		NUMBER ;

BEGIN

	
        i := 0 ;
	FOR C1 IN CUR_ACC LOOP
		GLOBAL.PR_INIT(C1.AC_BRANCH,'SYSTEM');
		IF ACPKSS.fn_acservice
   			(
			C1.AC_BRANCH ,
			global.application_date,
			global.lcy    ,
			C1.trn_ref_no ,
			C1.event_sr_no ,
			'A' ,
			'SYSTEM' , -- Change the user id
			pErrCodE,
			pParam	
		   	) THEN
			    DEBUG.PR_DEBUG('AC','SUCCESS - '||C1.trn_ref_no);
		ELSE
		    DEBUG.PR_DEBUG('AC','ERROR - '||C1.trn_ref_no || SQLERRM);
		END IF;

		I:=I+1;

		DEBUG.PR_DEBUG('AC','FINAL COUNT'||I);

	END LOOP;

	COMMIT;
EXCEPTION
	WHEN OTHERS
	THEN debug.pr_debug('AC','WOT - ' || SQLERRM);
	ROLLBACK;

END;
/

UPDATE Cstb_Clearing_Master SET Auth_Stat = 'A' WHERE Auth_Stat = 'U' AND reference_no = '010CGOD182010022' AND txn_branch = '010';
COMMIT;

select * from actbs_daily_log where trn_ref_no='010CGOD182010022' AND AC_ENTRY_SR_NO IN ('171340843','171340844','171340845','171340846');
		
SELECT * FROM Cstb_Clearing_Master WHERE reference_no = '010CGOD182010022' AND txn_branch = '010';
SPOOL OFF;
