create table control_cif_cip(
branch_code varchar2(3),
customer_no varchar2(6),
declare_Cip varchar2(1),
Valid_Cip varchar2(1),
stat_NOM_NAISSANCE varchar2(1),
stat_PRENOM varchar2(1),
stat_NOM_MARITAL varchar2(1),
stat_NUM_PIECE varchar2(1),
stat_DATE_DELIVRANCE varchar2(1),
stat_LIEU_DELIVRANCE varchar2(1),
stat_DATE_VALIDITE varchar2(1),
stat_NOM_DU_PERE varchar2(1),
stat_PRENOM_PERE varchar2(1),
stat_NOM_NAISSANCE_MERE varchar2(1),
stat_PRENOM_MERE varchar2(1));

truncate table control_cif_cip;

insert into control_cif_cip (branch_code,customer_no,declare_cip,valid_cip) 
SELECT  cu.local_branch,cu.customer_no,'N','N' from xafnfc.sttm_customer  cu WHERE cu.customer_type ='I';


create table control_cif_cip_12052016 as select * from control_cif_cip;

SELECT * FROM control_cif_cip cc WHERE cc.valid_cip <> 'Y' and cc.motif_rejet is not null;
SELECT * FROM control_cif_cip cc WHERE cc.declare_cip ='Y';
SELECT * FROM control_cif_cip cc WHERE cc.valid_cip ='Y';

