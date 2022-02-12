Create or replace procedure Upload_Interchange(P_filename varchar2 ) is

FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
V_Line varchar2(256);
V_txn_date varchar2(100);
V_card_no varchar2(100);
V_terminal_id varchar2(100);
V_rrn varchar2(100);
V_txn_desc varchar2(100);
V_txn_amount varchar2(100);
V_date_upload date;
V_date_generate date;
V_generate_stat varchar2(1);
V_direction varchar2(15);
Fichier_Vide Exception;
V_Total_Amount Number;
V_key_word varchar(256);

BEGIN
 V_File_Name := P_filename;
 V_File_Location := 'INPUT';
 FileHandler := utl_file.fopen(V_File_Location,V_file_Name,'R');
 LOOP
   BEGIN
      UTL_FILE.GET_LINE(FileHandler,V_Line);
      -- Traitement de la Ligne
      V_key_word := regexp_substr(V_Line,'[^ ]+',1);-- get the first word of the line
      if (V_key_word ='Acquisition') then V_direction :='off_us' ;
      if (V_key_word ='Emission') then V_direction :='remote_on_us' ;
      if (V_key_word not in ('Acquisition','Emission','GIMAC','Total','Chargeback','NFCBANK-10025-','Emission','Emission')) then 
         begin
           V_txn_date := Substr(V_Line,1,19);
           V_card_no := Substr(V_Line,22,17);
           V_terminal_id := Substr(V_Line,74,8);
           V_rrn := Substr(V_Line,84,12); 
           V_txn_desc := Substr(V_Line,134,12); 
           V_txn_amount := Substr(V_Line,153,9); 
           V_date_upload := to_char(sysdate,'DD/MM/YYYY');
           insert into sw_intch_txn_log(direction,txn_date,card_no,terminal_id,rrn,txn_desc,txn_amount,date_upload) 
           values (V_direction,to_date(V_txn_date,'DD/MM/YYYY HH:MM:SS'),V_card_no,V_terminal_id,V_rrn,V_txn_desc,V_txn_amount,V_date_upload);     
        end; 
     EXCEPTION
      WHEN NO_DATA_FOUND THEN EXIT ;
   END;
 END LOOP;
 utl_file.fclose(FileHandler);
 commit;
END;
