set serverout on size 1000000
set array 1
set head on
set trimspool on
set lines 10000
set long 10000
set pages 10000
set feedback on
set colsep "|"
set numformat 999999999999999.999
set echo ON
spool c:\check_EOM_Jul.spl

PROMPT Accounts not having record in STTB_ACCOUNT--No rows selected

SELECT *
FROM sttm_cust_account s
WHERE  record_stat <> 'C'
and auth_stat='A'
AND NOT EXISTS (SELECT ac_gl_no
      FROM sttb_account
      WHERE branch_code = s.branch_code 
      AND   ac_or_gl = 'A'
      AND   ac_gl_no = s.cust_ac_no)
/

PROMPT 
PROMPT Accounts not having record in STTM_CUST_ACCOUNT--no rows selected
PROMPT

SELECT *
FROM sttb_account a
WHERE ac_or_gl = 'A'
AND ac_gl_Rec_status <> 'C'
AND NOT EXISTS (SELECT CUST_AC_NO 
    FROM STTM_CUST_ACCOUNT 
    WHERE branch_code = a.branch_code
    AND   cust_ac_no = a.ac_gl_no
    and record_stat='O'
    AND AUTH_STAT='A'
    )
/
PROMPT
PROMPT Accounts having category NULL--no rows selected
PROMPT 

SELECT * FROM sttb_account WHERE gl_category IS NULL AND ac_gl_Rec_status <> 'C' and ac_or_gl<>'L'
/

PROMPT
PROMPT Accounts having dr gl or cr gl null --no rows selected
PROMPT 

SELECT * FROM STTM_CUST_ACCOUNT WHERE (dr_gl IS NULL OR CR_GL IS NULL) AND RECORD_STAT='O' AND AUTH_STAT='A'
/

PROMPT
PROMPT Duplicate Accounts in sttb_account--no rows selected
PROMPT 

SELECT branch_code,ac_gl_no
FROM sttb_account
where ac_gl_rec_status <> 'C'
group by branch_code,ac_gl_no
having count(1) > 1
/

PROMPT
PROMPT Missing Internal gls in sttb_account--NO ROWS selected
PROMPT 

SELECT *
  FROM gltm_glmaster g
 WHERE g.leaf = 'Y'
   AND g.customer <> 'C'
   AND g.record_stat <> 'C'
   AND G.AUTH_STAT='A'
   AND NOT EXISTS (SELECT 1
          FROM sttb_account s
         WHERE s.ac_or_gl = 'G'
           AND s.ac_gl_no = g.gl_code
           AND s.ac_gl_rec_status <> 'C')  		 
/

PROMPT
PROMPT Customer gls in sttb_account, problem --No rows  selected
PROMPT 

SELECT *
  FROM sttb_account s
 WHERE s.ac_or_gl = 'G'
   AND s.ac_gl_rec_status <> 'C'
   AND EXISTS (SELECT 1
          FROM gltm_glmaster g
         WHERE g.gl_code = s.ac_gl_no
           AND g.leaf = 'Y'
           AND g.customer = 'C'
           AND G.RECORD_STAT = 'O'
           AND G.AUTH_STAT = 'A')  
/               

PROMPT 
PROMPT Currency pairs for which exchange rates have not been maintained. 
PROMPT --no rows selected

SELECT BRN "BRANCH CODE", CCY1, CCY2
  FROM ICTB_CCY_PAIR A
 WHERE NOT EXISTS (SELECT '1'
          FROM CYTM_RATES
         WHERE BRANCH_CODE = A.BRN
           AND ((CCY1 = A.CCY1 AND CCY2 = A.CCY2) or
               (CCY1 = A.CCY2 AND CCY2 = A.CCY1))
           AND RATE_TYPE = 'STANDARD')
/
PROMPT 
PROMPT Accounts where book account and charge account are the same but the currencies are different. 
PROMPT 
--Such accounts have to be verified and corrected. 

