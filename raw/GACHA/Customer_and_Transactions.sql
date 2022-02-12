--- Corporate and their mandators
SELECT cu.customer_no, cu.customer_name1, substr(ud.rec_key,1,6) Mandator_Customer_no, cc.c_national_id Tax_Payer_Id
,( SELECT sc.customer_name1 FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) Mandator_name
,( SELECT sc.unique_id_Name FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) )Id_Type
,( SELECT sc.unique_id_value FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) National_id
FROM sttm_customer cu,CSTM_FUNCTION_USERDEF_FIELDS ud,sttm_cust_corporate cc
WHERE ud.field_val_8 = cu.customer_no
and cc.customer_no = cu.customer_no


--- Summary for GACHA
SELECT  cc.c_national_id NUM_FISC_D 
,case when ( SELECT sc.unique_id_Name FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) ='NAT_ID_CARD'
 then ( SELECT sc.unique_id_value FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) else null end NUM_CNI_D 
,case when ( SELECT sc.unique_id_Name FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) ='RES_PERMIT'
 then ( SELECT sc.unique_id_value FROM sttm_customer sc WHERE sc.customer_no =substr(ud.rec_key,1,6) ) else null end NUM_TITRE_S 
, cu.customer_no NUM_CPT_D
FROM sttm_customer cu,CSTM_FUNCTION_USERDEF_FIELDS ud,sttm_cust_corporate cc
WHERE ud.field_val_8 = cu.customer_no
and cc.customer_no = cu.customer_no

