set array 1
set line 5000
set head on
set pagesize 10000
set feedback on
set trimspool on
set numformat 9999999999999999.999
set echo on
set colsep ";"
SPOOL C:\LM_DETAILS.SPL

--accept CUSTOMER_ID PROMPT 'Enter the customer id ==> '
--select liability_no from sttms_customer where customer_no = '&customer_Id';

accept LIAB_ID PROMPT 'Enter the liability id ==> '

select * from sttms_dates where branch_code=( select distinct liab_br from lmtm_liab where LIAB_ID = '&LIAB_ID');
PROMPT LMTMS_LIMITS
SELECT * FROM LMTMS_LIMITS WHERE LIAB_ID = '&LIAB_ID';
PROMPT LMTBS_LIMITS
SELECT * FROM LMTBS_LIMITS WHERE LIAB_ID = '&LIAB_ID';
PROMPT LMTMS_LIAB
SELECT * FROM LMTMS_LIAB WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMTBS_LINE_UTILS
SELECT * FROM LMTBS_LINE_UTILS WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMTVS_LINE_UTILS
SELECT * FROM LMTVS_LINE_UTILS WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMVW_LINE_UTILS_REFNO
SELECT * FROM LMVW_LINE_UTILS_REFNO WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMTBS_LIMITS_HISTORY
SELECT * FROM LMTBS_LIMITS_HISTORY WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMTBS_LIMITS_TENOR_REST 
SELECT * FROM LMTBS_LIMITS_TENOR_REST WHERE LIAB_ID = '&LIAB_ID' ;
PROMPT LMTMS_LIMITS_TENOR_REST 
SELECT * FROM LMTMS_LIMITS_TENOR_REST where liab_id='&LIAB_ID';
PROMPT lmtms_limits_cust_rest 
SELECT * FROM lmtms_limits_cust_rest WHERE liab_id = '&LIAB_ID'; 
PROMPT lmtms_limits_prod_rest 
SELECT * FROM lmtms_limits_prod_rest WHERE liab_id = '&LIAB_ID'; 
PROMPT lmtms_limits_br_rest    
SELECT * FROM lmtms_limits_br_rest WHERE liab_id = '&LIAB_ID'; 
PROMPT lmtms_limits_ccy_rest      
SELECT * FROM lmtms_limits_ccy_rest WHERE liab_id = '&LIAB_ID'; 
PROMPT LMTMS_COLLAT
SELECT * FROM LMTMS_COLLAT WHERE LIAB_ID='&LIAB_ID';
PROMPT LMTMS_POOL_COLLATERAL_LINKAGES
select * from LMTMS_POOL_COLLATERAL_LINKAGES where liab_id='&LIAB_ID';
PROMPT LMTMS_POOL
select * from LMTMS_POOL where liab_id='&LIAB_ID';

PROMPT STTMS_CUSTOMER 
SELECT * FROM STTMS_CUSTOMER WHERE LIABILITY_NO = '&LIAB_ID';
PROMPT STTMS_CUST_ACCOUNT 
SELECT * FROM STTMS_CUST_ACCOUNT WHERE CUST_NO in ( select customer_no 
FROM STTMS_CUSTOMER WHERE LIABILITY_NO = '&LIAB_ID');

select * from cstb_contract where contract_ref_no in (SELECT ref_no FROM LMTBS_LINE_UTILS WHERE LIAB_ID = '&LIAB_ID' and amt <> 0);

PROMPT LIAB_LEVEL_MISMATCH
SELECT 	l.liab_id,	
			nvl(l.util_amt,0)-SUM(nvl(u.liab_util,0)) diff
	FROM 		lmtbs_line_utils u, lmtms_liab l
	WHERE 	l.liab_id=u.liab_id
	AND 		l.liab_br=u.liab_br
	AND 		l.record_stat='O'
	AND 		l.auth_stat='A' 
	AND 		l.liab_id ='&liab_id'
	GROUP BY 	l.liab_id,l.util_amt
	HAVING 	nvl(l.util_amt,0) <> SUM(nvl(u.liab_util,0))
	ORDER BY 	l.liab_id;

