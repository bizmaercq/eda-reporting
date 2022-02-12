accept uid PROMPT 'Enter the FCCLIVE schema name ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SET SERVEROUTPUT ON
set SQLP 'DBA>'
set TI on
set underline ~

set feedback off
set echo off

Prompt we have to add query to get chained rows from user_tables and profile related queries

PROMPT 			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PROMPT 						********Do not remove any formating option********
PROMPT
PROMPT 							This script needs to be run as a sys user 
PROMPT
PROMPT 							Provide FCC schema name when prompted
PROMPT
PROMPT 						This script create 1 files in the area or location provided by user
PROMPT
PROMPT 								1.  DB_Details_Utilization.spl
PROMPT
PROMPT  					Kindly make sure there is enough space in the location provided
PROMPT 
PROMPT 			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
define drive='c:'
define sep='\'
define name='DB_Details_Utilization.spl'
Prompt
Prompt
Prompt
Prompt
Prompt 'Default location of spool is under C Drive (c:\) '
Prompt 
Prompt
Prompt
Prompt
prompt Dynamically you can also provide spool location =>
prompt
PROMPT
prompt 'Example : ( D:\spool_location for Windows) and ( /ora3/dev/spool_location for LINUX/UNIX )'
prompt
prompt 
Accept drive PROMPT 'Enter the (Directory with / if "UNIX/LINUX") or (Drive with colon) =>'
PROMPT
PROMPT
PROMPT
prompt 'Example : ( \ for Windows) or ( / for LINUX/UNIX )'
prompt
prompt 
Accept sep prompt 'Enter the directory seperator for(\ for Windows or / for UNIX/LINUX ) =>'

spool  &drive&sep&name

PROMPT ------------------------------- Database component information -------------------------------

set feedback on
set echo on

select sysdate from dual;

select	to_char(startup_time, 'HH24:MI DD-MON-YY') "Startup time"
from	v$instance;

show user;
show user;
show user;

col comp_name format a40
col status format a10
col version format a10
SELECT comp_name, status, version FROM dba_registry;

PROMPT MTS SETTINGS
select * from v$shared_server_monitor;

PROMPT virtual circuits(to check user connections to the database through dispatchers and servers based on load on each circuit)

select sum(MESSAGES) "Total_MESSAGES",round(sum(BYTES)/1024/1024,2) "Size_MB",sum(BREAKS) total_interruptions,
QUEUE,STATUS,CIRCUIT,PRESENTATION Presentation_protocol from V$circuit group by QUEUE,STATUS,CIRCUIT,PRESENTATION order by QUEUE,STATUS,CIRCUIT,PRESENTATION ;

Prompt Shared server processes(gives load profile of shared server)

select sum(MESSAGES) total_MESSAGES,round(sum(BYTES)/1024/1024,2) total_message_size_MB,sum(BREAKS) total_BREAKS,round(sum(IDLE)/100,2) total_idle_time_sec,round(sum(BUSY)/100,2) total_busy_time_sec,round(sum(REQUESTS)/100,2) total_REQUESTS,STATUS,NAME from V$SHARED_SERVER group by STATUS,NAME order by NAME,status;



Prompt Dispatcher processes
Select * from V$DISPATCHER;

Prompt Shared server message queues
select sum(queued) total_item_in_queue,sum(wait),sum(totalq) total_items_ever_Q,type from V$queue group by Type order by Type;

Prompt Statistics for a number of activities performed by the dispatcher processes
select * from v$dispatcher_rate;

Prompt Below query used to identiify JAVA installed on the database or not. If the o/p is greater than 9000, Java is installed
select 	count(*)
from 	all_objects
where 	object_type like '%JAVA%'
and 	owner = 'SYS';

set feedback off
set echo off

PROMPT --------------------------------------- DATABASE PRIVILEDGES AND USERS PROFILE ---------------------------------------

set feedback on
set echo on

PROMPT DATABASE PROFILES
Select * from dba_profiles order by profile;

col GRANTEE format a20;
col OWNER format a20;
col GRANTOR format a20;
col PRIVILEGE format a20;

select * from DBA_TAB_PRIVS
where upper(grantee)=upper('&uid');

select * from DBA_SYS_PRIVS
where upper(grantee)=upper('&uid');

select * from DBA_ROLE_PRIVS
where upper(grantee)=upper('&uid');

column EXTERNAL_NAME format a200;

PROMPT DATABASE USERS

col USERNAME format a20;
col DEFAULT_TABLESPACE  format a20;
col TEMPORARY_TABLESPACE format a20;
col PROFILE format a15;

col USER_ID format 9999.9
col EXTERNAL_NAME format a15;

Select * from dba_users;

PROMPT DBA_TS_QUOTAS
col TABLESPACE_NAME format a25;
col TABLESPACE_NAME format a25;

Select * from Dba_ts_quotas;

SELECT username,
       default_tablespace,
       temporary_tablespace,
       profile,
       granted_role,
       admin_option,
       default_role
  FROM sys.dba_users a, sys.dba_role_privs b
 WHERE a.username = b.grantee
 ORDER BY username,
          default_tablespace,
          temporary_tablespace,
          profile,
          granted_role;

set feedback off
set echo off
PROMPT ---------------------------- DATABASE STATUS AND FEATURES ----------------------------

set feedback on
set echo on

set pages 10000
set lines 10000

PROMPT DATABASE FEATURES

select	name,detected_usages from dba_feature_usage_statistics where detected_usages > 0;

Prompt Options that are installed with the Oracle Database
Select * from v$option;

Prompt Information about the database from the control file
Select * from v$database;

col HOST_NAME format a25;

Prompt State of the current instance
Select * from v$instance;

PROMPT NLS_PARAMETERS
select * from v$nls_parameters;

PROMPT ORACLE VERSION 
select * from v$version;

PROMPT LICENSE DETAILS
Select * from V$LICENSE;

PROMPT RESOURCE LIMIT
select * from v$resource_limit;

col NUM format 9999.9
col NAME format a26;
col TYPE format 99.99
col VALUE format a35;
col DISPLAY_VALUE format a25;
col DESCRIPTION format a35;
col UPDATE_COMMENT format a15;

select * from v$parameter
where name in
(
'shared_pool_size','shared_pool_reserved_size','large_pool_size',
'cursor_space_for_time','cursor_sharing','session_cached_cursors','open_cursors'
);

Prompt Initialization parameters that are currently in effect for the instance.
col NAME format a40;
col VALUE  format a50;
col DESCRIPTION format a200;

select name,value,ismodified,isdefault,isses_modifiable,issys_modifiable,isadjusted,description from V$SYSTEM_PARAMETER order by name;

PROMPT PARAMETERS for RAC
col name format a35
col VALUE format a75
col DESCRIPTION format a75
col isses_modifiable format a8
col issys_modifiable format a10
col isadjusted format a9

PROMPT ISDEFAULT IS FALSE if  parameter value was specified in the parameter file
col INST_ID format 99.99

select inst_id,name,value,ismodified,isdefault,isses_modifiable,issys_modifiable,isadjusted,description from gv$parameter order by name;

col DISPLAY_VALUE format a50

PROMPT ISMODIFIED MODIFIED - Parameter has been modified with ALTER SESSION,SYSTEM_MOD - Parameter has been modified with ALTER SYSTEM,•FALSE - Parameter has not been modified after instance startup

select inst_id,name,display_value,isdeprecated,isinstance_modifiable from Gv$parameter where ISDEPRECATED='TRUE';

PROMPT SPINIT PARAMETERS with formating options as per 10g 
col NAME format a35;
col VALUE format a50;
col DISPLAY_VALUE format a50;
col UPDATE_COMMENT format a50;
col SID format a5;
select * from v$spparameter;

PROMPT SPINIT important Parameters
select * from v$spparameter
where name in
(
'shared_pool_size','shared_pool_reserved_size','large_pool_size',
'cursor_space_for_time','cursor_sharing','session_cached_cursors','open_cursors'
);

set feedback off
set echo off
PROMPT ---------------------------- DATABASE REDO AND UNDO DATA ----------------------------

set feedback on
set echo on

Prompt Total Database Size

col "Database Size" format a20
col "Free space" format a20
col "Used space" format a20
select	round(sum(used.bytes) / 1024 / 1024 / 1024 ) || ' GB' "Database Size"
,	round(sum(used.bytes) / 1024 / 1024 / 1024 ) - 
	round(free.p / 1024 / 1024 / 1024) || ' GB' "Used space"
,	round(free.p / 1024 / 1024 / 1024) || ' GB' "Free space"
from    (select	bytes
	from	v$datafile
	union	all
	select	bytes
	from 	v$tempfile
	union 	all
	select 	bytes
	from 	v$log) used
,	(select sum(bytes) as p
	from dba_free_space) free
group by free.p;


