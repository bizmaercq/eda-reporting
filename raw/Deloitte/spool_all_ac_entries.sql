set colsep '|'
set head on
set echo off
set feedback off
set linesize 1000
set pagesize 0
set sqlprompt ''
set trimspool on
set heading on
set headsep on

spool all_ac_entries.csv
SELECT * FROM STTM_BRANCH where BRANCH_CODE = '031';

/*
  SELECT ae.TRN_REF_NO "ID Transaction"||';'||acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,
                                                   ae.MODULE,
                                                   'TXN',
                                                   ae.TRN_CODE,
                                                   'ENG',
                                                   Ae.AC_NO,
                                                   Ae.AC_BRANCH,
                                                   ae.ac_ccy,
                                                   ae.trn_dt,
                                                   Ae.LCY_AMOUNT) "Libellé de l’écriture"
           ||';'|| ae.TRN_DT "date de la transaction"||';'||ae.VALUE_DT "Date de valeur"||';'||ae.USER_ID||';'||
           ae.AUTH_ID||';'|| ae.AC_ENTRY_SR_NO "N° de ligne dans le journal"||';'||ae.AC_NO "N° grand-livre"||';'||
           case when ae.DRCR_IND ='D' then ae.LCY_AMOUNT end "DEBIT" ||';'||
           case when ae.DRCR_IND ='C' then ae.LCY_AMOUNT end "CREDIT"
  FROM acvw_all_ac_entries ae WHERE  ae.VALUE_DT between '01/01/2016' and '30/06/2016'
  order by ae.TRN_REF_NO ASC ;
*/
/
spool off  
 
   
