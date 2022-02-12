set head on
set array 1
set linesize 30000
set pagesize 50000
set long 100000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.9999

spool c:\IC_Process_Details.SPL


select * from ictm_branch_parameters
/

select count(*) from ictb_entries where process is null
/

select count(*) from ictb_entries_history where entry_type<>'C' and process is null
/

select count(1) from ictb_is_vals where process is null
/


SPOOL OFF