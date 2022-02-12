select c.cliw_age BRANCH, c.cliw_red "SHORT NAME", c.cliw_int NAME ,c.cliw_adc1 ADDRESS1, c.cliw_adc2 ADDRESS2 
from clients c 
where c.cliw_int like '%CAISSE%'
order by c.cliw_age


select * from compte2012 where comw_cli ='235000'
