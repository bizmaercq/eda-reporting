
--- Registrations and Monthly Contributions
select smr.matriemp, nomemplo||' '||prnemplo name, exercice year, numemois month, decode(smr.coderete,'EMNS','REGISTRATION','MONTHLY DEDUCTION') DESCRIPTION,smr.montrsal amount
      , decode(c.numetave,4,'FORMER STAFF','IN SERVICE') status
from SALAIRE_MENSUEL_RET smr, employe e, contrat c
where e.matriemp = smr.matriemp and smr.matriemp = c.matriemp
  and coderete in  ('EMNS','CMNS')
  and c.numesequ = (select max(numesequ) from contrat where matriemp = c.matriemp)
order by matriemp, exercice, numemois
--------Registrations and Monthly Contributions avec parametre
select '0'||e.banqpaie BRANCH,smr.matriemp, nomemplo||' '||prnemplo name, exercice year, numemois month, decode(smr.coderete,'EMNS','REGISTRATION','MONTHLY DEDUCTION') DESCRIPTION,smr.montrsal amount
      , decode(c.numetave,4,'FORMER STAFF','IN SERVICE') status
from SALAIRE_MENSUEL_RET smr, employe e, contrat c
where e.matriemp = smr.matriemp and smr.matriemp = c.matriemp
  and coderete in  ('EMNS','CMNS')
  and c.numesequ = (select max(numesequ) from contrat where matriemp = c.matriemp)
  and e.banqpaie='&branch'
  and smr.exercice='&year'
  and smr.numemois='&month'
order by matriemp, exercice, numemois