SELECT I.BRN, I.ACC,T.CCY, I.BOOK_BRN,  I.BOOK_ACC, I.BOOK_CCY, I.CHARGE_BOOK_BRN,I.CHARGE_BOOK_ACC,I.CHARGE_BOOK_CCY
FROM ICTM_ACC I, STTM_CUST_ACCOUNT T
WHERE (I.BOOK_BRN = T.BRANCH_CODE AND I.BOOK_ACC = T.CUST_AC_NO AND I.BOOK_CCY <> T.CCY) OR 
      (I.CHARGE_BOOK_BRN = T.BRANCH_CODE AND I.CHARGE_BOOK_ACC = T.CUST_AC_NO AND I.CHARGE_BOOK_CCY <> T.CCY)
/

PROMPT 
PROMPT IC Type
PROMPT 

SELECT DECODE(PARAM_VAL,'Y','NEW_IC','OLD_IC') IC_TYPE
FROM CSTBS_PARAM  WHERE PARAM_NAME = 'IC50'
/

PROMPT 
PROMPT No. Of Products with PRODUCT/ACCOUT Level Accruals
PROMPT 

SELECT DECODE(ACCR_PROD_LEVEL,'Y','PRODUCT LEVEL ACCRUAL','ACCOUNT LEVEL ACCRUAL')ACCRUAL,COUNT(1) 
FROM ICTM_PR_INT 
WHERE PRODUCT_CODE IN(SELECT PRODUCT_CODE FROM CSTM_PRODUCT WHERE RECORD_STAT='O' AND MODULE='IC') 
GROUP BY ACCR_PROD_LEVEL
/

PROMPT 
PROMPT COMMIT Frequency
PROMPT 

SELECT * FROM CSTB_COMMITFREQ WHERE MODULE_ID='IC' AND FUNCTION_ID='ICEOD'
/

PROMPT 
PROMPT LIQ NETTING FLAG in IC Branch Parameters--NO ROWS SELECTED
PROMPT 

SELECT BRANCH_CODE,LIQ_NETTING 
FROM ICTM_BRANCH_PARAMETERS 
WHERE BRANCH_CODE IN (SELECT BRANCH_CODE FROM STTM_BRANCH WHERE RECORD_STAT='O')
	and LIQ_NETTING ='Y'
/

PROMPT 
PROMPT IC Special Condition - Amendment of TOD puts wrong value in ICTB_ACC_ACTION
PROMPT --no rows selected

SELECT * FROM ICTB_ACC_ACTION 
WHERE TBL_NAME='STTMS_CUST_ACCOUNT' 
AND OLD_VAL NOT LIKE 'ACC%'
AND  STATUS = 'U' AND AUTH_STAT='A'
/

PROMPT 
PROMPT NEXT CALC DATE for Charge Accounts
PROMPT 

SELECT TODAY,NEXT_CALC_DT,(TODAY-NEXT_CALC_DT),COUNT(1) 
FROM ICTB_ACC_PR , STTM_DATES D 
WHERE PROD_TYPE = 'C'  
AND BRN = D.BRANCH_CODE 
GROUP BY TODAY,NEXT_CALC_DT,(TODAY-NEXT_CALC_DT)
/

PROMPT 
PROMPT IC Rule Formulae with Periodicity as "Periodic" instead of "Daily"
PROMPT 

SELECT RULE_ID 
FROM ICTM_RULE_FRM 
WHERE PRD_FLAG='P' 
AND RULE_ID IN(SELECT RULE_ID FROM ICTM_RULE WHERE RECORD_STAT='O')
/

PROMPT 
PROMPT Contracts with null ESN
PROMPT 

SELECT *
  FROM cstb_contract
 WHERE (latest_event_seq_no IS NULL OR latest_version_no IS NULL)
   AND module_code not in ('SD', 'SS', 'SP')
   AND CONTRACT_STATUS='A' AND AUTH_STATUS='A'
/

PROMPT 
PROMPT Contracts where counterparty differs in cstb_contract and ldtb_contract_master
PROMPT 

