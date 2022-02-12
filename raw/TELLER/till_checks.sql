select * from fbtb_till_totals where till_id='TILL_030_3'
select * from fbtb_till_detail_ccy where till_id='TILL_030_3'
select * from fbtb_txnlog_details where functionid ='1401' and userid ='CONV_USER'
select * from fbtb_txnlog_master_hist where functionid ='1401' and makerid='CONV_USER' and txnstatus='COM'
select * from fbtb_txnlog_master_hist where functionid ='1401' and makerid='INDUM' and txnstatus='REV'

select * from smtb_current_users

select * from cstm_product
