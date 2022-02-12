-----------------------------------------------------------------------
-- Pr�paration du R�f�rentiel pour l'int�gartion de la nouvelle paie --
-----------------------------------------------------------------------
-- Chargement du fichier des traites
sqlldr delta23/nfc@delta control = x:\load\traiteSce02.ctl data=X:\Files\Recup_Impayes_12_2020.txt log = x:\files\Recup_Impayes_12_2020.log bad= x:\files\Recup_Impayes_12_2020.bad;
select * from traite_sce where sce_date_traite ='&date';

-- account = 0221730101291863

SELECT * FROM paie_fonctionnaire pf WHERE pf.fon_fcubs_account ='0202820100449636';

-- Initialisation des positions des comptes
select * from positions WHERE pos_ubs_account = '0202820100449636';
truncate table positions;
delete from positions WHERE substr(pos_ubs_account,1,3) = '043';
copy  from nfcread/nfcread1@fcubs to delta23/nfc@delta insert  positions using SELECT DISTINCT a.cust_ac_no POS_UBS_ACCOUNT , a.lcy_curr_balance + nvl(a.tod_limit,0) POS_BALANCE, a.ac_stat_dormant POS_STATUS_DORMANT, a.ac_stat_no_dr POS_NO_DEBIT,a.record_stat POS_RECORD_STAT, a.dormancy_date POS_DORMANCY_DATE FROM xafnfc.sttms_cust_account a WHERE substr(a.account_class,1,2) ='28';
--- Block accounts of more than 1 000 000
---  Initialisation des salaires en cours

update traite_sce set sce_salary = 
(
 select nvl(fon_montant_mois_actuel,0) from paie_fonctionnaire where fon_matricule = sce_matricule
)
where sce_date_traite = '&Date_Paie';


update traite_sce set sce_position = 
(
 select nvl(pos_balance,0) from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

update traite_sce set sce_dormancy = 
(
 select pos_status_dormant from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

update traite_sce set sce_no_debit = 
(
 select pos_no_debit from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

update traite_sce set sce_record_stat = 
(
 select pos_record_stat from positions where pos_ubs_account = sce_fcubs_account
)
where sce_date_traite = '&Date_Paie';

commit;


----------------------------------------------------------------------------------------------------------------------------
-- Etats Satistiques pour le Reporting                                                                                    --
----------------------------------------------------------------------------------------------------------------------------
-- Fonctionnaires n'ayant pas pu �tre d�bit�
select sce_matricule,sce_dossier Dossier,sce_nom Intitule,sce_Date_Traite,sce_montant Montant_A_Debiter, sce.sce_position as Position, sce.sce_dormancy, sce.sce_no_debit
from traite_sce sce 
where  sce.sce_date_traite= '&Date_Traite'
and ( ( sce.sce_montant > sce.sce_position)
or  (sce.sce_dormancy = 'Y' or sce.sce_no_debit = 'Y' or sce.sce_record_stat ='C') );


-- Fonctionnaires n'ayant pas pu �tre d�bit� mais ayant un solde positif
select sce.sce_agence as agence , sce_dossier Dossier,sce_matricule,sce_nom Intitule,sce_Date_Traite,sce_montant Montant_A_Debiter, sce.sce_position as Position
from traite_sce sce 
where sce.sce_date_traite= '&Date_Traite'
and sce.sce_montant > sce.sce_position 
and sce.sce_position >0
union
-- Liste des fonctionnaires d�bit�s avec couverture par la position
select sce.sce_agence as Agence,sce_dossier Dossier,sce_matricule,sce_nom Intitule,sce_Date_Traite,sce_montant Montant_A_Debiter, sce.sce_position as Position
from traite_sce sce 
where sce.sce_date_traite= '&Date_Traite'
--and sce.sce_montant < sce.sce_position 
and sce.sce_dormancy = 'N' 
and sce.sce_no_debit = 'N'
and sce.sce_record_stat ='O'
order by sce.sce_matricule;

SELECT * FROM traite_sce WHERE sce_date_traite='22/03/2020'

-- G�n�ration du fichier Texte pour envoi � la SCE

select 
ts.sce_dossier||rpad(ts.sce_nom,32,' ')||rpad(nvl(ts.sce_fcubs_account,' '),16,' ')||rpad(to_char(ts.sce_date_traite,'RRRRMMDD'),8,' ')||rpad(ts.sce_matricule,7,' ')||lpad(ts.sce_montant,15,'0')||
case when  (nvl(pf.fon_montant_mois_actuel,0) = 0) and (ts.sce_montant >ts.sce_position) then 'IVIREME' 
     when ts.sce_fcubs_account is null  or ts.sce_record_stat ='C' then 'ICOMPTE'
     when ts.sce_matricule is null then 'IMATRIC'
     --when (ts.sce_montant >ts.sce_position) and  ((ts.sce_dormancy = 'N') or (ts.sce_no_debit = 'N')) then 'ICOMPTE'
     when ts.sce_position is null then 'IPROVIS'
     when ((ts.sce_dormancy = 'N') and (ts.sce_no_debit = 'N') and (ts.sce_record_stat ='O') ) then 'P      '    
    else null   
end Ligne
from traite_sce ts left join paie_fonctionnaire  pf on ts.sce_matricule = pf.fon_matricule
where sce_date_traite ='&Date';


-- G�n�ration des Fichiers de Chargement

Execute sce_upload_files(&P_BATCH_NO,&P_DATE_PAIE);





