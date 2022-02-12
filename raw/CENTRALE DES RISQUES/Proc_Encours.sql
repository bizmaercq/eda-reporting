create or replace procedure Fichier_Encours (P_START_DATE VARCHAR2,P_END_DATE VARCHAR2) is
cursor Encours_Cursor is
select '"'||customer_id||'";"'||rpad(nvl(customer_name1,' '),100,' ')||'";"'||cust_mis_3||' ";'||
sum(Effet_Commerciaux_Locaux)||';'||
ltrim(replace(to_char(sum(Decouverts),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Accompagnements_Marches),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Avances_Court_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Export),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Moyen_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Credit_Long_Terme),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Impayes),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Douteux),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Agios_Reserves),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Engagement_par_signature),'99990.90'),'.',','),' ')||';'||
ltrim(replace(to_char(sum(Dont_Douteux),'99990.90'),'.',','),' ') as Ligne
from
(
 select customer_id,customer_name1,decode(cust_mis_3,'GRP999','93.0',cust_mis_3) as cust_mis_3,
 case when central_bank_code in ('C2J','C2K','C2L') then  trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Effet_Commerciaux_Locaux,
 case when central_bank_code in ('C71','C72','C75','C76','C86','C42','C43','C4J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Decouverts,
 case when central_bank_code in ('C2M','C2N') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Accompagnements_Marches,
 case when central_bank_code in ('C2C','C22','C23','C26','C27','C29','C4G','C4H','C87','C28','C78','N4D') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Avances_Court_Terme, 
 case when central_bank_code in ('C2D','C2E','C2F','C2G','C2H') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Export, 
 case when central_bank_code in ('C11','C12','C13','C14','C15','C16','C17','C18','C4D','C4E','C4F') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Moyen_Terme, 
 case when central_bank_code in ('C01','C02','C03','C04','C05','C06','C07','C08') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Credit_Long_Terme ,
 case when central_bank_code in ('C41') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Impayes, 
 case when central_bank_code in ('C42','C43','C4C','C4D','C4E','C4F','C4G','C4H','C4J','C46','C47') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Douteux, 
 case when central_bank_code in ('Q8K','Q8L') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Agios_Reserves, 
 case when central_bank_code in ('M21','M22','M23','M24','M25','M29','N43','Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Engagement_par_signature, 
 case when central_bank_code in ('Q8D','Q8E','Q8F','Q8G','Q83','Q8H','Q8J') then trunc(abs (nvl(sum(Amount),0))/1000000,2) end as Dont_Douteux 
 from xafnfc.vw_trial_balance join xafnfc.sttm_customer on customer_id = customer_no
                             join xafnfc.mitm_customer_default m on customer_no = m.customer
 where length(account_number)<> 9
 group by customer_id,customer_name1,cust_mis_3,central_bank_code
 having sum(amount) <=-10000
 union
SELECT a.cif_id customer_id,A.CUST_NAME customer_name1,M.CUST_MIS_3,
null as Effet_Commerciaux_Locaux,
null as Decouverts,
null as Accompagnements_Marches,
null as Avances_Court_Terme, 
null as Credit_Export, 
null as Credit_Moyen_Terme, 
null as Credit_Long_Terme ,
null as Impayes, 
null as Douteux, 
null as Agios_Reserves, 
trunc(abs (nvl(sum(A.CONTRACT_AMT),0))/1000000,2) as Engagement_par_signature, 
null  as Dont_Douteux 
FROM xafnfc.LCTB_CONTRACT_MASTER A,xafnfc.CSTM_PRODUCT C, xafnfc.lctb_ffts D, xafnfc.cstb_contract cs,xafnfc.mitm_customer_default m 
WHERE A.PRODUCT_CODE=C.PRODUCT_CODE and cs.contract_ref_no = A.contract_ref_no 
and m.customer = a.cif_id
AND cs.curr_event_code <> 'CLOS'
AND   C.PRODUCT_TYPE='G'
AND   A.CONTRACT_REF_NO = D.CONTRACT_REF_NO
AND   A.EVENT_SEQ_NO = (SELECT MAX(D.EVENT_SEQ_NO) FROM xafnfc.LCTB_CONTRACT_MASTER D WHERE D.CONTRACT_REF_NO=A.CONTRACT_REF_NO) and
A.EFFECTIVE_DATE between to_date(P_START_DATE,'DD/MM/YYYY') AND to_date(P_END_DATE,'DD/MM/YYYY')
group by a.cif_id,A.CUST_NAME,M.CUST_MIS_3
having sum(a.contract_amt) >=10000
)
where customer_id not in ('012918') -- excluding some specific customers
group by customer_id,customer_name1,cust_mis_3
having ( ( sum(Effet_Commerciaux_Locaux) <>0) or (sum(Decouverts) <>0) or(sum(Accompagnements_Marches) <>0) or(sum(Avances_Court_Terme) <>0) or
          (sum(Credit_Export) <>0) or(sum(Credit_Moyen_Terme) <>0) or(sum(Credit_Long_Terme) <>0) or(sum(Impayes) <>0) or
          (sum(Douteux) <>0) or(sum(Agios_Reserves) <>0) or(sum(Engagement_par_signature) <>0) or(sum(Dont_Douteux) <>0)
       ) 
order by customer_id;

V_Line  varchar2(1000);
V_Line_Count Number;
V_YEAR  varchar2(2);
V_MONTH varchar2(2);
FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
Fichier_Vide Exception;

begin
  V_File_Location:= 'OUTPUT';
  open Encours_Cursor;
  V_YEAR := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'RR');
  V_MONTH := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'MM');
  fetch Encours_Cursor into V_Line;
  V_Line_Count := 2;
  V_File_Name := V_YEAR||V_MONTH||'S049.txt;'||P_START_DATE||CHR(10);
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  if Encours_Cursor%Notfound then
     raise Fichier_Vide;
    else --write the first record of the branch
      UTL_FILE.PUTF(fileHandler, '"049"'||CHR(10)) ;
      UTL_FILE.PUTF(fileHandler, V_Line||CHR(10)) ;
	    V_Line_Count := V_Line_Count +1;
  end if;

  loop
     fetch Encours_Cursor into V_Line;
     exit when Encours_Cursor%Notfound;
     UTL_FILE.PUTF(fileHandler,V_Line||CHR(10)) ;
	   V_Line_Count := V_Line_Count +1;
     Utl_File.Fflush(fileHandler);
  end loop;
  
  UTL_FILE.PUTF(fileHandler, to_char(V_Line_Count)||CHR(10)) ;
  Utl_File.Fflush(fileHandler);
  UTL_FILE.FCLOSE(FileHandler);
  exception
    when Fichier_vide then dbms_output.put_line('Aucune Information à Traiter!');
end;
