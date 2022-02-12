-- initialising the customer_type
update control_cif_cip cc set cc.type_cif = (select cu.customer_type from xafnfc.sttm_customer cu WHERE cu.customer_no = cc.customer_no)
SELECT * FROM control_cif_cip;
-- Rejected Records
SELECT cu.local_branch,cu.customer_no,decode(cp.sex,'F',cu.udf_3,cp.last_name) birth_name,
cp.first_name prenom, decode(cp.sex,'F',cp.last_name,'') nom_marital,cp.date_of_birth date_naissance,cu.udf_2 lieu_naissance,
cp.passport_no num_piece,cp.ppt_iss_date date_emmission,cp.ppt_exp_date,ud.field_val_3 lieu_emis,
ud.field_val_2 nom_pere,ud.field_val_7 prenom_pere,ud.field_val_1 nom_mere,ud.field_val_5 prenom_mere,cc.motif_rejet
FROM control_cif_cip cc,xafnfc.sttm_customer cu,xafnfc.sttm_cust_personal cp,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud
WHERE cc.customer_no = cu.customer_no
and cc.customer_no = cp.customer_no
and ud.function_id ='STDCIF' 
and  substr(ud.rec_key,1,6) =cc.customer_no
and cc.valid_cip <>'Y'
and cc.motif_rejet is not null
order by cu.local_branch,cu.customer_no;

-- Validated Records
SELECT cu.local_branch,cu.customer_no,decode(cp.sex,'F',cu.udf_3,cp.last_name) birth_name,
cp.first_name prenom, decode(cp.sex,'F',cp.last_name,'') nom_marital,cu.udf_2 lieu_naissance,
cp.passport_no num_piece,cp.ppt_iss_date date_emmission,cp.ppt_exp_date,ud.field_val_3 lieu_emis,
ud.field_val_2 nom_pere,ud.field_val_7 prenom_pere,ud.field_val_1 nom_mere,ud.field_val_5 prenom_mere,cc.motif_rejet
FROM control_cif_cip cc,xafnfc.sttm_customer cu,xafnfc.sttm_cust_personal cp,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud
WHERE cc.customer_no = cu.customer_no
and cc.customer_no = cp.customer_no
and ud.function_id ='STDCIF' 
and  substr(ud.rec_key,1,6) =cc.customer_no
and cc.valid_cip ='Y'
order by cu.local_branch,cu.customer_no;

--- Global
SELECT count(*) from control_cif_cip cc,xafnfc.sttm_customer cu WHERE cu.customer_no = cc.customer_no and cu.record_stat ='O' ;--
SELECT count(*) from control_cif_cip cc WHERE cc.type_cif ='C' and cc.declare_cip ='Y';--
SELECT count(*) from control_cif_cip cc WHERE nvl(cc.declare_cip,'N') ='N';--
SELECT count(*) from control_cif_cip cc WHERE cc.valid_cip ='Y' and cc.type_cif ='I';--
SELECT count(*) from control_cif_cip cc WHERE cc.declare_cip ='Y' and cc.valid_cip ='N' and cc.type_cif ='I' ;--
SELECT count(*) from control_cif_cip cc WHERE cc.declare_cip ='Y' and cc.valid_cip ='N' and cc.type_cif <>'I' ;--
SELECT count(*) from control_cif_cip cc WHERE cc.declare_cip ='N';--
SELECT count(*) from control_cif_cip cc WHERE cc.valid_cip ='N';--

--view all
SELECT * FROM control_cif_cip WHERE  valid_cip ='Y';
SELECT * FROM control_cif_cip cc WHERE  cc.type_cif ='C' and cc.declare_cip ='Y' and cc.valid_cip='Y';
-- Corporate customersand 
--Corporate customers that already have mandators
SELECT count(*)
--select cm.customer_no
--select cm.local_branch,cm.customer_no,cm.customer_name1,cm.address_line1,cd.customer_no,cd.customer_name1,cd.address_line1,cd.address_line3
from xafnfc.sttm_customer cm 
join (SELECT cu.customer_no,cu.customer_name1,cu.address_line1,cu.address_line3,ud.field_val_8 Mandator_no
FROM xafnfc.sttm_customer cu ,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud  
WHERE substr(ud.rec_key,1,6) = cu.customer_no
and ud.field_val_8 is not null) cd on cd.Mandator_no = cm.customer_no
and cm.customer_no in (select distinct ca.cust_no from xafnfc.sttm_cust_account ca WHERE ca.record_stat ='O' )
order by cm.local_branch, cm.customer_no ;

