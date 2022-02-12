select mv.mvtw_age, mv.mvtw_cha,mv.mvtw_cli,mv.mvtw_suf,c.cliw_int ,mv.mvtw_dco, mv.mvtw_lib, mv.mvtw_sen,
case when mv.mvtw_sen = 'D' then  mv.mvtw_mon end DEBIT, case when mv.mvtw_sen = 'C' then  mv.mvtw_mon end CREDIT
from mouvement2009 mv, clients c
where mv.mvtw_cli = c.cliw_cli
and mv.mvtw_cha like '36%'
order by mv.mvtw_dco
