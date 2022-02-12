select mv.mvtw_age, cl.cliw_int,mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf Compte, mv.mvtw_dva,mv.mvtw_dco,mv.mvtw_lic,op.opew_int , mv.mvtw_lib, 
case when mv.mvtw_sen ='D' then mv.mvtw_mon else 0 end Debit,case when mv.mvtw_sen ='C' then mv.mvtw_mon else 0 end Credit
from MOUVEMENT2009 mv, clients cl, operations op
where mv.mvtw_cli = cl.cliw_cli
and mv.mvtw_cha ='37130'
and mv.mvtw_cli='250788'
and mv.mvtw_suf='44'
and mv.mvtw_ope = op.opew_ope 
order by mvtw_dco;

and mvtw_dco between '01-JAN-2007' and '31-DEC-2007';
-- for a specific CIF
--and mvtw_age='22' 
order by mvtw_dco; ---='31-JUL-2011'
-- for accounts


 and mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf in ('3728020180170');
select table_name from user_tables;

----
select mv.mvtw_age, cl.cliw_int,mv.mvtw_age||mv.mvtw_cha||mv.mvtw_cli||mv.mvtw_suf Compte, mv.mvtw_dva,mv.mvtw_dco,mv.mvtw_lic,op.opew_int , mv.mvtw_lib, 
case when mv.mvtw_sen ='D' then mv.mvtw_mon else 0 end Debit,case when mv.mvtw_sen ='C' then mv.mvtw_mon else 0 end Credit
from MOUVEMENT2011 mv, clients cl, operations op
where mv.mvtw_cli = cl.cliw_cli
and mv.mvtw_cha ='37280'
and mv.mvtw_ope = op.opew_ope 
-- for a specific CIF
--and mvtw_mon =1254000 
and mv.mvtw_cli ='206015' 
order by mvtw_dco ---='31-JUL-2011'
-- for accounts

and mvtw_dco between '25-JUL-2011' and '31-JUL-2011';

SELECT * FROM MOUVEMENT2012
where mvtw_mon=240193
order by mvtw_mon;

SELECT * FROM MOUVEMENT9900
where mvtw_dco='02-SEP-1999'  and mvtw_cli = '431195'-- or  mvtw_cli ='434430'
order by mvtw_lib ;

AND mvtw_age='40'

SELECT * FROM MOUVEMENT9900
where mvtw_dco='02-SEP-1999' AND mvtw_lic like '00044677' --and mvtw_mon =24669
order by mvtw_lib ;



SELECT * FROM MOUVEMENT2012
where mvtw_dco='01-DEC-2012'  
order by mvtw_lib ;

SELECT * FROM MOUVEMENT2010
where mvtw_dco='27-SEP-2010' AND mvtw_uti='HELE' and mvtw_dag='02709201' and mvtw_lig='06760'
order by mvtw_lib ;

SELECT * FROM MOUVEMENT2012
where mvtw_CHA='37280' and mvtw_CLI ='431195' and mvtw_eve  between 498290 and 498310
order by mvtw_mon;

SELECT * FROM MOUVEMENT2012
where mvtw_dco='01-DEC-2012' 
order by mvtw_mon;


SELECT * FROM SYSBASE

select * 
SELECT * FROM MOUVEMENT2003
where mvtw_dco='01-JUL-2002' AND mvtw_CLI ='280823' 
order by mvtw_lib;

SELECT * FROM MOUVEMENT2003
where mvtw_age='20'  AND mvtw_CLI ='206015' 
order by mvtw_dco;
SELECT * FROM MOUVEMENT2008 2507830
where mvtw_mon=654193 order by mvtw_lib;

SELECT * FROM MOUVEMENT2010
where mvtw_dco between '27-SEP-2010' and '30-SEP-2010' and mvtw_mon =1000000
---AND mvtw_cha='38100' and mvtw_cli='000675' 
order by mvtw_dco,mvtw_eve;


--and mvtw_mon=12000 or mvtw_mon=12300
SELECT * FROM    SYS.TABS
sELECT * FROM MOUVEMENT2012
where  mvtw_cha='38200' and mvtw_DCO='01-jan-2012' AND mvtw_age='23'
order by mvtw_dco,mvtw_eve;

sELECT * FROM MOUVEMENT2010
where mvtw_cha='37280' 
and mvtw_cli='207148'
and mvtw_suf='34'
order by mvtw_dco;

27/09/2010

order by mvtw_lig
SELECT * FROM MOUVEMENT2011 WHERE mvtw_cha ='38200' and mvtw_cli='00675' and mvtw_suf='12' 
order by mvtw_dco;
SELECT table_name FROM dba_tables where table_name like '%%'


SELECT * FROM MOUVEMENT2011 
where mvtw_dco='01-SEP-2011' ---AND mvtw_liB LIKE '%938501%'
SHOW STRUCTURE
