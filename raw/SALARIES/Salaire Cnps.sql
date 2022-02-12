-----------------------------------------------------------------------
-- Préparation du Référentiel pour l'intégartion de la nouvelle paie --
-----------------------------------------------------------------------
--Chargement des salaires
sqlldr delta23/nfc@delta control= x:\load\salaires_cnps.ctl data=x:\files\VIR_NFC_MAI_2020.txt
select * from sal_cnps where to_char(scn_date_paie,'DD/MM/YYYY')='&Date_Paie' for update;
select * from paie_cnps;

-- Vidage de la table de nouveaux fonctionnaires
truncate table New_fonctionnaires_cnps;



-- Initialisation des soldes de la période de paie et celle de la période précédente.
update paie_cnps pf set pf.fon_montant_mois_precedent = nvl(pf.fon_montant_mois_actuel,0);
update paie_cnps pf set pf.fon_montant_mois_actuel = 0;
commit; 

-- Nouveaux Fonctionnaires
insert into New_fonctionnaires_cnps(fon_matricule,Fon_Agence,Fon_Delta_Account,Fon_Fcubs_Account,Fon_Intitule,Fon_Montant_Mois_Precedent,Fon_Montant_Mois_Actuel,fon_Date_creation,Fon_Date_Dernier_Salaire,Fon_Status )
select sc.scn_matricule,null,null,null,sc.scn_nom||' '||sc.scn_prenom,0,sc.scn_montant,sc.scn_date_paie,sc.scn_date_paie,0
from sal_cnps sc
where sc.scn_matricule not in 
(
 select pf.fon_matricule
 from paie_cnps pf
) 


-- Vérification des comptes inexistants

-- Attribution interactive des agences et des numéros de compte aux nouveaux clients

Select * from New_fonctionnaires_cnps for update;

-- Ajout d'un salarie

-- Insertion des nouveaux Fonctionnaires dans la table Permanente

insert into paie_cnps
(fon_matricule,fon_agence,fon_fcubs_account,fon_intitule,fon_montant_mois_actuel,fon_date_creation,fon_date_dernier_salaire,fon_status)
select 
fon_matricule,
nvl(fon_agence,'10') fon_Agence,
nvl(fon_fcubs_account,'454101000') fon_fcubs_account ,
fon_intitule,
fon_montant_mois_actuel,
fon_date_creation,
fon_date_dernier_salaire,
fon_status
from New_fonctionnaires_cnps nf;


-- Au cas ou le changement concerne un ancien fonctionnaire
select * from paie_cnps pf  where pf.fon_matricule = &Matricule for Update;


-------------------------------------------------------------------------------------------------------------------------
-- Initialisation des comptes Flexcube des fonctionnaires basées sur le mapping.                                       --
-- Cette Mise à jour ne concerne que les éventuels fonctionnaire dont les comptes viennent d'être ajouté dans Flexcube --
-- Elle n'est pas obligatoire                                                                                          --
-------------------------------------------------------------------------------------------------------------------------

update paie_cnps set fon_fcubs_account =
(select ma.fcubs_account_no
from cp_map_delta_fcubs ma
 where '000'||fon_delta_account = ma.delta_account_no
) where fon_fcubs_account is null;

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

-- Ajout manuel d'un salaire

select * from paie_cnps  for update;

select * from sal_cnps where to_char(scn_date_paie,'DD/MM/YYYY') ='&DatePaie' for update;

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
