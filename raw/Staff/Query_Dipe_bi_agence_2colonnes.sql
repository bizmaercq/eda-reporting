select z.exercice, z.numemois mois, a.codentge branch, z.matriemp||' '||e.nomemplo||' '||decode(e.prnemplo,null,'',' '||prnemplo) noms
     , z.colonne, z.valeur, z.matriemp matricule, a.codentge agence
     , (select g1.colonrap from groupe g1, grille g, contrat c
        where g1.numegrou = g.numegrou and g.codecate = c.codecate and g.codechel = c.codechel 
          and c.numesequ = (select max(numesequ) from contrat where matriemp = c.matriemp)
          and c.matriemp = e.matriemp) classe
from EMPLOYE e, 
     (select exercice, numemois, matriemp, '101-SALABASE' colonne, nvl(salabase,0)+nvl(heuresup,0)-nvl(retemiap,0) valeur, 1 ordre1, 1 ordre2 from salaire_mensuel
        union
      select exercice, numemois, matriemp, '2'||lpad(ordraffi,2,'0')||'-'||colonrap colonne, salabrut valeur, 2 ordre1, ordraffi ordre2 from salaire_mensuel_av sma, avantage a
      where a.codeavan = sma.codeavan
      union 
      select x.exercice, x.numemois, x.matriemp, '301-SALABRUT' colonne, salabrut+salabase valeur, 3 ordre1, 1 ordre2 from (
        select exercice, numemois, matriemp, sum(salabrut) salabrut from salaire_mensuel_av
        group by  exercice, numemois, matriemp)x, salaire_mensuel s
      where x.exercice||x.numemois||x.matriemp = s.exercice||s.numemois||s.matriemp
      union 
      select x.exercice, x.numemois, x.matriemp, '302-SALATAXA' colonne, salataxa+salabase valeur, 3 ordre1, 2 ordre2 from (
        select exercice, numemois, matriemp, sum(salataxa) salataxa from salaire_mensuel_av
        group by  exercice, numemois, matriemp)x, salaire_mensuel s
      where x.exercice||x.numemois||x.matriemp = s.exercice||s.numemois||s.matriemp
      union 
      select x.exercice, x.numemois, x.matriemp, '303-SALACOTI' colonne, salacoti+salabase valeur, 3 ordre1, 3 ordre2 from (
        select exercice, numemois, matriemp, sum(salacoti) salacoti from salaire_mensuel_av
        group by  exercice, numemois, matriemp)x, salaire_mensuel s
      where x.exercice||x.numemois||x.matriemp = s.exercice||s.numemois||s.matriemp
      union 
      select exercice, numemois, matriemp, '4'||lpad(ordraffi,2,'0')||'-'||decode(typerete,'SP',colonrap||'_SAL',colonrap) colonne, montrsal valeur, 4 ordre1, ordraffi ordre2 from salaire_mensuel_ret smr, retenue r
      where smr.coderete = r.coderete and smr.coderete not in ('AVAV', 'ACO', 'CATE', 'ASSA') and nvl(montrsal,0) <>0 
      union
      select exercice, numemois, matriemp, '501-ACOMPTE' colonne, montrsal_acom valeur, 5 ordre1, 1 ordre2 from (
        select exercice, numemois, matriemp, sum(montrsal) montrsal_acom from salaire_mensuel_ret
        where coderete in ('AVAV', 'ACO', 'CATE', 'ASSA')
        group by  exercice, numemois, matriemp)
      union 
      select exercice, numemois, matriemp, '502-RETENUE_SAL' colonne, tmontrsal valeur, 5 ordre1, 2 ordre2 from (
        select exercice, numemois, matriemp, sum(montrsal) tmontrsal from salaire_mensuel_ret
        group by  exercice, numemois, matriemp)
      union
      select exercice, numemois, matriemp, '503-NET' colonne, restenet valeur, 5 ordre1, 3 ordre2 from salaire_mensuel
      union 
      select exercice, numemois, matriemp, '6'||lpad(ordraffi,2,'0')||'-'||decode(typerete,'SP',colonrap||'_PAT',colonrap) colonne, montrpat valeur, 6 ordre1, ordraffi ordre2 from salaire_mensuel_ret smr, retenue r
      where smr.coderete = r.coderete and nvl(montrpat,0) <>0
      union 
      select exercice, numemois, matriemp, '701-RETENUE_PAT' colonne, tmontrpat valeur, 7 ordre1, 1 ordre2 from (
        select exercice, numemois, matriemp, sum(montrpat) tmontrpat from salaire_mensuel_ret
        group by  exercice, numemois, matriemp)
      ) z, affectation a
where z.matriemp = e.matriemp and z.numemois <= 12 --and z.exercice = :vexercice and z.numemois between :vnumemois1 and :vnumemois2
  and e.matriemp = a.matriemp
  and a.numesequ = (select max(numesequ) from affectation where matriemp = a.matriemp)
order by z.numemois, z.matriemp, ordre1, ordre2