SELECT C.CONTRACT_REF_NO,
       L.BOOKING_DATE BOOK_DATE,
       L.VALUE_DATE VALUE_DATE,
       L.MATURITY_DATE MATURITY_DATE,
       C.contract_status,
       C.COUNTERPARTY CS_COUNTERPARTY,
       (SELECT C1.CUSTOMER_NAME1
          FROM STTM_CUSTOMER C1
         WHERE C1.CUSTOMER_NO = C.COUNTERPARTY) CS_CUSTNAME,
       L.COUNTERPARTY LD_COUNTERPARTY,
       (SELECT L1.CUSTOMER_NAME1
          FROM STTM_CUSTOMER L1
         WHERE L1.CUSTOMER_NO = L.COUNTERPARTY) LD_CUSTNAME
  FROM cstb_contract C, ldtb_contract_master L
 WHERE C.CONTRACT_REF_NO = L.CONTRACT_REF_NO
   AND L.EVENT_SEQ_NO =
       (SELECT MAX(LL.EVENT_SEQ_NO)
          FROM LDTB_CONTRACT_MASTER LL
         WHERE L.CONTRACT_REF_NO = LL.CONTRACT_REF_NO)
   AND C.MODULE_CODE = 'LD'
   AND L.COUNTERPARTY <> C.COUNTERPARTY
   AND C.contract_status ='A'
   AND C.AUTH_STATUS='A'
/   

PROMPT 
PROMPT Lines that are expiring on the Month End
PROMPT 
--Delink lines from accounts

SELECT s.*, l.*
FROM sttm_cust_account s, sttm_customer s1, lmtm_limits l,sttm_dates dt
WHERE s.line_id is not null
AND s.cust_no = s1.customer_no
AND s.record_stat = 'O'
AND l.liab_id = s1.liability_no
AND l.line_cd || l.line_serial = rtrim(line_id)
AND s.branch_code = dt.branch_code
AND l.line_expiry_date >= dt.today 
AND l.line_expiry_date < ( select min(pr.pc_start_date) from sttm_period_codes pr where pr.pc_start_date > dt.today)
AND l.availability_flag = 'Y'
AND l.record_stat = 'O'
/

PROMPT 
PROMPT Lines that are expiring on the Month End and not having records in lmtb_line_utils
PROMPT 
--Delink lines from accounts

SELECT l.*, s.*
  FROM sttm_cust_account s, sttm_customer s1, lmtm_limits l, sttm_dates dt
 WHERE s.line_id is not null
   AND s.cust_no = s1.customer_no
   AND s.record_stat = 'O'
   AND l.liab_id = s1.liability_no
   AND l.line_cd || l.line_serial = rtrim(line_id)
   AND s.branch_code = dt.branch_code
   AND l.line_expiry_date <
       (select min(pr.pc_start_date)
          from sttm_period_codes pr
         where pr.pc_start_date > dt.today)
   AND l.availability_flag = 'Y'
   AND l.record_stat = 'O'
   AND NOT EXISTS (SELECT *
          from lmtb_line_utils
         WHERE is_account = 'Y'
           AND trim(line_id) = rtrim(s.line_id)
           AND liab_id = l.liab_id
           AND amt_tag = 'BALANCE')
/

PROMPT 
PROMPT Lines that are expiring from 01st to 31st of DEC - Check and Delink 
PROMPT 

SELECT L.LIAB_BR,
       (SELECT SB.BRANCH_NAME
          FROM STTM_BRANCH SB
         WHERE SB.BRANCH_CODE = L.LIAB_BR) BRANCH,
       C.CUSTOMER_NO CUSTNUMBER,
       C.CUSTOMER_NAME1 CUSTNAME,
       L.AVAILABLE_AMOUNT AVAILABLEAMOUNT,
       L.LIMIT_AMOUNT FACILITYAMOUNT,
       L.LINE_EXPIRY_DATE EXPIRYDATE,
       C.CUSTOMER_TYPE SEGMENT1,
       TRIM(L.LINE_CD || L.LINE_SERIAL) TYPEOFLIMIT,
       L.UTILISATION
  FROM STTM_CUST_ACCOUNT A,
       STTM_CUSTOMER     C,
       LMTM_LIMITS       L,
       sttm_branch       S,
       sttm_period_codes P
 WHERE L.LIAB_ID = C.LIABILITY_NO
   AND A.CUST_NO = C.CUSTOMER_NO
   AND a.branch_code = s.branch_code
   AND s.current_period = p.period_code
   AND s.current_cycle = p.fin_cycle
   AND TRIM(TRIM(L.LINE_CD) || TRIM(L.LINE_SERIAL)) = TRIM(A.LINE_ID)
   AND L.LINE_EXPIRY_DATE <= p.pc_end_date
   AND L.LINE_EXPIRY_DATE > p.pc_start_date
/

spool off