set serveroutput on size 1000000
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 20000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999
spool c:\MWKCDHFCC0192_2.spl


PROMPT GLTM_GL_MASTER 

select * from GLTM_GL_MASTER WHERE GL_CODE ='475002000';

set echo off
spool off ;