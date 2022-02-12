SELECT * FROM employe em WHERE em.matriemp in 
(SELECT distinct a.matriemp FROM intervenant a) and em.matriemp not in (SELECT matriemp FROM poste_travail)order by nomemplo;

SELECT * FROM employe FOR UPDATE NOWAIT; 

