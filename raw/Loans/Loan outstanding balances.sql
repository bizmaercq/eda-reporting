--- Loan outstanding principal for a specific contrac
SELECT * FROM cltb_account_comp_balances cb WHERE cb.account_number ='023M06T121190025' and cb.component_name='PRINCIPAL_OUTSTAND';
SELECT * FROM cltb_account_comp_balances cb WHERE cb.account_number ='023M06T121190025' and cb.component_name='PRINCIPAL_OUTSTAND'
and cb.val_date = (select max(b.val_date) from cltb_account_comp_balances b 
                    where b.val_date <= '&Date' 
                    and b.account_number = cb.account_number
                    and b.component_name='PRINCIPAL_OUTSTAND');

-------- Loans outstanding principal as of date  for ongoing loans                  
SELECT am.BRANCH_CODE,cu.customer_no,cu.customer_name1, am.ACCOUNT_NUMBER,am.BOOK_DATE, am.AMOUNT_FINANCED,'&Date' "As_Of_Date", cb.balance 
FROM cltb_account_comp_balances cb , cltb_account_master am, sttm_customer cu
WHERE am.ACCOUNT_NUMBER = cb.account_number
and am.CUSTOMER_ID = cu.customer_no
and am.MATURITY_DATE >= sysdate -- ongoing
-- and am.Book_date between '' and '' -- for loans put in place at a specific period
-- and am.Maturity_date between '01/01/2019' and '308/06/2019' -- for loans ongoing at a specific period
and cb.component_name='PRINCIPAL_OUTSTAND'
and cb.val_date = (select max(b.val_date) from cltb_account_comp_balances b 
                    where b.val_date <= '&Date' 
                    and b.account_number = cb.account_number
                    and b.component_name='PRINCIPAL_OUTSTAND');
