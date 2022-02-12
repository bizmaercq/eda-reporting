CREATE OR REPLACE FORCE VIEW "NFCSUP"."SWVW_CUSTFILE" ("OPERATION", "CUST_ID", "CUSTOMER_CATEGORY", "FILLER", "CUSTOMER_TITLE", "CUST_FIRST_NAME", "CUST_MIDDLE_NAME", "CUST_LAST_NAME", "CUST_IDENTITY_NUMBER", "CUST_IDENTITY_TYPE", "CUST_GENDER", "CUST_MERITAL_STATUS", "CUST_NATIONALITY", "CUST_EMPLOYER_IDENTIFIER", "CUST_EMPLOYER_NAME", "CUST_POSITION", "CUST_GROSS_SALARY", "CUST_EMPLOYMENT_DATE", "CO_CUST_TITLE", "CO_CUST_FIRST_NAME", "CO_CUST_MIDDLE_NAME", "CO_CUST_LAST_NAME", "CO_CUST_IDENTITY_NUMBER", "CO_CUST_IDENTITY_TYPE", "CO_CUST_GENDER", "CO_CUST_MERITAL_STATUS", "CO_CUST_NATIONALITY", "CO_CUST_EMPLOYER_ID", "CO_CUST_EMPLOYER_NAME", "CO_CUST_POSITION", "CO_CUST_GROSS_SALARY", "CO_CUST_EMPLOYMENT_DATE", "COMPANY_NAME", "ENSEIGNE_NAME", "COMPANY_TYPE", "COMPANY_ID_NUMBER_1", "COMPANY_ID_NUMBER_2", "COMPANY_ID_NUMBER_3", "COMPANY_ID_NUMBER_4", "COMPANY_ID_NUMBER_5", "CAPITAL_COMPANY", "CUST_FIRST_CREATION_DATE", "CUST_DEBIT_FLAG", "CUST_CREDIT_FLAG", "CUST_CHARGE_FLAG", "CUST_PREPAID_FLAG", "CUST_STATUS", "CUST_PROMOTER_CODE", "CUST_PRODUCT_CODE", "CUST_BRANCH_CODE", "P_ADDRESS_CONTACT_FIRST_NAME", "P_ADDRESS_CONTACT_MIDDLE_NAME", "P_ADDRESS_CONTACT_LAST_NAME", "PERSONAL_ADDRESS", "PERSONAL_CITY_CODE", "PERSONAL_ZIP_CODE", "PERSONAL_COUNTRY_CODE", "PERSONAL_DEPARTEMENT_CODE", "PERSONAL_FIRST_PHONE", "PERSONAL_SECOND_PHONE", "PERSONAL_EMAIL", "PROFESIONAL_COMPANY_NAME", "FILLER1", "PROFESIONAL_ADDRESS", "PROFESIONAL_CITY_CODE", "PROFESIONAL_ZIP_CODE", "PROFESIONAL_COUNTRY_CODE", "PROFESIONAL_DEPARTEMENT_CODE", "PROFESIONAL_FIRST_PHONE", "PROFESIONAL_SECOND_PHONE", "PROFESIONAL_EMAIL") AS 
  Select 'M' As Operation
      ,Lpad(a.Customer_No, 24) As Cust_Id
      ,Decode(a.Customer_Type, 'I', 'N', 'Y') As Customer_Category
      ,Lpad(' ', 20, ' ') As Filler
      ,Lpad(nvl(b.Customer_Prefix,' '), 10, ' ') As Customer_Title
      ,Lpad(Decode(a.customer_type , 'I' , b.First_Name , a.short_name), 40) As Cust_First_Name -- Logic Changed For Cust First name
      ,Lpad(Decode(a.customer_type , 'I' , b.Middle_Name , a.short_name), 40) As Cust_Middle_Name -- Logic Changed For Cust First name
      ,Lpad(Decode(a.customer_type , 'I' , b.Last_Name , a.short_name), 40) As Cust_Last_Name -- Logic Changed For Cust First name
      ,Lpad(nvl(a.Unique_Id_Value,' '), 20) As Cust_Identity_Number
      ,Lpad(nvl(a.Unique_Id_Name,' '), 20) As Cust_Identity_Type
      ,Lpad(b.Sex, 1) As Cust_Gender
      ,Lpad(' ', 20) As Cust_Merital_Status
      ,Lpad((Select Iso_Num_Country_Code
            From   Sttm_Country Stc
            Where  Stc.Country_Code = a.Nationality)
           ,10) As Cust_Nationality
      ,Lpad(' ', 20) As Cust_Employer_Identifier
      ,Lpad(' ', 60) As Cust_Employer_Name
      ,Lpad(' ', 2) As Cust_Position
      ,Lpad('0', 15,' ') As Cust_Gross_Salary
      ,Lpad(' ', 14) As Cust_Employment_Date
      ,Lpad(' ', 10) As Co_Cust_Title
      ,Lpad(' ', 40) As Co_Cust_First_Name
      ,Lpad(' ', 40) As Co_Cust_Middle_Name
      ,Lpad(' ', 40) As Co_Cust_Last_Name
      ,Lpad(' ', 20) As Co_Cust_Identity_Number
      ,Lpad(' ', 20) As Co_Cust_Identity_Type
      ,Lpad(' ', 1) As Co_Cust_Gender
      ,Lpad(' ', 2) As Co_Cust_Merital_Status
      ,Lpad(' ', 10) As Co_Cust_Nationality
      ,Lpad(' ', 20) As Co_Cust_Employer_Id
      ,Lpad(' ', 60) As Co_Cust_Employer_Name
      ,Lpad(' ', 2) As Co_Cust_Position
      ,Lpad('0', 15,' ') As Co_Cust_Gross_Salary
      ,Lpad(' ', 14) As Co_Cust_Employment_Date
      ,Lpad(' ', 25) As Company_Name
      ,Lpad(' ', 20) As Enseigne_Name
      ,Lpad(' ', 2) As Company_Type
      ,Lpad(' ', 20) As Company_Id_Number_1
      ,Lpad(' ', 20) As Company_Id_Number_2
      ,Lpad(' ', 20) As Company_Id_Number_3
      ,Lpad(' ', 20) As Company_Id_Number_4
      ,Lpad(' ', 20) As Company_Id_Number_5
      ,Lpad('0', 15,' ') As Capital_Company
      ,rpad(to_char(a.Maker_Dt_Stamp,'DD/MM/YYYY'),14,' ') As Cust_First_Creation_Date
      ,Lpad('Y', 1) As Cust_Debit_Flag
      ,Lpad('Y', 1) As Cust_Credit_Flag
      ,Lpad(' ', 1) As Cust_Charge_Flag
      ,Lpad(' ', 1) As Cust_Prepaid_Flag
      ,Lpad(1, 1) As Cust_Status
      ,rpad('PRO_001', 20) As Cust_Promoter_Code --As per Paylogic suggestion over chat
      ,Lpad('NFC_001', 10) As Cust_Product_Code --As per Paylogic suggestion over chat
      ,rpad(a.Local_Branch, 20) As Cust_Branch_Code --As per Paylogic suggestion added RPAD over chat
      ,Lpad(b.First_Name, 20) As p_Address_Contact_First_Name
      ,Lpad(b.Middle_Name, 26) As p_Address_Contact_Middle_Name
      ,Lpad(b.Last_Name, 26) As p_Address_Contact_Last_Name
      ,Rpad(b.d_Address1 || ',' || b.d_Address2 || ',' || b.d_Address3, 200) As Personal_Address
      ,Lpad(nvl(b.d_Address3,' '), 20) As Personal_City_Code
      ,Lpad(' ', 20) As Personal_Zip_Code
      ,Lpad((Select Iso_Num_Country_Code
            From   Sttm_Country Cnty
            Where  Cnty.Country_Code = a.Country)
           ,20) As Personal_Country_Code
      ,Lpad(' ', 30) As Personal_Departement_Code
      ,Lpad(nvl(b.Mobile_Number,'0'), 20) As Personal_First_Phone
      ,Lpad(nvl(b.Telephone,'0'), 20) As Personal_Second_Phone
      ,Lpad(nvl(b.e_Mail,' '), 40) As Personal_Email
      ,Lpad(nvl(c.Employer,' '), 60) As Profesional_Company_Name
      ,Lpad(' ', 40) As Filler1
      ,Lpad(nvl(c.e_Address1,' '), 200) As Profesional_Address
      ,Lpad(nvl(c.e_Address2,' '), 100) As Profesional_City_Code
      ,Lpad(' ', 20) As Profesional_Zip_Code
      ,Lpad(nvl(c.e_Country,' '), 20) As Profesional_Country_Code
      ,Lpad(' ', 30) As Profesional_Departement_Code
      ,Lpad(nvl(c.e_Telephone,'0'), 20) As Profesional_First_Phone
      ,Lpad(' ', 20) As Profesional_Second_Phone
      ,Lpad(nvl(c.e_Email,' '), 40) As Profesional_Email
From   Sttm_Customer          a
      ,Sttm_Cust_Personal     b
      ,Sttm_Cust_Professional c
Where  a.Customer_No = b.Customer_No(+)
And    b.Customer_No = c.Customer_No(+)
And    Customer_Type <> 'B'
and		a.customer_No in (
SELECT distinct substr(a1.key_id,16,6) FROM sttb_record_log a1 WHERE  a1.FUNCTION_ID='STDCIF'
Union
Select Cust_No From Cust_temp)
And    a.Record_Stat = 'O'
And    a.Auth_Stat = 'A'
And    a.Once_Auth = 'Y'
;
