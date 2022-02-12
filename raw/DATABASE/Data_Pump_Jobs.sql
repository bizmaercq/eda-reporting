SELECT owner_name, job_name, operation, job_mode, 
   state, attached_sessions 
   FROM dba_datapump_jobs 
   where owner_name='&SCHEMA' and state='NOT RUNNING'
ORDER BY 1,2; 

SELECT o.status, o.object_id, o.object_type, 
          o.owner||'.'||object_name "OWNER.OBJECT",o.created,j.state 
     FROM dba_objects o, dba_datapump_jobs j 
    WHERE o.owner=j.owner_name AND o.object_name=j.job_name 
   and o.owner='&SCHEMA' and j.state='NOT RUNNING' ORDER BY 4,2;
   
SELECT owner_name,job_name,operation,state FROM DBA_DATAPUMP_JOBS FOR UPDATE NOWAIT;
select owner,table_name from dba_tables where table_name like '%SYS%EXPORT%' FOR UPDATE NOWAIT;

SELECT o.status, o.object_id, o.object_type,
o.owner||'.'||object_name "OWNER.OBJECT",o.created,j.state
FROM dba_objects o, dba_datapump_jobs j
WHERE o.owner=j.owner_name AND o.object_name=j.job_name
and j.state='NOT RUNNING' ORDER BY 4,2;

DROP TABLE BACKUP.SYS_EXPORT_FULL_01 ;
SELECT * FROM BACKUP.SYS_EXPORT_FULL_01;