select sum(bytes)/1024/1024 Size_MB,owner,tablespace_name,status from DBA_UNDO_EXTENTS group by owner,tablespace_name,status order by size_Mb,owner,tablespace_name,status ;

prompt Queries using Undo more then undo retention limit 

Select b.MAXQUERYLEN "max query length in sec" ,b.tuned_undoretention "Purposed undo retention",b.maxqueryid,a.hash_value, a.sql_text ,to_char(b.begin_time,'DD-MON-YYYY HH24:MI:SS') starttime,
       to_char(b.end_time,'DD-MON-YYYY HH24:MI:SS') endtime 
from v$sqltext a,v$undostat b
where a.sql_id = b.maxqueryid and b.MAXQUERYLEN>(SELECT value FROM SYS.V_$PARAMETER WHERE NAME='undo_retention') AND ROWNUM<11
order by b.MAXQUERYLEN desc;

PROMPT RBS WAITSTATS
select class, count 
from v$WAITSTAT 
where CLASS in ('undo header','undo block','system undo header','system undo block');

PROMPT SYSSTATS 
select round(sum(value)/1024/1024,0) Statistics_value_MB,name Statistics_name,decode(class,1,'User',2,'Redo',4,'Enqueue',8,'Cache',16,'OS',32,'RAC',64,'SQL',128,'Debug','NULL')Statistics_Class	from v$sysstat having sum(value)/1024/1024>1 group by name,class	order by Statistics_value_MB desc;

PROMPT ROLLSTAT
select count(USN)count_RS,round(sum(rssize)/1024/1024,2) Size_RS_MB,round(sum(writes)/1024/1024,2) SIze_Written_RS_MB,sum(waits)Total_waits,latch from V$rollstat group by latch order by latch;

PROMPT USER USAGE
SELECT   r.name "RB NAME ", p.pid "ORACLE PID", 
         p.spid "SYSTEM PID ", NVL (p.username, 'NO TRANSACTION') "OS USER",  
         p.terminal 
FROM v$lock l, v$process p, v$rollname r, v$session s 
WHERE    l.sid = s.sid(+) 
AND      s.paddr = p.addr 
AND      TRUNC (l.id1(+)/65536) = r.usn 
AND      l.type(+) = 'TX' 
AND      l.lmode(+) = 6 
ORDER BY r.name; 

PROMPT SEGMENT STORAGE
select count(SEGMENT_ID),OWNER,INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,MAX_EXTENTS,PCT_INCREASE,INSTANCE_NUM,STATUS  from DBA_ROLLBACK_SEGS group by OWNER,INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,MAX_EXTENTS,PCT_INCREASE,INSTANCE_NUM,STATUS order by OWNER,INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,MAX_EXTENTS,PCT_INCREASE,INSTANCE_NUM,STATUS

PROMPT SEGMENT FREESPACE
select tablespace_name,sum(bytes/(1024*1024)) free_space_MB 
from dba_free_space
where tablespace_name like '%UNDO%'
group by tablespace_name
order by 2;

Prompt monitor rollback segment activity

SELECT rn.Name "Rollback Segment", rs.RSSize/1024/1024 "Size (MB)", rs.Gets "Gets",
       rs.waits "Waits", (rs.Waits/rs.Gets)*100 "% Waits",
       rs.Shrinks "# Shrinks", rs.Extends "# Extends"
FROM   sys.v_$rollName rn, sys.v_$rollStat rs
WHERE  rn.usn = rs.usn;

Prompt To check PGA Cache Hit depending on the  information of the workareas that whether they are being working/allocated in the memory or being swapped to the temp space
col c1 heading 'Workarea|Profile' format a35
col c2 heading 'Count' format 999,999,999
col c3 heading 'Percentage' format 999
select name c1,count c2,decode(total, 0, 0, round(count*100/total)) c3
from
(
select name,value count,(sum(value) over ()) total
from
v$sysstat
where
name like 'workarea exec%'
);
Prompt Redo Informations

SELECT * FROM V$LOGFILE;

SELECT * FROM V$LOG;

set feedback off
set echo off
PROMPT ---------------------------------------- DATABASE JOBS AND SCHEDULER INFORMATION ----------------------------------------

set feedback on
set echo on


PROMPT Running JOBS
Select * from dba_jobs_running;

Prompt Jobs

col INTERVAL format a30
col WHAT format a65
col SCHEMA_USER format a20;


PROMPT DB LINKS
col DB_LINK format a35;
col OWNER format a15
col HOST format a50;
Select * 
from dba_db_links
where upper(owner)=upper('&uid');


select * from Dba_scheduler_job_run_details where log_date >(sysdate-7) order by log_date desc;


select count(*),to_char(log_date,'MM-YYYY') Run_month from Dba_scheduler_job_run_details group by to_char(log_date,'MM-YYYY') order by to_date(Run_month,'MM-YYYY') desc;

set lines 32767
set pages 50000

PROMPT scheduler
column PROGRAM_OWNER format a20;
col CLIENT_ID format a15;
column PROGRAM_NAME  format a75;
column NLS_ENV   format a300; 
col SCHEDULE_LIMIT format a25;
col MAX_RUN_DURATION format a15;
column RAISE_EVENTS  format a100; 
col JOB_ACTION format a150;
col SCHEDULE_OWNER format a20;
col SCHEDULE_NAME format a20;
col REPEAT_INTERVAL format a50;
col EVENT_CONDITION format a20;
col SOURCE format a25;
col COMMENTS format a75;
col EVENT_QUEUE_AGENT format a15;
col EVENT_QUEUE_NAME format a15;
col DESTINATION format a25;
select * from Dba_Scheduler_jobs;

set lines 10000
set pages 10000

select * from Dba_scheduler_running_jobs;

col LOG_DATE  format a35;
col JOB_SUBNAME format a20;
col ADDITIONAL_INFO format a250;
col JOB_NAME format a25;
col LOG_ID format 9999999.999

select * from Dba_scheduler_job_log where log_date>(sysdate-7) order by log_date desc;

select count(*),to_char(log_date,'MM-YYYY') Run_month from Dba_scheduler_job_log group by to_char(log_date,'MM-YYYY') order by to_date(Run_month,'MM-YYYY') desc

col PROGRAM_NAME format a30;
col OWNER format a15;
col PROGRAM_ACTION format a50;
col COMMENTS format a60;

select * from Dba_scheduler_programs;

Prompt all schedules

col START_DATE  format a35;
col REPEAT_INTERVAL format a50;
col SCHEDULE_NAME format a35;

Select schedule_name, schedule_type, start_date, repeat_interval 
from dba_scheduler_schedules;

col DEFAULT_VALUE format a25
col DEFAULT_ANYDATA_VALUE() format a25
select * from dba_scheduler_program_args;

Prompt Information about all credentials in the database(Available only from  11g)
Select owner, credential_name, username from dba_scheduler_credentials;

col NAME format a40;
select owner,NAME Referring_object_Name,TYPE,REFERENCED_OWNER,REFERENCED_NAME,REFERENCED_TYPE,REFERENCED_LINK_NAME,DEPENDENCY_TYPE FROM DBA_DEPENDENCIES
where REFERENCED_NAME='DBMS_SCHEDULER';

select B.sid, B.job, a.what, a.schema_user,
b.this_date, b.this_sec 
from dba_jobs A, dba_jobs_running B
Where 	A.job(+) = B.job
order by schema_user, b.this_date, b.this_sec, b.job;

col WHAT format a200;
col SCHEMA_USER format a15;
col JOB format 9999999.999
Select job,broken,failures,interval,what,schema_user,last_date,last_sec,this_date,this_sec,next_date,next_sec,total_time from dba_jobs order by broken;

set feedback off
set echo off
PROMPT ------------------------------- DATABASE CONTROL FILE  DETAILS -------------------------------

set feedback on
set echo on


Prompt  Lists the names of the control files
Col NAME format a100;
select * from V$controlfile;

Prompt control file record sections
select * from v$controlfile_record_section;

set feedback off
set echo off
PROMPT ----------------------------------- DATABASE LOG FILE AND REDO  DETAILS -----------------------------------

set feedback on
set echo on

col MEMBER format a100;
Prompt Information about redo log files

select * from V$logfile;

Prompt Information from the control file
select * from v$log;
col LOG_FILE  format a150;
PROMPT LOGFILES DETAILS
select member log_file,	round(bytes/1024/1024,2) size_mb
from 	v$logfile f, v$log l
where	l.group# = f.group#
order by 1;

PROMPT RBS DETAILS
col SEGMENT_NAME format a35;
col TABLESPACE_NAME format a15;
col STATUS format a20;
col INIT_SIZE format 99999.999
select s.owner,s.segment_type,r.segment_name,r.tablespace_name,r.file_id, status,round((r.min_extents * r.initial_extent)/1024) init_size,
	round(bytes/1024 )Curr_size, round(r.next_extent/1024) next_size,
	round((r.max_extents * r.next_extent)/1024) max_size
