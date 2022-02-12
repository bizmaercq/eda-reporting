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

spool c:\allaeod.spl

show user

Prompt STTM_BRANCH
select branch_code, end_of_input,time_level,bank_code,record_stat,auth_stat from xafnfc.sttm_branch  
order by branch_code;

PROMPT STTM_BRANCH (Time Level is Null or Bank Code is Null or End of Input is Null)
select record_stat,branch_code,end_of_input,time_level,bank_code 
from xafnfc.sttm_branch  where end_of_input is null or bank_code is null or time_level is null
order by branch_code;

select a.branch_code,today , decode(end_of_input,'N','Transaction Input','T','EOTI','F','EOFI','E','EOD',
'B','BOD',end_of_input) status from xafnfc.sttm_dates a,xafnfc.sttm_branch b where a.branch_code = b.branch_code;

SELECT * FROM xafnfc.STTM_BRANCH;

PROMPT STTMS_DATES
select * from xafnfc.sttms_dates order by branch_code;

PROMPT STTMS_AEOD_DATES
select * from xafnfc.sttms_aeod_dates order by branch_code; 

PROMPT EITM_MODULES_INSTALLED
select * from xafnfc.eitm_modules_installed 
order by branch_code,eoc_group, function_id;

PROMPT EITBS_PENDING_PROGRAMS
select * from xafnfc.eitbs_pending_programs  order by branch_code;

PROMPT aetm_process_defn_streams
Select * from xafnfc.aetm_process_defn_streams ;

PROMPT Streams (INRKMF)
SELECT distinct stream_code FROM xafnfc.aetm_process_defn_streams WHERE record_stat = 'O' and auth_stat = 'A' and nvl(process_status,'X') <> 'W';

PROMPT  AETB_PROCESS_PROGRESS
select * from xafnfc.aetb_process_progress  order by branch;

PROMPT aetb_process_status
select * from xafnfc.aetb_process_status  order by branch_code;

PROMPT aetb_aeod_status
SELECT * FROM xafnfc.aetb_aeod_status;

PROMPT aetb_branch_schedules
select * from xafnfc.aetb_branch_schedules  order by submittime desc,branch_code;

PROMPT eitm_modules_predecessors
select * from xafnfc.eitm_modules_predecessors   order by branch_code, eoc_group, function_id;

PROMPT aetms_process_defn
select * from xafnfc.aetms_process_defn  order by branch_code;

PROMPT AETB_INPUTS
select * from xafnfc.AETB_INPUTS  order by branch_code;

PROMPT AETB_SPL_KEYS
select * from AETB_SPL_KEYS;

SELECT * FROM xafnfc.STTM_LCL_HOLIDAY WHERE  YEAR IN ( SELECT TO_CHAR(TODAY,'YYYY') FROM xafnfc.STTM_DATES ) ORDER BY BRANCH_CODE;

SELECT * FROM xafnfc.AETB_BRANCH_SCHEDULES;

select * from xafnfc.AETMS_PROCESS_SCHEDULE;

-- This is Mainly for Flexcel Site ( Key Stroke AEOD)

select min(today) from xafnfc.sttm_dates where branch_code in ( select branch_code from xafnfc.sttm_branch
where record_stat='O' and auth_stat='A' and end_of_input='N');
 
select branch_code,today,next_working_day,prev_working_day  from xafnfc.sttm_dates
where branch_code in ( select branch_code from xafnfc.sttm_branch
where record_stat='O' and auth_stat='A' );
 

select branch_code,today,next_working_day,prev_working_day  from xafnfc.sttm_aeod_dates
where branch_code in ( select branch_code from xafnfc.sttm_branch
where record_stat='O' and auth_stat='A' );

select * from xafnfc.smtb_menu where function_id like 'AEODSTRT';

select * from xafnfc.smtb_menu where function_id like 'BAEODSTRT';

select * from xafnfc.smtb_FUNCTION_DESCRIPTION where function_id like 'AEODSTRT';

select * from xafnfc.smtb_FUNCTION_DESCRIPTION where function_id like '%BAEOD%';

-- This is Mainly for USDABA.

SELECT * FROM xafnfc.aetbs_func_detail ;

SELECT * FROM xafnfc.aetbs_func_master;

SELECT * FROM xafnfc.AETB_FUNC_CODES ;

SELECT * FROM xafnfc.AETB_JOB_SEQUENCE;

select * from AETB_JOB_QUEUE;

select * from aetb_external_funcs;

SELECT * FROM xafnfc.AETBS_ERROR_LOG;

SELECT * FROM xafnfc.AETB_RUNTIME_OPTIONS;

PROMPT AEOD_PROCESS_PROGRESS Timings

select 
	ESN    	       			, 
	BRANCH         			,
	PROCESS        			,
	STATUS         			,
	ERRCODE       			,
	REASON         			,
	TO_CHAR(STARTTIME,'DD-MON-YYYY HH24:MI:SS')	,
	TO_CHAR(ENDTIME,'DD-MON-YYYY HH24:MI:SS')   
FROM 
	xafnfc.AETB_PROCESS_PROGRESS;

spool off
