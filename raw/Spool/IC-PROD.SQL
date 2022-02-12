accept Product PROMPT 'Enter the IC Product >'
SET ARRAY 1
SET HEAD ON
SET FEEDBACK ON
SET LINE 10000
SET PAGESIZE 10000
SET ECHO ON
SET COLSEP ";"
SET TRIMSPOOL ON
SET NUMFORMAT 99999999999999999999.9999

spool c:\IC_PROD1.SPL

select * from ictms_pr_int where product_code = '&Product'
/
select * from ictms_pr_int_aclass where product_code = '&Product'
/
select * from ictms_product_definition where product_code  = '&Product'
/
select * from cstm_product where product_code = '&Product'
/
SELECT * FROM CStms_PRODUCT_EVENT_ACCT_ENTRY WHERE product_code  = '&Product'
ORDER BY product_code,event_code, amt_tag, dr_cr_indicator
/
SELECT * FROM CSTMS_PRODUCT_ACCROLE WHERE product_code ='&Product'
/
SELECT * FROM icvws_all_mappings WHERE product_code ='&Product'
/
select * from ictms_pr_chg where product_code = '&Product'
/
select * from ictms_pr_int_udevals where product_code  = '&Product'
/
select * from ICTMS_PR_INT_EFFDT where product_code  = '&Product'
/
PROMPT 'ALL RULES LINKED TO THE ACCOUNT'

SELECT * FROM ictms_rule WHERE rule_id IN (select RULE from ictms_pr_int where product_code = '&Product')
/
SELECT * FROM ictms_rule_frm WHERE rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
SELECT * FROM ictms_rule_frm_elements WHERE rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
SELECT * FROM ictms_rule_sde WHERE rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
SELECT * FROM ictms_rule_ude WHERE rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
select * from ictm_expr where rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
select * from ictms_is_fmt_desc where  rule_id IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/
SELECT * FROM ictms_pr_int WHERE rule IN (select RULE from ictms_pr_int
where product_code  = '&Product')
/

--select * from ictbs_udevals where ude_id in ( select ude_id from  ictms_rule_ude 
--WHERE rule_id in (select RULE from ictms_pr_int where product_code  = '&Product'))
--/

select * from ictb_maint_queue where maint_key like '%&Product%'
/

select * from cstm_product_event_advice where product_code = '&Product';

SELECT * FROM CSTMS_PROD_BRN_DISALLOW where product_code = '&Product';

select * from CSTMS_PRODUCT_CCY_DISALLOW where product_code = '&Product';

SELECT * FROM cstms_product_customer_access where product_code = '&Product';

SELECT * FROM ICVW_PROD_NOT_OK WHERE PROD= '&PRODUCT';

select * from acvw_all_ac_entries where substr(trn_ReF_no,4,4) =  '&Product';

spool off
