SELECT distinct ac.card_branch,ca.atm_card_no,ac.flex_acc_no,cp.first_name||' '||cp.last_name Card_name,cp.mobile_number
FROM account_branch ac,card_account ca,xafnfc.sttm_cust_personal cp
WHERE ac.flex_acc_no(+) = ca.flex_acc_no
and substr(ac.flex_acc_no,9,6)= cp.customer_no
and substr(ac.flex_acc_no,4,1)<>'1'
order by ac.card_branch,ca.atm_card_no;
SELECT distinct ac.card_branch,ca.atm_card_no,ac.flex_acc_no,cu.full_name||' C/O '||cd.Director_name Card_name,cd.mobile_number
FROM account_branch ac,card_account ca,xafnfc.sttm_corp_directors cd,xafnfc.sttm_customer cu
WHERE ac.flex_acc_no = ca.flex_acc_no
and substr(ac.flex_acc_no,9,6) = cu.customer_no
and substr(ac.flex_acc_no,4,1)='1'
order by ac.card_branch,ca.atm_card_no;

SELECT ca.atm_card_no,ca.flex_acc_no,cu.ac_desc,ab.card_branch
FROM card_account ca,account_branch ab,xafnfc.sttm_cust_account cu
WHERE ca.flex_acc_no = ab.flex_acc_no(+)
and ca.flex_acc_no = cu.cust_ac_no;