from 	dba_segments s, dba_rollback_segs r
where s.segment_name= r.segment_name;

prompt count of log switches for last 20 day's 
select 
to_char(first_time,'dd-mon-rr'),
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'00',1,0)) as "00",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'01',1,0)) as "01",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'02',1,0)) as "02",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'03',1,0)) as "03",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'04',1,0)) as "04",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'05',1,0)) as "05",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'06',1,0)) as "06",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'07',1,0)) as "07",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'08',1,0)) as "08",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'09',1,0)) as "09",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'10',1,0)) as "10",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'11',1,0)) as "11",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'12',1,0)) as "12",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'13',1,0)) as "13",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'14',1,0)) as "14",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'15',1,0)) as "15",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'16',1,0)) as "16",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'17',1,0)) as "17",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'18',1,0)) as "18",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'19',1,0)) as "19",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'20',1,0)) as "20",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'21',1,0)) as "21",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'22',1,0)) as "22",
sum(decode(substr(to_char(first_time,'dd-mon-rr hh24:mi:ss'),11,2),'23',1,0)) as "23",
count(*) as total_log_switch
from 
v$log_history
where 
first_time>=(sysdate-20)
and
first_time<=sysdate
group by 
to_char(first_time,'dd-mon-rr');

set feedback off
set echo off
PROMPT ------------------------------------ DATABASE MEMORY SGA AND PGA  DETAILS ------------------------------------

set feedback on
set echo on


PROMPT  SGA STATISTICS

select * from V$SGA_DYNAMIC_FREE_MEMORY;

select * from V$SGA_CURRENT_RESIZE_OPS;

col CACHE# format 99999.999
col USAGE format 99999.999
col FIXED format  99999.999
col SUBORDINATE# format 99999.99
col COUNT format 99999.99
select * from v$rowcache;

col NAME format a25;
col VALUE format 999999999999999
select * from v$sga;

col VALUE format a20;
col DISPLAY_VALUE format a25;
col DESCRIPTION  format a45;
col UPDATE_COMMENT format a20;

select * from v$parameter
where name in
(
'log_buffer','java_pool_size',
'log_checkpoint_interval','log_checkpoint_timeout',
'log_archive_max_processes','backup_tape_io_slaves','log_checkpoints_to_alert',
'fast_start_mttr_target','fast_start_io_target','sga_max_size'
);

col NAME format a25;
col SID format a5;
col VALUE format a15;
col DISPLAY_VALUE format a15;.
col UPDATE_COMMENT format a20;

select * from v$spparameter
where name in
(
'log_buffer','java_pool_size',
'log_checkpoint_interval','log_checkpoint_timeout',
'log_archive_max_processes','backup_tape_io_slaves','log_checkpoints_to_alert',
'fast_start_mttr_target','fast_start_io_target','sga_max_size'
);


prompt shows Statistis stored in sgasts where there value is greater then 5 MB

col NAME format a35;
select POOL,NAME,round(BYTES/1024/1024,0) SIZE_MB from v$sgastat where bytes >(5*1024*1024 )order by bytes desc;

select * from v$shared_pool_reserved;

col STATISTIC# format 9999.99
col NAME format a50;
col CLASS format 9999.99
col VALUE format 99999999999
select statistic#,name,decode(Class,64,'SQL',1,'USER',2,'UNDO',4,'ENQUEUE',8,'CACHE',16,'OS',32,'RAC',128,'Debug'),round(value/1024/1024,0) size_MB,stat_id from V$sysstat  where value/1024/1024>5 order by value desc 

PROMPT PGAUSAGE
--ad hint on what a query is doing

select sum(bytes)/1024/1024 Mb
from  ( select bytes
 	     from v$sgastat
  	     union
  	     select value bytes
 	     from v$sesstat s,v$statname n
 	     where n.STATISTIC# = s.STATISTIC#
 	     and   n.name = 'session pga memory');


PROMPT PGAUSAGE
--ad hint on what a query is doing
select sum(value)/1024/1024 Mb
from v$sesstat s, v$statname n
where n.STATISTIC# = s.STATISTIC#
and   name = 'session pga memory';

PROMPT PGASTAT
col VALUE format 999999999999999
col NAME format a55;
Select * from v$pgastat order by value desc;

col NAMESPACE format a20;
prompt list namespaces which are  found in memory according to their availability (low to high)

select NAMESPACE,GETS,GETHITS,round(GETHITRATIO,2) Times_found_in_memory,PINS,PINHITS,round(PINHITRATIO,2) Times_metadata_found_in_mem,RELOADS,INVALIDATIONS,DLM_LOCK_REQUESTS,DLM_PIN_REQUESTS,DLM_PIN_RELEASES,DLM_INVALIDATION_REQUESTS,DLM_INVALIDATIONS from v$librarycache order by gethitratio asc;



select * from V$LIBRARY_CACHE_MEMORY;

col NAME format a25;
col ERROR format 999999;
select * from v$bgprocess where paddr<>'00';

col COMPONENT format a25;
col PARAMETER format a30;

select * from V$SGA_RESIZE_OPS;

col OPER_COUNT format a999.99
select * from V$SGA_DYNAMIC_COMPONENTS;

PROMPT SORT DETAILS
SELECT * FROM V$SORT_SEGMENT;

PROMPT SORT USAGE
col USERNAME format a30;
col USER format a30;
col TABLESPACE format a15;

SELECT * FROM V$SORT_USAGE;

PROMPT Displays the state of temporary space cached
col TABLESPACE_NAME format a10;
select * from v$temp_extent_pool;

set echo off
set feedback off
set linesize 512

prompt SGA Memory Map (overall)

column dummy      noprint
column area       format a20 heading 'Main SGA Areas'
column name       format a20
column pool       format a20
column bytes      format 999,999,999,999
column sum(bytes) format 999,999,999,999

break on report
compute sum of sum(bytes) on report

SELECT 1 dummy, 'DB Buffer Cache' area, name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'db_block_buffers'
group by name
union all
SELECT 2, 'Shared Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool'
group by pool
union all
SELECT 3, 'Large Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'large pool'
group by pool
union all
SELECT 4, 'Java Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'java pool'
group by pool
union all
SELECT 5, 'Redo Log Buffer', name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'log_buffer'
group by name
union all
SELECT 6, 'Fixed SGA', name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'fixed_sga'
group by name
ORDER BY 4 desc;


column area format a20 heading 'Shared Pool Areas'


prompt SGA Memory Map (shared pool)

SELECT 'Shared Pool' area, name, sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool' and
      name in ('library cache','dictionary cache','free memory','sql area')
group by name
union all
SELECT 'Shared Pool' area, 'miscellaneous', sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool' and
      name not in ('library cache','dictionary cache','free memory','sql area')
group by pool
order by 3 desc;

set echo on
set feedback on


PROMPT MEMORY ADVICE

select * from v$shared_pool_advice;

col ID format 999.99
col NAME format a20;
col BLOCK_SIZE format 999999.99
select * from v$db_cache_advice;

select * from V$PGA_TARGET_ADVICE;

select * from V$MTTR_TARGET_ADVICE;

select * from V$PGA_TARGET_ADVICE_HISTOGRAM;

set feedback off
set echo off
PROMPT ---------------------------- Database Buffer information ---------------------------- 

set feedback on
set echo on

PROMPT static information on buffer pool configuration
col ID format 999.999
col NAME format a20;
col BLOCK_SIZE format 99999.99
select * from v$buffer_pool;

select * from v$buffer_pool_statistics;

Prompt Identify Objects and Amount of Blocks in the Buffer Pools – Default, Keep, Recycle, nK Cache
select decode(pd.bp_id,1,'KEEP',2,'RECYCLE',3,'DEFAULT',
         4,'2K SUBCACHE',5,'4K SUBCACHE',6,'8K SUBCACHE',
         7,'16K SUBCACHE',8,'32KSUBCACHE','UNKNOWN') subcache,
         bh.object_name,bh.blocks
from x$kcbwds ds,x$kcbwbpd pd,(select /*+ use_hash(x) */ set_ds,
         o.name object_name,count(*) BLOCKS
         from obj$ o, x$bh x where o.dataobj# = x.obj
         and x.state !=0 and o.owner# !=0
         group by set_ds,o.name) bh 
where ds.set_id >= pd.bp_lo_sid
and ds.set_id <= pd.bp_hi_sid 
and pd.bp_size != 0 
and bp_id !=3  -- ADDED TO REMOVE OBJECTS WHICH ARE PRESENT IN DEFAULT SUBCACHE ,IF OBJECTS IN DEFAULTARE ALSO REQUIRED REMOVE THIS CONDITION 
and ds.addr=bh.set_ds;

