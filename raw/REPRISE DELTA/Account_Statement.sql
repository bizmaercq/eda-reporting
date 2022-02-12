select mvtw_ope ope,mvtw_eve eve,mvtw_dco dco,mvtw_lib lib, Debit , Credit,
sum(Credit-Debit) over (partition by mvtw_age||mvtw_cha||mvtw_cli||mvtw_suf order by mvtw_dco  rows BETWEEN unbounded preceding AND current row ) as Solde,
mvtw_dva dva,mvtw_lic lic,mvtw_ser ser,&FromDate Debut, &ToDate  Fin,&DeltaAccountNumber Account
from 
(
select mv.mvtw_ope,mv.mvtw_eve, mv.mvtw_dco,mv.mvtw_lib ,mvtw_age,mvtw_cha,mvtw_cli,mvtw_suf,
decode(mvtw_sen,'D',mv.mvtw_mon,0) as Debit,decode(mvtw_sen,'C',mv.mvtw_mon,0) as Credit,0 as Solde,
mv.mvtw_dva,mv.mvtw_lic,mv.mvtw_ser
from mouvements mv
where mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf = &DeltaAccountNumber
and mv.mvtw_dco between &FromDate and &ToDate
)
order by mvtw_dco




