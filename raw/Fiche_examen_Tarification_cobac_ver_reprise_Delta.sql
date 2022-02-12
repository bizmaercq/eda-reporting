select t.q1,t.q2,t.q3,t.q4,t.q5,t.q6,t.q7,t.q8,t.q9, nvl(l.loan_amount,t.q10) q10,t.q11,t.q12,t.q13,t.q14,t.q15,t.q16,t.q17,t.q18,t.q19,t.q20,t.q21
from cobac_tarif_staff t left outer join temp_deltaloan l on substr(t.q22,1,15) = l.loan_branch||l.loan_loan_ocam||l.loan_loan_customer_id||l.loan_loan_suffixe

select * from temp_deltaloan l.loan_branch||l.loan_loan_ocam||l.loan_loan_customer_id||l.loan_loan_suffixe= '233160100142901';
select * from cobac_tarif_staff ;