set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
SET SERVEROUTPUT ON
col NAME format a29;
col VALUE format a15;
col UPDATE_COMMENT format a10;
col DESCRIPTION format a60;
col DISPLAY_VALUE format a15;
col NUM format 999.9
col TYPE format 9.99

select * from v$parameter
where name in
(
'db_block_size','db_cache_size','db_cache_advice','db_writer_processes','dbwr_io_slaves',
'db_2k_cache_size','db_4k_cache_size','db_8k_cache_size','db_16k_cache_size','db_32k_cache_size',
'db_keep_cache_size','db_recycle_cache_size','db_block_buffers','db_block_checksum','db_file_multiblock_read_count'
);

col SID format a5;

select * from v$spparameter
where name in
(
'db_block_size','db_cache_size','db_cache_advice','db_writer_processes','dbwr_io_slaves',
'db_2k_cache_size','db_4k_cache_size','db_8k_cache_size','db_16k_cache_size','db_32k_cache_size',
'db_keep_cache_size','db_recycle_cache_size','db_block_buffers','db_block_checksum','db_file_multiblock_read_count'
);


prompt Shared Pool LIBRARYCACHE

declare
	h_char          varchar2(100);
	h_char2		varchar(50);
	h_num1          number(25);
	result1         varchar2(50);
	result2         varchar2(50);

	cursor c1 is
        select lpad(namespace,17)||': gets(pins)='||rpad(to_char(pins),9)||
                                     ' misses(reloads)='||rpad(reloads,9)||
               ' Ratio='||decode(reloads,0,0,to_char((reloads/pins)*100,999.999))||'%'
        from v$librarycache;

begin
    dbms_output.put_line
    	('=================================================================================================');
    dbms_output.put_line('.                      SHARED POOL: LIBRARY CACHE (V$LIBRARYCACHE)');
    dbms_output.put_line
    	('=================================================================================================');
    dbms_output.put_line('.');
    dbms_output.put_line('.         Goal: The library cache ratio < 1%' );
    dbms_output.put_line('.');
    
    Begin
    	SELECT 'Current setting: '||substr(value,1,30) INTO result1
    	FROM V$PARAMETER	
    	WHERE NUM = 23;
    	SELECT 'Current setting: '||substr(value,1,30) INTO result2
    	FROM V$PARAMETER	
    	WHERE NUM = 325;
    EXCEPTION
    	WHEN NO_DATA_FOUND THEN 
    		h_num1 :=1;
    END;
    dbms_output.put_line('Recommendation: Increase SHARED_POOL_SIZE '||rtrim(result1));
    dbms_output.put_line('.                        OPEN_CURSORS '    ||rtrim(result2));
    dbms_output.put_line('.               Also write identical sql statements.');
    dbms_output.put_line('.');
        
    open c1;
    loop
	fetch c1 into h_char;
	exit when c1%notfound;
	
	dbms_output.put_line('.'||h_char);
    end loop;
    close c1;

    dbms_output.put_line('.');

    select lpad('Total',17)||': gets(pins)='||rpad(to_char(sum(pins)),9)||
                                 ' misses(reloads)='||rpad(sum(reloads),9),
               ' Your library cache ratio is '||
                decode(sum(reloads),0,0,to_char((sum(reloads)/sum(pins))*100,999.999))||'%'
    into h_char,h_char2
    from v$librarycache;
    dbms_output.put_line('.'||h_char);
    dbms_output.put_line('.           ..............................................');
    dbms_output.put_line('.           '||h_char2);

    dbms_output.put_line('.');
end;
/



declare
        h_num1          number(25);
        h_num2          number(25);
        h_num3          number(25);
        result1         varchar2(50);

begin
    dbms_output.put_line
    	('=================================================================================================');
        dbms_output.put_line('.                      SHARED POOL: DATA DICTIONARY (V$ROWCACHE)');
    dbms_output.put_line
    	('=================================================================================================');
        dbms_output.put_line('.');
        dbms_output.put_line('.         Goal: The row cache ratio should be < 10% or 15%' );
        dbms_output.put_line('.');
        dbms_output.put_line('.         Recommendation: Increase SHARED_POOL_SIZE '||result1);
        dbms_output.put_line('.');

        select sum(gets) "gets", sum(getmisses) "misses", round((sum(getmisses)/sum(gets))*100 ,3)
        into h_num1,h_num2,h_num3
        from v$rowcache;

        dbms_output.put_line('.');
        dbms_output.put_line('.             Gets sum: '||h_num1);
        dbms_output.put_line('.        Getmisses sum: '||h_num2);

        dbms_output.put_line('         .......................................');
        dbms_output.put_line('.        Your row cache ratio is '||h_num3||'%');

end;
/

declare
        h_char          varchar2(100);
        h_num1          number(25);
        h_num2          number(25);
        h_num3          number(25);
        h_num4          number(25);
        result1         varchar2(50);
begin
    dbms_output.put_line('.');
    dbms_output.put_line
    	('=================================================================================================');
        dbms_output.put_line('.                      BUFFER CACHE (V$SYSSTAT)');
    dbms_output.put_line
    	('=================================================================================================');
        dbms_output.put_line('.');
        dbms_output.put_line('.         Goal: The buffer cache ratio should be > 70% ');
        dbms_output.put_line('.');
	Begin
    		SELECT 'Current setting: '||substr(value,1,30) INTO result1
    		FROM V$PARAMETER	
    		WHERE NUM = 125;
    	EXCEPTION
    	WHEN NO_DATA_FOUND THEN 
    		result1 := 'Unknown parameter';
	END;
        dbms_output.put_line('.          Recommendation: Increase DB_BLOCK_BUFFERS '||result1);
        dbms_output.put_line('.');

        select lpad(name,15)  ,value
        into h_char,h_num1
        from v$sysstat
        where name ='db block gets';
        dbms_output.put_line('.         '||h_char||': '||h_num1);

        select lpad(name,15)  ,value
        into h_char,h_num2
        from v$sysstat
        where name ='consistent gets';
        dbms_output.put_line('.         '||h_char||': '||h_num2);

        select lpad(name,15)  ,value
        into h_char,h_num3
        from v$sysstat
        where name ='physical reads';
        dbms_output.put_line('.         '||h_char||': '||h_num3);

        h_num4:=round(((1-(h_num3/(h_num1+h_num2))))*100,3);

        dbms_output.put_line('.          .......................................');
        dbms_output.put_line('.          Your buffer cache ratio is '||h_num4||'%');

    dbms_output.put_line('.');
end;
/

declare
        h_char          varchar2(100);
        h_num1          number(25);
        h_num2          number(25);
        h_num3          number(25);

        cursor buff2 is
        SELECT name
                ,consistent_gets+db_block_gets, physical_reads
                ,DECODE(consistent_gets+db_block_gets,0,TO_NUMBER(null)
                ,to_char((1-physical_reads/(consistent_gets+db_block_gets))*100, 999.999))
        FROM v$buffer_pool_statistics;
begin
     dbms_output.put_line
    	('=================================================================================================');
        dbms_output.put_line('.                      BUFFER CACHE (V$buffer_pool_statistics)');
    dbms_output.put_line
    	('=================================================================================================');

        dbms_output.put_line('.');
        dbms_output.put_line('.');
        dbms_output.put_line('Buffer Pool:         Logical_Reads     Physical_Reads        HIT_RATIO');
        dbms_output.put_line('.');

        open buff2;
        loop
            fetch buff2 into h_char, h_num1, h_num2, h_num3;
            exit when buff2%notfound;

	    dbms_output.put_line(rpad(h_char, 15, '.')||'         '||lpad(h_num1, 10, ' ')||'         '||
	    	lpad(h_num2, 10, ' ')||'       '||lpad(h_num3, 10, ' '));

        end loop;
        close buff2;

    dbms_output.put_line('.');
end;
/
set feedback off
set echo off
PROMPT ---------------------------- BACKUP AND RECOVERY SETUP ----------------------------

set feedback on
set echo on

set lines 10000
set pages 10000

select * from v$instance_recovery;

prompt predict the number of physical I/Os for MTTR

select * from V$MTTR_TARGET_ADVICE;


col SID format a5;
col NAME format a30;
col VALUE format a20;
col DISPLAY_VALUE format a20;
col UPDATE_COMMENT format a15;

select * from v$spparameter where name like 'log_archive%';

col DEST_NAME format a20;
col DEST_ID format 99.99;
col DESTINATION format a25;
col ERROR format 9
col ALTERNATE format a15;
col DEPENDENCY  format a10;
col REMOTE_TEMPLATE a10;


select * from v$archive_dest;

prompt Actual archive log
select * from v$archive_processes;


Prompt runtime and configuration information for the archived redo log destinations
col DEST_NAME format a20;
col DEST_ID format 99.99;
col DESTINATION format a80;
col ERROR format a50
col ALTERNATE format a15;
col DEPENDENCY  format a10;
col REMOTE_TEMPLATE format a10;

