create role SAL_OPER
create role SAL_CONSULT
create role SAL_FON_UPDATE
create role SAL_ADMIN

-- Roles pour consulter
grant select on paie_fonctionnaire to SAL_CONSULT;
grant select on new_civil_servants to SAL_CONSULT;
grant select on new_fonctionnaires to SAL_CONSULT;
grant select on sal_cenadi to SAL_CONSULT;
grant select on paie to SAL_CONSULT;
grant select on new_accounts to SAL_CONSULT;
grant select on temp_salaire to SAL_CONSULT;

-- Roles pour opérer

grant select,insert,update,delete  on paie_fonctionnaire to SAL_OPER;
grant select,insert,update,delete  on new_civil_servants to SAL_OPER;
grant select,insert,update,delete  on new_fonctionnaires to SAL_OPER;
grant select,insert,update,delete  on sal_cenadi to SAL_OPER;
grant select,insert,update,delete  on paie to SAL_OPER;
grant select,insert,update,delete  on new_accounts to SAL_OPER;
grant select,insert,update,delete  on temp_salaire to SAL_OPER;

-- Roles pour saisir les nouveaux fonctionnaires
grant select,insert,update,delete  on new_civil_servants to SAL_FON_UPDATE;
grant select,insert,update,delete  on new_accounts to SAL_FON_UPDATE;
grant select,insert,update,delete  on new_fonctionnaires to SAL_FON_UPDATE;
grant execute on cenadi_upload_files to SAL_FON_UPDATE;
grant read,write on DIRECTORY OUTPUT to SAL_FON_UPDATE;


grant all on new_fonctionnaires to SAL_FON_UPDATE;

select table_name from user_tables where table_name like 'TMP%'

truncate table paie_fonctionnaire
truncate table sal_cenadi

insert into paie_fonctionnaire select * from tmp_paie_fonctionnaire
insert into sal_cenadi select distinct * from tmp_sal_cenadi

create user ndagha identified by nfc default tablespace users temporary tablespace temp;
grant connect to ndagha;

create user mbatcha identified by nfc default tablespace users temporary tablespace temp;
grant connect,resource to mbatcha;

create user nana identified by nfc default tablespace users temporary tablespace temp;
grant connect,resource to nana;

create user choumele identified by nfc default tablespace users temporary tablespace temp;
grant connect to choumele;


grant SAL_CONSULT to ndagha;
grant SAL_CONSULT to delta23;
grant SAL_CONSULT,SAL_OPER to mbatcha;
grant SAL_FON_UPDATE to nana;
grant SAL_OPER to choumele;


select 'create or replace public synonym '||table_name ||' for delta23.'||table_name||';' from user_tables
select 'drop public synonym '||table_name ||' ;' from user_tables


create or replace public synonym BACK_TMP_PAIE_FONCTIONNAIRE for delta23.BACK_TMP_PAIE_FONCTIONNAIRE;
create or replace public synonym BACK_NEW for delta23.BACK_NEW;
create or replace public synonym BACK_TEMP_PAIE for delta23.BACK_TEMP_PAIE;
create or replace public synonym TEMP_NEW_ACCOUNTS for delta23.TEMP_NEW_ACCOUNTS;
create or replace public synonym BACK_CNPS for delta23.BACK_CNPS;
create or replace public synonym RIC_NEW_CIVIL_SERVANTS for delta23.RIC_NEW_CIVIL_SERVANTS;
create or replace public synonym PAIE_CNPS for delta23.PAIE_CNPS;
create or replace public synonym SAL_CNPS for delta23.SAL_CNPS;
create or replace public synonym PAIE for delta23.PAIE;
create or replace public synonym TMP_PAIE_FONCTIONNAIRE for delta23.TMP_PAIE_FONCTIONNAIRE;
create or replace public synonym OLD_SAL_CENADI for delta23.OLD_SAL_CENADI;
create or replace public synonym TRAITE_SCE for delta23.TRAITE_SCE;
create or replace public synonym UPDATE_ACCOUNT for delta23.UPDATE_ACCOUNT;
create or replace public synonym TEMP_DELTA for delta23.TEMP_DELTA;
create or replace public synonym CP_MAP_DELTA_FCUBS for delta23.CP_MAP_DELTA_FCUBS;
create or replace public synonym UTILISATEURS for delta23.UTILISATEURS;
create or replace public synonym SOUSTRAITANTWU for delta23.SOUSTRAITANTWU;
create or replace public synonym SERVICES for delta23.SERVICES;
create or replace public synonym OPERATIONS for delta23.OPERATIONS;
create or replace public synonym EXERCICES for delta23.EXERCICES;
create or replace public synonym DEVISES for delta23.DEVISES;
create or replace public synonym COMPTEREF for delta23.COMPTEREF;
create or replace public synonym CLOTURES for delta23.CLOTURES;
create or replace public synonym UPL_NEW_CIVIL_SERVANTS for delta23.UPL_NEW_CIVIL_SERVANTS;
create or replace public synonym UPL_PAIE_FONCTIONNAIRE for delta23.UPL_PAIE_FONCTIONNAIRE;
create or replace public synonym PAIE_FONCTIONNAIRE for delta23.PAIE_FONCTIONNAIRE;
create or replace public synonym SAL_CENADI for delta23.SAL_CENADI;
create or replace public synonym NEW_ACCOUNTS for delta23.NEW_ACCOUNTS;
create or replace public synonym NEW_FONCTIONNAIRES_CNPS for delta23.NEW_FONCTIONNAIRES_CNPS;
create or replace public synonym NEW_CIVIL_SERVANTS for delta23.NEW_CIVIL_SERVANTS;
create or replace public synonym TMP_SAL_CENADI for delta23.TMP_SAL_CENADI;
create or replace public synonym POSITIONS for delta23.POSITIONS;
create or replace public synonym NEW_FONCTIONNAIRES for delta23.NEW_FONCTIONNAIRES;
create or replace public synonym MAP_MAT_NEW for delta23.MAP_MAT_NEW;
create or replace public synonym TEMP_SALAIRE for delta23.TEMP_SALAIRE;
create or replace public synonym MAP_DELTA_FCUBS for delta23.MAP_DELTA_FCUBS;
create or replace public synonym SETTLEMENT for delta23.SETTLEMENT;
create or replace public synonym OPERATIONSDIVERSES for delta23.OPERATIONSDIVERSES;
create or replace public synonym MOUVEMENTS for delta23.MOUVEMENTS;
create or replace public synonym CONTREPARTIES for delta23.CONTREPARTIES;
create or replace public synonym WU_DETB_UPLOAD_DETAIL for delta23.WU_DETB_UPLOAD_DETAIL;
create or replace public synonym frm50_enabled_roles for sys.frm50_enabled_roles;

select * from paie

drop PUBLIC synonym  COMPTE2011;

select 'create synonym '||object_name|| ' for delta.'||object_name from dba_objects where object_type ='SYNONYM' and owner ='PUBLIC'

select 'select * from  '||object_name|| ';' from dba_objects where object_type ='SYNONYM' and owner ='PUBLIC'


grant select on frm50_enabled_roles to public;

grant sal_consult to delta23

select * from dba_role_privs

select * from frm50_enabled_roles;
