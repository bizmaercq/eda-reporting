-- Truncating tables
truncate table flexcube.SI_SITB_UPLOAD_INSTRUCTION;
truncate table flexcube.SI_SITB_UPLOAD_MASTER;


-- SI Master Upload
-- Sitb_Upload_Master
insert into flexcube.SI_Sitb_Upload_Master
(
BRANCH_CODE,
SOURCE_CODE,
SOURCE_REF,
DETAIL_REF,
USER_REF_NUMBER,
SI_EXPIRY_DATE,
BOOK_DATE,
PRODUCT_CODE,
COUNTERPARTY,
PRODUCT_TYPE,
SERIAL_NO,
ACTION_CODE_AMT,
APPLY_CHG_SUXS,
APPLY_CHG_PEXC,
APPLY_CHG_REJT, 
MAX_RETRY_COUNT,
MIN_SWEEP_AMT,
DR_ACC_BR,
DR_ACCOUNT,
DR_ACC_CCY,
SI_AMT_CCY,
SI_AMT,
CR_ACC_BR,
CR_ACCOUNT,
CR_ACC_CCY,
PRIORITY,
CHARGE_WHOM,
MIN_BAL_AFTER_SWEEP,
INTERNAL_REMARKS,
ICCF_CHANGED,
TAX_CHANGED,
SETTLE_CHANGED,
MIS_CHANGED,
CONV_STATUS,
ERR_MSG,
AUTHORIZE,
CONTRACT_REF_NO,
VERSION_NO,
INSTRUCTION_NO,
TRANSFER_TYPE,
SUBSYSTEM_STAT,
FUNCTION_ID,
SOURCE_SEQ_NO,
UPLOAD_ID,
ACTION_CODE
) 
select 
'0'||dsi.fon_agence as BRANCH_CODE,
'NFCSOURCE' as SOURCE_CODE,
--dsi.SI_FROM_BRANCH||lpad(dsi.SI_NUMBER,4,'0') as SOURCE_REF,
--dsi.SI_FROM_BRANCH||lpad(dsi.SI_NUMBER,4,'0') as DETAIL_REF,
--dsi.SI_FROM_BRANCH||lpad(dsi.SI_NUMBER,4,'0') as USER_REF_NUMBER, 
810078+rownum as SOURCE_REF,
810078+rownum as DETAIL_REF,
810078+rownum as USER_REF_NUMBER, 
Add_months( to_date('25/10/2013','DD/MM/YYYY'),30) as SI_EXPIRY_DATE,
--dsi.si_maturity_date as SI_EXPIRY_DATE,
to_date('14/11/2013','DD/MM/YYYY') as  BOOK_DATE,
'SICC' as PRODUCT_CODE,
--substr(dsi.SI_FROM_ACCOUNT,8,6) as COUNTERPARTY, -- For Migration considering Delta Account
substr(dsi.fon_fcubs_account,9,6) as COUNTERPARTY, -- For Live considering Flexcube Accounts
'P' as PRODUCT_TYPE,
--lpad(dsi.SI_NUMBER,4,'0') as  SERIAL_NO,
lpad(rownum,4,'0') as  SERIAL_NO,
'F' as ACTION_CODE_AMT,
'N' as APPLY_CHG_SUXS,
'N' as APPLY_CHG_PEXC,
'N' as APPLY_CHG_REJT,
5 as MAX_RETRY_COUNT,
null as MIN_SWEEP_AMT,
'0'||dsi.fon_agence as DR_ACC_BR,
--'000'||dsi.SI_FROM_ACCOUNT as  DR_ACCOUNT, -- For Migration Considering Delta Accounts
dsi.fon_fcubs_account as  DR_ACCOUNT, -- For Live considering the Flexcube Accounts
'XAF' as DR_ACC_CCY,
'XAF' as SI_AMT_CCY,
--dsi.SI_AMOUNT as  SI_AMT,
500 as  SI_AMT, -- standing instruction amount for civil servants
'0'||dsi.fon_agence as  CR_ACC_BR,
--'000'||dsi.SI_TO_ACCOUNT as CR_ACCOUNT, -- For Migration Considering Delta Accounts
--dsi.SI_TO_ACCOUNT as CR_ACCOUNT, -- For Live considering the Flexcube Accounts
'374101000' as CR_ACCOUNT, -- Cash collateral for civil servants account
'XAF' as CR_ACC_CCY,
1 as PRIORITY,
'R' as CHARGE_WHOM,
null as MIN_BAL_AFTER_SWEEP,
'CONSTITUTION - CASH COLLATERAL FOR '||dsi.fon_matricule||'-'||dsi.fon_intitule as INTERNAL_REMARKS,
'N' as ICCF_CHANGED,
'N' as TAX_CHANGED,
'N' as SETTLE_CHANGED,
'N' as MIS_CHANGED,
'U' as CONV_STATUS,
null as ERR_MSG,
null as AUTHORIZE,
--dsi.SI_FROM_BRANCH||lpad(dsi.SI_NUMBER,4,'0') as CONTRACT_REF_NO,
810078 + rownum as CONTRACT_REF_NO,
1 as VERSION_NO,
null INSTRUCTION_NO,
null TRANSFER_TYPE,
null SUBSYSTEM_STAT,
'SIDCONON' as FUNCTION_ID,
1 as  SOURCE_SEQ_NO,
null UPLOAD_ID,
'NEW' ACTION_CODE
from paie_fonctionnaire dsi 
where dsi.fon_date_creation between '28/04/2012' and '25/10/2013'
and dsi.fon_date_dernier_salaire is not null
and dsi.fon_fcubs_account is not null
and dsi.fon_agence <> 10;
--  Requête de génération des Virements permanents Instructions
-- Sitb_Upload_Instruction 

