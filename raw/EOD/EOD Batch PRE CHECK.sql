
--1 --  TRANSACTION DU SIEGE ET DE CPU EN ATTENTE   --   

select * from xafnfc.eivw_pending_items XA

--2 --- OPERATIONS ET TRANSACTIONS DE CAISSE EN ATTENTE au NIVEAU DES AGENCES ---
 
SELECT * FROM XAFNFC.FBTB_TXNLOG_MASTER where TXNSTATUS NOT IN ('COM','DIS','REV','FAL') --- AND BRANCHCODE='023'
AND FUNCTIONID NOT IN ('TVCL','TVQR','EODM','LOCH')
ORDER BY BRANCHCODE --for update
--------OPERATIONS ET TRANSACTIONS DE CAISSE EN ATTENTE
select f.xrefid,F.branchcode, C.BRANCH_NAME, FUNCTIONID, b.sub_menu_2, Makerid, ASSIGNEDTO
from fbtb_txnlog_master f, smtb_function_description b, STTM_BRANCH C
where f.txnstatus = 'IPR'
AND C.BRANCH_CODE = F.branchcode
and f.functionid not in ('TVCL', 'TVQR', 'EODM')
and b.function_id = F.functionid
and F.POSTINGDATE = '&PM_DATE'
ORDER BY F.branchcode, C.BRANCH_NAME, F.FUNCTIONID, Makerid, ASSIGNEDTO

-- POUR VOIR LA TRANSACTION AVEC LA REFERENCE -- 
--NOTE DO NOT DISCARD A TRANSACTION THAT IS COM, discard only for IPR and WTS by changing TXNSTATUS and STAGESTATUS
SELECT * FROM XAFNFC.FBTB_TXNLOG_MASTER WHERE XREFID='FJB2016806479482' --FOR UPDATE


--3 --- VERIFICATION DES CAISSES ET COFFRES ENCORE OUVERTS  ---

SELECT * FROM XAFNFC.FBTB_TILL_MASTER WHERE BALANCED_IND='N'

--4 --SIGNATURES NON AUTORISEES 

select * from XAFNFC.eivw_pending_items cd where cd.MD <> 'MA'
---TO discard, change AUTH_STAT from U to X
select * from xafnfc.sttb_record_log where auth_stat = 'U' ---for update

--5 --- Verification des agences qui n'ont pas encore fait leurs EODM ---

SELECT * FROM xafnfc.STTM_BRANCH WHERE BRANCH_CODE NOT IN 
(    select BRANCH_CODE from xafnfc.sttb_brn_eodm where RUN_DATE='&DATE' ) order by BRANCH_CODE


--6 --- VERIFICATION DES UTILISATEURS ENCORE CONNECTES DANS LE SYSTEME   ---
 
select * from xafnfc.smtb_current_users ---for update;

-- 7--- Verifier qu'il n'y a pas de desequilibre comptable apres la fermeture des agences  ---
select * FROM xafnfc.actb_daily_log lo where lo.batch_no = '1026'
SELECT * FROM getm_liab WHERE id = '91822';
--8 ---  Verifier si le debug est ON pour un utilisateur --- ---
SELECT * FROM CSTB_DEBUG_USERS WHERE DEBUG ='Y';
SELECT * FROM CSTB_PARAM WHERE PARAM_NAME='REAL_DEBUG';
SELECT * FROM CSTB_DEBUG WHERE DEBUG ='Y';

-- 9 -- SWITCH OFF DEBUG check this every times before start the EOD ---

UPDATE XAFNFC.CSTB_DEBUG_USERS SET DEBUG='N' WHERE debug='Y'

UPDATE XAFNFC.CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG'
  
--10 Mettre le ONLINE BANKING OFF avant le EOD 
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'Y' WHERE JOB = 'EOD';

--11 Mettre le ONLINE BANKING ON apres le EOD
UPDATE TEK_IB_MAINTENANCE SET STATUS = 'N' WHERE JOB = 'EOD';

****status eodm**************
select * from sttb_brn_eodm where run_date='18-Oct-2021'; --today`s date


************************ update le eodm*************
update fbtm_branch_info_tb
   set currentpostingdate = to_date(20210705, 'RRRRMMDD'), --next working date
       nextpostingdate    = to_date(20210706, 'RRRRMMDD')  --next next working date
 where branch_code   in ('012'); -- for which branch you want to run

insert into STTB_BRN_EODM (BRANCH_CODE, RUN_DATE, EOD_RUN)
values ('012', to_date('02-07-2021', 'dd-mm-yyyy'), 'Y'); --today`s date and branch


****************debug******************
--enable debug
update cstb_param set param_val = 'Y' where param_name = 'REAL_DEBUG';
update cstb_debug set debug = 'Y';
update cstb_debug_users set debug = 'Y';
commit;
