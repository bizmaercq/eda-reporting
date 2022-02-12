-- Signatures Modified since migration
SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc,to_date(sm.checker_dt_stamp,'DD/MM/RRRR') Date_Modified,sm.maker_id Maker,sm.checker_id checker
FROM svtm_cif_sig_master sm, sttm_cust_account ca
WHERE sm.cif_id = ca.cust_no
and sm.maker_id  <>'CONV_USER'
and sm.checker_id is not null
order by ca.branch_code,sm.checker_dt_stamp;

--- Accounts with more than one signature

SELECT ca.branch_code,ca.cust_ac_no,ca.ac_desc, count(*) Number_Sig
FROM svtm_acc_sig_det sd, sttm_cust_account ca
WHERE sd.acc_no = ca.cust_ac_no
group by ca.branch_code,ca.cust_ac_no,ca.ac_desc
having count(*) >1
order by ca.branch_code;