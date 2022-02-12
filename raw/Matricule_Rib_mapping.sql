SELECT rm.mat, cu.customer_name1,'10025'||ca.cust_ac_no RIB, decode(ca.ac_stat_dormant,'Y','DORMANT','ACTIF') STATUT
FROM mapping_rib_matricule rm, xafnfc.sttm_cust_account ca, xafnfc.sttm_customer cu
WHERE rm.acc=ca.cust_ac_no
and ca.cust_no = cu.customer_no
--and ca.record_stat ='O'
order by cu.customer_name1

