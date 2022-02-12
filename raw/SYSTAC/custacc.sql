create or replace procedure Custacc (P_END_DATE VARCHAR2) is
cursor Cust_Acc_Cursor is
SELECT c.customer_no,P.LAST_NAME,p.first_name,c.customer_name1,'Particulier','"1002500'||a.cust_ac_no 
from xafnfc.sttm_cust_account a,xafnfc.sttm_customer c, xafnfc.sttm_cust_personal p
WHERE a.cust_no = c.customer_no
and p.customer_no = c.customer_no
and c.customer_no = '014314'
union
SELECT c.customer_no,d.director_name,c.full_name,'Entreprise','"1002500'||a.cust_ac_no
from xafnfc.sttm_cust_account a,xafnfc.sttm_customer c, xafnfc.sttm_corp_directors d
WHERE a.cust_no = c.customer_no
and d.customer_no = c.customer_no
and c.customer_no = '046434';


V_Line_Count Number;
FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
V_code varchar2(10);
V_nom varchar2(100);
V_prenom varchar2(100);
V_Raison_sociale varchar2(100);
V_Type varchar2(20);
V_RIB varchar2(100);
V_Curr_Customer varchar2(10);

Fichier_Vide Exception;

begin
  V_File_Location:= 'OUTPUT';
  V_File_Name := 'Cust_acc_export.txt';
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  open Cust_Acc_Cursor;
  fetch Cust_Acc_Cursor into V_code ,V_nom ,V_prenom ,V_Raison_sociale,V_Type,V_RIB;
  if Cust_Acc_Cursor%Notfound then
     raise Fichier_Vide;
    else --write the first record of the branch
    loop
       UTL_FILE.PUTF(fileHandler, '"'||V_code||'","'||V_nom||'","'||V_prenom||'","'||V_Raison_sociale||'","'||V_Type||"||'",'||V_RIB||'"'||CHR(10)) ;  -- Ecriture de la première ligne du client
	   V_Curr_Customer := V_Code;
       loop
          fetch Cust_Acc_Cursor into V_code ,V_nom ,V_prenom ,V_Raison_sociale,V_Type,V_RIB ;
          exit when PV_code <>V_code;
          UTL_FILE.PUTF(fileHandler, '"","","","","",'||V_RIB||'"'||CHR(10)) ;  -- Ecriture des autres lignes du client
          Utl_File.Fflush(fileHandler);
	   end loop; 	
    end loop;
  end if;
  Utl_File.Fflush(fileHandler);
  UTL_FILE.FCLOSE(FileHandler);
  exception
    when Fichier_vide then dbms_output.put_line('Aucune Information à Traiter!');
end;