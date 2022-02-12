select count(*) from sttm_customer where customer_no in
(

select count(*) from sttm_cust_account where substr(account_class,1,2)  not in ('11','12','13','14','15','16','17','19','35','55','56','57')

)


select * from sttm_cust_account where cust_ac_no ='0501720103833668'

select * from sttm_customer where customer_name1 like '%AJEFU%'

select * from fbtb_till_detail_ccy


select * from sttm_customer where customer_no ='004157'

select * from sitb_contract_master where contract_ref_no ='020SIOO123260004'

select * from sitb_instruction where counterparty ='000966'

select * from smtb_user where user_name like '%AKEMESEK%'
select * from detb_batch_master_hist where batch_no ='1207'  and last_oper_id ='AAPONDE' and branch_code ='010'

select * from actb_history where trn_ref_no ='FJB1306401410058'

select * from actb_history h,detb_jrnl_txn_detail t where t.reference_no = h.trn_ref_no and ac_no in ('434004000','435002000')  and value_dt between '01/02/2013' and '28/02/2013'

select * from fbtb_txnlog_details_hist where xrefid ='0417008121640001'
select * from actb_history where external_ref_no ='FJB1306401410058'  

select * from detb_jrnl_txn_detail where ac_gl_no in ('434004000','435002000') 


select * from sttm_cust_account where cust_ac_no ='0432820103078476'


select * from actb_history where trn_ref_no = '0417008121640001'

select h.ac_branch,h.ac_no,h.instrument_code,h.drcr_ind,decode(h.drcr_ind,'D',-h.lcy_amount,h.lcy_amount)lcy_amount,h.trn_dt from actb_history h where length(ac_no) = 9 and ac_no = '371006000' and trn_dt between '18/03/2013' and '19/03/2013'

select * from gltb_gl_bal where gl_code = '371006000'
select * from gltm_glmaster where gl_code ='371006000'

select * from actb_history where length(ac_no) <> 9 and substr(ac_no,4,2)='17' and trn_dt  between '18/03/2013' and '19/03/2013'


select * from sttm_cust_account where cust_ac_no = '0203830100706102'

select * from sttm_customer where customer_no ='007061'