select * from v$archive_dest_status;

select * from V$BACKUP where status='ACTIVE';

Prompt Corrupt block ranges in datafile backups from the control file
select * from V$BACKUP_CORRUPTION;

prompt Control files and datafiles in backup sets from the control file harsh tuned added date
--select * from V$BACKUP_DATAFILE ;
select * from V$BACKUP_DATAFILE where CHECKPOINT_TIME >(sysdate-7);

Prompt Database blocks that were corrupted after the last backup
select * from V$DATABASE_BLOCK_CORRUPTION;

Prompt datafile copy corruptions from the control file
select * from V$COPY_CORRUPTION;

select * from V$DATABASE_INCARNATION;

col DEVICE_NAME format a30;

select * from V$BACKUP_DEVICE;

prompt harsh changes
--select * from V$BACKUP_PIECE;
select * from V$BACKUP_PIECE where START_TIME  >(sysdate-7);

select * from V$BACKUP_REDOLOG;

select * from V$BACKUP_SET;

select * from V$RMAN_CONFIGURATION;

select * from V$RECOVER_FILE;

select * from V$RECOVERY_FILE_STATUS;

select * from V$RECOVERY_LOG;

select * from V$RECOVERY_PROGRESS;

select * from V$RECOVERY_STATUS;

Prompt Users who have been granted SYSDBA and SYSOPER privileges
select * from V$PWFILE_USERS;

select * from V$FAST_START_SERVERS;

select * from V$FAST_START_TRANSACTIONS;

select * from V$DATABASE_BLOCK_CORRUPTION;


set feedback off
set echo off
prompt ---------------------------- Database Information on Load ----------------------------

set feedback on
set echo on

PROMPT HIGH LOADS  --QUERY
col USERNAME format a20;
col SQL_TEXT format a150;
 
SELECT A.USERNAME,C.EXECUTIONS,C.DISK_READS,C.LOADS,C.SQL_TEXT 
FROM DBA_USERS A, V$SESSION B, V$SQLAREA C
WHERE C.PARSING_USER_ID=A.USER_ID AND C.ADDRESS=B.SQL_ADDRESS(+) AND
C.LOADS > 50
ORDER BY C.EXECUTIONS DESC;

PROMPT LOADS  --SYSTEM WAITS
select * from v$waitstat where count<>0;

col EVENT format a35;
col WAIT_CLASS# format 9.99;

select * from v$system_event;

column load format a6 justify right
column executes format 9999999
break on load on executes skip 1

select
  substr(to_char(s.pct, '99.00'), 2) || '%'  load,
  s.executions  executes,
  p.sql_text
from
  ( 
    select
      address,
      buffer_gets,
      executions,
      pct,
      rank() over (order by buffer_gets desc)  ranking
    from
      ( 
	select
	  address,
	  buffer_gets,
	  executions,
	  100 * ratio_to_report(buffer_gets) over ()  pct
	from
	  sys.v_$sql
	where
	  command_type != 47
      )
    where
      buffer_gets > 50 * executions
  )  s,
  sys.v_$sqltext  p
where
  s.ranking <= 5 and
  p.address = s.address
order by
  1, s.address, p.piece ;

PROMPT Session Waitclass Statistics


col sesid format a21 wrap head 'Ses ID'
col wait_class format a11 wrap head 'Wait|Class'
col sumtotwaits format 9,999,990 head 'Sum|Tot|Waits'
col sumtimwaited format 999,999,990 head 'Sum|Time|Waited'
col username format a12 wrap
break on sesid skip 1 on report
compute sum of sumtimwaited on sesid
compute sum of sumtimwaited on report

select
 swc.sid || ',' ||  swc.serial# || ' ' || s.username sesid,
 swc.wait_class,
 sum(swc.total_waits) sumtotwaits,
 sum(swc.time_waited) sumtimwaited
from
 v$session_wait_class swc,
 v$session s
where
 swc.sid = s.sid and
 swc.serial# = s.serial# and
 s.username is not null and
 swc.wait_class != 'Idle'
group by
 swc.sid || ',' ||  swc.serial# || ' ' || s.username,
 swc.wait_class
order by
 1, 4 desc
/

set echo on feed on
clear col
clear break


PROMPT WAITSTATS
select * from V$WAITSTAT order by time desc;

prompt Summary of Current Cursor Usage
col name format a25

select min(value) min, max(value) max, avg(value) avg
from   sys.v_$sesstat
where  statistic# = (select statistic#
                       from sys.v_$statname
                      where name like 'opened cursors current');

prompt Top 10 Users With Most Open Cursors
col program  format a15 trunc
col osuser   format a15 trunc
col username format a15 trunc

select * from (
  select s.sid, s.username, s.osuser, s.program, v.value "Open
Cursors"
  from   sys.v_$sesstat v,  sys.v_$session s
  where  v.sid        = s.sid
    and  v.statistic# = (select statistic#
                       from sys.v_$statname
                      where name like 'opened cursors current')
  order  by v.value desc
)
where rownum < 11;


DECLARE
  v_value  NUMBER;

  FUNCTION Format(p_value  IN  NUMBER) 
    RETURN VARCHAR2 IS
  BEGIN
    RETURN LPad(To_Char(Round(p_value,2),'990.00') || '%',8,' ') || '  ';
  END;

