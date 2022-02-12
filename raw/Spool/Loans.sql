

select  * from xafnfc.cltb_account_master where substr(product_code,4,1) = 'T' 
-- Outstanding staff loan accounts
select m.branch_code,m.account_number,m.PRIMARY_APPLICANT_NAME, b.out_bal_amount
from xafnfc.cltb_daily_acc_out_bal b join xafnfc.cltb_account_master m on m.account_number = b.account_number
where substr(m.account_number,7,1) ='T' and to_char(run_date,'DD/MM/YYYY') ='31/05/2012'
