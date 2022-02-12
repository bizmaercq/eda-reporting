Select Class,case when debit_balance is not null then dr_gl else cr_gl end GL,nvl(credit_balance,0) - nvl(debit_balance,0) Balance
from (select substr(ac.dr_gl,1,3) Class, ac.dr_gl DR_GL,ac.cr_gl CR_GL,aa.account,ac.ac_desc,'&Date' Period_End_Date,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac
where aa.account = ac.cust_ac_no 
and aa.bkg_date = (select max(a.bkg_date) from actb_accbal_history a 
                    where a.bkg_date <= '&Date' 
                    and a.account = aa.account)
--and substr(ac.cust_ac_no,4,5) ='28102' --- Teller second accounts
--and substr(ac.account_class,1,1) in ('1','2','3','5') -- Normal customer accounts
--and substr(ac.dr_gl,1,3) in ('371','372','373')
--and nvl(aa.lcy_closing_bal,0) > 0
order by aa.branch_code, aa.account);
