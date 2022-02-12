select Cust_Type,Rep_line_group,Sum(Record_count) Record_Count
from
(
 select  decode(substr(t.ACCOUNT_NUMBER,4,1),1,'CORPORATE','INDIVIDUAL') Cust_Type, 
 decode (substr(t.CENTRAL_BANK_CODE,1,1),'C','DEBIT','H','CREDIT','K','CREDIT','DEBIT' ) REP_LINE_GROUP , count(*) Record_Count
 from xafnfc.vw_trial_balance t
 where length(t.ACCOUNT_NUMBER)<>9
 and substr(t.CENTRAL_BANK_CODE,1,1) in ('C','H','E','K')
 group by substr(t.ACCOUNT_NUMBER,4,1),t.CENTRAL_BANK_CODE
 having substr(t.ACCOUNT_NUMBER,4,1) in ('2','3','1')
)
group by Cust_Type,Rep_line_group;
