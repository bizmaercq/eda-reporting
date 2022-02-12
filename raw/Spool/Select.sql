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
SPOOL C:\update.SPL

SELECT DISTINCT B.BRANCH,
                B.ACC_NO,
                A.CUST_NO,
                C.CUSTOMER_NAME1,
                D.ACC_MSG,
                B.CIF_SIG_ID,
                B.SOLO_SUFFICIENT
  FROM STTM_CUST_ACCOUNT   A,
       SVTM_ACC_SIG_DET    B,
       STTM_CUSTOMER       C,
       SVTM_ACC_SIG_MASTER D
 WHERE A.CUST_AC_NO = B.ACC_NO
   AND A.CUST_NO = C.CUSTOMER_NO
   AND B.ACC_NO = '0221640104102103'
   AND D.ACC_NO = B.ACC_NO
   AND D.BRANCH = A.BRANCH_CODE
   AND A.AUTH_STAT = 'A'
   AND A.RECORD_STAT = 'O'
   AND A.BRANCH_CODE = '022'
 ORDER BY B.BRANCH ;


 SELECT D.CIF_SIG_ID,
                  D.SPECIMEN_NO,
                  D.FILE_TYPE,
                  D.SIG_TEXT,
                  NVL(M.CIF_SIG_NAME, '') CIF_SIG_NAME
             FROM svtm_CIF_SIG_DET D, svtm_CIF_SIG_MASTER M
            WHERE M.CIF_SIG_ID = D.CIF_SIG_ID
              and M.cif_id = D.cif_id
              and M.AUTH_STAT = 'A'
              and M.RECORD_STAT = 'O'
              and M.CIF_SIG_ID ='041021'
              and M.cif_id ='041021';


set echo off
spool off




