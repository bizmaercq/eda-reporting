-----------------------------------------------------------------------
-- Pr�paration du R�f�rentiel pour l'int�gartion de la nouvelle paie --
-----------------------------------------------------------------------
-- Chargement des salaires


--- From CENADI File on CD
sqlldr delta23/nfc@delta control = x:\load\salaires_sup.ctl data=x:\files\Nfc_Act_Et_Pen_201506_sup.txt log = x:\files\Nfc_Act_Et_Pen_201506_sup.log bad= x:\files\Nfc_Act_Et_Pen_201506_sup.bad;
--- From EFT Upload file from SYSTAC
sqlldr nfcread/nfcread1@fcubs control = x:\load\eft.ctl data=x:\files\eftupd.txt log = x:\files\eftupd.log bad= x:\eftupd.bad;




SELECT count(*) FROM sal_cenadi sc where sc.sal_date_paie='23/08/2019';


select *  from sal_cenadi sc where sc.sal_date_paie='23-mar-2018' and sc.sal_matricule not in  (select pf.fon_matricule from paie_fonctionnaire pf )


select sc.sal_matricule,sc.sal_intitule,count(*)  from sal_cenadi sc 
where sc.sal_date_paie='23-mar-2018'
group by  sc.sal_matricule,sc.sal_intitule
having count(*) >1

-- Vidage de la table de nouveaux fonctionnaires
truncate table New_fonctionnaires;

-- Nouveaux Fonctionnaires
insert into New_fonctionnaires(fon_matricule,Fon_Agence,Fon_Delta_Account,Fon_Fcubs_Account,Fon_Intitule,Fon_Montant_Mois_Precedent,Fon_Montant_Mois_Actuel,fon_Date_creation,Fon_Date_Dernier_Salaire,Fon_Status )
select sc.sal_matricule,null,null,null,sc.sal_intitule,0,sc.sal_montant,sc.sal_date_paie,sc.sal_date_paie,0
from sal_cenadi sc
where  sc.sal_matricule not in 
(
 select pf.fon_matricule
 from paie_fonctionnaire pf
) ;


-- Initialisation des soldes de la p�riode de paie et celle de la p�riode pr�c�dente.
update paie_fonctionnaire pf set pf.fon_montant_mois_precedent = nvl(pf.fon_montant_mois_actuel,0);
update paie_fonctionnaire pf set pf.fon_montant_mois_actuel = 0;
commit; 



-- Attribution interactive des agences et des num�ros de compte aux nouveaux clients

Select * from New_fonctionnaires where fon_fcubs_account is null for update;

update new_fonctionnaires set fon_agence = substr (fon_fcubs_account,2,2)

-- mise � jour des comptes des nouveaux fonctionnaires � partir des fichiers des nouveaux comptes
select * from new_civil_servants ncs where ncs.ncs_matricule in (select fon_matricule from new_fonctionnaires );

update New_Fonctionnaires pf set pf.fon_fcubs_account = 
(
  select substr(n.ncs_fcubs,8,16) from new_civil_servants n where n.ncs_matricule = pf.fon_matricule
)where pf.fon_fcubs_account is null;

update paie_fonctionnaire pf set pf.fon_fcubs_account= (select na_fcubs_account from New_accounts where pf.fon_matricule = na_matricule) 
where pf.fon_matricule in (select na_matricule from new_accounts) 


-- Insertion des nouveaux Fonctionnaires dans la table Permanente
insert into paie_fonctionnaire
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
from New_fonctionnaires nf
where nf.fon_matricule not in (select pf.fon_matricule from paie_fonctionnaire pf);



-- initialisation des comptes Flexcube pour les nouveaux fonctionnaires

update paie_fonctionnaire pf set pf.fon_fcubs_account = 
(
  select substr(n.ncs_fcubs,8,16) from new_civil_servants n where n.ncs_matricule = pf.fon_matricule
)where pf.fon_fcubs_account is null;

-- Initialisation  pour les clients ayant uniquement des comptes de Delta
update paie_fonctionnaire pf set pf.fon_agence = nvl(substr(pf.fon_delta_account,1,2),'10') 
where fon_fcubs_account is null
and fon_delta_account is not null
and fon_montant_mois_actuel is not null;

