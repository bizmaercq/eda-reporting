create or replace procedure Interchange_Upload_Files (P_BATCH_NO VARCHAR2)is
cursor Intch_Cursor is
select 
P_BATCH_NO as BATCH_NO,
cd.fcc_acc_brn as BRANCH_CODE,
cd.fcc_acc_no as ACCOUNT,
decode(upper(tl.txn_desc),'RETRAIT_GAB ',400,100) as AMOUNT,
'XAF' as CCY_CD,
'D' as DR_CR,
'COM' as TXN_CODE,
to_char(tl.txn_date,'YYYYMMDD') as VALUE_DATE,
decode(upper(tl.txn_desc),'RETRAIT_GAB ','REMOTE ON US ATM WITHDRAWAL FEES ' ||to_char(tl.txn_date,'DD-MON-RRRR')||' RRN-'||tl.rrn,'REMOTE ON US ATM BALANCE INQUIRY ' ||to_char(tl.txn_date,'DD-MON-RRRR')||' RRN-'||tl.rrn) as ADDL_TEXT,
'UPLOAD' as SOURCE_CODE
from SW_INTCH_TXN_LOG tl, xafnfc.swtm_card_details cd
where substr(cd.atm_card_no,13,4) = substr(tl.card_no,13,4)
and upper(tl.txn_desc)<>'RETRAIT_GAB '
order by cd.fcc_acc_brn ;

V_CURR_NO Number;
V_BATCH_NO Varchar2(5);
V_ACCOUNT_BRANCH Varchar2(3);
V_ACCOUNT Varchar2(20);
V_AMOUNT Number;
V_CCY_CD Varchar2(3);
V_DR_CR Varchar2(1);
V_TXN_CODE Varchar2(3);
V_VALUE_DATE Date;
V_ADDL_TEXT Varchar2(100);
V_SOURCE_CODE Varchar2(10);
Max_Curr_No number;

FileHandler UTL_FILE.FILE_TYPE;
V_Branch Varchar2(3);
V_File_Name varchar2(256);
V_File_Location varchar2(256);
Fichier_Vide Exception;
V_Total_Amount Number;
V_Total_TVA number;
V_RowNum number;

