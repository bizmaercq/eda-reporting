set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on

BEGIN
delete trial_balance_old;
insert into trial_balance_old select * from trial_balance;
delete from TRIAL_BALANCE;
commit;
END;
/

alter table trial_balance enable row movement;
alter table trial_balance shrink space;
alter table trial_balance disable row movement;
 
analyze table trial_balance compute statistics;
commit;

alter table trial_balance enable row movement;
alter table trial_balance shrink space;
alter table trial_balance disable row movement;
 
analyze table trial_balance compute statistics;
commit;