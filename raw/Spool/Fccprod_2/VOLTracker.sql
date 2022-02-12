CL SCR

set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo off
set feedback off
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
set serverout on size 1000000
SPOOL c:\VOLTracker.SPL

DECLARE
	ACTIVE_CONTRACT 	NUMBER;
	INACTIVE_CONTRACT 	NUMBER;
	ACTIVE_GL 		NUMBER;
	INACTIVE_GL 		NUMBER;
	ACTIVE_ACCOUNT 		NUMBER;
	INACTIVE_ACCOUNT 	NUMBER;
	ACTIVE_USER 		NUMBER;
	INACTIVE_USER 		NUMBER;
	ACTIVE_BRN 		NUMBER;
	INACTIVE_BRN 		NUMBER;
	M 			VARCHAR2(2);
	PROCESSED_OUT 		NUMBER;
	UNPROCESSED_OUT 	NUMBER;
	PROCESSED_IN 		NUMBER;
	UNPROCESSED_IN 		NUMBER;
	DLY_TXN_COUNT 		NUMBER;
	TXN_HIST_COUNT	 	NUMBER;
	SITE_NAME 		VARCHAR2(10);
	MUX_TXN_COUNT 		NUMBER;
	L_TODAY 		DATE;


	CURSOR cr_cstb_contract is
	select distinct module_code from cstbs_contract;

	cursor cr_branch is
	select branch_code from sttm_branch where record_stat = 'O';

