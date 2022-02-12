create or replace procedure acq_fichier_pm(P_File_Name in varchar2) is

FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
V_Line varchar2(1000);
V_IBU varchar2(100);
V_CIF varchar2(100);
V_Motif varchar2(256);
V_End_Line varchar2(1);
Fichier_Vide Exception;

BEGIN
 V_File_Name := P_File_Name;
 V_File_Location := 'OUTPUT';
 FileHandler := utl_file.fopen(V_File_Location,V_file_Name,'R');
 LOOP
   BEGIN
     V_Line :='';
      UTL_FILE.GET_LINE(FileHandler,V_Line);
      V_End_Line :=Get_Cip_Status(V_Line);
      -- Traitement de la Ligne
      if Get_cip_status(V_Line)='1' then -- Validated record
         V_IBU := get_ibu(V_line);
         V_CIF := get_Cif_corp(V_Line);
         update control_cif_cip cc set cc.valid_cip ='Y', cc.ibu_cip = V_IBU where cc.customer_no =V_CIF;
       end if;
      if Get_Cip_status_corp(V_Line)='2' then -- Rejected record
         V_CIF := get_Cif_corp(V_Line);
         UTL_FILE.GET_LINE(FileHandler,V_Line); -- Reading error line
         V_Motif := Replace(V_Line,'|','-');
         update control_cif_cip cc set cc.valid_cip ='N', cc.motif_rejet = V_Motif where cc.customer_no =V_CIF;
       end if;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN EXIT ;
   END;
 END LOOP;
 commit;
 utl_file.fclose(FileHandler);

END acq_fichier_pm;