insert into flexcube.SI_Sitb_Upload_Instruction
(
BRANCH_CODE,
SOURCE_CODE,
SOURCE_REF,
PRODUCT_CODE,
PRODUCT_TYPE,
SI_TYPE,
CAL_HOL_EXCP,
RATE_TYPE,
EXEC_DAYS,
EXEC_MTHS,
EXEC_YRS, 
FIRST_EXEC_DATE,
NEXT_EXEC_DATE, 
FIRST_VALUE_DATE,
NEXT_VALUE_DATE,
MONTH_END_FLAG,
PROCESSING_TIME,
USER_INST_NO,
INST_STATUS,
AUTH_STATUS,
LATEST_VERSION_DATE,
BOOK_DATE,
SERIAL_NO,
COUNTERPARTY,
LATEST_CYCLE_NO,
LATEST_CYCLE_DATE,
CONV_STATUS,
ERR_MSG,
GEN_MESG,
INSTRUCTION_NO,
INST_VERSION_NO,
OPERATION,
FUNCTION_ID,
SOURCE_SEQ_NO,
UPLOAD_ID,
ACTION_CODE
)
select
'0'||dsi.fon_agence as BRANCH_CODE,
'NFCSOURCE' as SOURCE_CODE,
--dsi.SI_FROM_BRANCH||lpad(dsi.SI_NUMBER,4,'0') as SOURCE_REF,
810078 +rownum as SOURCE_REF,
'SICC' as PRODUCT_CODE,
'P' as PRODUCT_TYPE,
'1' as SI_TYPE,
'F' as CAL_HOL_EXCP,
'STANDARD' as RATE_TYPE,
null as EXEC_DAYS,
'1' as EXEC_MTHS,
null as EXEC_YRS,
/*case when dsi.SI_DAY_EXECUTE <'28' then to_date('28/04/2012','DD/MM/YYYY') 
     when dsi.SI_DAY_EXECUTE ='31' then to_date('30/04/2012','DD/MM/YYYY')
     else to_date(dsi.SI_DAY_EXECUTE||'/04/2012','DD/MM/YYYY') 
end */ '22/11/2013' as FIRST_EXEC_DATE, 
null as NEXT_EXEC_DATE,
/* case when dsi.SI_DAY_EXECUTE <'28' then to_date('28/04/2012','DD/MM/YYYY') 
     when dsi.SI_DAY_EXECUTE ='31' then to_date('30/04/2012','DD/MM/YYYY')
     else to_date(dsi.SI_DAY_EXECUTE||'/04/2012','DD/MM/YYYY') 
end */ '22/11/2013' as FIRST_VALUE_DATE,
null as NEXT_VALUE_DATE,
'N' as MONTH_END_FLAG,
'E' as PROCESSING_TIME,
810078+rownum as USER_INST_NO,
null as INST_STATUS,
null as AUTH_STATUS,
null as LATEST_VERSION_DATE,
to_date('14/11/2013','DD/MM/YYYY') as BOOK_DATE,
lpad(rownum,4,'0') as SERIAL_NO,
substr(dsi.fon_fcubs_account,9,6) as COUNTERPARTY,
'1' as LATEST_CYCLE_NO,
null as LATEST_CYCLE_DATE,
'U' as CONV_STATUS,
null as ERR_MSG,
null as GEN_MESG,
null as INSTRUCTION_NO,
null as INST_VERSION_NO,
null as OPERATION,
'SIDCONON' as FUNCTION_ID,
1 as SOURCE_SEQ_NO,
null as UPLOAD_ID,
'NEW' as ACTION_CODE
from paie_fonctionnaire dsi
where dsi.fon_date_creation between '28/04/2012' and '25/10/2013'
and dsi.fon_date_dernier_salaire is not null
and dsi.fon_fcubs_account is not null
and dsi.fon_agence <>10;


commit;
