ACCEPT ACC PROMPT 'PLS ENTER THE ACCOUNT NO. ==> '
SET ARRAY 1
SET HEAD ON
SET COLSEP ";"
SET FEEDBACK ON
SET LINESIZE 10000
SET PAGESIZE 50000
SET LONG 10000
SET ECHO ON
SET TRIMSPOOL ON
SET NUMFORMAT 999999999999999999999.99999

SPOOL C:\Account_details.SPL

select * from sttb_account where AC_GL_NO IN(
SELECT /*aa.AC_BRANCH,
       aa.AC_NO,
       aa.trn_code,
       aa.LCY_AMOUNT,
       aa.TXN_INIT_DATE,
       bb.branch_code,*/
       bb.cust_ac_no
       --,aa.related_account,
	   --bb.ac_stat_dormant,aa.*,bb.*
  FROM ACVW_ALL_AC_ENTRIES aa, sttm_cust_account bb
 WHERE aa. EVENT = 'ILIQ'
  and aa.TXN_init_date = '31-Dec-2012'
   and aa.AC_NO = bb.cust_ac_no
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND bb.CUST_AC_NO NOT IN
       (SELECT ac.cust_ac_no
          FROM STTM_CUST_ACCOUNT ac
         WHERE ac.ACY_AVL_BAL >= '10000000'
           AND ac.ACCOUNT_CLASS LIKE '3%'));

SELECT aa.AC_BRANCH,
       aa.AC_NO,
       aa.trn_code,
       aa.LCY_AMOUNT,
       aa.TXN_INIT_DATE,
       bb.branch_code,
       bb.cust_ac_no
       ,aa.related_account,
	   bb.ac_stat_dormant--aa.*,bb.*
  FROM ACVW_ALL_AC_ENTRIES aa, sttm_cust_account bb
 WHERE aa. EVENT = 'ILIQ'
   and aa.TXN_init_date = '31-Dec-2012'
   and aa.AC_NO = bb.cust_ac_no
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND aa.TRN_REF_NO LIKE '%CIOS%'
   AND bb.CUST_AC_NO NOT IN
       (SELECT ac.cust_ac_no
          FROM STTM_CUST_ACCOUNT ac
         WHERE ac.ACY_AVL_BAL >= '10000000'
           AND ac.ACCOUNT_CLASS LIKE '3%');

SELECT * FROM STTMS_CUST_ACCOUNT WHERE CUST_AC_NO = '&ACC';

SELECT * FROM STTBS_ACCOUNT WHERE AC_GL_NO = '&ACC';

SELECT * FROM ACVWS_ALL_AC_ENTRIES WHERE AC_NO = '&ACC';

SELECT * FROM ACTB_DAILY_LOG WHERE AC_NO = '&ACC';

SELECT * FROM ACTBS_ACCBAL_HISTORY WHERE ACCOUNT = '&ACC';

SELECT * FROM CATMS_AMOUNT_BLOCKS WHERE ACCOUNT  ='&ACC';

SELECT * FROM ACTBS_FUNCOL WHERE ACCOUNT  ='&ACC';

SELECT SUM(DECODE(DRCR_IND,'D',-LCY_AMOUNT,LCY_AMOUNT)) FROM ACVW_ALL_AC_ENTRIES WHERE AC_NO = '&ACC';

SELECT * FROM ACTBS_VD_BAL WHERE ACC = '&ACC';

SELECT * FROM STTMS_ACCOUNT_BAL_TOV WHERE CUST_AC_NO = '&ACC';

SELECT * FROM ACTB_DAILY_GHOST_LOG WHERE AC_NO = '&ACC';

SELECT * FROM STTM_ACCOUNT_CLASS WHERE ACCOUNT_CLASS IN (SELECT ACCOUNT_CLASS FROM STTM_CUST_ACCOUNT WHERE CUST_AC_NO = '&ACC');


SELECT * FROM ICTBS_DR_INT_ERR WHERE ACC = '&ACC';

SELECT * FROM STTM_CUST_ACCOUNT_DORMANCY WHERE CUST_AC_NO = '&ACC';

SELECT * FROM STTM_TRN_CODE;

SELECT * FROM STTB_RECORD_LOG WHERE KEY_ID LIKE '~STTM_CUST_ACCOUNT~' || '%' || '~' || '&ACC' || '~';

SELECT * FROM STTB_FIELD_LOG WHERE DETAIL_KEY LIKE '~STTM_CUST_ACCOUNT~' || '%' || '~' || '&ACC' || '~';

SELECT * FROM STTB_RECORD_LOG_HIST WHERE KEY_ID LIKE '~STTM_CUST_ACCOUNT~' || '%' || '~' || '&ACC' || '~';

SELECT * FROM STTB_FIELD_LOG_HIST WHERE KEY_ID LIKE '~STTM_CUST_ACCOUNT~' || '%' || '~' || '&ACC' || '~';

SPOOL OFF
