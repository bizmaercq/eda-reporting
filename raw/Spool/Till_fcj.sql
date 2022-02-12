accept BRANCH PROMPT 'Enter BRANCH ==> '
accept VAULT PROMPT 'Enter Till/Vault Id ==> '
set array 1
set line 1000
set head on
set pagesize 10000
set colsep ';'
SPOOL C:\DE_TILL.SPL

prompt fbtb_till_detail_ccy

select * from fbtb_till_detail_ccy where branchcode='&BRANCH' and TILL_ID='&VAULT';

PROMPT fbtb_till_master

select * from fbtb_till_master where branch_code = '&BRANCH' AND TIL_ID = '&VAULT';

prompt fbtb_till_txn_detail

select * from fbtb_till_txn_detail where branchcode = '&BRANCH' AND TILL_ID = '&VAULT';

prompt fbtb_till_totals

select * from fbtb_till_totals where till_id ='&VAULT' and postingdate = (select today from fbtb_dates where branch_code='&BRANCH');

prompt fbtb_ccy_denom

select * from fbtb_ccy_denom;

prompt fbtb_dates

select * from fbtb_dates;

prompt fbtb_user_tills 

select * from fbtb_user_tills where til_id = '&VAULT';


SPOOL OFF