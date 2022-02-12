-----------------------------------------------------------------------
-- Préparation du Référentiel pour l'intégartion de la nouvelle paie --
-----------------------------------------------------------------------
-- Chargement du fichier des traites
sqlldr delta23/nfc@delta control = x:\load\traiteSce02.ctl data=X:\Files\Recup_Impayes_06_2019.txt log = x:\files\Recup_Impayes_06_2019.log bad= x:\files\Recup_Impayes_06_2019.bad;

-- Vérification du chargement
select * from traite_sce where sce_date_traite ='&date';

-- Initialisation des positions et statuts des comptes

-- Purge de la table des positions et statuts
truncate table positions;

-- Recopie des Soldes à partir de fles (à exécuter en ligne de commande )
copy  from nfcread/nfcread1@fcubs to delta23/nfc@delta insert  positions using SELECT DISTINCT a.cust_ac_no POS_UBS_ACCOUNT , a.lcy_curr_balance + nvl(a.tod_limit,0) POS_BALANCE, a.ac_stat_dormant POS_STATUS_DORMANT, a.ac_stat_no_dr POS_NO_DEBIT,a.record_stat POS_RECORD_STAT, a.dormancy_date POS_DORMANCY_DATE  FROM xafnfc.sttms_cust_account a WHERE substr(a.account_class,1,2) ='28';

-- Vérification du chargement

select * from positions;
--- Initialisation des 
---update positions po set pos_salary ='Y' where exists (select * from traite_sce ts ,paie_fonctionnaire pf where ts.sce_matricule = pf.fon_matricule and pf.fon_fcubs_account = po.pos_ubs_account and ts.sce_date_traite ='&DateTrate' );

---  Initialisation des salaires en cours

update traite_sce set sce_salary = 
(
 select nvl(fon_montant_mois_actuel,0) from paie_fonctionnaire where fon_matricule = sce_matricule
)
where sce_date_traite = '&Date_Paie';

--- Initialisation du solde du compte 
update traite_sce set sce_position = 
(
 select nvl(pos_balance,0) from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';
--- Initialisation du statut dormant
update traite_sce set sce_dormancy = 
(
 select pos_status_dormant from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

-- Initialisation blocage
update traite_sce set sce_no_debit = 
(
 select pos_no_debit from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

--- Initialisation validité
update traite_sce set sce_record_stat = 
(
 select pos_record_stat from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

commit;

----- Etats et rapports
-- Liste des fonctionnaires débités avec couverture par la position
select sce.sce_agence as Agence,sce_dossier Dossier,sce_matricule,sce_nom Intitule,sce_Date_Traite,sce_montant Montant_A_Debiter, sce.sce_position as Position
from traite_sce sce 
where sce.sce_date_traite= '&Date_Traite'
--and sce.sce_montant < sce.sce_position 
and sce.sce_dormancy = 'N' 
and sce.sce_no_debit = 'N'
and sce.sce_record_stat ='O'
and nvl(sce.sce_salary,0) <> 0
order by sce.sce_matricule;

-- Etat en fichier Texte
-- Génération du fichier Texte pour envoi à la SCE

select 
ts.sce_dossier||rpad(ts.sce_nom,32,' ')||rpad(nvl(ts.sce_fcubs_account,' '),16,' ')||rpad(to_char(ts.sce_date_traite,'RRRRMMDD'),8,' ')||rpad(ts.sce_matricule,7,' ')||lpad(ts.sce_montant,15,'0')||
case when  (nvl(pf.fon_montant_mois_actuel,0) = 0) or (nvl(ts.sce_salary,0) = 0)  then 'IVIREME' 
     when ts.sce_fcubs_account is null  or ts.sce_record_stat ='C' then 'ICOMPTE'
     when ts.sce_matricule is null then 'IMATRIC'
     --when (ts.sce_montant >ts.sce_position) and  ((ts.sce_dormancy = 'N') or (ts.sce_no_debit = 'N')) then 'ICOMPTE'
     when ts.sce_position is null then 'IPROVIS'
     when ((ts.sce_dormancy = 'N') and (ts.sce_no_debit = 'N') and (ts.sce_record_stat ='O') ) then 'P      '    
    else null   
end Ligne
from traite_sce ts left join paie_fonctionnaire  pf on ts.sce_matricule = pf.fon_matricule
where sce_date_traite ='&Date';


--- Génération des fichiers de chargement à exécuter en ligne de commande

Execute sce_upload_files(&P_BATCH_NO,&P_DATE_PAIE);
