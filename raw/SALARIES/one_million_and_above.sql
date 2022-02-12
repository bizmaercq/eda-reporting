select financial_year,sal_matricule,sal_intitule,date_of_birth,fon_fcubs_account,lcy_curr_balance,
sum(January) january,
sum(February) February,
sum(March) march,
sum(April) april,
sum(May) may,
sum(June) june,
sum(July) july,
sum(August) august,
sum(September) september,
sum(October) october,
sum(November) november,
sum(december) december

from
(
SELECT to_char(sc.sal_date_paie,'RRRR') financial_year, sc.sal_matricule,sc.sal_intitule,cp.date_of_birth ,pf.fon_fcubs_account,ca.lcy_curr_balance,
case when to_char(sc.sal_date_paie,'MON') = 'JAN' then sc.sal_montant else 0 end January,
case when to_char(sc.sal_date_paie,'MON') = 'FEB' then sc.sal_montant else 0 end February,
case when to_char(sc.sal_date_paie,'MON') = 'MAR' then sc.sal_montant else 0 end March,
case when to_char(sc.sal_date_paie,'MON') = 'APR' then sc.sal_montant else 0 end April,
case when to_char(sc.sal_date_paie,'MON') = 'MAY' then sc.sal_montant else 0 end May,
case when to_char(sc.sal_date_paie,'MON') = 'JUN' then sc.sal_montant else 0 end June,
case when to_char(sc.sal_date_paie,'MON') = 'JUL' then sc.sal_montant else 0 end July,
case when to_char(sc.sal_date_paie,'MON') = 'AUG' then sc.sal_montant else 0 end August,
case when to_char(sc.sal_date_paie,'MON') = 'SEP' then sc.sal_montant else 0 end September,
case when to_char(sc.sal_date_paie,'MON') = 'OCT' then sc.sal_montant else 0 end October,
case when to_char(sc.sal_date_paie,'MON') = 'NOV' then sc.sal_montant else 0 end November,
case when to_char(sc.sal_date_paie,'MON') = 'DEC' then sc.sal_montant else 0 end december
FROM sal_cenadi@delta_link sc , paie_fonctionnaire@delta_link pf,xafnfc.sttm_cust_personal cp,xafnfc.sttm_cust_account ca
WHERE sc.sal_matricule = pf.fon_matricule
and substr(pf.fon_fcubs_account,9,6) = cp.customer_no
and pf.fon_fcubs_account=ca.cust_ac_no
and sc.sal_montant >= 1000000 
) 
group by financial_year,sal_matricule,sal_intitule,date_of_birth,fon_fcubs_account,lcy_curr_balance
order by financial_year,sal_intitule;


