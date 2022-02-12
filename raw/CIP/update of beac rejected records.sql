-- correcting sex not stated
create or replace view sexe_null as SELECT cu.customer_no,cu.customer_name1,cp.sex FROM 
 xafnfc.sttm_cust_personal cp,xafnfc.sttm_customer cu
WHERE cu.customer_no = cp.customer_no
and cp.sex is null
and cu.customer_type ='I' ;
SELECT * FROM sexe_null FOR UPDATE NOWAIT; 
drop view sexe_null;
-- Parent's names
create or replace view correct_parents as
SELECT cu.customer_no,cu.customer_name1,cp.passport_no, ud.field_val_2 nom_pere,
ud.field_val_7 prenom_pere,
ud.field_val_1 nom_mere,
ud.field_val_5 prenom_mere
FROM xafnfc.sttm_customer cu,xafnfc.sttm_cust_personal cp,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud
WHERE  cu.customer_no = cp.customer_no
and ud.function_id ='STDCIF' 
and  substr(ud.rec_key,1,6) =cu.customer_no
and cu.customer_type ='I'
and cp.passport_no is not null;
drop view correct_parents;
-- Parenté for fathers
SELECT ud.rec_key,ud.field_val_2,ud.field_val_7 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
--update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_2 ='PND',ud.field_val_7 ='ND'
WHERE ud.field_val_2 is null and ud.field_val_7 is null
and ud.function_id ='STDCIF'
and  substr(ud.rec_key,1,6) in (select cu.customer_no from sttm_customer cu,sttm_cust_personal cp 
WHERE cu.customer_no = cp.customer_no
and cp.passport_no is not null
--and cu.local_branch ='&Branch'
and cu.customer_type ='I');

-- Parenté for Mothers
--SELECT ud.rec_key,ud.field_val_1,ud.field_val_5 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_1 ='PND',ud.field_val_2 ='ND'
WHERE ud.field_val_1 is null and ud.field_val_5 is null
and ud.function_id ='STDCIF'
and  substr(ud.rec_key,1,6) in (select cu.customer_no from sttm_customer cu,sttm_cust_personal cp 
WHERE cu.customer_no = cp.customer_no
and cp.passport_no is not null
and cu.local_branch ='&Branch'
and cu.customer_type ='I');

-- incompatible characters
SELECT ud.rec_key,ud.field_val_1,substr(ud.field_val_1,5), ud.field_val_5 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
--update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_1 =substr(ud.field_val_1,5)
WHERE ud.field_val_1 like 'FEUE %' ;

SELECT ud.rec_key,ud.field_val_2,substr(ud.field_val_2,4), ud.field_val_7 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
--update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_2 =substr(ud.field_val_2,4)
WHERE ud.field_val_2 like 'FEU %' ;


-- special caracters in names
SELECT ud.rec_key,ud.field_val_2, ud.field_val_7 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
--update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_2 =substr(ud.field_val_2,4)
--WHERE (ud.field_val_2 like '%/%'  or ud.field_val_7 like '%/%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_2 like '%,%'  or ud.field_val_7 like '%,%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_2 like '%.%'  or ud.field_val_7 like '%.%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_2 like '%11%'  or ud.field_val_7 like '%11%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_2 like '%HH%'  or ud.field_val_7 like '%HH%') FOR UPDATE NOWAIT;

SELECT ud.rec_key,ud.field_val_1, ud.field_val_5 FROM CSTM_FUNCTION_USERDEF_FIELDS ud 
--update CSTM_FUNCTION_USERDEF_FIELDS ud set  ud.field_val_2 =substr(ud.field_val_2,4)
--WHERE (ud.field_val_1 like '%/%'  or ud.field_val_5 like '%/%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_1 like '%,%'  or ud.field_val_5 like '%,%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_1 like '%0%'  or ud.field_val_5 like '%0%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_1 like '%.%'  or ud.field_val_5 like '%.%') FOR UPDATE NOWAIT;
WHERE (ud.field_val_1 like '%PND%'  or ud.field_val_5 like '%PND%') FOR UPDATE NOWAIT;
--WHERE (ud.field_val_1 like '%11%'  or ud.field_val_5 like '%11%') FOR UPDATE NOWAIT;
WHERE (ud.field_val_1 like '%HH%'  or ud.field_val_5 like '%HH%') FOR UPDATE NOWAIT;

-- Correction of names 

SELECT * FROM sttm_cust_personal cp
--WHERE upper(cp.first_name) like '%,%' FOR UPDATE NOWAIT; 
--WHERE upper(cp.first_name) like '%EPSE%' FOR UPDATE NOWAIT; 
--WHERE upper(cp.first_name) like '%?%' FOR UPDATE NOWAIT; 
--WHERE upper(cp.first_name) like '%/%' FOR UPDATE NOWAIT; 
--WHERE upper(cp.last_name) like '%/%' FOR UPDATE NOWAIT; 
WHERE upper(cp.last_name) like '%,%' FOR UPDATE NOWAIT; 

update sttm_cust_personal cp set cp.last_name = replace(cp.last_name,'EPSE','') WHERE upper(cp.last_name) like '%EPSE%' ;

update CSTM_FUNCTION_USERDEF_FIELDS ud ud.field_val_2 ='PND',ud.field_val_7 ='ND' WHERE ud.field_val_2 is null
and ud.function_id ='STDCIF';