-- Initialisation  pour les clients ayant des comptes Flexcube
update paie_fonctionnaire pf set pf.fon_agence = nvl(substr(pf.fon_fcubs_account,2,2),'10') 
where  fon_fcubs_account is not null
and fon_fcubs_account <> '454101000' 
and fon_delta_account is null
and fon_montant_mois_actuel is not null;

commit;

-- Au cas ou le changement concerne un ancien fonctionnaire
select * from paie_fonctionnaire pf  where pf.fon_matricule = '&Matricule' ;
select * from paie_fonctionnaire pf  where pf.fon_date_dernier_salaire= '26-MAR-2018';

select * from historique_cenadi pf  where pf.matricule = '&Matricule'
ORDER BY ANNEE ;

select * from paie_fonctionnaire pf  where pf.fon_fcubs_account='0231510205218435' --for Update;
SELECT * FROM PAIE_FONCTIONNAIRE P WHERE fon_delta_account ='213728023032052'
select * from paie_fonctionnaire pf  where pf.fon_fcubs_account like '019358%'
select * from paie_fonctionnaire pf  where pf.fon_intitule like '%LAMBERT%' 
select * from paie_CNPS pf  where pf.fon_intitule like '%LAMBERT%'
select * from paie_CNPS pf where pf.fon_fcubs_account='0302820101935817'
select * from paie_cnps where pf.FON_matricule = '&Matricule'
-------------------------------------------------------------------------------------------------------------------------
-- Initialisation des comptes Flexcube des fonctionnaires bas�es sur le mapping.                                       --
-- Cette Mise � jour ne concerne que les �ventuels fonctionnaire dont les comptes viennent d'�tre ajout� dans Flexcube --
-- Elle n'est pas obligatoire                                                                                          --
-------------------------------------------------------------------------------------------------------------------------

update paie_fonctionnaire set fon_fcubs_account =
(select ma.fcubs_account_no
from cp_map_delta_fcubs ma
 where '000'||fon_delta_account = ma.delta_account_no
) where fon_fcubs_account is null;

-------------------------------------------------------------------------------------------------------------------------
-- Initialisation de la Paie du mois en cours                                                                          --
-------------------------------------------------------------------------------------------------------------------------
truncate table temp_salaire;

insert into temp_salaire 
select sc.sal_matricule,sc.sal_date_paie,sum(sc.sal_montant) sal_montant ,'27/08/2012' sal_value_date
 from tmp_sal_cenadi sc
 where   to_char(sal_date_paie,'DD/MM/YYYY') =&DatePaie
 group by sc.sal_matricule,sc.sal_date_paie;

update paie_fonctionnaire pf set pf.fon_montant_mois_precedent = pf.fon_montant_mois_actuel;
update paie_fonctionnaire pf set (pf.fon_montant_mois_actuel,pf.fon_date_dernier_salaire) =
(select sum(sc.sal_montant),sc.sal_value_date
 from temp_salaire sc
 where sc.sal_matricule = pf.fon_matricule
) ;

commit;


----------------------------------------------------------------------------------------------------------------------------
-- Etats Satistiques pour le Reporting                                                                                    --
----------------------------------------------------------------------------------------------------------------------------

-- Nouveaux Fonctionnaires

Select * from New_Fonctionnaires order by fon_agence;

-- Nouveaux fonctionnaires sans compte Flexcube
Select * from New_Fonctionnaires where fon_fcubs_account is null;
select * from historique_cenadi;

-- D�serteurs

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel,pf.fon_montant_mois_precedent
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is null 
and pf.fon_montant_mois_precedent <>0;

-- Recouvrement

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel,pf.fon_montant_mois_precedent 
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel <>0 
and pf.fon_montant_mois_precedent =0

-- Gros Salaires

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel > 500000
order by pf.fon_agence,pf.fon_montant_mois_actuel desc;

-- Liste des fonctionnaires pay�s par Agence

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null 
order by pf.fon_agence;

-- liste des fonctionnaires dont les salaires iront en suspense
select fon_agence,fon_matricule,fon_delta_account,fon_fcubs_account,fon_intitule,fon_montant_mois_actuel 
from paie_fonctionnaire 
where (fon_fcubs_account is null or fon_fcubs_account ='454101000') and fon_montant_mois_actuel is not null;


-- Liste des fonctionnaires des Micro-Finances