-- corporate customers without mandators
select count(*)
--select c.local_branch,c.customer_no,c.customer_name1,c.address_line1
from xafnfc.sttm_customer c
where c.customer_no not in  (select distinct cm.customer_no
from xafnfc.sttm_customer cm 
join (SELECT cu.customer_no,cu.customer_name1,cu.address_line1,cu.address_line3,ud.field_val_8 Mandator_no
FROM xafnfc.sttm_customer cu ,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud  
WHERE substr(ud.rec_key,1,6) = cu.customer_no
and ud.field_val_8 is not null) cd on cd.Mandator_no = cm.customer_no)
and ( c.customer_no in (select distinct ca.cust_no from xafnfc.sttm_cust_account ca WHERE ca.record_stat ='O' ) ) 
and c.customer_type <> 'I'
and c.record_stat ='O';

SELECT * FROM control_cif_cip WHERE customer_no ='051921';

-- Mandators maintained
SELECT count(*) FROM xafnfc.sttm_customer cu,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud 
WHERE cu.customer_no =  substr(ud.rec_key,1,6) 
and   ud.field_val_8 is not null;

-- Mandators that already have an IBU
SELECT * FROM control_cif_cip cc,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud 
WHERE cc.customer_no =  substr(ud.rec_key,1,6) 
and cc.ibu_cip is not null and   ud.field_val_8 is not null;

-- adding new records for mandators
insert into control_cif_cip (branch_code,customer_no,declare_cip,valid_cip)
SELECT cu.local_branch,cu.customer_no,'N','N' FROM 
xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud , xafnfc.sttm_customer cu
WHERE  substr(ud.rec_key,1,6) = cu.customer_no
and substr(ud.rec_key,1,6) not in (select  cc.customer_no from control_cif_cip cc)
and ud.field_val_8 is not null;

--- Control of accounts
SELECT count(*) FROM control_acc_cip ca;
SELECT count(*) FROM xafnfc.sttm_cust_account a WHERE a.record_stat ='O';
SELECT count(*) FROM control_acc_cip ca WHERE ca.valid_cip ='Y';
SELECT count(*) FROM control_acc_cip ca WHERE ca.declare_cip= 'Y' and ca.valid_cip ='N';
SELECT count(*) FROM control_acc_cip ca WHERE ca.valid_cip ='N';

SELECT * FROM control_acc_cip
update control_acc_cip Set declare_cip  ='Y' WHERE valid_cip ='Y';
update control_acc_cip SEt declare_cip ='Y' WHERE customer_no in (select cc.customer_no from control_cif_cip cc WHERE cc.valid_cip ='Y');
SELECT * FROM control_acc_cip WHERE customer_no in (select cc.customer_no from control_cif_cip cc WHERE cc.valid_cip ='Y' and cc.type_cif = 'I');
 insert into control_acc_cip ca 
 SELECT a.branch_code,a.cust_no,a.cust_ac_no,'N','N',null,null FROM xafnfc.sttm_cust_account a WHERE a.record_stat ='O' and a.cust_ac_no not in (SELECT distinct acc_no FROM control_acc_cip )

-- customers with more than one account

SELECT a.branch_code,a.cust_no,a.cust_ac_no,a.ac_desc FROM xafnfc.sttm_cust_account a WHERE a.cust_no in 
(SELECT ac.cust_no--,cu.customer_name1,count(*) 
FROM xafnfc.sttm_cust_account ac,xafnfc.sttm_customer cu
WHERE ac.cust_no = cu.customer_no
and cu.customer_type <> 'I'
and ac.record_stat = 'O'
group by ac.cust_no--,cu.customer_name1
having count(*) >1)
order by a.branch_code,a.cust_no;
-- purge cip control files
update control_cif_cip cc set cc.ibu_cip ='';
update control_acc_cip ac set ac.declare_cip ='N';

SELECT * FROM control_cif_cip;
