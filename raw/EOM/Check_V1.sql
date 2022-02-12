set head on
set array 1
set linesize 10000
set pagesize 50000
set long 90000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99
set timing on

COLUMN REMARKS FORMAT A50;
COLUMN ACCESS_PREDICATES FORMAT A50;
COLUMN PROJECTION FORMAT A50;
COLUMN FILTER_PREDICATES FORMAT A50;
COLUMN OTHER_TAG FORMAT A50;
COLUMN PARTITION_START FORMAT A50;
COLUMN PARTITION_STOP FORMAT A50;
COLUMN OTHER_XML FORMAT A500;
COLUMN OPTIONS FORMAT A50;
COLUMN OBJECT_NODE FORMAT A50;
COLUMN OPTIMIZER FORMAT A30;



spool D:\Details.spl

Show user;

Prompt To check FC version 

select * from cstb_param where lower(param_name) like '%release%';

PROMPT To check No of open branches

select count(*) cnt   from sttm_branch  where record_stat = 'O' and auth_stat = 'A';

Prompt To check GL upate online/offline 

select online_gl_update from sttm_bank;

Prompt To check Commit frequencies for the major modules

select * from cstb_commitfreq where module_id in( 'IC','ic','CL','LD','LE');

Prompt To check ELCM/Message/VD bal parameter values

select * from cstb_param where param_name in ('ELCM_LOG_TXN','GEN_EXT_MESSAGE','VDBAL_UPDATE');

select count(1) from eltbs_util_txn_log;  

Prompt To check Notification table counts  

select count(1) from sttb_notification;
select count(1) from sttb_notification_history;
select notif_code,count(1) from sttb_notification group by notif_code;

Prompt To check external message counts table counts 

select count(1) from mstb_ext_msg_out; 

Prompt To check global temporary table creation required or not based on the below MS table counts

select count(*) from MSTB_VIEW_MESSAGE;

select count(*) from MSTB_ADV_INPUT;

Prompt To check existnace of histograms

SELECT COUNT(1) FROM (select * from user_tab_columns where histogram!='NONE');

Prompt To check ILM usage

select * from iltbs_sys_account; 

Prompt To check IC counts

select count(*), brn, prod_type from ictb_acc_pr group by brn, prod_type; 

select b.group_code, a.brn, count(1)
      from ictb_acc_pr a, aetm_eoc_group_branches b
     where a.brn = b.branch_code  group by b.group_code, a.brn;

Prompt To check ACBCSTAT batch usage 

select count(1) from Actb_Cust_Account_Stat;  

select count(1) from sttm_account_class where  Acc_Statistics ='Y'; 

Prompt To check CL accrual frequency

select distinct accrual_frequency from CLTM_PRODUCT_COMPONENTS;

Prompt To check MGRP subprocess to be disbaled if enabled

select * from Cltb_Automatic_Process where process_name = 'MGRP';

Prompt To check bulk payment process exists/not

select distinct bulk_pmt_reqd, count(1) from getm_facility group by bulk_pmt_reqd;

Prompt To check Stats gather parameter value

SELECT DBMS_STATS.GET_PARAM ('METHOD_OPT') FROM DUAL ;

SELECT DBMS_STATS.GET_PARAM('ESTIMATE_PERCENT') FROM DUAL;

Prompt To check the tables with stale stats 

SELECT COUNT(1) FROM (select * from user_tab_statistics where stale_stats = 'YES');

Prompt To check db parametes 

select * from v$parameter;

SELECT * FROM gv$parameter; -- Added as it will be there for RAC instances

Prompt To check db fragmentatiions 
  
select table_name,
       tablespace_name,
       round(((blocks * 8) / 1024), 2) "table_size_in_MB",
       round((num_rows * avg_row_len / 1024 / 1024), 2) "Used_size_in_MB",
       (round(((blocks * 8 / 1024)), 2) -
       round((num_rows * avg_row_len / 1024 / 1024), 2)) "fragmented_size_in_MB",
       round(((round(((blocks * 8 / 1024)), 2) -
              round((num_rows * avg_row_len / 1024 / 1024), 2)) /
              round(((blocks * 8) / 1024), 2)) * 100,
              2) "%_of_fragmentation" from user_tables
 where blocks > 0;
 
  select tablespace_name, trunc(last_analyzed), count(1)
  from user_tables
 group by tablespace_name, trunc(last_analyzed); 
--------------------------
SELECT table_name,
       NUM_ROWS,
       BLOCKS,
       SAMPLE_SIZE,
       TO_CHAR(LAST_ANALYZED, 'DD-MON-YYYY HH24:MI:SS')
  from USER_TAB_STATISTICS  where last_analyzed < sysdate - 10;
------------------

Prompt To check table / index partitions

select *  from user_part_tables;

select * from user_part_indexes;

SPOOL OFF