-- Toutes les Microfinances
Select (select cliw_int from delta.clients where cliw_cli = substr(pf.fon_delta_account,8,6) ) Micro_finance , pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf
where pf.fon_montant_mois_actuel is not null
and substr(pf.fon_fcubs_account,4,2)='17' 
order by pf.fon_fcubs_account, pf.fon_agence,pf.fon_intitule;



-- Rural Investment
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0221730101338326' 
order by pf.fon_agence,pf.fon_intitule;



--- File for Upload RIC ex date :24/06/2013
select sal_code||sal_matricule||rpad(sal_intitule,27,' ')||rpad(sal_compte,9,' ')||lpad(sal_montant,7,'0') LINE
from sal_cenadi where  to_char(sal_date_paie,'DD/MM/YYYY') ='&Date_Paie' and sal_matricule in 
(select fon_matricule
from paie_fonctionnaire pf where fon_fcubs_account = '0221730101338326'  and pf.fon_matricule  is not null)



-- citty Trust 
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0221730101384304' 
order by pf.fon_agence;


-- CRENAC
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0231510101591977' 
order by pf.fon_agence;

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_delta_account='213728023095587K' 
order by pf.fon_agence;



select * from paie_fonctionnaire

-- MONEY OPPORTUNITY
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_precedent, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0221720101243606' 
order by pf.fon_agence; 

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
order by pf.fon_agence,pf.fon_matricule; 

--bayelle credit union
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_precedent, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0301730102020407'
order by pf.fon_agence;

Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_precedent, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_delta_account='0203728020749754' 
order by pf.fon_agence;


Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_precedent, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_fcubs_account='0432820105330428' 
order by pf.fon_agence;

-- Statistiques par agence
Select pf.fon_agence,count(*) as Nombre,sum(pf.fon_montant_mois_actuel) as Total
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null 
group by pf.fon_agence;

-- Civil servants and their last pay date

select sal_matricule,sal_intitule,max(to_char(sal_date_paie,'DD/MM/YYYY') )
from sal_cenadi WHERE sal_matricule = '510883C'
group by sal_matricule,sal_intitule;


select sal_matricule,sal_intitule,sal_date_paie 
from sal_cenadi WHERE sal_matricule = '11554H'
order by sal_date_paie desc
--group by sal_matricule,sal_intitule;


-- G�n�ration des Fichiers d'int�gration de Flexcube

execute sal_upload_files(&Batch_Number,'26/09/2012');
execute sal_upload_files_sup('9999','02/07/2015');

-- divers clients 
Select pf.fon_agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
and pf.fon_matricule='033824D' 
order by pf.fon_agence;

SELECT * from paie_fonctionnaire b where b.fon_matricule='579456'
SELECT * from paie_fonctionnaire b where b.fon_intitule like '%KUM%'


SELECT * from paie_fonctionnaire b where b.fon_fcubs_account='0302820101935817'

--- Suppression d'une ligne de salaire non re�u.
select * from sal_cenadi where sal_matricule='074481H' and sal_date_paie='25-sep-2014' for update;
---- Historique des salaiares re�us par fonctionnaire
select * from historique_cenadi where matricule='529219Y' order by annee, mois, date_chargement
select * from historique_cenadi where substr(noms,1,6)='KUM SAMPSON' order by noms, annee, date_chargement
select * from historique_cenadi where noms like '%KUM%' order by noms, annee, date_chargement
select * from historique_cenadi where noms like '%HLAMNA%' and annee='2008' order by annee, mois, date_chargement

---- Mise � Jour Historique des salaiares re�us pour le mois
select * from historique_cenadi where matricule='H026562' order by annee, mois
select * from historique_cenadi where matricule like '579456%' order by annee, mois

-- CHARGER LE FICHIER avec la prodecure chargement.bat dans 172.20.50.153
---affichage des salaires import�s
select * from historique_cenadi where mois is null
update historique_cenadi set annee='2018' where mois is null 
update historique_cenadi set mois='03'  where mois is null
select * from historique_cenadi where mois = '04' and annee='2018' order by annee,mois,matricule
---- statistique sur les fonctionnaires 
select * from  historique_cenadi ;
select annee,mois, count(*) from historique_cenadi group by annee,mois
order by annee,mois;
update historique_cenadi set mois='05'  where mois='JUL'
create table sal_cenadi_sup as select * from sal_cenadi where 1=2;
select * from mouvement2012 where mvtw_age='40' and mvtw_mon=7009680 -- and  mvtw_dco='&DATE' 
order by mvtw_lib;
 
