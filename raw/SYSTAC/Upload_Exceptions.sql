-- Cheque uplod exceptions
SELECT a.txn_brn Branch , REMACCOUNT  Account,  INSTRNO  cheque_no, a.instramt Amount,decode( a.direction,'I','INWARD','OUTWARD') Direction,MESSAGE
FROM IFTBS_CLEARING_UPLOAD a, ERTB_MSGS b
WHERE INSTRNO IN (SELECT TRIM(fld7) FROM GITM_UPLOAD_MASTER WHERE FLD1 IN ('I','O'))
AND STATUS !='UNPR' 
AND TXNDATE = '14/03/2016'
AND replace(substr(a.error_codes,0,9),';') = b.err_code
AND b.language ='ENG';

-- Funds Transfer upload exceptions

SELECT TRIM(b.fld10) Benficiary_Account, a.source_ref Source_Ref, a.error_message Error, TRIM(fld25) Product_code 
FROM FTTB_UPLOAD_EXCEPTION a, GITM_UPLOAD_MASTER b
WHERE A.SOURCE_REF = TRIM(b.fld24)
AND B.INTERFACE_CODE = 'EFTUPLD'
AND A.ERROR_CODE IS NOT NULL;

-- Monitoring FT contracts Creation

SELECT count(*) FROM FTTB_CONTRACT_MASTER 
WHERE CONTRACT_REF_NO IN (SELECT USER_REF_NO FROM FTTB_UPLOAD_MASTER
WHERE DR_VALUE_DATE ='14/03/2016');

SELECT * from actb_daily_log WHERE product_code ='CGOD'