BEGIN

	select today INTO L_TODAY from sttm_dates where branch_code= (SELECT HO_BRANCH FROM STTM_BANK);
	select param_val into SITE_NAME from cstb_param where param_name='X9$';
	
	dbms_output.put_line(rpad('SITE CODE',25)||'~'||SITE_NAME);
	dbms_output.put_line(rpad('DATE',25)||'~'||L_TODAY);
	dbms_output.put_line(chr(13)); 

	Select sum(decode(record_stat,'O',1,0)) ,  sum(decode(record_stat,'O',0,1)) 
	into ACTIVE_USER,INACTIVE_USER 
	from smtb_user;
	dbms_output.put_line(rpad('USER_COUNT',25)||'~'||rpad(ACTIVE_USER,15)||'~'||INACTIVE_USER);
	dbms_output.put_line(chr(13));


	Select sum(decode(record_stat,'O',1,0)) ,  sum(decode(record_stat,'O',0,1)) 
	into ACTIVE_BRN,INACTIVE_BRN 
	from sttm_branch;
	dbms_output.put_line(rpad('BRANCH_COUNT',25)||'~'||rpad(ACTIVE_BRN,15)||'~'||INACTIVE_BRN);
	dbms_output.put_line(chr(13));


	select sum(decode(record_stat,'O',1,0)) ,  sum(decode(record_stat,'O',0,1)) 
	INTO ACTIVE_GL, INACTIVE_GL
	from gltm_glmaster;
	dbms_output.put_line(rpad('GL COUNT',25)||'~'||rpad(ACTIVE_GL,15)||'~'||INACTIVE_GL);
	dbms_output.put_line(chr(13));
	

	FOR CRB in cr_branch
	LOOP

		dbms_output.put_line('===========================================');
		dbms_output.put_line(rpad('BRANCH CODE',25)||'~'||CRB.BRANCH_CODE);
		dbms_output.put_line('~'||'ACTIVE'||'~'||'INACTIVE');

		dbms_output.put_line('CONTRACT COUNT ');
		FOR c1 IN cr_cstb_contract
		LOOP
			select 	sum(decode(contract_status,'A',1,0)) , sum(decode(contract_status,'A',0,1)) 
			into 	ACTIVE_CONTRACT, INACTIVE_CONTRACT
			from 	cstb_contract 
			where 	module_code=C1.module_code
			and	branch = CRB.BRANCH_CODE;
			--dbms_output.put_line(rpad('contract count',25)||'~'||C1.module_code||'~'||ACTIVE_CONTRACT||'~'||INACTIVE_CONTRACT);
			dbms_output.put_line(rpad(C1.module_code,10)||'~'||rpad(ACTIVE_CONTRACT,15)||'~'||INACTIVE_CONTRACT);
		end loop;
		dbms_output.put_line(' ');

		select sum(decode(record_stat,'O',1,0)) ,  sum(decode(record_stat,'O',0,1)) INTO ACTIVE_ACCOUNT, INACTIVE_ACCOUNT
		from sttm_cust_account
		where branch_code = CRB.BRANCH_CODE;
		dbms_output.put_line(rpad('CUST_AC_COUNT',25)||'~'||rpad(ACTIVE_ACCOUNT,15)||'~'||INACTIVE_ACCOUNT);

		Begin
			select 	count(*)/((PC_END_DATE - PC_START_DATE) +1 )
			INTO 	DLY_TXN_COUNT 
			from 	actb_history a, 
				sttm_period_codes b, 
				sttm_branch c
			where 	A.AC_BRANCH = 		CRB.BRANCH_CODE
			and	c.branch_code = 	A.AC_BRANCH
			and	c.CURRENT_CYCLE =	b.FIN_CYCLE	
			and	c.current_period = 	b.PERIOD_CODE
			and 	trn_dt between PC_START_DATE and PC_END_DATE
			group by ((PC_END_DATE - PC_START_DATE) +1 );
		Exception
			When No_data_found Then
			DLY_TXN_COUNT :=0;
		end;
		dbms_output.put_line(rpad('DLY_TXN_COUNT',25)||'~'||DLY_TXN_COUNT); 

		select  sum(decode(processed_flag,'N',0,1))  ,sum(decode(processed_flag,'N',1,0)) INTO PROCESSED_OUT,UNPROCESSED_OUT
	       	from mstb_dly_msg_out
	       	where branch = CRB.BRANCH_CODE;
		dbms_output.put_line(rpad('MSG_COUNT_OUT',25)||'~'||rpad(PROCESSED_OUT,15)||'~'||UNPROCESSED_OUT);       

		select  sum(decode(AUTH_STATUS,'A',1,0)),
			sum(decode(AUTH_STATUS,'A',0,1)) 
		INTO 	PROCESSED_IN,
			UNPROCESSED_IN
		from mstb_dly_msg_in
		where branch = CRB.BRANCH_CODE;
		dbms_output.put_line(rpad('MSG_COUNT_IN',25)||'~'||rpad(PROCESSED_IN,15)||'~'||UNPROCESSED_IN);  

		-- CL Count included start
/* -- No CL module for FBZ
		select sum(decode(ACCOUNT_STATUS,'A',1,0)),
		       sum(decode(ACCOUNT_STATUS,'A',0,1))
		INTO 	ACTIVE_CONTRACT, INACTIVE_CONTRACT
		from cltb_account_apps_master 
		where branch_code = CRB.BRANCH_CODE;
		dbms_output.put_line(rpad('CL COUNT',25)||'~'||rpad(ACTIVE_CONTRACT,15)||'~'||INACTIVE_CONTRACT);  
*/
		-- CL Count included end

		dbms_output.put_line(chr(13));
		dbms_output.put_line('===========================================');

	END LOOP; 
	select count(*) into MUX_TXN_COUNT 
	from actb_history where batch_no>='9000';
	dbms_output.put_line(rpad('MUX_TXN_COUNT',25)||'~'||MUX_TXN_COUNT); 

	select count(*) INTO TXN_HIST_COUNT 
	from actb_history;
	dbms_output.put_line(rpad('TXN_HIST_COUNT',25)||'~'||TXN_HIST_COUNT); 
	
EXCEPTION
		WHEN OTHERS
		THEN
			dbms_output.put_line('entered exception '||sqlcode||sqlerrm);
			NULL;
END;
/

spool off
