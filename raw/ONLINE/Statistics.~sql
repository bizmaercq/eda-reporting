-- All transactions
select t.seq,t.user_id,t.customer_id,c.customer_name1,nvl(t.channel,'IOS') channel,
decode(nvl(t.id_request,'IAT'),'IAT' ,'Funds Transfer Internal Same Customer','OAT','Funds Transfer Internal Other Customer','RTGS','Funds Transfer Other Bank','BILLPAYPREP','Bill Payments','BILLPAYPREP_REVERSAL','Bill Payments Reversal','STPCHQPAY','Cheque Stop payment','OTHERS')
from TXN_ONLINE t, xafnfc.sttm_customer c
WHERE t.customer_id = c.customer_no;

-- Transaction per staff
select distinct t.user_id,t.customer_id,c.customer_name1,
decode(nvl(t.id_request,'IAT'),'IAT' ,'Funds Transfer Internal Same Customer','OAT','Funds Transfer Internal Other Customer','RTGS','Funds Transfer Other Bank','BILLPAYPREP','Bill Payments','BILLPAYPREP_REVERSAL','Bill Payments Reversal','STPCHQPAY','Cheque Stop payment','OTHERS') request
,count(*)
from TXN_ONLINE t, xafnfc.sttm_customer c
WHERE t.customer_id = c.customer_no
group by  t.user_id,t.customer_id,c.customer_name1,
decode(nvl(t.id_request,'IAT'),'IAT' ,'Funds Transfer Internal Same Customer','OAT','Funds Transfer Internal Other Customer','RTGS','Funds Transfer Other Bank','BILLPAYPREP','Bill Payments','BILLPAYPREP_REVERSAL','Bill Payments Reversal','STPCHQPAY','Cheque Stop payment','OTHERS')
order by t.customer_id;

-- Transaction per Request
select decode(nvl(t.id_request,'IAT'),'IAT' ,'Funds Transfer Internal Same Customer','OAT','Funds Transfer Internal Other Customer','RTGS','Funds Transfer Other Bank','BILLPAYPREP','Bill Payments','BILLPAYPREP_REVERSAL','Bill Payments Reversal','STPCHQPAY','Cheque Stop payment','OTHERS') request
/*, t.user_id,t.customer_id,c.customer_name1,*/,count(*)
from TXN_ONLINE t, xafnfc.sttm_customer c
WHERE t.customer_id = c.customer_no
group by  /*t.user_id,t.customer_id,c.customer_name1,*/
decode(nvl(t.id_request,'IAT'),'IAT' ,'Funds Transfer Internal Same Customer','OAT','Funds Transfer Internal Other Customer','RTGS','Funds Transfer Other Bank','BILLPAYPREP','Bill Payments','BILLPAYPREP_REVERSAL','Bill Payments Reversal','STPCHQPAY','Cheque Stop payment','OTHERS');

-- Transaction per channel
select nvl(t.channel,'IOS') channel ,count(*)
from TXN_ONLINE t, xafnfc.sttm_customer c
WHERE t.customer_id = c.customer_no
group by  nvl(t.channel,'IOS');
