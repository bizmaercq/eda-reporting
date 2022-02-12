accept uid PROMPT 'Enter the Oracle schema/username for Fcc==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

SPOOL c:\Db_info.spl

PROMPT ----------------------------
PROMPT fcc schema info
PROMPT ----------------------------

PROMPT HISTOGRAMS
select distinct table_name
from ( select table_name from dba_tab_columns where histogram!='NONE');

PROMPT UNUSABLE INDEXES
Select index_name, status from dba_indexes 
where upper(owner)=upper('&uid')
and status in ('UNUSABLE','N/A')
/

select default_tablespace,temporary_tablespace from dba_users
where upper(username)=upper('&uid');

select * from dba_ts_quotas
where upper(username)=upper('&uid');

select tablespace_name,autoextensible,sum(bytes)/(1024*1024) as size_mb 
from dba_data_files
group by tablespace_name,autoextensible;

select tablespace_name,sum(bytes)/(1024*1024) as free_mb 
from dba_free_space
group by tablespace_name;

select tablespace_name,autoextensible,sum(bytes)/(1024*1024) as size_mb  
from dba_temp_files
group by tablespace_name,autoextensible;

select tablespace_name,sum(bytes_free)/(1024*1024) as free_mb  
from v$temp_space_header
group by tablespace_name;

select tablespace_name,segment_type,count ( * ) as cnt 
from dba_segments
where upper(owner)=upper('&uid')
group by tablespace_name,segment_type;

select owner,segment_type,tablespace_name,count(1)  No_of_Obj,sum(bytes)/1048576 size_Mb
from dba_segments
group by owner,segment_type,tablespace_name;

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
first_time>='25-FEB-2010'
and
first_time<=sysdate
group by 
to_char(first_time,'dd-mon-rr');

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

select object_type,count(*) from dba_objects
where upper(owner)=upper('&uid')
group by object_type;

select object_type,count(*) from dba_objects
where status='INVALID'
and upper(owner)=upper('&uid')
group by object_type;

select * from dba_tablespaces;

select * from dba_data_files;

select * from dba_temp_files;

select 
a.owner,
decode(a.partition_name,null,a.segment_name,a.segment_name ||'.' || a.partition_name) as segment_name,
a.segment_type,
a.extents,
a.min_extents,
a.initial_extent,
a.next_extent,
a.tablespace_name
from 
dba_segments a
where 
upper(a.owner)=upper('&uid')
and
(a.max_extents-a.extents)<=5
and
a.segment_type<>'CACHE'
order by 1,2,3;

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

select object_name,TABLESPACE_NAME,object_type,statistic_name,value 
from V$SEGMENT_STATISTICS
where upper(owner)=upper('&uid')
and value<>0;

select * from DBA_TAB_PRIVS
where upper(grantee)=upper('&uid');

select * from DBA_SYS_PRIVS
where upper(grantee)=upper('&uid');

select * from DBA_ROLE_PRIVS
where upper(grantee)=upper('&uid');

select * from DBA_FREE_SPACE_COALESCED;

select * from DBA_JOBS;

--select * from DBA_JOBS_RUNNING;

select status,count(*) 
from dba_constraints
where upper(owner)=upper('&uid')
group by status;

select status,count(*) 
from dba_triggers
where upper(owner)=upper('&uid')
group by status;

select status,count(*) 
from dba_indexes
where upper(owner)=upper('&uid')
group by status;

select table_owner,count(*) 
from DBA_SYNONYMS
where upper(owner)=upper('&uid')
group by table_owner;

select * from dba_segments
where upper(owner)=upper('&uid')
and bytes>=1048576000;

PROMPT ----------------------------
PROMPT rollback and undo segments
PROMPT ----------------------------

select * from v$parameter
where name in
(
'undo_management',
'undo_retention',
'undo_suppress_errors',
'undo_tablespace'
);

select * from v$spparameter
where name in
(
'undo_management',
'undo_retention',
'undo_suppress_errors',
'undo_tablespace'
);

select * from dba_rollback_segs;

select * from v$rollname;

select * from v$rollstat;

select * from v$undostat;

select * from DBA_UNDO_EXTENTS;

PROMPT ----------------------------
PROMPT shared pool
PROMPT ----------------------------

select * from v$parameter
where name in
(
'shared_pool_size','shared_pool_reserved_size','large_pool_size',
'cursor_space_for_time','cursor_sharing','session_cached_cursors','open_cursors'
);

select * from v$spparameter
where name in
(
'shared_pool_size','shared_pool_reserved_size','large_pool_size',
'cursor_space_for_time','cursor_sharing','session_cached_cursors','open_cursors'
);

select * from v$librarycache;

select * from V$LIBRARY_CACHE_MEMORY;

select * from v$sgastat;

select * from v$sga;

select * from v$shared_pool_reserved;

select * from v$rowcache;

select * from v$shared_pool_advice;

select * from V$SGA_RESIZE_OPS;

select * from V$SGA_CURRENT_RESIZE_OPS;

select * from V$SGA_DYNAMIC_COMPONENTS;

select * from V$SGA_DYNAMIC_FREE_MEMORY;

PROMPT ----------------------------
PROMPT buffer cache
PROMPT ----------------------------

select * from v$parameter
where name in
(
'db_block_size','db_cache_size','db_cache_advice','db_writer_processes','dbwr_io_slaves',
'db_2k_cache_size','db_4k_cache_size','db_8k_cache_size','db_16k_cache_size','db_32k_cache_size',
'db_keep_cache_size','db_recycle_cache_size','db_block_buffers','db_block_checksum','db_file_multiblock_read_count'
);

