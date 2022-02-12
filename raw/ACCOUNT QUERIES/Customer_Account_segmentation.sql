select ca.branch_code,ca.cust_ac_no,ca.ac_desc, ca.account_class,ca.dr_gl,ca.cr_gl,cm.Secteur_activite Code_Secteur,(select mt.code_desc from gltm_mis_code mt where mt.mis_code = cm.secteur_activite ) Secteur_Activite,
cm.groupe_activite Code_groupe ,(select mt.code_desc from gltm_mis_code mt where mt.mis_code = cm.groupe_activite ) Groupe_Activite
from sttm_cust_account ca,
(select c.local_branch,  c.customer_no Reference_Interne,decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1) secteur_activite,decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3) groupe_activite
from xafnfc.sttm_customer c  join xafnfc.mitm_customer_default m on c.customer_no = m.customer) cm
where ca.cust_no = cm.reference_interne


SELECT ca.cust_ac_no,ca.ac_desc,decode(cu.customer_type,'I','INDIVIDUAL','CORPORATE') "TYPE",cp.sex
FROM sttm_cust_account ca,sttm_customer cu,sttm_cust_personal cp
WHERE cu.customer_no = ca.cust_no
and cu.customer_no = cp.customer_no
and ca.ac_open_date <='&End_Date'
