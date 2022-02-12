-- Checking all processed transactions
SELECT * FROM sms_alert_log FOR UPDATE NOWAIT;
select * from sms_alert_log where process_status ='P' and ac_branch ='&Branch';
select ac_branch,count(*) from sms_alert_log where process_status ='P' group by ac_branch order by ac_branch;
Select count(*) from sms_alert_log where process_status ='P' and Error_Reason ='Mobile Number is null ' ;
aand Error_Reason ='Mobile Number is null ' ;
truncate table sms_alert_log;
select * from sms_alert_log where acc_no ='0423830106018947' for update;
select * from sms_alert_log_history al  where al.mobile_number  like '%653275944%' for update;
SELECT * FROM sms_alert_log_history where acc_no ='0302820105986343'  
SELECT * FROM xafnfc.sttm_cust_personal cp  WHERE cp.customer_no ='014286' FOR UPDATE NOWAIT; 
SELECT * FROM xafnfc.sttm_corp_directors cp  WHERE cp.customer_no ='051474' FOR UPDATE NOWAIT;
SELECT * FROM xafnfc.sttm_corp_directors cp  WHERE cp.mobile_number ='678131707' FOR UPDATE NOWAIT;
SELECT * FROM xafnfc.sttm_cust_personal cp  WHERE cp.mobile_number ='653275944' FOR UPDATE NOWAIT;

SELECT * FROM sms_cust_account WHERE cust_no ='065541' ;--FOR UPDATE NOWAIT;  
-- Pull SMS initiated in the system
select * from smsusr_trlog;
-- Detail sms for customers
select cu.local_branch,tl.id,tl.created_on,tl.status,cu.customer_no,cu.full_name,cp.mobile_number
from smsusr_trlog tl,sms_cust_personal cp,xafnfc.sttm_customer cu
where substr(tl.msisdn,4,8) = cp.mobile_number
and cp.customer_no = cu.customer_no
order by cu.local_branch;
-- Summary per branch
select cu.local_branch,tl.id,tl.created_on,tl.status,cu.customer_no,cu.full_name,cp.mobile_number
from smsusr_trlog tl,sms_cust_personal cp,xafnfc.sttm_customer cu
where substr(tl.msisdn,4,8) = cp.mobile_number
and cp.customer_no = cu.customer_no
order by cu.local_branch;


-- checking for Unprocessed SMS
Select count(*) from sms_alert_log where process_status ='P';
Select * from sms_alert_log where process_status ='U';


-- All failed transactions

Select * from sms_alert_log where process_status ='P' order by datestamp desc;

-- Check  transactions for one customer account

select * from sms_alert_log where acc_no ='0422820106351077' FOR UPDATE NOWAIT;


update sms_alert_log set process_status ='U' 
where acc_no in ('0513830105478134' );

-- Check transaction for one transaction code
select process_status,count(*) from sms_alert_log where operation ='S13' group by process_status;
update sms_alert_log set process_status = 'U' where operation ='ILT';


-- Failed because of no mobile number Detailed
select distinct al.ac_branch,cu.CUSTOMER_NO,al.acc_no,cu.CUSTOMER_NAME1 ,al.error_reason
from sms_alert_log al , sms_customer cu
where substr(al.acc_no,9,6) = cu.CUSTOMER_NO
and al.process_status ='F'
and al.Error_Reason ='Mobile Number is null '
order by al.ac_branch,cu.CUSTOMER_NAME1;

-- Failed because of no mobile number Summary
select ac_branch,count(*) "COUNT"
from
(select distinct al.ac_branch,cu.CUSTOMER_NO,al.acc_no,cu.CUSTOMER_NAME1 ,al.error_reason
from sms_alert_log al , sms_customer cu
where substr(al.acc_no,9,6) = cu.CUSTOMER_NO
and al.process_status ='F'
and al.Error_Reason ='Mobile Number is null ')
group by ac_branch
order by ac_branch;


-- Force processing for these transactioins
update sms_alert_log al set process_status ='U' where process_status ='F' and al.Error_Reason ='Mobile Number is null ' and al.ac_branch ='&Branch';
commit;


-- Failed because of Gateway not available
select  count(*)
from sms_alert_log al
where al.Error_Reason ='TNS: Operation Timed Out - Gateway Unavailable'
and al.process_status ='U';

select *
from sms_alert_log al
where al.Error_Reason ='TNS: Operation Timed Out - Gateway Unavailable'
and al.process_status ='F';

-- force processing for these transactions
update sms_alert_log al set process_status ='U' where al.process_status='F' and  al.Error_Reason ='TNS: Operation Timed Out - Gateway Unavailable';
commit;

-- Unhandled Exception
select  *
from sms_alert_log al
where al.Error_Reason ='Unhandled Exception';
-- force processing for these transactions
update sms_alert_log al set process_status ='U' where al.Error_Reason ='Unhandled Exception';
commit;

-- Failed because of Unstable message
select  *
from sms_alert_log al
where al.Error_Reason ='Message is unstable';
-- force processing for these transactions
update sms_alert_log al set process_status ='U' where al.Error_Reason ='Message is unstable';
update sms_alert_log al set email_status ='P' where process_status ='P';
commit;


-- SMS Parameters
SELECT * FROM sms_param FOR UPDATE NOWAIT; 
http://lmtgroup.dyndns.org/sendsms/sendsms.php?  

select trunc(cc.dispatch_dt_stamp,'YYYY') from sms_alert_log cc

update sms_alert_log cc set process_status ='U' where cc.process_status = 'X' and substr(cc.acc_no,4,3)<>'282'

select  count(*)
from sms_alert_log al
where al.process_status ='U';

select  *
from sms_alert_log al
where al.process_status ='U';


SELECT * FROM sms_alert_log WHERE trunc(datestamp) ='11-SEP-2017' and process_status ='P'
select * from sms_alert_log where operation='ODACC'
SELECT * FROM sms_exception_log where UPPER(error_params) like '%ODACC%'

SELECT * FROM sms_user_logins; --FOR UPDATE NOWAIT;

select * from sms_alert_log order by  datestamp desc FOR UPDATE NOWAIT; 

create table sms_alert_log_bkp02082018  as SELECT * FROM  sms_alert_log
truncate table sms_alert_log

update sms_alert_log al set al.process_status ='U' WHERE al.process_status ='F'
update sms_alert_log al set al.email_status ='P' WHERE al.process_status ='P'

insert into sms_alert_log_history Select * from sms_alert_log where process_status ='P'