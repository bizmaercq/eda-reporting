update ictb_acc_pr
set has_problems='*'
where acc='0402820104095954';
commit;


select has_problems from ictb_acc_pr where acc='0402820104095954'
commit;

select * from sttm_cust_account where cust_ac_no ='0402820104095954'

select cust_ac_no from sttm_cust_account where line_id='040959';

select customer_no from sttm_customer where liability_no='040959';

update sttm_customer set liability_no = Null where customer_no='040959' ;

select customer_no from sttm_customer where liability_no='040959';

update sttm_customer set liability_no = '040959' where customer_no='040959';

SELECT * FROM LMTMS_LIMITS where liab_id='040959'

SELECT * FROM LMTMS_LIMITS where liab_id='040959'

SELECT ID FROM GETM_LIAB WHERE LIAB_NO='040959'

select line_id from sttm_cust_account where cust_ac_no = '0402820104095954';

SELECT count(1) FROM GETM_FACILITY_BLOCK WHERE FACILITY_ID = (SELECT ID FROM GETM_FACILITY WHERE LIAB_ID =(SELECT ID FROM GETM_LIAB WHERE LIAB_NO='040959'));

SELECT * FROM LMTMS_LIMITS WHERE LIAB_ID = '43753'

SELECT count(1) FROM GETM_FACILITY_BLOCK WHERE FACILITY_ID = (SELECT ID FROM GETM_FACILITY WHERE LIAB_ID =(SELECT ID FROM GETM_LIAB WHERE LIAB_NO='040959'));

SELECT * FROM LMTMS_LIMITS WHERE LIAB_ID = '43753'


SELECT count(1) FROM LMTMS_LIMITS where liab_id='040959'



SELECT * FROM getm_liab_cust WHERE customer_no ='040959'

SELECT * FROM getm_liab WHERE id = (SELECT liab_id FROM getm_liab_cust WHERE customer_no ='040959')

SELECT * FROM getm_facility WHERE liab_id =(SELECT liab_id FROM getm_liab_cust WHERE customer_no ='040959');

select record_stat from sttm_cust_account where cust_ac_no='0402820104095954'

select record_stat from sttm_customer where customer_no='040959';

select a.branch_code,today , decode(end_of_input,'N','Transaction Input','T','EOTI','F','EOFI','E','EOD',
'B','BOD',end_of_input) status from sttm_dates a,sttm_branch b where a.branch_code = '040';

select a.branch_code,today , decode(end_of_input,'N','Transaction Input','T','EOTI','F','EOFI','E','EOD',
'B','BOD',end_of_input) status from sttm_dates a,sttm_branch b where a.branch_code = b.branch_code and a.branch_code='040' 

SELECT COUNT(1)
FROM Getm_Liab
WHERE Liab_No = '040959' ;

SELECT COUNT(1)
FROM Getm_Liab_Cust Lc, Getm_Liab l
WHERE Lc.Customer_No = '040959'
AND Lc.Liab_Id = '040959';

select * from eitbs_pending_programs where branch_code='040' ;

select count(1) from Getm_Liab where id = '40959';


select count(1) from Getm_Liab_Cust where Customer_No = '040959';

select * from eitbs_pending_programs where branch_code='040' and function_id='ICEOD' ;


SELECT a.Branch_Code,
a.Cust_Ac_No,
b.Account_Class,
b.Ccy,
a.Last_Salary_Dt,
a.Salary_Amt,
a.First_Salary_Dt
FROM Sttb_Cust_Salary a, Sttm_Cust_Account b
WHERE a.Branch_Code = '040'
AND a.First_Salary_Dt <= '05/11/2012'
AND b.Cust_Ac_No = a.Cust_Ac_No
And a.cust_ac_no = '0402820104095954'
AND Nvl(a.Fee_Processed_Flag, 'U') = 'U';

