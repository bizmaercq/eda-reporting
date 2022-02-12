set serveroutput on size 1000000
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999
SPOOL C:\actbs_recon_master.SPL
         SELECT amount
                  ,amount_to_recon
                  ,ref_no
                  ,event_seq_no
             FROM   actbs_recon_master
            WHERE  branch = '020' 
                        AND account = '327101000' ;
SPOOL OFF