BEGIN

  -- --------------------------
  -- Dictionary Cache Hit Ratio
  -- --------------------------
  SELECT (1 - (Sum(getmisses)/(Sum(gets) + Sum(getmisses)))) * 100
  INTO   v_value
  FROM   v$rowcache;

  DBMS_Output.Put('Dictionary Cache Hit Ratio       : ' || Format(v_value));
  IF v_value < 90 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 90%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

  -- -----------------------
  -- Library Cache Hit Ratio
  -- -----------------------
  SELECT (1 -(Sum(reloads)/(Sum(pins) + Sum(reloads)))) * 100
  INTO   v_value
  FROM   v$librarycache;

  DBMS_Output.Put('Library Cache Hit Ratio          : ' || Format(v_value));
  IF v_value < 99 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 99%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

  -- -------------------------------
  -- DB Block Buffer Cache Hit Ratio
  -- -------------------------------
  SELECT (1 - (phys.value / (db.value + cons.value))) * 100
  INTO   v_value
  FROM   v$sysstat phys,
         v$sysstat db,
         v$sysstat cons
  WHERE  phys.name  = 'physical reads'
  AND    db.name    = 'db block gets'
  AND    cons.name  = 'consistent gets';

  DBMS_Output.Put('DB Block Buffer Cache Hit Ratio  : ' || Format(v_value));
  IF v_value < 89 THEN
    DBMS_Output.Put_Line('Increase DB_BLOCK_BUFFERS parameter to bring value above 89%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;
  
  -- ---------------
  -- Latch Hit Ratio
  -- ---------------
  SELECT (1 - (Sum(misses) / Sum(gets))) * 100
  INTO   v_value
  FROM   v$latch;

  DBMS_Output.Put('Latch Hit Ratio                  : ' || Format(v_value));
  IF v_value < 98 THEN
    DBMS_Output.Put_Line('Increase number of latches to bring the value above 98%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  -- -----------------------
  -- Disk Sort Ratio
  -- -----------------------
  SELECT (disk.value/mem.value) * 100
  INTO   v_value
  FROM   v$sysstat disk,
         v$sysstat mem
  WHERE  disk.name = 'sorts (disk)'
  AND    mem.name  = 'sorts (memory)';

  DBMS_Output.Put('Disk Sort Ratio                  : ' || Format(v_value));
  IF v_value > 5 THEN
    DBMS_Output.Put_Line('Increase SORT_AREA_SIZE parameter to bring value below 5%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;
  
  -- ----------------------
  -- Rollback Segment Waits
  -- ----------------------
  SELECT (Sum(waits) / Sum(gets)) * 100
  INTO   v_value
  FROM   v$rollstat;

  DBMS_Output.Put('Rollback Segment Waits           : ' || Format(v_value));
  IF v_value > 5 THEN
    DBMS_Output.Put_Line('Increase number of Rollback Segments to bring the value below 5%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  -- -------------------
  -- Dispatcher Workload
  -- -------------------
  SELECT NVL((Sum(busy) / (Sum(busy) + Sum(idle))) * 100,0)
  INTO   v_value
  FROM   v$dispatcher;

  DBMS_Output.Put('Dispatcher Workload              : ' || Format(v_value));
  IF v_value > 50 THEN
    DBMS_Output.Put_Line('Increase MTS_DISPATCHERS to bring the value below 50%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;
  
END;
/

PROMPT
SET FEEDBACK ON

prompt ------------------------------ Database Information IO usage ------------------------------

set pages 10000
set lines 10000
col statement format a30 wrap
col username format a10 trunc

select b.sql_text "Statement ",
a.Disk_reads "Disk Reads",
a.executions "Executions",
a.disk_reads/decode(a.executions,0,1,a.executions) "Ratio",
c.username from  v$sqlarea a,
		 v$sqltext_with_newlines b,
		 dba_users c
where 	a.parsing_user_id = c.user_id
	and a.address=b.address
	and a.disk_reads>100000
order by a.disk_reads desc,b.piece,a.executions desc;

PROMPT Database CPU Usage

set pages 10000
set lines 10000
col statement format a30 wrap
col username format a10 trunc
select b.sql_text "Statement ",a.buffer_gets "BUffer Gets",
a.executions "Executions",
a.buffer_gets/decode(a.executions,0,1,a.executions) "Ratio",
c.username from  v$sqlarea a,
		 v$sqltext_with_newlines b,
		 dba_users c
where 	a.parsing_user_id = c.user_id
	and a.address=b.address
	and a.buffer_gets>1 and 
	rownum<=30
order by a.buffer_gets desc,b.piece,a.executions desc;
PROMPT SQL with high disk reads

SELECT   disk_reads, sql_text
    FROM v$sqlarea
   WHERE disk_reads > 1000
ORDER BY disk_reads DESC;

Prompt IO COST
col c1 heading 'Average Waits|forFull| Scan Read I/O'        format 9999.999
col c2 heading 'Average Waits|for Index|Read I/O'            format 9999.999
col c3 heading 'Percent of| I/O Waits|for Full Scans'        format 9.99
col c4 heading 'Percent of| I/O Waits|for Index Scans'       format 9.99
col c5 heading 'Starting|Value|for|optimizer|index|cost|adj' format 999



select
   a.average_wait                                  c1,
   b.average_wait                                  c2,
   a.total_waits /(a.total_waits + b.total_waits)  c3,
   b.total_waits /(a.total_waits + b.total_waits)  c4,
   (b.average_wait / a.average_wait)*100           c5
from
  v$system_event  a,
  v$system_event  b
where
   a.event = 'db file scattered read'
and
   b.event = 'db file sequential read';

set pages 10000
set lines 10000
col THREAD# format 99999.999
col INSTANCE format a20;
select * from V$THREAD;

prompt top 50 objects accessed in database 

col owner  format a20 trunc
col object_name    format a30
col touches        format 9,999,999

select     *
from       (
   select  count(*)
   ,       sum(tch) TOUCHES
   ,       u.name OWNER
   ,       o.name OBJECT_NAME
   from    x$bh x
   ,       obj$ o
   ,       user$ u
   where   x.obj = o.obj#
   and     o.owner# = u.user#
   group   by u.name, o.name
   order by 2 desc
   )
where      rownum < 51
/


prompt  the top ten of the segments in terms of the  application ("row lock waits") and ITL TX enqueues ("ITL waits")
prompt 		
prompt 		
SELECT * FROM
   (SELECT OBJECT_NAME, SUBSTR(STATISTIC_NAME, 1, 30), VALUE
   FROM V$SEGMENT_STATISTICS
   WHERE STATISTIC_NAME = 'ITL waits' OR
         STATISTIC_NAME = 'row lock waits'
   ORDER BY VALUE DESC )
WHERE ROWNUM <=10;


set feedback off
set echo off

PROMPT ---------------------------- FCC SCHEMA INFO ---------------------------- 

set feedback on
set echo on

Prompt Tables whose stats are locked

select table_name,num_rows,sample_size,last_analyzed,global_stats,user_stats,stattype_locked,stale_stats,partition_name from user_tab_statistics WHERE stattype_locked is not null;

Prompt Indexes whose stats are locked

select index_name,table_name,num_rows,sample_size,last_analyzed,global_stats,user_stats,stattype_locked,stale_stats,partition_name from user_ind_statistics WHERE stattype_locked is not null;

PROMPT OBJECT_COUNT
Select object_type, count(*) 
from dba_objects
where upper(owner)=upper('&uid')
group by object_type;

PROMPT INVALID OBJECT_COUNT
Select object_type, count(*) 
from dba_objects 
where upper(owner)=upper('&uid')
and status='INVALID'
group by object_type;

PROMPT INVALID OBJECT_COUNT All including SYS..required for bug workaround verification
Select owner,object_type, count(*) 
from dba_objects 
where status='INVALID'
group by owner,object_type;


PROMPT INVALID OBJECT_COUNT SYS
Select object_type, count(*) 
from dba_objects 
where upper(owner)=upper('&uid')
and status='INVALID'
group by object_type;

set lines 10000
set pages 10000
PROMPT INVALID OBJECT DETAILS

col OWNER format a20;
col OBJECT_NAME format a60;

/*
Select owner,object_name, object_type, object_id, created, last_ddl_time
from dba_objects
where status ='INVALID'
order by owner,object_type;
*/

Select owner,object_type,count(*)
from dba_objects
where status ='INVALID'
group by owner,object_type;


PROMPT HISTOGRAMS
select distinct table_name
from ( select table_name 
       from dba_tab_columns 
       where histogram!='NONE'
       and upper(owner)=upper('&uid'));

PROMPT TABLE STATISTICS
select to_char(last_analyzed,'dd-mon-rrrr'),count ( * ) from dba_tables
where upper(owner)=upper('&uid')
group by to_char(last_analyzed,'dd-mon-rrrr');

PROMPT INDEX STATISTICS
select to_char(last_analyzed,'dd-mon-rrrr'),count ( * ) from dba_indexes
where upper(owner)=upper('&uid')
group by to_char(last_analyzed,'dd-mon-rrrr');

PROMPT UNUSABLE INDEXES
Select index_name, status 
from dba_indexes
where upper(owner)=upper('&uid')
and status in ('UNUSABLE','N/A');

PROMPT UNUSABLE INDEXES
Select index_name, status 
from dba_indexes 
where upper(owner)=upper('&uid')
and status ='UNUSABLE';

PROMPT INDEXES PARTITION
select * 
from DBA_IND_PARTITIONS 
where INDEX_OWNER=UPPER('&UID');

PROMPT INDEXES PARTITION 
select * 
from DBA_IND_PARTITIONS 
where INDEX_OWNER=UPPER('&UID')
and status ='UNUSABLE';

PROMPT INDEX REBUILD 
select to_char(last_ddl_time,'dd-mon-rrrr'),count ( * ) from dba_objects
where object_type='INDEX'
and upper(owner)=upper('&uid')
group by to_char(last_ddl_time,'dd-mon-rrrr');


prompt index types

select count(*),owner,index_type from dba_indexes group by owner,index_type order by owner,index_type;


PROMPT TRIGGER STATUS
Select owner,status,count(*)
from dba_triggers
group by owner,status
order by owner,status;

PROMPT TRIGGER DISABLED
Select owner, trigger_name,trigger_type, table_owner, table_name from dba_triggers
where upper(owner)=upper('&uid')
and status='DISABLED';

PROMPT CONSTRAINT STATUS
Select owner,status,count(*)
from dba_constraints
group by owner,status
order by owner,status;

PROMPT CONSTRAINTS DISABLED
Select a.CONSTRAINT_NAME,b.CONSTRAINT_TYPE,a.TABLE_NAME,a.COLUMN_NAME,a.POSITION,b.STATUS 
from USER_CONS_COLUMNS a ,USER_CONSTRAINTS b
where a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
and upper(b.owner)=upper('&uid') 
and b.STATUS ='DISABLED'
order by TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_TYPE,COLUMN_NAME,POSITION,STATUS;

PROMPT SYNONYM DETAILS
select table_owner,count(*) 
from DBA_SYNONYMS
where upper(owner)=upper('&uid')
group by table_owner;

select count(*) from dba_objects where upper(owner)=upper('&uid');


set heading on;
col SYSTEM_NAME format a25;
col PROGRAM format a25;
col OS_USER format a25;
col DB_USER format a25;


select
   substr(a.spid,1,9) pid,
   substr(b.sid,1,5) sid,
   substr(b.serial#,1,5) ser#,
   substr(b.username,1,10) db_user,
   substr(b.osuser,1,8) os_user,
   substr(b.machine,1,12) system_name,
   substr(b.program,1,30) program
from
   v$session b,
   v$process a
where
b.paddr = a.addr
and type='USER'
order by spid;

select to_char(last_ddl_time,'dd-mon-rrrr'),count ( * ) from dba_objects
where object_type='INDEX'
and upper(owner)=upper('&uid')
group by to_char(last_ddl_time,'dd-mon-rrrr');

select object_type,to_char(last_ddl_time,'dd-mon-rrrr'),count ( * ) from dba_objects
where upper(owner)=upper('&uid') and object_type in('TABLE','INDEX')
group by object_type,to_char(last_ddl_time,'dd-mon-rrrr');

select to_char(last_analyzed,'dd-mon-rrrr'),count ( * ) from dba_tables
where upper(owner)=upper('&uid')
group by to_char(last_analyzed,'dd-mon-rrrr');

select to_char(last_analyzed,'dd-mon-rrrr'),count ( * ) from dba_indexes
where upper(owner)=upper('&uid')
group by to_char(last_analyzed,'dd-mon-rrrr');

Prompt table level lock for the FCC schema provided...

SELECT a.sid,a.serial#, a.username,c.os_user_name,a.terminal,
b.object_id,substr(b.object_name,1,40) object_name
from v$session a, dba_objects b, v$locked_object c
where a.sid = c.session_id
and b.object_id = c.object_id
and upper(a.username)=upper('&uid');

set feedback off
set echo off
PROMPT ---------------------DATABASE PHYSICAL STRUCTURE SIZE AND FREESPACE ------------------------

set feedback on
set echo on

set pages 10000
set lines 10000
PROMPT DATABASE SIZE

select owner,sum(bytes)/1048576 size_Mb
from dba_segments
group by owner;

col TABLESPACE_NAME format a30;

select owner,segment_type,tablespace_name,count(*) No_of_Obj,sum(bytes)/1048576 size_Mb
from dba_segments
group by owner,segment_type,tablespace_name
order by owner,segment_type,tablespace_name;

PROMPT PCT_INCREASE
Select segment_name, initial_extent, next_extent,min_extents,max_extents,pct_increase
from dba_segments
where upper(owner)=upper('&uid')
and pct_increase > 0;

PROMPT MAX_EXTENTS
Select segment_name 
from dba_segments 
where upper(owner)=upper('&uid')
and max_extents < 506;

col OWNER format a15;
col SEGMENT_NAME format a60;
col PARTITION_NAME format a20;


col OWNER format a25;
col SEGMENT_NAME format a50;
col TABLESPACE_NAME format a25;


select * from dba_segments
where upper(owner)=upper('&uid')
and bytes>=268435000
order by extents desc;

select * from V$tablespace;

col TABLESPACE_NAME format a30;
Select * from dba_tablespaces;

col FILE_ID format 9999.99
col FILE_NAME format a110;
select * from dba_data_files;

PROMPT TABLESPACE OPTION 

select tablespace_name,autoextensible,sum(bytes)/(1024*1024) as size_mb
from dba_data_files
group by tablespace_name,autoextensible;

PROMPT FREESPACE IN DIFFERENT DATAFILES AND TABLESPACE

PROMPT FREESPACE TABLESPACE 
select distinct df.tablespace_name "Tablespace",
       NVL((df.totalspace - fs.freespace),df.totalspace) "Used MB",
       NVL(fs.freespace,'0') "Free MB",
       df.totalspace "Total MB",
       NVL(round(100 * (fs.freespace / df.totalspace)),'0') "% Free"
  from (select tablespace_name,round(sum(bytes) / 1048576) TotalSpace
          from dba_data_files 
         group by tablespace_name) df,
       (select tablespace_name,round(sum(bytes) / 1048576) FreeSpace
          from dba_free_space
          group by tablespace_name) fs 
 where fs.tablespace_name (+)= df.tablespace_name;

PROMPT FREESPACE DATAFILES
col FILE_NAME format a125
select b.file_name,b.file_id "File #",b.tablespace_name "tablespace name",
b.bytes/1024/1024 "#SIZE_MB ",ROUND((b.bytes-sum(nvl(a.bytes,0)))/1024/1024,2) " # MB_USED",ROUND(sum(nvl(a.bytes,0))/1024/1024,2) "# MB_FREE",
ROUND((sum(nvl(a.bytes,0))/(b.bytes))*100,2) "% free"
from sys.dba_free_space a, sys.dba_data_files b
where a.file_id(+)=b.file_id
group by b.file_name,b.tablespace_name,b.file_id, b.bytes
order by b.tablespace_name;

PROMPT TEMPFILE DETAILS
select tablespace_name,autoextensible,sum(bytes)/(1024*1024) as size_mb
from dba_temp_files
group by tablespace_name,autoextensible;

PROMPT TEMPFILE FREESPACE
select tablespace_name,sum(bytes_free)/(1024*1024) as free_mb
from v$temp_space_header
group by tablespace_name;

prompt ERROR- These segments will fail during NEXT EXTENT (DBA_SEGMENTS)
column Tablespaces	format a30
column Segment		format a40
column "NEXT Needed"	format 999,999,999
column "MAX Available"	format 999,999,999
/*
select	a.tablespace_name	"Tablespaces",
	a.owner			"Owner",
	a.segment_name		"Segment",
	a.next_extent		"NEXT Needed",
	b.next_ext		"MAX Available"
  from	sys.dba_segments a,
	(select tablespace_name,max(bytes) next_ext
	from sys.dba_free_space 
	group by tablespace_name) b
 where	a.tablespace_name=b.tablespace_name(+)
   and	b.next_ext < a.next_extent;
*/

prompt taking only tablespace name
select	a.tablespace_name	"Tablespaces",
	a.owner			"Owner"
  from	sys.dba_segments a,
	(select tablespace_name,max(bytes) next_ext
	from sys.dba_free_space
	group by tablespace_name) b
 where	a.tablespace_name=b.tablespace_name(+)
   and	b.next_ext < a.next_extent
   group by a.tablespace_name,a.owner;



prompt WARNING- These segments > 70% of MAX EXTENT (DBA_SEGMENTS)
column Tablespace	format a30
column Segment		format a40
column Used		format 9999
column Max		format 9999
select	tablespace_name	"Tablespace",
	owner		"Owner",
	segment_name	"Segment",
	extents		"Used",
	max_extents	"Max"
  from	sys.dba_segments
 where	(extents/decode(max_extents,0,1,max_extents))*100 > 70
   and	max_extents >0;

select object_name,TABLESPACE_NAME,object_type,statistic_name,value
  from V$SEGMENT_STATISTICS
where upper(owner)=upper('&uid')
and value/1024/1024>1
order by value desc

select  
tablespace_name,
count(*) free_chunks,
decode(round((max(bytes)/1048576),2),null,0,
round((max(bytes)/1048576),2)) largest_chunk,
nvl(round(sqrt(max(blocks)/sum(blocks))*(100/sqrt(sqrt(count(blocks)) )),2),0) fragmentation_index
from 
dba_free_space
group by tablespace_name
order by 2 desc;

set pages 10000
set lines 10000
col FILE_NAME format a110;
col FILE_ID format 99.99

select * from dba_temp_files;

Prompt high water mark -- temp tablespace

select tablespace_name, sum(bytes_cached)/1024/1024 mb
from v$temp_extent_pool 
group by tablespace_name;

Prompt current usage

select ss.tablespace_name,sum((ss.used_blocks*ts.blocksize))/1024/1024 mb 
from gv$sort_segment ss, sys.ts$ ts  
where ss.tablespace_name = ts.name  
group by ss.tablespace_name;

Prompt temporary tablespaces which contain sort segments.

SELECT tablespace_name, extent_size, total_extents, used_extents,
free_extents, max_used_size
FROM v$sort_segment;

Prompt temporary segments currently in use by the database-users

SELECT s.username, u.tablespace, u.contents, u.extents, u.blocks
FROM v$session s, v$sort_usage u
WHERE s.saddr=u.session_addr;

col SEGMENT_NAME format a15;
col TABLESPACE_NAME format a15;
col STATUS  format a8;
col INITIALEXTENT format 9999.9
col NEXTEXTENT format 9999.9


PROMPT SEGMENT STORAGE
col SEGMENT_NAME  format a35;
col TABLESPACE_NAME format a25;
col STATUS format a20;
select segment_name, 
tablespace_name, r.status, 
(initial_extent/1024) InitialExtent,
(next_extent/1024) NextExtent, 
max_extents, v.curext CurExtent
From dba_rollback_segs r, v$rollstat v
Where r.segment_id = v.usn(+)
order by segment_name ;

/*
prompt LIST OF OBJECTS HAVING > 12 EXTENTS (DBA_EXTENTS)
column Tablespace_ext	format a30
column Segment		format a40
column Count		format 9999
break on "Tablespace_ext" skip 1
select	tablespace_name "Tablespace_ext" ,
	owner		"Owner",
	segment_name    "Segment",
	count(*)        "Count"
  from	sys.dba_extents
 group by tablespace_name,owner,segment_name
 having count(*)>12
 order by 1,3 desc;
*/

prompt Summary of Current Curor Usage
col name format a25

select min(value) min, max(value) max, avg(value) avg
from   sys.v_$sesstat
where  statistic# = (select statistic#
                       from sys.v_$statname
                      where name like 'opened cursors current');

prompt Top 10 Users With Most Open Cursors

col program  format a15 trunc
col osuser   format a15 trunc
col username format a15 trunc

select * from (
  select s.sid, s.username, s.osuser, s.program, v.value "Open
Cursors"
  from   sys.v_$sesstat v,  sys.v_$session s
  where  v.sid        = s.sid
    and  v.statistic# = (select statistic#
                       from sys.v_$statname
                      where name like 'opened cursors current')
  order  by v.value desc
)
where rownum < 11;

Prompt Identify the blocking session in deadlock
select distinct
a.sid "waiting sid"
, d.sql_text "waiting SQL"
, a.ROW_WAIT_OBJ# "locked object"
, a.BLOCKING_SESSION "blocking sid"
, c.sql_text "SQL from blocking session"
from v$session a, v$active_session_history b, v$sql c, v$sql d
where a.event='enq: TX - row lock contention'
and a.sql_id=d.sql_id
and a.blocking_session=b.session_id
and c.sql_id=b.sql_id
and b.CURRENT_OBJ#=a.ROW_WAIT_OBJ#
and b.CURRENT_FILE#= a.ROW_WAIT_FILE#
and b.CURRENT_BLOCK#= a.ROW_WAIT_BLOCK#;

SELECT DISTINCT a.sid "waiting sid" ,
a.event ,
c.sql_text "SQL from blocked session" ,
b.sid "blocking sid" ,
b.event ,
b.sql_id ,
b.prev_sql_id ,
d.sql_text "SQL from blocking session"
FROM v$session a,
v$session b,
v$sql c ,
v$sql d
WHERE a.event ='enq: TX - row lock contention'
AND a.blocking_session=b.sid
AND c.sql_id =a.sql_id
AND d.sql_id =NVL(b.sql_id,b.prev_sql_id);

select s.username username,  
       a.sid sid,  
       a.owner||'.'||a.object object,  
       s.lockwait,  
       t.sql_text SQL 
from   v$sqltext t,  
       v$session s,  
       v$access a 
where  t.address=s.sql_address  
and    t.hash_value=s.sql_hash_value  
and    s.sid = a.sid  
and    a.owner != 'SYS' 
and    upper(substr(a.object,1,2)) != 'V$' 
/ 


Prompt ---------------------RAC Diag Info--------------------------

SELECT B1.INST_ID,
       B2.VALUE blocks,
       Round(B1.VALUE / 100) total_time,
       round((B1.VALUE / B2.VALUE) * 10, 2) avg_time
  FROM GV$SYSSTAT B1, GV$SYSSTAT B2
 WHERE B1.NAME = 'gc cr block receive time'
   AND B2.NAME = 'gc cr blocks received'
   AND B1.INST_ID = B2.INST_ID
   AND B2.VALUE > 0
 Order by 1;

select v.banner, i.instance_name
  from gv$version v, gv$instance i
 where v.inst_id = i.inst_id
   and v.banner in
       (select banner
          from (select banner, count(*) cnt from gv$version group by banner)
         where cnt <> 2)
 order by 1, 2;


SELECT INST_ID,
       SND_Q_LEN,
       SND_Q_MAX,
       SND_Q_TOT,
       TCKT_AVAIL,
       TCKT_LIMIT,
       TCKT_RCVD,
       TCKT_WAIT
  FROM GV$DLM_TRAFFIC_CONTROLLER
 WHERE (SND_Q_LEN > 0)
    OR ((TCKT_LIMIT - TCKT_AVAIL) >= (TCKT_LIMIT * 0.6))
    OR TCKT_WAIT = 'YES';


SELECT A1.INST_ID,
       A1.VALUE blocks_lost,
       A2.VALUE blocks_corrupt
FROM   GV$SYSSTAT A1,
       GV$SYSSTAT A2
WHERE  A1.NAME = 'gc blocks lost'
AND    A2.NAME = 'gc blocks corrupt'
AND    A1.INST_ID = A2.INST_ID
AND    (a1.value > 0 or a2.value > 0);

select *
  from (SELECT INST_ID,
               OWNER#,
               NAME,
               KIND,
               FILE#,
               SUM(FORCED_READS) READS,
               SUM(FORCED_WRITES) WRITES,
               MAX(XNC) XNC
          FROM GV$CACHE_TRANSFER
         GROUP BY INST_ID, OWNER#, NAME, KIND, FILE#
         ORDER BY 8 DESC)
 where rownum <= 10;

select o.parameter, o.value, i.instance_name
  from gv$option o, gv$instance i
 where o.inst_id = i.inst_id
   and o.Parameter in (select Parameter
                         from (select Parameter, value, count(*) cnt
                                 from gv$option
                                group by Parameter, value)
                        where cnt <> 2)
 order by 1, 2;

select p.name, p.value, i.instance_name
  from gv$parameter p, gv$instance i
 where p.inst_id = i.inst_id
   and p.name in (select name
                    from (select name, value, count(*) cnt
                            from gv$parameter
                           where name in ('archive_lag_target',
                                          'control_management_pack_access',
                                          'diagnostic_dest',
                                          'redo_transport_user',
                                          'trace_enabled',
                                          'license_max_users',
                                          'log_archive_format',
                                          'spfile',
                                          'undo_retention')
                           group by name, value)
                   where cnt <> 2)
 order by 1, 2;

select p.name, p.value, i.instance_name
  from gv$parameter p, gv$instance i
 where p.inst_id = i.inst_id
   and p.name in (select name
                    from (select name, value, count(*) cnt
                            from gv$parameter
                           where name in ('active_instance_count',
                                          'cluster_database',
                                          'cluster_database_instances',
                                          'compatible',
                                          'control_files',
                                          'db_block_size',
                                          'db_domain',
                                          'db_files',
                                          'db_name',
                                          'db_recovery_file_dest',
                                          'db_recovery_file_dest_size',
                                          'db_unique_name',
                                          'instance_type',
                                          'max_parallel_servers',
                                          'parallel_execution_message_size',
                                          'dml_locks',
                                          'remote_login_passwordfile',
                                          'result_cache_max_size',
                                          'undo_management')
                             and not ((name = 'dml_locks') and (value = '0'))
                           group by name, value)
                   where cnt <> 2)
 order by 1, 2;

select p.name, p.value, i.instance_name
  from gv$parameter p, gv$instance i
 where p.inst_id = i.inst_id
   and p.name in
       (select name
          from (select name, value, count(*) cnt
                  from gv$parameter
                 where name in ('instance_name',
                                'instance_number',
                                'thread',
                                'rollback_segments',
                                'undo_tablespace')
                   and not ((name = 'rollback_segments') and (value = null))
                   and not ((name = 'instance_name') and (value = null))
                 group by name, value)
         where cnt <> 1)
 order by 1, 2;

select s.inst_id,
       s.blocks_served,
       Round(1000000 * s.pin_time / s.blocks_served) / 1000 avg_pin_time,
       Round(1000000 * s.flush_time / s.blocks_served) / 1000 avg_flush_time,
       Round(1000000 * s.send_time / s.blocks_served) / 1000 avg_send_time,
       Round((1000000 * (s.pin_time + s.flush_time + s.send_time)) /
             s.blocks_served) / 1000 avg_service_time
  from (select inst_id,
               sum(decode(name, 'gc current block pin time', value, 0)) pin_time,
               sum(decode(name, 'gc current block pin flush', value, 0)) flush_time,
               sum(decode(name, 'gc current block pin send', value, 0)) send_time,
               sum(decode(name, 'gc current block blocks served', value, 0)) blocks_served
          from gv$sysstat
         where name in ('gc current block pin time',
                        'gc current block pin flush',
                        'gc current block pin send',
                        'gc current block blocks served')
         group by inst_id) s
 where s.blocks_served > 0; 

Prompt ~~~~~~~~~~ALERT log Errors~~~~~~~~~~~~~~~

Prompt Below queries works only in 11G version.

select DISTINCT MESSAGE_TEXT from x$dbgalertext where MESSAGE_TEXT like 'ORA-%' or MESSAGE_TEXT like 'TNS-%' or MESSAGE_TEXT like 'PLS-%';

select DISTINCT (MESSAGE_TEXT),to_char(originating_timestamp, 'DD-MON-YYYY HH24:MI:SS') from x$dbgalertext where (MESSAGE_TEXT like 'ORA-%' or MESSAGE_TEXT like 'TNS-%' or MESSAGE_TEXT like 'PLS-%') and (originating_timestamp >= sysdate - 30);

select originating_timestamp, message_text from X$DBGALERTEXT where originating_timestamp > sysdate - 2 and message_group = 'admin_ddl';
  
select originating_timestamp, message_text from X$DBGALERTEXT where originating_timestamp > sysdate - 30 and message_group = 'Generic Internal Error';

select originating_timestamp, message_group, problem_key, message_text from X$DBGALERTEXT where message_text like '%ORA-00600%' and rownum < 10;

SPOOL OFF