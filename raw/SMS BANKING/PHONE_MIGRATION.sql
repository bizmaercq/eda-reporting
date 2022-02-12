-- Triming left spaces on all phone numbers
update sttm_cust_personal cp set cp.mobile_number = ltrim(cp.mobile_number);
update sttm_corp_directors cd set cd.mobile_number = ltrim(cd.mobile_number);
commit;


-- checking telephone numbers for individuals
SELECT cu.local_branch BRANCH, cp.customer_no, cu.customer_name1,cp.mobile_number,substr(cp.mobile_number,1,2) INDICATIF,
decode ( nvl(substr(cp.mobile_number,1,2),'00'),'20' ,'CAMTEL','21','CAMTEL','22' ,'CAMTEL','23' ,'CAMTEL','24' ,'CAMTEL','33' ,'CAMTEL',
         '90' ,'ORANGE','91' ,'ORANGE','92' ,'ORANGE','93' ,'ORANGE','94' ,'ORANGE','95' ,'ORANGE','96' ,'ORANGE','97' ,'ORANGE','98' ,'ORANGE','99' ,'ORANGE',
         '55' ,'ORANGE','56' ,'ORANGE','57' ,'ORANGE','58' ,'ORANGE','59' ,'ORANGE',
         '70' ,'MTN','71' ,'MTN','72' ,'MTN','73' ,'MTN','74' ,'MTN','75' ,'MTN','76' ,'MTN','77' ,'MTN','78' ,'MTN','79' ,'MTN',
         '50' ,'MTN','51' ,'MTN','52' ,'MTN','53' ,'MTN','54' ,'MTN',
         '60' ,'NEXTTEL','61' ,'NEXTTEL','62' ,'NEXTTEL','63' ,'NEXTTEL','64' ,'NEXTTEL','65' ,'NEXTTEL','66' ,'NEXTTEL','67' ,'NEXTTEL','68' ,'NEXTTEL','69' ,'NEXTTEL',
         '00','NONE','OTHERS'
) OPERATOR
FROM sttm_customer cu, sttm_cust_personal cp 
where cp.customer_no = cu.customer_no;

-- Updating customer numbers 
-- Mobile Operators 
update sttm_cust_personal cp set cp.mobile_number = '6'||cp.mobile_number where substr(cp.mobile_number,1,1) in ('5','6','7','9');
update sttm_corp_directors cd set cd.mobile_number = '6'||cd.mobile_number where substr(cd.mobile_number,1,1) in ('5','6','7','9');
-- Camtel Operators
update sttm_cust_personal cp set cp.mobile_number = '24'||substr(cp.mobile_number,2,7) where substr(cp.mobile_number,1,1) in ('2','3');
update sttm_corp_directors cd set cd.mobile_number = '24'||substr(cd.mobile_number,2,7) where substr(cd.mobile_number,1,1) in ('2','3');
-- checking telephone numbers for individuals
SELECT cu.local_branch BRANCH, cp.customer_no, cu.customer_name1,cp.mobile_number,substr(cp.mobile_number,1,2) INDICATIF,
decode ( nvl(substr(cp.mobile_number,1,1),'0'),'6' ,'MOBILE','2','CAMTEL','OTHERS') OPERATOR
FROM sttm_customer cu, sttm_cust_personal cp 
where cp.customer_no = cu.customer_no;

-- checking telephone numbers for corporate
SELECT cu.local_branch BRANCH, cd.customer_no, cu.customer_name1,cd.mobile_number,substr(cd.mobile_number,1,2) INDICATIF,
decode ( nvl(substr(cd.mobile_number,1,1),'0'),'6' ,'MOBILE','2','CAMTEL','OTHERS') OPERATOR
FROM sttm_customer cu, sttm_corp_directors cd 
where cd.customer_no = cu.customer_no;


SELECT * FROM sttm_corp_directors;


