SET HEAD ON
SET ARRAY 1
SET LINESIZE 10000
SET PAGESIZE 50000
SET COLSEP ';'
SET LONG 10000
SET ECHO ON
SET TRIMSPOOL ON
SPOOL C:\ROLE_DETAILS.SPL

select * from SMTB_USER_ROLE ;
select * from SMTB_USER_BRANCHES ;
select * from SMTB_USER ;
select * from SMTB_CURRENT_USERS;

insert into smtb_user_role select role_id,'SYSTEM',auth_stat,branch_code from smtb_user_role where user_id ='CONV_USER';

SET ECHO OFF
SPOOL OFF
