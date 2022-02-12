-- repartition des credits
select
round(sum (ar.Short_Term_Loan)/1000000) as Short_Term_Loan,
round(sum (ar.Medium_Term_Loan)/1000000) as Medium_Term_Loan,
round(sum (ar.Long_Term_Loan)/1000000) as Long_Term_Loan
from 
(
select 
to_char(mv.mvtw_dco,'MM/YYYY') Period,
case when mv.mvtw_CHA  between '30000' and '30999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Long_Term_Loan,
case when mv.mvtw_CHA  between '31000' and '31999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Medium_Term_Loan,
case when mv.mvtw_CHA  between '32000' and '32999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Short_Term_Loan
from mouvement2010 mv
where mv.mvtw_cli>'000999'
and mv.mvtw_dco <= '31/12/2010'
group by to_char(mv.mvtw_dco,'MM/YYYY'), mv.MVTW_CHA
) ar;


