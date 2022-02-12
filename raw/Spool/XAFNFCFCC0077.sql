set numformat 999,999,999,999,999,999,999.99
set serveroutput on

select stop_ic from ictb_acc_pr where acc='0402820104095954';

update  ictb_acc_pr
set stop_ic='Y'
where acc='0402820104095954';

select stop_ic from ictb_acc_pr where acc='0402820104095954';

commit;