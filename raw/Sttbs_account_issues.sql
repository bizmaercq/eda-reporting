SELECT a.cust_ac_no,a.ac_desc FROM sttm_cust_account a WHERE a.cust_ac_no not in (SELECT ac_gl_no FROM sttb_account) ;

update sttbs_account sa set sa.ac_gl_no = 
(SELECT  ca.cust_ac_no FROM sttm_cust_account ca WHERE ca.alt_ac_no   = sa.alt_ac_no )
WHERE  sa.ac_gl_no ='N'
and sa.alt_ac_no <>'DUMMY';

create table sttb_account_back_02032016 as  SELECT * FROM sttbs_account WHERE ac_gl_no = 'N';
 
SELECT * FROM sttbs_account WHERE ac_gl_no ='N' FOR UPDATE NOWAIT; 

SELECT sa.ac_gl_no FROM sttbs_account sa , sttb_account_back_02032016 ba WHERE ba.alt_ac_no = sa.alt_ac_no

SELECT * from sttm_cust_account WHERE cust_no ='043703'

SELECT  sa.alt_ac_no,ac.alt_ac_no ,count(*) FROM 
sttm_cust_account ac ,sttbs_account sa
WHERE ac.alt_ac_no = sa.alt_ac_no
and sa.ac_gl_no ='N' 
group by sa.alt_ac_no,ac.alt_ac_no having count(*) >1

and sa.alt_ac_no not in(SELECT alt_ac_no FROM sttbs_account WHERE ac_gl_no ='N') ;
