create or replace procedure Fichier_PP_CIP  is
cursor PP_Cursor is
SELECT '2'||'|'|| c.customer_no ||'|'|| 
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)) ||'|'|| 
nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)) ||'|'|| 
p.first_name||'|'|| 
p.sex ||'|'|| 
p.date_of_birth ||'|'|| 
null ||'|'|| 
null ||'|'|| 
null ||'|'|| 
null ||'|'|| 
c.udf_2 ||'|'|| 
c.country ||'|'|| 
c.country ||'|'|| 
c.udf_4 ||'|'|| 
decode(m.cust_mis_3,'GRP999','93',substr(m.cust_mis_3,1,2) )  ||'|'|| 
case when (c.frozen ='N' and c.deceased ='N') then '00'
  else
     case when c.frozen ='Y' then '02' else '01' end 
end  ||'|'|| 
null ||'|'|| 
null ||'|'|| 
null ||'|'|| 
null ||'|'|| 
null Comntr as Ligne
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='I'
and c.record_stat ='O';


V_Line  varchar2(1000);
V_Line_Count Number;
FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
Fichier_Vide Exception;

begin
  V_File_Location:= 'OUTPUT';
  open PP_Cursor;
  fetch PP_Cursor into V_Line;
  V_Line_Count := 2;
  V_File_Name := 'CM10025'||to_char(sysdate,'DDMMYYYY')||to_char(sysdate,'HHMISS')||'001.DEC';
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  if PP_Cursor%Notfound then
     raise Fichier_Vide;
    else --write the header line for the file
      UTL_FILE.PUTF(fileHandler, '1|1|CM|10025|01|'||to_char(sysdate,'DDMMYYYY')||'|'||CHR(10)) ;
      UTL_FILE.PUTF(fileHandler, V_Line||CHR(10)) ;
	    V_Line_Count := V_Line_Count +1;
  end if;

  loop
     fetch PP_Cursor into V_Line;
     exit when PP_Cursor%Notfound;
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
