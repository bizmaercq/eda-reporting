select a.cust_ac_no, a.ac_desc, a.lcy_curr_balance, sum(decode(h.drcr_ind,'D',lcy_amount,0)) IC_Debited, sum(decode(h.drcr_ind,'C',lcy_amount,0)) IC_Credited, sum(decode(h.drcr_ind,'C',lcy_amount,0))- sum(decode(h.drcr_ind,'D',lcy_amount,0)) IC_Balance
from actb_history h, sttm_cust_account a
where h.ac_no = a.cust_ac_no
and h.trn_code in ('RVE','TAX','ADJ','ASC','DIN','HDI','TOI','TDD','COM','DTO','LRI')
and h.module in ('DE','IC')
and h.ac_no in (select cust_ac_no from sttm_cust_account where acc_status like 'DO%')
group by a.cust_ac_no, a.ac_desc, a.lcy_curr_balance
--order by  sum(decode(h.drcr_ind,'C',lcy_amount,0))- sum(decode(h.drcr_ind,'D',lcy_amount,0));
order by lcy_curr_balance
