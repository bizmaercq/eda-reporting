select count(*) from xafnfc.trial_balance;
select count(*) from xafnfc.vw_trial_balance;
select * from xafnfc.trial_balance where length(account_number) <> '9' and rownum <= 7;
select count(*) from xafnfc.trial_balance where module = 'CL';
