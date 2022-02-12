select mv.mvtw_age,ch.chaw_lib,op.opew_int,mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf,sum(mv.mvtw_mon) Revenue
from mouvement2006 mv, operations op, chapitres ch
where mv.mvtw_ope = op.opew_ope
and ch.chaw_cha = mv.mvtw_cha
and mv.mvtw_cha like '7%'
group by mv.mvtw_age,ch.chaw_lib,op.opew_int,mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf
