-- Civil Servants accounts in books
SELECT ca.branch_code,ca.cust_no, cp.last_name||' '||cp.first_name Names,round((sysdate - cp.date_of_birth)/360) Age,ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance balance,ca.tod_limit TOD,ca.tod_end_date, decode(ca.ac_stat_dormant,'Y','DORMANT','ACTIVE') Dormancy,
case when ca.dormancy_date<sysdate then round((sysdate -ca.dormancy_date)/30) else 0 end "DORMANCY/MONTHS"
FROM sttm_cust_account ca,sttm_cust_personal cp
WHERE cp.customer_no = ca.cust_no 
and ca.account_class in ('282')-- Civil Servants
--and ca.account_class in ('281','283','284','285')-- Non Civil Servants
and ca.branch_code ='&Branch'
and ca.record_stat ='O';

-- Civil Servants with Loans
select a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,b.balance outstanding,sum(nvl(s.amount,0)) Financed,l.BOOK_DATE
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and b.component='PRINCIPAL'
and b.balance <> 0
and a.branch_code ='&Branch'
--and a.account_class in ('282')-- Civil Servants
and a.account_class in ('281','283','284','285')-- Non Civil Servants
group by a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,b.balance,l.BOOK_DATE;

-- civil servants without loans

SELECT ca.branch_code,ca.cust_no, cp.last_name||' '||cp.first_name Names,round((sysdate - cp.date_of_birth)/360) Age,cp.mobile_number,ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance balance,ca.tod_limit TOD,ca.tod_end_date, decode(ca.ac_stat_dormant,'Y','DORMANT','ACTIVE') Dormancy,
case when ca.dormancy_date<sysdate then round((sysdate -ca.dormancy_date)/30) else 0 end "DORMANCY/MONTHS"
FROM sttm_cust_account ca,sttm_cust_personal cp
WHERE cp.customer_no = ca.cust_no 
and ca.account_class in ('282')-- Civil Servants
--and ca.account_class in ('281','283','284','285')-- Non Civil Servants
and ca.branch_code ='&Branch'
and ca.record_stat ='O'
and ca.cust_no not in
(select c.customer_no
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and b.component='PRINCIPAL'
and b.balance <> 0
and a.branch_code ='&Branch'
and a.account_class in ('282')-- Civil Servants
--and a.account_class in ('281','283','284','285')-- Non Civil Servants
group by c.customer_no);


-- without loans but with SI 

select a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,m.si_amt Amount, m.si_expiry_date
from sttm_customer c,sttm_cust_account a,sitb_contract_master m
where a.cust_ac_no=m.dr_account
and c.customer_no =  a.cust_no
and m.si_expiry_date >sysdate
and a.branch_code ='&Branch'
and a.account_class in ('282')
and a.cust_no not in 
(select c.customer_no
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and b.component='PRINCIPAL'
and b.balance <> 0
and a.branch_code ='&Branch'
and a.account_class in ('282')-- Civil Servants
--and a.account_class in ('281','283','284','285')-- Non Civil Servants
group by c.customer_no);-- Civil Servants



-- Civil servants with SI
select a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,m.si_amt Amount, m.si_expiry_date
from sttm_customer c,sttm_cust_account a,sitb_contract_master m
where a.cust_ac_no=m.dr_account
and c.customer_no =  a.cust_no
and m.si_expiry_date >sysdate
and a.branch_code ='&Branch'
and a.account_class in ('282');-- Civil Servants
--and a.account_class in ('281','283','284','285');-- Non Civil Servants




-- Non Civil Servants accounts in books
SELECT ca.branch_code,ca.cust_no, cp.last_name||' '||cp.first_name Names,round((sysdate - cp.date_of_birth)/360) Age,ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance balance,ca.tod_limit TOD,ca.tod_end_date, decode(ca.ac_stat_dormant,'Y','DORMANT','ACTIVE') Dormancy,
case when ca.dormancy_date<sysdate then round((sysdate -ca.dormancy_date)/30) else 0 end "DORMANCY/MONTHS"
FROM sttm_cust_account ca,sttm_cust_personal cp
WHERE cp.customer_no = ca.cust_no 
--and ca.account_class in ('282')-- Civil Servants
and ca.account_class in ('281','283','284','285')-- Non Civil Servants
and ca.branch_code ='&Branch'
and ca.record_stat ='O';

-- Non Civil Servants with Loans
select a.branch_code,c.customer_name1, c.address_line3,a.cust_ac_no,substr(a.cust_ac_no,9,6) ,a.ac_desc,b.balance outstanding,sum(nvl(s.amount,0)) Financed,l.BOOK_DATE
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and b.component='PRINCIPAL'
and b.balance <> 0
and a.branch_code ='&Branch'
--and a.account_class in ('282')-- Civil Servants
and a.account_class in ('281','283','284','285')-- Non Civil Servants
group by a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,b.balance,l.BOOK_DATE,c.address_line3,substr(a.cust_ac_no,9,6) ;



-- Non Civil servants with SI
select a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,m.si_amt Amount, m.si_expiry_date
from sttm_customer c,sttm_cust_account a,sitb_contract_master m
where a.cust_ac_no=m.dr_account
and c.customer_no =  a.cust_no
and m.si_expiry_date >sysdate
and a.branch_code ='&Branch'
--and a.account_class in ('282');-- Civil Servants
and a.account_class in ('281','283','284','285');-- Non Civil Servants


-- Corporate accounts in books
SELECT ca.branch_code,ca.cust_no,ca.cust_ac_no,ca.ac_desc,ca.lcy_curr_balance balance,ca.tod_limit TOD,ca.tod_end_date, decode(ca.ac_stat_dormant,'Y','DORMANT','ACTIVE') Dormancy,
case when ca.dormancy_date<sysdate then round((sysdate -ca.dormancy_date)/30) else 0 end "DORMANCY/MONTHS"
FROM sttm_cust_account ca
WHERE ca.account_class like '1%' 
and ca.branch_code ='&Branch'
and ca.record_stat ='O';


-- Atm Cards
SELECT to_char(nvl(cd.checker_dt_stamp,'01/01/2015'),'YYYY') "YEAR", cd.fcc_acc_brn Business_unit,count(*) Number_of_cards
from swtm_card_details cd
WHERE cd.fcc_acc_brn ='&Branch'
group by to_char(nvl(cd.checker_dt_stamp,'01/01/2015'),'YYYY'), cd.fcc_acc_brn
order by to_char(nvl(cd.checker_dt_stamp,'01/01/2015'),'YYYY'), cd.fcc_acc_brn;


--- SMS Services
SELECT to_char(a.maker_dt_stamp,'YYYY') "YEAR",a.branch_code, count (*) "NUMBER" FROM sttm_cust_account a
WHERE a.branch_code ='&Branch'
and a.cust_ac_no in 
(select ca.cust_ac_no from sttm_cust_account ca WHERE ca.account_class ='282' and ca.cust_ac_no not in 
(SELECT acc FROM ictm_acc_udevals  WHERE prod ='SMSC' and ude_id ='SMS_AMT' and ude_value =0)
union
SELECT acc FROM ictm_acc_udevals  WHERE prod ='SMSC' and ude_id ='SMS_AMT' and ude_value <>0
)
group by to_char(a.maker_dt_stamp,'YYYY') ,a.branch_code
order by to_char(a.maker_dt_stamp,'YYYY') ,a.branch_code;


---credit all  clientele 
select substr(a.cust_ac_no,4,3),c.customer_name1,a.cust_ac_no,a.ac_desc,b.balance outstanding,sum(nvl(s.amount,0)) Financed,l.BOOK_DATE
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and b.component='PRINCIPAL'
and b.balance  > 0
and substr(s.ACCOUNT_NUMBER,4,1) in ('S')
---and SELECT.sch_start_date between '01/09/2018' and '30/09/2018'
group by a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,b.balance,l.BOOK_DATE
order by substr(a.cust_ac_no,4,3);


 

