SET HEAD ON
SET ARRAY 1
SET LINESIZE 10000
SET PAGESIZE 50000
SET LONG 10000
SET ECHO ON
SET TRIMSPOOL ON
SET COLSEP ';'
SPOOL C:\3-9380748401.SPL

select * from AETB_EOC_BRANCHES_HISTORY where branch_code='031' and eoc_ref_no='010ZEOC14203000R';

/
SET ECHO OFF
SPOOL OFF