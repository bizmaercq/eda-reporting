SELECT cd.atm_card_no,cd.fcc_acc_no,cu.first_name||' '||cu.last_name Customer_name
FROM swtm_card_details cd,sttm_cust_personal cu
WHERE substr(cd.atm_acc_no,9,6) = cu.customer_no
and trunc(cd.maker_dt_stamp) ='15/10/2015'
order by cd.atm_card_no
