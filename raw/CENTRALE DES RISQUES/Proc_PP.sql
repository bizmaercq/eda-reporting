create or replace procedure Fichier_PP (P_END_DATE VARCHAR2) is
cursor PP_Cursor is
select '"'||c.customer_no||'";"'||rpad(p.customer_prefix,4,' ')||'";"'||rpad(p.customer_prefix1,5,' ')||'";"'||rpad(nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)),30,' ')||'";"'||rpad(nvl(p.first_name,' '),30,' ')||'";'||to_char(date_of_birth,'DD/MM/YYYY')||';"'||rpad(nvl(c.udf_2,' '),50,' ')||'";"'||rpad(nvl(c.udf_3,' '),30,' ')||'";'||'"S.'||substr(decode(m.cust_mis_1,'SEC999','14400',m.cust_mis_1),1,3)||'";"'||rpad(iso3_code,3,' ')||'";"'||rpad(nvl(c.udf_4,' '),50,' ')||'";"'||rpad(c.cust_classification,3,' ')||'";"'||rpad(nvl(c.address_line1,' '),30,' ')||'";"'||rpad(nvl(c.address_line2,' '),30,' ')||'";"'||rpad(nvl(c.address_line3,' '),30,' ')||'";;"'||rpad(substr(c.loc_code,1,2),2,' ')||'   ";"'||field_val_1||'"' as Ligne
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_professional pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
                     join xafnfc.sttm_country_isocodes i on i.iso2_code = c.country
where c.customer_type ='I'
and trunc(c.checker_dt_stamp) >= to_date(P_END_DATE,'DD/MM/YYYY') -30 ;


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
  open PP_Cursor;
  V_YEAR := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'RR');
  V_MONTH := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'MM');
  fetch PP_Cursor into V_Line;
  V_Line_Count := 2;
  V_File_Name := V_YEAR||V_MONTH||'I049.txt';
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  if PP_Cursor%Notfound then
     raise Fichier_Vide;
    else --write the first record of the branch
      UTL_FILE.PUTF(fileHandler, '"049"'||CHR(10)) ;
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
