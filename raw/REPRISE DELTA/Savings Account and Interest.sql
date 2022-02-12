select mvtw_age,mvtw_cha,mvtw_cli,cliw_int,chaw_lib,nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)  as solde,
nvl(sum(decode(mvtw_ope,'099', mvtw_mon,0)),0) as Interest
from mouvement2011, chapitres,clients
where mvtw_cha between '37380' and '37399'
and mvtw_cha = chaw_cha
and mvtw_cli = cliw_cli
group by mvtw_age,mvtw_cha,mvtw_cli,cliw_int,chaw_lib
having nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0)>= 10000000;
