SELECT DISTINCT BRN branch,c.customer_name1 customer,
                acc account_no,
                sum(NVL(RTRIM(SUBSTR(NEW_VAL, 5), '~'), 0)) TOTAL_OVERDRAFT
FROM ictb_acc_action a,sttm_customer c
WHERE substr(a.acc,9,6) = c.customer_no
AND KEY_VAL LIKE '%ACCOUNT_TOD%'
and BRN = '&BRANCH'
and A.BRN_DATE between '&StartDate' and '&EndDate'
group by BRN,c.customer_name1,ACC
having sum(NVL(RTRIM(SUBSTR(NEW_VAL, 5), '~'), 0)) <>0
union
SELECT DISTINCT t.branch branch,c.customer_name1 customer,
                t.account_no account_no,
                sum(T.TOD_AMOUNT) TOTAL_OVERDRAFT
FROM STTB_CUST_TOD_HIST t,sttm_customer c
WHERE substr(t.account_no,9,6) = c.customer_no
and t.branch = '&BRANCH'
and t.appl_date between '&StartDate' and '&EndDate'
group by t.branch,c.customer_name1,t.account_no
having sum(T.TOD_AMOUNT) <>0
order by customer;
