set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000
set serveroutput on;

spool spool /home/oracle/SPOOL/Dormant_to_active_recent.spl

SELECT aa.AC_BRANCH,
       aa.AC_NO,
       aa.trn_code,
       aa.LCY_AMOUNT,
       aa.TXN_INIT_DATE,
       bb.branch_code,
       bb.cust_ac_no,
       aa.related_account,
	   bb.ac_stat_dormant "DORM_CUST_ACC",
       cc.ac_stat_dormant "DORM_ACC"
  FROM ACVW_ALL_AC_ENTRIES aa, sttm_cust_account bb,sttb_account cc
 WHERE aa. EVENT = 'ILIQ'
   and aa.TXN_init_date = '31-Dec-2012'
   and aa.AC_NO = bb.cust_ac_no
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND cc.ac_stat_dormant='Y'
   AND bb.cust_ac_no=cc.ac_gl_no
   AND bb.CUST_AC_NO NOT IN
       (SELECT ac.cust_ac_no
          FROM STTM_CUST_ACCOUNT ac
         WHERE ac.ACY_AVL_BAL >= '10000000'
           AND ac.ACCOUNT_CLASS LIKE '3%');
   
declare
CURSOR c1 is
SELECT aa.AC_BRANCH,
       aa.AC_NO,
       aa.trn_code,
       aa.LCY_AMOUNT,
       aa.TXN_INIT_DATE,
       bb.branch_code,
       bb.cust_ac_no,
       aa.related_account,
	   bb.ac_stat_dormant "DORM_CUST_ACC",
       cc.ac_stat_dormant "DORM_ACC"
  FROM ACVW_ALL_AC_ENTRIES aa, sttm_cust_account bb,sttb_account cc
 WHERE aa. EVENT = 'ILIQ'
   and aa.TXN_init_date = '31-Dec-2012'
   and aa.AC_NO = bb.cust_ac_no
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND cc.ac_stat_dormant='Y'
   AND bb.cust_ac_no=cc.ac_gl_no
   AND bb.CUST_AC_NO NOT IN
       (SELECT ac.cust_ac_no
          FROM STTM_CUST_ACCOUNT ac
         WHERE ac.ACY_AVL_BAL >= '10000000'
           AND ac.ACCOUNT_CLASS LIKE '3%');
BEGIN  
FOR each_row in c1 LOOP

update STTM_CUST_ACCOUNT
   set AC_STAT_DORMANT = 'N'
 where cust_ac_no = each_row.cust_ac_no 
 and branch_code= each_row.branch_code 
 and ac_stat_dormant='Y';
 
update STTB_ACCOUNT
   set AC_STAT_DORMANT = 'N'
 where ac_gl_no= each_row.cust_ac_no
  and branch_code= each_row.branch_code
  and ac_stat_dormant='Y';

commit;
END LOOP;
EXCEPTION
            WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR ' || SUBSTR(SQLERRM, 1, 255));
END;
/

SELECT aa.AC_BRANCH,
       aa.AC_NO,
       aa.trn_code,
       aa.LCY_AMOUNT,
       aa.TXN_INIT_DATE,
       bb.branch_code,
       bb.cust_ac_no,
       aa.related_account,
	   bb.ac_stat_dormant "DORM_CUST_ACC",
       cc.ac_stat_dormant "DORM_ACC"
  FROM ACVW_ALL_AC_ENTRIES aa, sttm_cust_account bb,sttb_account cc
 WHERE aa. EVENT = 'ILIQ'
   and aa.TXN_init_date = '31-Dec-2012'
   and aa.AC_NO = bb.cust_ac_no
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND cc.ac_stat_dormant='Y'
   AND bb.cust_ac_no=cc.ac_gl_no
   AND bb.CUST_AC_NO NOT IN
       (SELECT ac.cust_ac_no
          FROM STTM_CUST_ACCOUNT ac
         WHERE ac.ACY_AVL_BAL >= '10000000'
           AND ac.ACCOUNT_CLASS LIKE '3%');
		     
spool off;				   