set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 99999999999999999999.9999
SPOOL /home/oacle/spool/upd_pwd.spl

select * from smtb_user;

update smtb_user 
set user_password='77939BADC3D679717E8AC9422DDC377C'
where user_id='SYSTEM' ;
commit ;

select * from smtb_user;

select * from sttm_dates;
select * from sttm_branch;
select count(*) from actb_history ;

select * from sttm_fin_cycle;
select count(*) from cstm_product ;

set echo off
/
