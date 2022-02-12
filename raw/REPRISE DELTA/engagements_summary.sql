select mvtw_age,MVTW_CLI,cliw_int,
 case when sum(COURANT)<0 then sum(COURANT) else null end as Courant
, case when sum(CREDIT)<0 then sum(CREDIT) else null end as Credit
, sum(Impayes) as impayes
, sum (Douteux) as Douteux
, sum (Provisions) as Provisions
, sum (Depot_Garantie) as Depot_Garantie
, sum (Titres_Foncier) as Titres_Foncier
, sum (Cash_Collateral) as Cash_Collateral
, sum (Cautions) as Cautions
, sum(HorsBilan) as HorsBilan
from 
(
select mvtw_age,mvtw_cli,cliw_int,mvtw_cha,
case when mvtw_cha between '37100' and '37299' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Courant,
case when mvtw_cha between '30100' and '32999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end as Credit,
case when mvtw_cha between '34100' and '34199' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Impayes,   
case when mvtw_cha between '34400' and '34599' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Douteux,   
case when mvtw_cha between '39100' and '39999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Provisions,  
case when mvtw_cha between '37400' and '37499' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Depot_Garantie,   
case when mvtw_cha between '93100' and '93199' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Titres_Foncier,   
case when mvtw_cha between '93200' and '93299' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Cash_Collateral,   
case when mvtw_cha between '92400' and '92499' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Cautions,   
case when mvtw_cha between '98100' and '98999' then nvl(sum(decode(mvtw_sen,'C', mvtw_mon,0)),0) - nvl(sum(decode(mvtw_sen,'D', mvtw_mon,0)),0) end  as Horsbilan	 
from mouvement2012 join compte2012  on (MVTW_CHA=comw_cha and mvtw_cli=comw_cli and mvtw_suf = comw_suf)
     join  clients  on comw_cli = cliw_cli
where mvtw_cli >='000999'
--where mvtw_cli in (select distinct comw_cli from compte2011 where comw_cha like '371%' and comw_cha not like '3718%' )
and mvtw_dco <= to_date('30/04/2012','DD/MM/YYYY')
group by mvtw_age,mvtw_cli,cliw_int,mvtw_cha
)
--where mvtw_age ='23'
having ( (sum(courant) <0) or (sum(credit) <0) )
and (sum(Courant) is not null) 
or (sum(Credit) is not null) 
or(sum(Impayes) is not null)
or(sum(Douteux) is not null) 
or(sum(Provisions) is not null) 
or (sum(Depot_Garantie) is not null) 
or (sum(Titres_Foncier) is not null) 
or(sum(Cash_Collateral) is not null) 
or(sum(Cautions) is not null) 
or(sum(HorsBilan) is not null)
group by mvtw_age,mvtw_cli,cliw_int;