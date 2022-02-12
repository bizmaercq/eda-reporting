delete mouvements mv where mv.MVTW_DCO >='&Date';

delete contreparties where conw_nor in  (select opdw_nor from operationsdiverses where opdw_dco >='&Date');

delete OPERATIONSDIVERSES where opdw_dva >='&Date';

delete SETTLEMENT where setw_date >='&Date';

select mv.MVTW_EVE, sum(decode(mv.MVTW_SEN,'D',mv.MVTW_MON) ) as debit, sum(decode(mv.MVTW_SEN,'C',mv.MVTW_MON)) as credit
from mouvements mv
where mv.MVTW_DVA >='&Date'
group by mv.mvtw_eve
having  sum(decode(mv.MVTW_SEN,'D',mv.MVTW_MON) ) - sum(decode(mv.MVTW_SEN,'C',mv.MVTW_MON)) <> 0;

commit;



---------------Invalidating a batch
select * from clotures order by clow_num desc for update;

update operationsdiverses set opdw_sta = -1 where opdw_nor in(select distinct mvtw_eve from mouvements where mvtw_clo=&Num_Cloture);
delete mouvements mv where mv.mvtw_clo = &Num_Cloture ;
delete SETTLEMENT where setw_date ='&Date';

commit;

select * from clotures;
select * from contreparties;

------ Invalidating a settlement day

select * from settlement where setw_date ='15/07/2020'

update mouvements mv set mv.mvtw_dco = '01/01/2000', mv.mvtw_dva = '01/01/2000'  where mv.MVTW_DCO ='&Date';
update OPERATIONSDIVERSES op set op.opdw_dco =  '01/01/2000', op.opdw_dva=  '01/01/2000' where opdw_dva ='&Date';
update settlement set setw_date = '01/01/2000' where setw_date ='24/08/2012'

SELECT * FROM soustraitantwu FOR UPDATE NOWAIT; 

SELECT op.opdw_nor,count(*) FROM operationsdiverses op group by op.opdw_nor having count(*)>1;

SELECT * FROM compteref WHERE rcow_grp =2

update soustraitantwu sw set sw.swuw_cli = substr(sw.swu_fcc_compte,9,6) WHERE sw.swuw_cli ='000000'