PROMPT LINE_LEVEL_MISMATCH

SELECT v.branch,v.liab_id, v.line_id, v.main_line,v.line_currency,
v.limit_amount,sum(nvl(v.utilisation,0))-SUM(v.sum_util) diff
from
(
SELECT u.branch,u.liab_id, u.line_id, l.main_line,l.line_currency,
l.limit_amount,nvl(l.utilisation,0) utilisation , SUM(nvl(u.line_ccy_util,0)) sum_util
FROM lmtbs_line_utils u, lmtms_limits l  , STTMS_DATES C
WHERE  l.liab_id(+) 	= u.liab_id
 AND l.line_cd(+) 	= SUBSTR(u.line_id,1,9)
 AND l.line_serial(+) 	= TO_NUMBER(SUBSTR(u.line_id,10))
 AND L.LINE_EXPIRY_DATE >= C.TODAY
 AND L.LIAB_BR 		= C.BRANCH_CODE
 AND L.LIAB_ID ='&liab_id'
 AND L.RECORD_STAT 	= 'O'
 AND l.auth_stat		= 'A'
 AND l.main_line is not null
 GROUP BY u.branch,u.liab_id, u.line_id,l.main_line,l.line_currency, l.limit_amount,l.utilisation
UNION
 SELECT u.branch,u.liab_id, u.line_id, l.main_line, l.line_currency,
 l.limit_amount, nvl(l.utilisation,0) - s.utilisation utilisation, SUM(nvl(u.line_ccy_util,0)) sum_util
 FROM lmtbs_line_utils u, lmtms_limits l  , STTMS_DATES C,
(SELECT u.branch,u.liab_id, u.line_id, l.main_line,l.line_currency,
l.limit_amount,nvl(l.utilisation,0) utilisation , SUM(nvl(u.line_ccy_util,0)) sum_util
FROM lmtbs_line_utils u, lmtms_limits l  , STTMS_DATES C
WHERE  l.liab_id(+) 	= u.liab_id
 AND l.line_cd(+) 	= SUBSTR(u.line_id,1,9)
 AND l.line_serial(+) 	= TO_NUMBER(SUBSTR(u.line_id,10))
 AND L.LINE_EXPIRY_DATE >= C.TODAY
 AND L.LIAB_BR 		= C.BRANCH_CODE
 AND L.LIAB_ID ='&liab_id'
 AND L.RECORD_STAT 	= 'O'
 AND l.auth_stat		= 'A'
 AND l.main_line is not null
 GROUP BY u.branch,u.liab_id, u.line_id,l.main_line,l.line_currency, l.limit_amount,l.utilisation)S
 WHERE l.liab_id	 	= u.liab_id
 AND l.line_cd 		= SUBSTR(u.line_id,1,9)
 AND l.line_serial 	= TO_NUMBER(SUBSTR(u.line_id,10))
 AND L.LINE_EXPIRY_DATE >= C.TODAY
 AND L.LIAB_BR 		= C.BRANCH_CODE
 AND L.RECORD_STAT 	= 'O'
 AND l.auth_stat		= 'A'
 AND l.liab_id = s.liab_id 
 AND L.LIAB_ID ='&liab_id'
 AND l.line_cd||l.line_serial = s.main_line
 AND l.main_line is null
 GROUP BY u.branch,u.liab_id, u.line_id,l.main_line,l.line_currency,l.limit_amount, nvl(l.utilisation,0) - s.utilisation 
)v
group by
v.branch,v.liab_id, v.line_id,v.main_line,v.line_currency,v.limit_amount
having sum(nvl(v.utilisation,0)) - SUM(v.sum_util) <> 0
/

SPOOL OFF