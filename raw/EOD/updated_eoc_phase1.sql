SET SERVEROUTPUT ON SIZE 100000
set head on
set array 1
set linesize 10000
set pagesize 40200
set long 10000
set echo on
set trimspool on

SPOOL C:\3-15506232691.spl


select * from aetb_Eoc_branches where branch_Code='022';


UPDATE aetb_Eoc_branches 
SET ERROR_CODE=NULL,ERROR=NULL
where branch_Code='022';

select * from aetb_Eoc_runchart  where branch_Code='022';

UPDATE aetb_Eoc_runchart 
SET ERROR_CODE=NULL,ERROR=NULL
 where branch_Code='022' AND EOC_STAGE='MARKEOD';

select * from Aetb_Eoc_Programs where branch_Code='022' AND EOC_STAGE='POSTEOFI';

select * from eitbs_pending_programs where branch_Code='022';


UPDATE  eitbs_pending_programs 
SET RUN_STAT='S'
where branch_Code='022' AND EOC_GROUP='F' AND RUN_STAT='T';


COMMIT;

select * from eitbs_pending_programs where branch_Code='022';

spool off;