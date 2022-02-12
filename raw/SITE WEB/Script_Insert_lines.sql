declare

cursor Curr_Mouvement (P_ACCOUNT) is
select TRN_DATE,VALUE_DATE,ACCOUNT,TRN_REF_NO,DESCRIPTION,DEBIT,CREDIT,BALANCE,SERIAL 
from web_actb_transaction_log  
where account = P_ACCOUNT 
and CALC = 'N' 
order by serial;

cursor Curr_Account is 
select distinct ACCOUNT 
from web_actb_transaction_log  
where CALC = 'N' 
order by serial;


V_Solde number;


begin
    for C1 in curr_Account loop
    select BALANCE from web_actb_transaction_log  into V_Solde where serial = (select max(serial) from web_actb_transaction_log where account =c1.ACCOUNT and calc ='Y')
       for c2 in curr_Mouvement (C1.account) loop
	      update   web_actb_transaction_log set BALANCE=V_Solde+C2.CREDIT-C2.DEBIT,CALC='Y' where serial = C2.SERIAL;
		  V_Solde := V_Solde+C2.CREDIT-C2.DEBIT;
        end loop;
    end loop;
commit;
	
exception
  when others then null;
end;
/


