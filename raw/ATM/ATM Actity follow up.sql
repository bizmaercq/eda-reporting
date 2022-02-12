----schemas xafnfc FCUBS

-- Transaction log for today and yesterday
SELECT TRN_REF_NO, a.work_progress, a.reconsiled, error_code, rrn, a.* FROM swtb_txn_log A where msg_type<>'0800' order by a.rrn desc; --Yesterdays and Todays Transactions Log
SELECT TRN_REF_NO, a.work_progress, a.reconsiled, error_code, rrn, a.* FROM swtb_txn_log A where msg_type='0220' order by a.rrn desc; --Yesterdays and Todays Transactions Log




-- Unreconciled Transactions
SELECT a.trn_ref_no,a.Error_Code,a.resp_code,A.* FROM swtb_txn_log a WHERE MSG_TYPE <> '0800' and reconsiled is null
order by xref desc;

SELECT a.trn_ref_no,a.Error_Code,a.resp_code,A.* FROM swtb_txn_log a WHERE rrn='514958326086' --SW-DUP-02
order by xref desc ;
-- ATM Cash withdrawals in daily log
SELECT * FROM actb_daily_log a where a.trn_code ='ACW'and length(a.ac_no)<>9 and a.trn_ref_no like '023%';

SELECT * FROM actb_daily_log a where a.trn_code ='ACW'and length(a.ac_no)<>9 and a.trn_ref_no like '023%';
---- valeur des transactions des cartes regroupées par agences et années fiscales
SELECT a.ac_branch,a.financial_cycle , sum(a.lcy_amount) from acvw_all_ac_entries a 
where a.trn_code ='ACW'and length(a.ac_no)<>9 
group by a.ac_branch,a.financial_cycle 
order by a.ac_branch 

----choumele---
SELECT ac_no  FROM actb_daily_log a where a.trn_code ='ACW' and length(a.ac_no)<>9 ;

-- Checking customer account
SELECT * FROM sttm_cust_account ac where ac.cust_ac_no ='0203810201421785';
-- Checking Account mapping
SELECT * FROM swtm_card_details cd WHERE substr(cd.fcc_acc_no,9,6) = '054371'; --FOR UPDATE NOWAIT;
SELECT * FROM swtm_card_details cd WHERE atm_card_no ='5028529472916720' FOR UPDATE NOWAIT;
-- Checking next run date
SELECT * FROM gitm_interface_definition FOR UPDATE NOWAIT; 
-- Updating to maintain cash GL for Terminal
SELECT * FROM Swtm_Terminal_Details FOR UPDATE NOWAIT; 
SELECT * FROM swtms_acquirer_details;

SELECT * FROM swtb_settlement;

SELECT distinct object_name FROM gitm_comp_fld_linkage ;


UPDATE SMTB_USER SET AUTO_AUTH='Y' WHERE (LOWER(USER_ID)=LOWER('&USERID') OR UPPER(USER_ID)=UPPER('&USERID'));

SELECT * FROM  swtb_txn_hist WHERE trn_ref_no ='023ATCW151560001';
SELECT * FROM  swtb_txn_log WHERE trn_ref_no ='023ATCW151550003';

SELECT * FROM  swtb_txn_log WHERE msg_type <>'0800' and term_id ='10025210' and trans_dt_time like '0903%';
SELECT * FROM  swtb_txn_log WHERE pan = '5028529472916720' ;

SELECT * FROM sttm_cust_account WHERE cust_no ='000247';

SELECT * FROM sttm_cust_account WHERE cust_ac_no ='0232810101421677';

SELECT * FROM swtb_txn_hist WHERE rrn in ('517443808028','517433530026','517443872030');
SELECT * FROM swtb_txn_log WHERE rrn in ('532521556839');

SELECT table_name from user_tables WHERE table_name like '%%';

SELECT * FROM  swtm_card_details WHERE atm_card_no ='5028529472916720'; 