select * from v$spparameter
where name in
(
'db_block_size','db_cache_size','db_cache_advice','db_writer_processes','dbwr_io_slaves',
'db_2k_cache_size','db_4k_cache_size','db_8k_cache_size','db_16k_cache_size','db_32k_cache_size',
'db_keep_cache_size','db_recycle_cache_size','db_block_buffers','db_block_checksum','db_file_multiblock_read_count'
);

select * from v$db_cache_advice;

select * from v$buffer_pool;

select * from v$buffer_pool_statistics;

PROMPT ----------------------------
PROMPT other sga structures
PROMPT ----------------------------

select * from v$parameter
where name in
(
'log_buffer','java_pool_size',
'log_checkpoint_interval','log_checkpoint_timeout',
'log_archive_max_processes','backup_tape_io_slaves','log_checkpoints_to_alert',
'fast_start_mttr_target','fast_start_io_target','sga_max_size'
);

select * from v$spparameter
where name in
(
'log_buffer','java_pool_size',
'log_checkpoint_interval','log_checkpoint_timeout',
'log_archive_max_processes','backup_tape_io_slaves','log_checkpoints_to_alert',
'fast_start_mttr_target','fast_start_io_target','sga_max_size'
);

select * from v$bgprocess where paddr<>'00';

PROMPT ----------------------------
PROMPT db config and i/o
PROMPT ----------------------------

select 
b.file_name,b.file_id,b.tablespace_name,b.bytes/1048576 size_mb,b.status,
b.autoextensible,a.PHYRDS,a.PHYWRTS
from v$filestat a, dba_data_files b
where a.FILE#=b.file_id
order by b.tablespace_name;

select 
b.file_name,b.file_id,b.tablespace_name,b.bytes/1048576 size_mb,b.status,
b.autoextensible,a.PHYRDS,a.PHYWRTS
from V$TEMPSTAT a, dba_temp_files b
where a.FILE#=b.file_id
order by b.tablespace_name;

select * from v$parameter
where name in
(
'control_files','db_files','remote_login_passwordfile'
) or name like 'db_create%';

select * from v$spparameter
where name in
(
'control_files','db_files','remote_login_passwordfile'
) or name like 'db_create%';

select * from v$log;

select * from v$logfile;

select * from v$controlfile;

select * from v$controlfile_record_section;

select * from v$instance_recovery;

select * from v$version;

select * from v$option;

select * from V$THREAD;

select * from V$RMAN_CONFIGURATION;

select * from V$RESOURCE_LIMIT;

select * from V$NLS_PARAMETERS;

select * from V$MTTR_TARGET_ADVICE;

select * from V$LICENSE;

select * from V$DATABASE_BLOCK_CORRUPTION;

select * from V$DATABASE_INCARNATION;

select * from V$COPY_CORRUPTION;

select * from V$BACKUP where status='ACTIVE';

select * from V$BACKUP_CORRUPTION;

select * from V$BACKUP_DATAFILE;

select * from V$BACKUP_DEVICE;

select * from V$BACKUP_PIECE;

select * from V$BACKUP_REDOLOG;

select * from V$BACKUP_SET;

PROMPT ----------------------------
PROMPT sort 
PROMPT ----------------------------

select * from v$parameter
where name in
(
'workarea_size_policy','sort_area_size','sort_area_retained_size','pga_aggregate_target',
'bitmap_merge_area_size','create_bitmap_area_size','hash_area_size','optimizer_mode'
);

select * from v$spparameter
where name in
(
'workarea_size_policy','sort_area_size','sort_area_retained_size','pga_aggregate_target',
'bitmap_merge_area_size','create_bitmap_area_size','hash_area_size','optimizer_mode'
);

select * from v$pgastat;

select * from V$PGA_TARGET_ADVICE;

select * from V$PGA_TARGET_ADVICE_HISTOGRAM;

select * from v$sort_segment;

select * from v$sort_usage;

select * from v$temp_extent_pool;

PROMPT ----------------------------
PROMPT shared servers
PROMPT ----------------------------

select * from v$parameter
where name in
(
'circuits','dispatchers','max_dispatchers','shared_servers',
'max_shared_servers','shared_server_sessions',
'instance_name','db_domain','service_names','processes','db_name'
);

select * from v$spparameter
where name in
(
'circuits','dispatchers','max_dispatchers','shared_servers',
'max_shared_servers','shared_server_sessions',
'instance_name','db_domain','service_names','processes','db_name'
);

select * from v$shared_server_monitor;

select * from v$dispatcher;

select * from v$queue;

select * from v$dispatcher_rate;

select * from v$shared_server;

PROMPT ----------------------------
PROMPT log mode
PROMPT ----------------------------

select * from v$parameter
where name like 'log_archive%';

select * from v$spparameter
where name like 'log_archive%';

select * from v$instance;

select * from v$database;

select * from v$archive_processes;

select * from v$archive_dest;

select * from v$archive_dest_status;

select * from V$RECOVER_FILE;

select * from V$RECOVERY_FILE_STATUS;

select * from V$RECOVERY_LOG;

select * from V$RECOVERY_PROGRESS;

select * from V$RECOVERY_STATUS;

select * from V$PWFILE_USERS;

select * from V$FAST_START_SERVERS;

select * from V$FAST_START_TRANSACTIONS;

select * from DBA_USERS;

PROMPT ----------------------------
PROMPT gen stats
PROMPT ----------------------------

select * from v$system_event;

select * from v$waitstat where count<>0;

select * from v$sysstat where value<>0;

set echo off
spool off