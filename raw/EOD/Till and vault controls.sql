-- control system denominations for Till or vault
select * from xafnfc.fbtb_till_detail_ccy where branchcode='&BRANCH' and TILL_ID='&VAULT';

-- detail transaction for a Till
select * from xafnfc.fbtb_till_txn_detail where branchcode = '&BRANCH' AND TILL_ID = '&VAULT';


select * from smtb_current_users for update

