-- repartition des comptes
select ar.MVTW_AGE, 
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
mv.mvtw_age,
case when (mv.mvtw_CHA  between '37100' and '37179') or (mv.mvtw_CHA  between '37190' and '37199') then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Checking_accounts_Corporate,
case when mv.mvtw_CHA  between '37180' and '37189' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Checking_accounts_Non_Salary,
case when mv.mvtw_CHA  between '37280' and '37280' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Current_accounts_CC,
case when mv.mvtw_CHA  between '37281' and '37289' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Current_accounts_non_CC,
case when mv.mvtw_CHA  between '37290' and '37299' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Current_accounts_Staff,
case when mv.mvtw_CHA  between '37300' and '37399' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Saving_Accounts,
case when mv.mvtw_CHA  between '36115' and '36850' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Term_Deposits,
case when mv.mvtw_CHA  between '30100' and '32999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Loans
from mouvement2011 mv
where mv.mvtw_cli>'000999'
and mv.MVTW_CHA between '30100' and '37399'
group by mv.MVTW_AGE, mv.MVTW_CHA
) ar
group by ar.MVTW_AGE;
