accept EODDATE PROMPT 'Enter the EODDATE in Format DD-MON-YYYY >'
SET ARRAY 1
SET HEAD ON
SET FEEDBACK ON
SET ECHO ON
SET TRIMSPOOL ON
SET LINE 30000
SET PAGESIZE 50000
SET LONG 100000
SET NUMFORMAT 999999999999.99999
SET COLSEP ";"
SET SERVEROUTPUT ON SIZE 1000000

SPOOL  D:\EOD_EOM_TIME.SPL


PROMPT batch timings lower version (<10)

select a.*,
       TO_CHAR(starttime, 'DD-MON-YYYY HH24:MI:SS') start_time,
       TO_CHAR(endtime, 'DD-MON-YYYY HH24:MI:SS') end_time
  from aetb_process_progress a;

PROMPT Total elapsed time

select *
  from (select eod_date,
            TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
               TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
               round((max(end_time) - min(start_time)) * 24 * 60, 0) tot_min_taken
          from (select x.eod_date,
                       min(x.start_time) start_time,
                       max(x.end_time) end_time,
                       round((max(x.end_time) - min(x.start_time)), 2) * 24 * 60 tot_min_taken
                  from aetb_eoc_runchart_history x
                  left join aetm_eoc_group_branches y on x.branch_code =
                                                         y.branch_code
                 group by x.eod_date
                union all
                select i.eod_date,
                       min(i.start_time) start_time,
                       max(i.end_time) end_time,
                       round((max(i.end_time) - min(i.start_time)), 2) * 24 * 60 tot_min_taken
                  from aetb_eoc_runchart i
                  left join aetm_eoc_group_branches j on i.branch_code =
                                                         j.branch_code
                 group by i.eod_date)
         group by eod_date,start_time,end_time)
 where eod_date = TO_DATE('&EODDATE', 'DD-MON-YYYY')
 order by start_time;

PROMPT batch timings lower version (>11 <12)

select a.*,
       TO_CHAR(starttime, 'DD-MON-YYYY HH24:MI:SS') start_time,
       TO_CHAR(endtime, 'DD-MON-YYYY HH24:MI:SS') end_time
  from aetb_process_progress a
  where a.starttime >= TO_DATE('&EODDATE', 'DD-MON-YYYY');


PROMPT full batch timings with group code for 11x sites

 select *
  from (select x.eod_date,
               y.group_code,
               x.branch_code,
               x.branch_date,
               x.eoc_stage,
               x.eoc_batch,
               x.eoc_batch_status,
               TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
               TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
               round((x.end_time - x.start_time) * 24 * 60, 2) tot_min_taken
			from aetb_eoc_programs_history x 
			left join aetm_eoc_group_branches y on (x.branch_code = y.branch_code)
		union all	
			select i.eod_date,
				j.group_code,
				i.branch_code,
				i.branch_date,
				i.eoc_stage,
				i.eoc_batch,
				i.eoc_batch_status,
				TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
				TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
				round((i.end_time - i.start_time) * 24 * 60, 2) tot_min_taken
				from aetb_eoc_programs i
				left join aetm_eoc_group_branches j on (i.branch_code = j.branch_code)
        )
 where eod_date = TO_DATE('&EODDATE', 'DD-MON-YYYY')
 order by start_time;


PROMPT Groupwise/Branchwise/stage wise timings 

 select *
  from (select group_code,
			   branch_code,
               eod_date,
               eoc_stage,
               TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
               TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
               tot_min_taken
          from (select y.group_code,
					   x.branch_code,
                       x.eod_date,
                       x.eoc_stage,
                       min(x.start_time) start_time,
                       max(x.end_time) end_time,
                       round((max(x.end_time) - min(x.start_time)) * 24 * 60,
                             2) tot_min_taken
                from aetb_eoc_runchart_history x
				left join aetm_eoc_group_branches y on x.branch_code =
                                                         y.branch_code
                group by y.group_code, x.branch_code, x.eod_date, x.eoc_stage
                union all
                select j.group_code,
					   i.branch_code,
                       i.eod_date,
                       i.eoc_stage,
                       min(i.start_time) start_time,
                       max(i.end_time) end_time,
                       round((max(i.end_time) - min(i.start_time)) * 24 * 60,
                             2) tot_min_taken
                from aetb_eoc_runchart i
				left join aetm_eoc_group_branches j on i.branch_code = j.branch_code
                group by j.group_code, i.branch_code, i.eod_date, i.eoc_stage))
 where eod_date = TO_DATE('&EODDATE', 'DD-MON-YYYY')
 order by start_time;

PROMPT full batch timings with group code 

 select *
  from (select x.eod_date,
               y.group_code,
               x.branch_code,
               x.branch_date,
               x.eoc_stage,
               x.eoc_batch,
               x.eoc_batch_status,
               TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
               TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
               round((x.end_time - x.start_time) * 24 * 60, 2) tot_min_taken
			from aetb_eoc_programs_history x 
			left join aetm_eoc_group_branches y on (x.branch_code = y.branch_code)
		union all	
			select i.eod_date,
				j.group_code,
				i.branch_code,
				i.branch_date,
				i.eoc_stage,
				i.eoc_batch,
				i.eoc_batch_status,
				TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
				TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME,
				round((i.end_time - i.start_time) * 24 * 60, 2) tot_min_taken
				from aetb_eoc_programs i
				left join aetm_eoc_group_branches j on (i.branch_code = j.branch_code)
        )
 where eod_date = TO_DATE('&EODDATE', 'DD-MON-YYYY')
 order by start_time;

PROMPT  stage wise timings
 
select *
  from (select eod_date, eoc_stage, TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') START_TIME,
               TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') END_TIME, tot_min_taken
          from (select x.eod_date,
                       x.eoc_stage,
                       min(x.start_time) start_time,
                       max(x.end_time) end_time,
                       round((max(x.end_time) - min(x.start_time)) * 24 * 60,
                             2) tot_min_taken
                  from aetb_eoc_runchart_history x
                 group by x.eod_date, x.eoc_stage
                union all
                select i.eod_date,
                       i.eoc_stage,
                       min(i.start_time) start_time,
                       max(i.end_time) end_time,
                       round((max(i.end_time) - min(i.start_time)) * 24 * 60,
                             2) tot_min_taken
                  from aetb_eoc_runchart i
                 group by i.eod_date, i.eoc_stage))
 where eod_date = TO_DATE('&EODDATE', 'DD-MON-YYYY')
 order by start_time;
 
 spool off