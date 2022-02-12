select mvtw_ope,mvtw_eve,mvtw_dco,mvtw_lib, Debit , Credit,
sum(Credit-Debit) over (partition by mvtw_age||mvtw_cha||mvtw_cli||mvtw_suf order by mvtw_dco  rows BETWEEN unbounded preceding AND current row ) as Solde,
mvtw_dva,mvtw_lic,mvtw_ser
from 
(
select mv.mvtw_ope,mv.mvtw_eve, mv.mvtw_dco,mv.mvtw_lib ,mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf,
decode(mvtw_sen,'D',mv.mvtw_mon,0) as Debit,decode(mvtw_sen,'C',mv.mvtw_mon,0) as Credit,0 as Solde,
mv.mvtw_dva,mv.mvtw_lic,mv.mvtw_ser
from mouvement2012 mv
where mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf = &DeltaAccountNumber
and mv.mvtw_dco between &FromDate and &ToDate
union
select null mvtw_ope,null mvtw_eve,to_date(&FromDate,'DD/MM/YYYY')-1 mvtw_dco,'Solde Ouverture' mvtw_lib, mv.mvtw_age,mv.mvtw_cha,mv.mvtw_cli,mv.mvtw_suf,
sum(decode(mvtw_sen,'D',mv.mvtw_mon,0)) as Debit,sum(decode(mvtw_sen,'C',mv.mvtw_mon,0)) as Credit,nvl(sum(nvl(decode(mvtw_sen,'C',mv.mvtw_mon,0),0) - nvl(decode(mvtw_sen,'D',mv.mvtw_mon,0),0)),0) Solde, 
to_date(&FromDate,'DD/MM/YYYY')-1 mvtw_dva,null mvtw_lic,null mvtw_ser
from mouvement2012 mv
where mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf = &DeltaAccountNumber
and mv.mvtw_dco < &FromDate
group by mv.mvtw_age,mv.mvtw_cha,mv.mvtw_cli,mv.mvtw_suf
)
order by mvtw_dco; 


--- Version Obiee Report

select mvtw_ope,mvtw_eve,mvtw_dco,mvtw_lib, Debit , Credit,
sum(Credit-Debit) over (partition by mvtw_age||mvtw_cha||mvtw_cli||mvtw_suf order by mvtw_dco  rows BETWEEN unbounded preceding AND current row ) as Solde,
mvtw_dva,mvtw_lic,mvtw_ser
from 
(
select mv.mvtw_ope,mv.mvtw_eve, mv.mvtw_dco,mv.mvtw_lib ,mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf,
decode(mvtw_sen,'D',mv.mvtw_mon,0) as Debit,decode(mvtw_sen,'C',mv.mvtw_mon,0) as Credit,0 as Solde,
mv.mvtw_dva,mv.mvtw_lic,mv.mvtw_ser
from mouvement2012 mv
where mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf = :DeltaAccountNumber
and mv.mvtw_dco between :FromDate and :ToDate
union
select null mvtw_ope,null mvtw_eve,:FromDate-1 mvtw_dco,'Solde Ouverture' mvtw_lib, mv.mvtw_age,mv.mvtw_cha,mv.mvtw_cli,mv.mvtw_suf,
sum(decode(mvtw_sen,'D',mv.mvtw_mon,0)) as Debit,sum(decode(mvtw_sen,'C',mv.mvtw_mon,0)) as Credit,nvl(sum(nvl(decode(mvtw_sen,'C',mv.mvtw_mon,0),0) - nvl(decode(mvtw_sen,'D',mv.mvtw_mon,0),0)),0) Solde, 
:FromDate-1 mvtw_dva,null mvtw_lic,null mvtw_ser
from mouvement2012 mv
where mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf = :DeltaAccountNumber
and mv.mvtw_dco < :FromDate
group by mv.mvtw_age,mv.mvtw_cha,mv.mvtw_cli,mv.mvtw_suf
)
order by mvtw_dco;
