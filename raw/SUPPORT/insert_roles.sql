set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000

spool /home/oracle/scripts/Rollover_dup_val_deletion.spl

SELECT * FROM smtb_user_role;

insert into smtb_user_role (select role_id,'SYSTEM',auth_stat,branch_code from smtb_user_role where user_id='CONV_USER');
commit;
 
select * from smtb_user_role where user_id='SYSTEM';

select * from smtb_user;

update smtb_user 
set user_password='2F80B5820549491E21724CF45C25D89C'
where user_id='CONV_USER' ;
commit ;

select * from smtb_user;
 
spool off 
