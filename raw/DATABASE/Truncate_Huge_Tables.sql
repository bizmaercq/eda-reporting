-- Query the huge table sizes
SELECT owner,segment_name,tablespace_name,bytes/1048576 MB
FROM DBA_SEGMENTS
WHERE OWNER = 'XAFNFC'  AND SEGMENT_TYPE = 'TABLE' 
AND SEGMENT_NAME IN ('STTB_NOTIFICATION_HISTORY','GETB_UTILS_LOG_HISTORY','ELTB_UTIL_TXN_LOG_HISTORY','FBTB_TXNLOG_DETAILS_HIST','ICTB_ICALC_STMT','STTB_NOTIFICATION_HISTORY','GETB_UTILS_LOG_HISTORY') 
order by bytes desc;

-- Truncating the Huge Tables
select count(*) from ELTB_UTIL_TXN_LOG_HISTORY;
truncate table ELTB_UTIL_TXN_LOG_HISTORY;

select count(*) from FBTB_TXNLOG_DETAILS_HIST;
truncate table FBTB_TXNLOG_DETAILS_HIST;

select count(*) from ICTB_ICALC_STMT;
truncate table ICTB_ICALC_STMT;

select count(*) from STTB_NOTIFICATION_HISTORY;
truncate table STTB_NOTIFICATION_HISTORY;

select count(*) from GETB_UTILS_LOG_HISTORY;
truncate table GETB_UTILS_LOG_HISTORY;

