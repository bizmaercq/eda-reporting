-----------------------------------------------------------------------
-- Préparation du Référentiel pour l'intégartion de la nouvelle paie --
-----------------------------------------------------------------------
--Chargement des salaires
sqlldr delta23/nfc@delta control= x:\load\salaires_cnps.ctl data=x:\files\VIR_NFC_01032021_31032021.txt
-- Vérification du chargement
select * from sal_cnps where to_char(scn_date_paie,'DD/MM/YYYY')='&Date_Paie';


-- Initialisation des soldes de la période précédente  et celle de la période de paie.
update paie_cnps pf set pf.fon_montant_mois_precedent = nvl(pf.fon_montant_mois_actuel,0);
update paie_cnps pf set pf.fon_montant_mois_actuel = 0;
commit; 
-- Vérification
SELECT * FROM paie_cnps;-- FOR UPDATE NOWAIT; 


-------------------------------------------------------------------------------------------------------------------------
-- Initialisation de la Paie du mois en cours                                                                          --
-------------------------------------------------------------------------------------------------------------------------

update paie_cnps pf set (pf.fon_montant_mois_actuel,pf.fon_date_dernier_salaire) =
(select sum(sc.scn_montant),to_char(sc.scn_date_paie,'DD-MON-RRRR')
 from sal_cnps sc
 where sc.scn_matricule = pf.fon_matricule
 and  trunc(scn_date_paie) ='&Date_Paie'
 group by sc.scn_matricule,sc.scn_date_paie
) ;

commit;


----------------------------------------------------------------------------------------------------------------------------
-- Etats Satistiques pour le Reporting                                                                                    --
----------------------------------------------------------------------------------------------------------------------------

-- Nouveaux Fonctionnaires

Select * from New_Fonctionnaires_cnps;

-- Déserteurs

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel,pf.fon_montant_mois_precedent
from paie_cnps pf 
where pf.fon_montant_mois_actuel is null 
and pf.fon_montant_mois_precedent <>0;

-- Recouvrement

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel,pf.fon_montant_mois_precedent 
from paie_cnps pf 
where pf.fon_montant_mois_actuel <>0 
and pf.fon_montant_mois_precedent =0;

-- Gros Salaires

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_cnps pf 
where pf.fon_montant_mois_actuel > 500000
order by pf.fon_agence,pf.fon_montant_mois_actuel desc;

-- Liste des fonctionnaires payés par Agence

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_cnps pf 
where pf.fon_montant_mois_actuel is not null 
order by pf.fon_agence;

-- Liste des fonctionnaires des Micro-Finances
-- Rural Investment
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_cnps pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0221730101338326' 
order by pf.fon_agence;

-- File for Upload
select scn_code||scn_matricule||rpad(scn_intitule,27,' ')||rpad(scn_compte,9,' ')||lpad(scn_montant,7,'0')
from scn_cnps where  to_char(scn_date_paie,'DD/MM/YYYY') =&Date_Paie and scn_matricule in 
(select fon_matricule
from paie_cnps where fon_fcubs_account = '0221730101338326' )




-- Customer who went to suspense
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_cnps pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account is null 
order by pf.fon_agence;




-- Statistiques par agence
Select pf.fon_agence,count(*) as Nombre,sum(pf.fon_montant_mois_actuel) as Total
from paie_cnps pf 
where pf.fon_montant_mois_actuel is not null 
group by pf.fon_agence;




-- Génération des Fichiers d'intégration de Flexcube

execute sal_cnps_upload_files(&Batch_Number,&Value_Date);

SELECT * FROM paie_fonctionnaire WHERE fon_matricule ='556434Z'