select to_char(to_date(mois||'/'||annee,'MM/YYYY'),'MONTH YYYY') PERIOD, count(*) as " Nombres de fonctionnaires" from historique_cenadi
group by to_date(mois||'/'||annee,'MM/YYYY'),to_char(to_date(mois||'/'||annee,'MM/YYYY'),'MONTH YYYY')
order by  to_date(mois||'/'||annee,'MM/YYYY');

--- extrations mvt d'une date pour une agence
select * from mouvement2011 where mvtw_age='23' and mvtw_dco='&DATE' --- and mvtw_ope='403'
order by mvtw_lib;

select * from mouvement2012 where mvtw_dco='&DATE' and mvtw_lib='Trsf to Yde'
order by mvtw_lib;

select * from mouvement2012 where mvtw_age='40' and mvtw_dco='&DATE' 
order by mvtw_lib;

select * from mouvement2008 where mvtw_age='30' and mvtw_dco='&DATE' order by mvtw_lib;
37280 207148 34
select * from mouvement2011 where  mvtw_age='23' and mvtw_cha='37292' and mvtw_cli='006000' and mvtw_suf='01' ---and mvtw_mon=15300  order by mvtw_dco;

select mvtw_dco,mvtw_dva,mvtw_ope,mvtw_lib,mvtw_mon,mvtw_sen,mvtw_lic,mvtw_uti  from mouvement2011 where  mvtw_cha='37155' and mvtw_cli='281739' and mvtw_suf='47'  order by mvtw_dco;
---- Selection pour montant connu
select * from mouvement2011 where mvtw_age='42' and mvtw_lig ='07310' order by mvtw_dco, mvtw_lib ;

select * from mouvement2011 where mvtw_age='23' and mvtw_mon=2829750 order by mvtw_lib;

select * from mouvement2010 where mvtw_age='42'  and mvtw_lib='DIVERS     CH3998012' and mvtw_dco ='&date' order by mvtw_lib;

DIVERS     CH3998012

select * from mouvement2012 where mvtw_age='23' and mvtw_mon=3592094 order by mvtw_lib;

select * from mouvement2009 where mvtw_cha='37197' and mvtw_cli='480860' and mvtw_suf='76'
order by mvtw_dco;

select * from mouvement2011 where mvtw_age='40' and  substr(mvtw_lib,1,5)='4498518' and mvtw_dco='&DATE'
order by mvtw_lib;

select * from mouvement2010 where mvtw_age='20'  and mvtw_lib LIKE '%NSANGAY%' ORDER BY MVTW_DCO
select * from mouvement2010 where mvtw_cha='38400' and mvtw_cli='000678' and mvtw_suf='03' and mvtw_mon=76000
select * from tab;---- affiche toutes les tables du chemas
select * from clients where cliw_age=30 and cliw_int LIKE '%NKUV  VITALIS%';
select * from clients where cliw_age=30 and cliw_cli='305942';
order by mvtw_lib;


select * from paie_fonctionnaire  order by fon_agence, fon_matricule;

Select pf.fon_agence agence,pf.fon_matricule,pf.fon_intitule,pf.fon_fcubs_account,pf.fon_montant_mois_precedent, pf.fon_montant_mois_actuel
from paie_fonctionnaire pf 
where pf.fon_montant_mois_actuel is not null
order by pf.fon_agence; 




-- AFIB '0231630101465386'
--CREMINCAM '0231510101537851'
-- Peoples finance 0231510101585672'
-- PWD Mamfe '0221510101217863'


SELECT *  From paie_fonctionnaire pf WHERE pf.fon_montant_mois_actuel <>0 and substr(pf.fon_fcubs_account,4,3)  not in ('282','173','151','172')

SELECT * FROM paie_fonctionnaire pf WHERE pf.fon_fcubs_account in ('0221730101338326','0221720101243606','0201720100667844','0221510106096866','0231510105218419','0311510106944511','0231510101585672') 

SELECT *from sal_cenadi sc WHERE sc.sal_matricule ='867571Y'