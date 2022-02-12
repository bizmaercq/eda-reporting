---- schemas oblive 

-- Registered users
SELECT  * FROM tek_hb_user  ;

--Registered users count
select count(*)  from tek_hb_user;
--Registered users count for period
select count(*)  from tek_hb_user a
where a.auth_date between '01-JAN-2017' and '09-NOV-2018';

-- Registered but not loggedin
select count(*)  from tek_hb_user where last_login_time is null;

--Registered but not done any transactions like billpayments/fundstransfers
select count(*) from tek_hb_user where user_id not in (select distinct user_id from tek_hb_host_reqrep_audit);

--Currently logged-in users in descending order
select * from tek_user_session order by login_time desc

--[OTHER BANK TRANSFER THROUGH JOB - ALL ENTRIES]
SELECT * FROM TEK_HB_RTGS_PENDINGLIST;

--[OTHER BANK TRANSFER THROUGH JOB - REFERENCE NUMBER]
SELECT REF_NO FROM TEK_HB_RTGS_PENDINGLIST;

--[FOR RETRY, SAMPLE RETRY REF_NO : 1234_RETRY_1]
SELECT * FROM TEK_HB_HOST_REQREP_AUDIT WHERE IDREFRENCE LIKE '1234%';

--[OTHER BANK TRANSFER THROUGH JOB - ERROR LOGS]
SELECT * FROM TEK_HB_HOST_REQREP_AUDIT WHERE IDREFRENCE IN (SELECT REF_NO FROM TEK_HB_RTGS_PENDINGLIST);

--Bill payment requests
select * from tek_hb_biller_request order by payment_date desc;

--Bill payment requests by particular user in descending order.
select * from tek_hb_biller_request where user_id = 'TEST' order by payment_date desc;

--Fund transfers success count [Own], For fail count use response_status = 'FAIL'
select count(*) from tek_hb_host_reqrep_audit where idrequest in ('OAT') and response_status = 'SUCCESS';

--Fund transfers success count [Own/Internal], For fail count use response_status = 'FAIL'
select count(*) from tek_hb_host_reqrep_audit where idrequest in ('IAT','OAT') and response_status = 'SUCCESS';

--Fund transfers success count [Own/Internal/Other], For fail count use response_status = 'FAIL'
select count(*) from tek_hb_host_reqrep_audit where idrequest in ('IAT','OAT','RTGS') and response_status = 'SUCCESS';

--Bill payments success count, For fail count use response_status = 'FAIL'
select count(*) from tek_hb_host_reqrep_audit where idrequest in ('BILLPAYPREP') and response_status = 'SUCCESS';

--Bill payments reversal success count, For fail count use response_status = 'FAIL'
select count(*) from tek_hb_host_reqrep_audit where idrequest in ('BILLPAYPREP_REVERSAL') and response_status = 'SUCCESS';

--Bill payments flexcube logs search by date
select * from tek_hb_host_reqrep_audit  where idrequest = 'BILLPAYPREP' and rep_time like '21-NOV-17%'  order by rep_time desc;

--Bill payments details
SELECT * FROM TEK_HB_BILLER_REQUEST WHERE PAYMENT_DATE LIKE '21-NOV-17%' AND STATUS = 'SUCCESS' 
-- sum of Bill payments succes details for a period
SELECT sum(a.amount) FROM TEK_HB_BILLER_REQUEST a WHERE a.payment_date between  '01-jan-2017' and '31-dec-2017' AND STATUS = 'SUCCESS'

--USERS STATISTICS
select user_id,idrequest,response_status,count(*) from tek_hb_host_reqrep_audit group by user_id,idrequest,response_status order by count(*) desc;
select user_id,response_status,count(*) from tek_hb_host_reqrep_audit group by user_id,response_status order by count(*) desc;
select user_id,count(*) from tek_hb_host_reqrep_audit group by user_id order by count(*) desc;

--RETAIL USERS, FOR ACTIVE USER - ACTIVE_STATUS WILL BE 'Y' AND FAIL_LGN_COUNTER WILL BE LESS THAN 4
SELECT * FROM TEK_HB_USER us WHERE us.mapped_customer ='060113' ;

--RETAIL PROFILE AND BENEFICIARIES IMAGES
SELECT * FROM TEK_IB_USER_IMAGES;

--RETIAL BENEFICIARIES
SELECT * FROM TEK_INTERNAL_BENE WHERE CREATED_BY =’TEST’;

--CHEQUE BOOK REQUESTS
SELECT * FROM TEK_HB_CHEQUE_BOOK_DETAILS;

--DEBIT CARD REQUESTS
SELECT * FROM TEK_HB_DEBIT_CARD_DETAILS;

--DEBIT CARD OPERATIONS, EX:BLOCK CARD
SELECT * FROM TEK_HB_DEBIT_CARD_OPTS

--VIEW FEEDBACKS
SELECT * FROM TEK_HB_FEED_BACK

--MAINTENANCE
--BEFORE EOD STATUS - Y, AFTER EOD STATUS - N
SELECT * FROM TEK_IB_MAINTENANCE

--UPDATE MAINTENANCE WITH EOD STATUS
UPDATE TEK_IB_MAINTENANCE SET STATUS='Y' WHERE JOB='EOD'

---- nombre de souscription du online banking par agence pour une periode

select init_brn, count(*)  from tek_hb_user thu  
where thu.auth_date between '01-JAN-2017' and '22-aug-2018' 
group by init_brn 
order by thu.init_brn ;

---liste des souscription au online banking par agence
  select cc.init_brn branch,cc.mapped_customer cif, cc.lname nom, cc.fname prenom, cc.add1 adresse  from tek_hb_user cc
  where cc.auth_date between '01-JAN-2017' and '09-nov-2018' 
  order by cc.init_brn, cc.lname; 
select * from tek_hb_user where mapped_customer='065922'
---- afficher les tables d'un schemas
select * from tab
where cif_id='065922'

select a.cif_id Numero_client,a.address,a.last_name nom_responsable,a.first_name prenom, a.limit_val plafond 
from tek_corporate_user a 

select * from tek_hb_host_reqrep_audit where customer_id='065922'
