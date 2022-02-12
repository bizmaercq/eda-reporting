set array 1
set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool C:\EOD_EOM_TIMINGS_NFC.spl

PROMPT
PROMPT  Branch,process wise in aetb_process_progress
PROMPT

select branch,
       process,
       TO_CHAR(min(starttime), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(endtime), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_process_progress
 group by branch, process
 order by branch,
          process,
          TO_CHAR(min(starttime), 'DD-MON-YYYY HH24:MI:SS'),
          TO_CHAR(max(endtime), 'DD-MON-YYYY HH24:MI:SS');
PROMPT
PROMPT  process wise in aetb_process_progress
PROMPT

select process,
       TO_CHAR(min(starttime), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(endtime), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_process_progress
 group by  process
 order by process,
          TO_CHAR(min(starttime), 'DD-MON-YYYY HH24:MI:SS'),
          TO_CHAR(max(endtime), 'DD-MON-YYYY HH24:MI:SS');

PROMPT
PROMPT  branch,process, batch wise in aetb_eoc_programs
PROMPT

select branch_code,
       eod_date,
       branch_date,
       eoc_stage,
       eoc_batch,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs
 group by branch_code, eod_date, branch_date, eoc_stage, eoc_batch
 order by branch_code,
          eod_date,
          branch_date,
          eoc_stage,
          eoc_batch,
          TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS'),
          TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS');

PROMPT
PROMPT  branch,process wise in aetb_eoc_programs
PROMPT

select branch_code,
       eod_date,
       branch_date,
       eoc_stage,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs
 group by branch_code, eod_date, branch_date, eoc_stage
 order by branch_code,
          eod_date,
          branch_date,
          eoc_stage,
          TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS'),
          TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS');
PROMPT
PROMPT  process wise in aetb_eoc_programs
PROMPT

select eod_date,
       branch_date,
       eoc_stage,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs
 group by eod_date, branch_date, eoc_stage
 order by eod_date,
          branch_date,
          eoc_stage,
          TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS'),
          TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS');

PROMPT
PROMPT  branch,process, batch wise in aetb_eoc_programs_history
PROMPT

select branch_code,
       eod_date,
       branch_date,
       eoc_stage,
       eoc_batch,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs_history
 where EOD_DATE >= '02-AUG-2016'
group by branch_code, eod_date, branch_date, eoc_stage, eoc_batch 
order by branch_code, 
eod_date, 
branch_date, 
eoc_stage, 
eoc_batch, 
TO_CHAR(min(start_time),'DD-MON-YYYY HH24:MI:SS'), 
TO_CHAR(max(end_time),'DD-MON-YYYY HH24:MI:SS');

PROMPT
PROMPT  branch,process wise in aetb_eoc_programs_history
PROMPT

select branch_code,
       eod_date,
       branch_date,
       eoc_stage,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs_history
 where EOD_DATE >= '02-AUG-2016'
group by branch_code, eod_date, branch_date, eoc_stage
order by branch_code, 
eod_date, 
branch_date, 
eoc_stage, 
TO_CHAR(min(start_time),'DD-MON-YYYY HH24:MI:SS'), 
TO_CHAR(max(end_time),'DD-MON-YYYY HH24:MI:SS');

PROMPT
PROMPT process wise in aetb_eoc_programs_history
PROMPT

select eod_date,
       branch_date,
       eoc_stage,
       TO_CHAR(min(start_time), 'DD-MON-YYYY HH24:MI:SS') min_start_time,
       TO_CHAR(max(end_time), 'DD-MON-YYYY HH24:MI:SS') max_end_time
  from aetb_eoc_programs_history
 where EOD_DATE >= '02-AUG-2016'
group by eod_date, branch_date, eoc_stage
order by 
eod_date, 
branch_date, 
eoc_stage, 
TO_CHAR(min(start_time),'DD-MON-YYYY HH24:MI:SS'), 
TO_CHAR(max(end_time),'DD-MON-YYYY HH24:MI:SS');


spool off