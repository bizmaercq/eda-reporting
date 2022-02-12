select branch,matricle,name,sum(JANUARY) JANUARY_&Year,sum(FEBRUARY) FEBRUARY_&Year,sum(MARCH) MARCH_&Year,sum(APRIL) APRIL_&Year,sum(MAY) MAY_&Year,sum(JUNE) JUNE_&Year,
sum(JULY) JULY_&Year,sum(AUGUST) AUGUST_&Year,sum(SEPTEMBER) SEPTEMBER_&Year,sum(OCTOBER) OCTOBER_&Year,sum(NOVEMBER) NOVEMBER_&Year,sum(DECEMBER) DECEMBER_&Year
from
(select pf.fon_agence Branch,hc.matricule MATRICLE,hc.noms NAME, 
case when hc.mois ='JANUARY' then hc.montant_salaire else 0 end JANUARY ,
case when hc.mois ='FEBRUARY' then hc.montant_salaire else 0 end FEBRUARY ,
case when hc.mois ='MARCH' then hc.montant_salaire else 0 end MARCH ,
case when hc.mois ='APRIL' then hc.montant_salaire else 0 end APRIL ,
case when hc.mois ='MAY' then hc.montant_salaire else 0 end MAY ,
case when hc.mois ='JUNE' then hc.montant_salaire else 0 end JUNE ,
case when hc.mois ='JULY' then hc.montant_salaire else 0 end JULY ,
case when hc.mois ='AUGUST' then hc.montant_salaire else 0 end AUGUST ,
case when hc.mois ='SEPTEMBER' then hc.montant_salaire else 0 end SEPTEMBER ,
case when hc.mois ='OCTOBER' then hc.montant_salaire else 0 end OCTOBER ,
case when hc.mois ='NOVEMBER' then hc.montant_salaire else 0 end NOVEMBER ,
case when hc.mois ='DECEMBER' then hc.montant_salaire else 0 end DECEMBER 
from historique_cenadi hc,paie_fonctionnaire pf
where hc.matricule = pf.fon_matricule
and hc.annee =_&Year)
group by branch,matricle,Name