begin
  V_File_Location:= 'OUTPUT';
  open Intch_Cursor;
  V_CURR_NO := 1;
  fetch Intch_Cursor into V_BATCH_NO,V_ACCOUNT_BRANCH,V_ACCOUNT,V_AMOUNT,V_CCY_CD,V_DR_CR,V_TXN_CODE,V_VALUE_DATE,V_ADDL_TEXT,V_SOURCE_CODE;
  V_Branch := V_ACCOUNT_BRANCH;
  V_Total_Amount := 0;
  V_Total_TVA := 0;
  V_File_Name := 'gimac_deupld_'||V_Branch||'.csv';
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  if Intch_Cursor%Notfound then 
     raise Fichier_Vide;
    else --write the first record of the branch
      UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||V_AMOUNT||','||V_AMOUNT||','||V_CCY_CD||',,'||V_DR_CR||','||V_TXN_CODE||',,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; -- Transaction Amount
      V_CURR_NO := V_CURR_NO +1;
      UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||ceil(V_AMOUNT*19.25/100)||','||ceil(V_AMOUNT*19.25/100)||','||V_CCY_CD||',,'||V_DR_CR||','||V_TXN_CODE||',,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; --VAT Amount
      V_Total_Amount := V_Total_Amount + V_AMOUNT;
	  V_Total_TVA := V_Total_TVA + ceil(V_AMOUNT*19.25/100);
  end if;
  
  loop
     V_CURR_NO := V_CURR_NO+1;
     fetch Intch_Cursor into V_BATCH_NO,V_ACCOUNT_BRANCH,V_ACCOUNT,V_AMOUNT,V_CCY_CD,V_DR_CR,V_TXN_CODE,V_VALUE_DATE,V_ADDL_TEXT,V_SOURCE_CODE;
     exit when Intch_Cursor%Notfound;
     if V_Branch = V_ACCOUNT_BRANCH then
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||V_AMOUNT||','||V_AMOUNT||','||V_CCY_CD||',,'||V_DR_CR||','||V_TXN_CODE||',,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; -- Transaction Amount
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||ceil(V_AMOUNT*19.25/100)||','||ceil(V_AMOUNT*19.25/100)||','||V_CCY_CD||',,'||V_DR_CR||','||V_TXN_CODE||',,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; --VAT Amount
        V_Total_Amount := V_Total_Amount + V_AMOUNT;
	    V_Total_TVA := V_Total_TVA + ceil(V_AMOUNT*19.25/100);
        else
        -- New Branch. we should cumulate the Debit of the HO DAP for MINEFI Salaries for that specific branch
         -- Writting the compensating accounting entry for MINEFI DAP account
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',381008500,'||replace(ceil(V_Total_Amount*90/100),',','.')||','||replace(ceil(V_Total_Amount*10/100),',','.')||','||V_CCY_CD||',,C,AAT,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',GIMAC COMMISSION FOR REMOTE ON US BALANCE INQUIRY,381008500,'||V_SOURCE_CODE||CHR(10)) ;
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',728340000,'||replace(ceil(V_Total_Amount*10/100),',','.')||','||replace(ceil(V_Total_Amount*10/100),',','.')||','||V_CCY_CD||',,C,COM,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',COMMISSION FOR REMOTE ON US BALANCE INQUIRY,728340000,'||V_SOURCE_CODE||CHR(10)) ;
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',434003000,'||replace(V_Total_TVA,',','.')||','||replace(V_Total_TVA,',','.')||','||V_CCY_CD||',,C,TAX,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',TAX FOR REMOTE ON US BALANCE INQUIRY,434003000,'||V_SOURCE_CODE||CHR(10)) ;
        Utl_File.Fflush(fileHandler);
        UTL_FILE.FCLOSE_ALL();
		-- New branch starts here
        V_Branch := V_ACCOUNT_BRANCH;
        V_Total_Amount := 0;
        V_Total_TVA := 0;
		V_CURR_NO := 1;
        V_File_Name := 'gimac_deupld_'||V_Branch||'.csv';
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||V_AMOUNT||','||V_AMOUNT||','||V_CCY_CD||',,'||V_DR_CR||','||V_TXN_CODE||',,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; -- Transaction Amount
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||','||V_ACCOUNT||','||ceil(V_AMOUNT*19.25/100)||','||ceil(V_AMOUNT*19.25/100)||','||V_CCY_CD||',,'||V_DR_CR||',TAX,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ','||V_ADDL_TEXT||','||V_Account||','||V_SOURCE_CODE||CHR(10)) ; --VAT Amount
        V_Total_Amount := V_Total_Amount + V_AMOUNT;
	    V_Total_TVA := V_Total_TVA + ceil(V_AMOUNT*19.25/100);
     end if ;
     Utl_File.Fflush(fileHandler);
  end loop;
  -- Counterparty for the Last Branch
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',381008500,'||replace(ceil(V_Total_Amount*90/100),',','.')||','||replace(ceil(V_Total_Amount*10/100),',','.')||','||V_CCY_CD||',,C,AAT,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',GIMAC COMMISSION FOR REMOTE ON US BALANCE INQUIRY,381008500,'||V_SOURCE_CODE||CHR(10)) ;
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',728340000,'||replace(ceil(V_Total_Amount*10/100),',','.')||','||replace(ceil(V_Total_Amount*10/100),',','.')||','||V_CCY_CD||',,C,COM,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',COMMISSION FOR REMOTE ON US BALANCE INQUIRY,728340000,'||V_SOURCE_CODE||CHR(10)) ;
        V_CURR_NO := V_CURR_NO +1;
        UTL_FILE.PUTF(fileHandler, V_CURR_NO||','||lpad(V_BATCH_NO,4,0)||','||V_ACCOUNT_BRANCH||',434003000,'||replace(V_Total_TVA,',','.')||','||replace(V_Total_TVA,',','.')||','||V_CCY_CD||',,C,TAX,,'||to_char(V_VALUE_DATE,'YYYYMMDD')||
                   ',TAX FOR REMOTE ON US BALANCE INQUIRY,434003000,'||V_SOURCE_CODE||CHR(10)) ;
  Utl_File.Fflush(fileHandler);
  UTL_FILE.FCLOSE(FileHandler);
  exception
    when Fichier_vide then dbms_output.put_line('Aucune Information à Traiter!');
end;