SELECT distinct cu.local_branch, cu.customer_no,cu.customer_name1
FROM sttm_cust_account ca, sttm_customer cu
WHERE ca.cust_no = cu.customer_no
and ca.cust_ac_no 
not in (SELECT cd.fcc_acc_no FROM  swtm_card_details cd WHERE substr(cd.fcc_acc_no,4,3) ='281')
and ca.account_class ='281'
and ca.ac_open_date >='01-JAN-2012'
and ca.record_stat ='O'
order by cu.local_branch,cu.customer_name1; 


--- linked cards
SELECT cd.atm_card_no/*, trunc(cd.checker_dt_stamp) Link_Date*/ , count(*) Number_links FROM swtm_card_details cd group by cd.atm_card_no/*,trunc(cd.checker_dt_stamp)*/ having count(*) = 2;


----- liste des clients ayant des cartes liées à 2 compte(courant et epargne)
select cu.local_branch,cu.customer_no,cu.customer_name1,cd.atm_card_no,cd.atm_acc_no 
from swtm_card_details cd , sttm_customer cu
where cu.customer_no = substr(cd.atm_acc_no,9,6)
and cd.atm_card_no in (
SELECT cd.atm_card_no FROM swtm_card_details cd group by cd.atm_card_no/*,trunc(cd.checker_dt_stamp)*/ having count(*) = 2
) order by cd.atm_card_no;
----- nombre de cartes pour une agence 
SELECT count(*) FROM swtm_card_details cd WHERE cd.fcc_acc_brn='051' and cd.maker_dt_stamp  between  '01-JAN-2015' and '30-JUL-2018'

SELECT * FROM swtm_card_details cd WHERE cd.fcc_acc_brn='051' and cd.maker_dt_stamp  between  '01-JAN-2015' and '09-NOV-2018'

-- Liste of  all costomer with an ATM card
SELECT cd.fcc_acc_brn branch,cd.atm_acc_no flex_account,cd.atm_card_no Card_number,cu.customer_name1,cd.maker_dt_stamp 
FROM swtm_card_details cd, sttm_customer cu
WHERE substr(cd.atm_acc_no,9,6)=cu.customer_no and cd.maker_dt_stamp  between  '01-JAN-2015' and '09-NOV-2018'
order by cd.fcc_acc_brn,cu.customer_name1

--- tout le réseau nfc
SELECT count(*) FROM swtm_card_details cd WHERE  cd.maker_dt_stamp  between  '01-JAN-2018' and '17-sept-2018'
----- nombre de cartes par agence 
SELECT cd.fcc_acc_brn, count(*) FROM swtm_card_details cd WHERE  cd.maker_dt_stamp  between  '01-JAN-2015' and '31-JUL-2018'  group by cd.fcc_acc_brn order by cd.fcc_acc_brn

SELECT * FROM swtm_card_details cd WHERE cd.fcc_acc_brn='051' and cd.maker_dt_stamp  between  '01-JAN-2018' and '30-JUN-2018'

----nombre de carte et volume de transactions par années 
select FINANCIAL_CYCLE, count(atm_card_no) nombre,sum(volume)/1000000 volume
from (SELECT a.FINANCIAL_CYCLE, cd.atm_card_no, sum(a.LCY_AMOUNT)volume  FROM acvw_all_ac_entries a ,swtm_card_details cd 
where a.AC_NO=cd.fcc_acc_no
and  a.trn_code ='ACW' and length(a.ac_no)<>9 
--and a.FINANCIAL_CYCLE='FY2016'
group by a.FINANCIAL_CYCLE,cd.atm_card_no)
group by FINANCIAL_CYCLE;

select * from acvw_all_ac_entries a where substr(a.AC_NO,1,16)='0402820102740573' and a.TRN_DT between '01-JAN-2018' and '31-JUL-2018'


select * from swtm_card_details where FCC_ACC_NO like '%281%'



