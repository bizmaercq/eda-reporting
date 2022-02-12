
-- très bon
select a.matriemp matricule, e.nomemplo||' '||e.prnemplo Noms
 , x.libefonc former_function, x.codentge former_branch, f.libefonc current_function, a.codentge current_branch
 , decode(x.libefonc,null,null,a.datedebu) date_of_change
 , months_between(last_day(to_date('28/'||to_char(&vNUMEMOIS)||'/'||to_char(&vEXERCICE),'dd/mm/yyyy'))+1, a.datedebu)/12 anc_dern_fonction
 , anciennete(e.matriemp, &vEXERCICE, decode(&vNUMEMOIS,13,12,&vNUMEMOIS))/12 anciennete_globale
from affectation a, employe e, fonction f,
(select matriemp, a0.codefonc, codentge, libefonc from affectation a0, fonction f0 where a0.codefonc = f0.codefonc and numesequ = (select max(numesequ) from affectation where matriemp = a0.matriemp)-1) x
where a.matriemp = e.matriemp and a.codefonc = f.codefonc
  and a.datedebu = (select max(datedebu) from affectation where matriemp = a.matriemp)
  and a.matriemp = x.matriemp (+)
  and a.matriemp in (select matriemp from contrat where numetave <>4)
order by a.matriemp
