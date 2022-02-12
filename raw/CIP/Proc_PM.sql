create or replace procedure Fichier_PM_CIP  is
cursor PM_Cursor is
select c.customer_no  as IdinterneClt,
c.full_name as  RAISONSOCIALE,
to_char(pr.incorp_date,'DD/MM/YYYY') as  DATECREAT,
field_val_7 sigle,
(select country from xafnfc.sttm_country_isocodes i where c.country = i.iso2_code ) as  PaysSiegeSocial,
decode(substr(c.loc_code,1,2),'10','YAOUNDE','11','DOUALA','12','GAROUA','13','LIMBE','14','NKONGSAMBA','15','BAFOUSSAM','17','NGAOUNDERE','18','BAMENDA','AUTRES VILLES DU CAMEROUN' )  as VILLEsiegeSOCIAL,
c.unique_id_value as  RegCommerce,
pr.c_national_id  as CarteContribuable,
decode(m.cust_mis_2,'FOR999','SA',m.cust_mis_2)  as FORMEJURIDIQUE,
(select code_desc from xafnfc.gltm_mis_code where mis_class ='GRPACT' and mis_code = decode(m.cust_mis_3,'GRP999','90.3',m.cust_mis_3) ) as  ActEcon,
'0' as V_SitJudiciaire,
null as V_DateDebIJ ,
null as V_DateFinIJ ,
to_char(sysdate,'DDMMYYYY') as V_DatEvent, 
null as V_Comntr 


from xafnfc.sttm_customer c join xafnfc.mitm_customer_default m on c.customer_no = m.customer
                     left join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
                     join xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud on c.customer_no = substr(ud.rec_key,1,6)
where c.customer_type ='C'
and c.record_stat ='O';

cursor PM_MDT_Cursor(P_Id) is
select 
cc.ibu_cip IBUMdt,
cc.customer_no IdInterneMdt,
'A' TypeModif,
null as Qualite,
decode (p.sex,'F', nvl(c.udf_3,nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1))),nvl(p.last_name,regexp_substr(full_name,'[^ ]+',1)) ) as NomNai,
nvl(p.first_name,'ND') as Prenom,
to_char(p.date_of_birth,'DDMMYYYY') as DatNai
from control_cif_cip cc,xafnfc.CSTM_FUNCTION_USERDEF_FIELDS ud,xafnfc.sttm_cust_personal p,xafnfc.sttm_customer c
WHERE cc.customer_no =  substr(ud.rec_key,1,6)
and cc.customer_no = p.customer_no
and cc.customer_no = c.customer_no
and ud.field_val_8 = P_Id
and cc.ibu_cip is not null;

V_IBUClt varchar2(20);
V_IdInterneClt varchar2(20);
V_RaisonSociale varchar2(256);
V_DatCreat varchar2(8);
V_Sigle varchar2(256);
V_PaysSiegeSocial varchar2(20);
V_VilleSiegeSocial varchar2(50);
V_RegCommerce varchar2(20);
V_CarteContribuable varchar2(20);
V_FormeJuridique varchar2(20);
V_ActEcon varchar2(100);
V_SitJudiciaire varchar2(20);
V_DateDebIJ varchar2(8);
V_DateFinIJ varchar2(8);
V_DatEvent varchar2(8);
V_Comntr varchar2(20);

V_IBUMdt varchar2(20);
V_IdInterneMdt varchar2(20);
V_TypeModif varchar2(1);
V_Qualite varchar2(2);
V_NomNai varchar2(100);
V_Prenom varchar2(100);
V_DatNai varchar2(8);


V_Line  varchar2(2000);
V_Line_Count Number;
FileHandler UTL_FILE.FILE_TYPE;
V_File_Name varchar2(256);
V_File_Location varchar2(256);
V_File_Sequence varchar2(10);
Fichier_Vide Exception;

begin
  V_File_Location:= 'OUTPUT';
  select to_char(cip_pmfile_seq.nextval) into V_File_Sequence from dual; 
  open PM_Cursor;
  loop  
     fetch PM_Cursor into V_IDINTERNECLT,V_RaisonSociale,V_DatCreat,V_Sigle,V_PaysSiegeSocial,V_VilleSiegeSocial,V_RegCommerce,V_CarteContribuable,V_FormeJuridique,V_ActEcon,V_SitJudiciaire,V_DateDebIJ,V_DateFinIJ,V_DatEvent,V_Comntr;
     exit when PM_Cursor%notfound
     V_Line_Count := 0;
     V_File_Name := 'CM-10025-'||to_char(sysdate,'DDMMYYYY')||'-'||substr(to_char(systimestamp,'HHMISSFF'),1,9)||'-02.DEC';
     fileHandler := UTL_FILE.FOPEN(V_File_Location, V_File_Name, 'w',32767);
     UTL_FILE.PUTF(fileHandler, '1|'||lpad(V_file_Sequence,10,'0')||'|CM|10025|02|'||to_char(sysdate,'DDMMYYYY')||'|'||CHR(10)) ;
     V_Line :='2|04||'||V_IDINTERNECLT||'|'||V_RaisonSociale||'|'||V_DatCreat||'|'||V_Sigle||'|'||V_PaysSiegeSocial||'|'||V_VilleSiegeSocial||'|'||V_RegCommerce||'|'||V_CarteContribuable||'|'||V_FormeJuridique||'|'||V_ActEcon||'|'||V_SitJudiciaire||'|'||V_DateDebIJ||'|'||V_DateFinIJ||'|'||V_DatEvent||'|'||V_Comntr;
     UTL_FILE.PUTF(fileHandler, V_Line||CHR(10)) ;
     Utl_File.Fflush(fileHandler);
	  -- Getting the mandators
	 open PM_MDT_Cursor(V_IDINTERNECLT);
		 loop
		    fetch PM_MDT_Cursor into V_IBUMdt,V_IdInterneMdt,V_TypeModif,V_Qualite,V_NomNai,V_Prenom,V_DatNai;
		    exit when  PM_MDT_Cursor%notfound;
		    V_Line := '3|'||V_IBUMdt||'|'||V_IdInterneMdt||'|'||V_TypeModif||'|'||V_Qualite||'|'||V_NomNai||'|'||V_FINVALPIECE||'|'||V_DatNai; 
            UTL_FILE.PUTF(fileHandler, V_Line||CHR(10)) ;
			UTL_FILE.PUTF(fileHandler, V_Line||CHR(10))
		 end loop; 
     update control_cif_cip cc set cc.declare_cip ='Y' WHERE cc.customer_no =V_IDINTERNECLT; 
     V_Line_Count := V_Line_Count +1;
     Utl_File.Fflush(fileHandler);
 end loop;
-- writing footer
 UTL_FILE.PUTF(fileHandler, '4|'||lpad(V_file_Sequence,10,'0')||'|'||lpad(to_char(V_Line_Count),5,'0')||CHR(10)) ;
 Utl_File.Fflush(fileHandler);
 UTL_FILE.FCLOSE(FileHandler);
 commit;
 exception
   when Fichier_vide then dbms_output.put_line('Aucune Information à Traiter!');
end;