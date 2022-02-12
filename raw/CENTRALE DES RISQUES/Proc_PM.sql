create or replace procedure Fichier_PM (P_END_DATE VARCHAR2) is
cursor PM_Cursor is
select '"'||c.customer_no||'";"'||rpad(c.full_name,100,' ')||'";"'||rpad(nvl(field_val_2,' '),20,' ')||'";"'||substr(c.loc_code,1,2)||'";"'||rpad(replace(c.unique_id_value,'/',''),15,' ')||'";"'||rpad(nvl(pr.corporate_name,' '),34,' ')||'";"'||rpad(pr.c_national_id,15,' ')||'";"'||rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' ')||'";"'||to_char(pr.incorp_date,'DD/MM/YYYY')||'";"'||rpad(c.cust_classification,5,' ')||'";"'||
rpad(nvl(pr.business_description,' '),100,' ')||'";"'||rpad(nvl(pr.r_address1,' '),30,' ')||'";"'||rpad(nvl(c.address_line2,' '),30,' ')||'";"'||rpad(nvl(c.address_line3,' '),30,' ')||'";'||null||';"'||rpad(substr(c.loc_code,1,2),5,' ')||'";"S.'||decode(substr(m.cust_mis_1,1,3),'SEC','144',substr(m.cust_mis_1,1,3))||'";"'||rpad(c.fax_number,20,' ')||'";"'||rpad(p.telephone,20,' ')||'";"'||null||'";"'||null||'";"'||
null||'";"'||decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3)||' "'
from xafnfc.sttm_customer c join xafnfc.sttm_cust_personal p on c.customer_no = p.customer_no
                     join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
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
  open PM_Cursor;
  V_YEAR := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'RR');
  V_MONTH := To_char(to_date(P_END_DATE,'DD/MM/YYYY'),'MM');
  fetch PM_Cursor into V_Line;
  V_Line_Count := 2;
  V_File_Name := V_YEAR||V_MONTH||'I049.txt';
  fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
  if PM_Cursor%Notfound then
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
