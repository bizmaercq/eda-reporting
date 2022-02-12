-- repartition des comptes
select ar.COMW_AGE, 
sum (ar.CHECKING_ACCOUNTS_CORPORATE) as CHECKING_ACCOUNTS_CORPORATE,
sum (ar.CHECKING_ACCOUNTS_NON_SALARY) as CHECKING_ACCOUNTS_NON_SALARY,
sum (ar.CURRENT_ACCOUNTS_CC) as CURRENT_ACCOUNTS_CC,
sum (ar.CURRENT_ACCOUNTS_NON_CC) as CURRENT_ACCOUNTS_NON_CC,
sum (ar.CURRENT_ACCOUNTS_STAFF) as CURRENT_ACCOUNTS_STAFF,
sum (ar.SAVING_ACCOUNTS) as SAVING_ACCOUNTS,
sum(ar.TERM_DEPOSITS ) as TERM_DEPOSITS,
sum(ar.LOANS ) as LOANS
from 
(
select 
co.comw_age,
case when (co.COMW_CHA  between '37100' and '37179') or (co.COMW_CHA  between '37190' and '37199') then count(*) end as Checking_accounts_Corporate,
case when co.COMW_CHA  between '37180' and '37189' then count(*) end as Checking_accounts_Non_Salary,
case when co.COMW_CHA  between '37280' and '37280' then count (*) end as Current_accounts_CC,
case when co.COMW_CHA  between '37281' and '37289' then count (*) end as Current_accounts_non_CC,
case when co.COMW_CHA  between '37290' and '37299' then count (*) end as Current_accounts_Staff,
case when co.COMW_CHA  between '37300' and '37399' then count(*) end as Saving_Accounts,
case when co.COMW_CHA  between '36115' and '36850' then count(*) end as Term_Deposits,
case when co.COMW_CHA  between '30100' and '32999' then count(*) end as Loans
from compte2009 co
where co.COMW_CLI>'000999'
and co.COMW_CHA between '30100' and '37399'
group by co.COMW_AGE, co.COMW_CHA
) ar
group by ar.COMW_AGE;
