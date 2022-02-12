CREATE OR REPLACE FORCE VIEW "NFCSUP"."SWVW_CUSTACCOUNT" ("OPERATION", "CUST_AC_NO", "CUST_AC_NO_BANK", "CURRENCY", "ACCOUNT_TYPE", "PROD_CODE", "CREATION_DATE", "EFFECTIVE_DATE", "CLOSING_DATE", "ACCT_STATUS", "ACCT_STAT_MOD_DT", "AGENCY_ACNT_CODE", "BANK_CODE", "ACCNT_TYPE", "CUST_NO") AS 
  Select 'M' As Operation
      ,Lpad(a.Cust_Ac_No, 24) As Cust_Ac_No
      ,Lpad(a.Cust_Ac_No, 24) As Cust_Ac_No_Bank
      ,Lpad((Select Cytm.Iso_Num_Ccy_Code
            From   Cytm_Ccy_Defn Cytm
            Where  Cytm.Ccy_Code = a.Ccy)
           ,3) As Currency
      ,'1' As Account_Type
      ,'0000000000' As Prod_Code
      ,Rpad(To_Char(a.Maker_Dt_Stamp, 'DD/MM/YYYY'), 14, ' ') As Creation_Date
      ,Rpad(To_Char(a.Ac_Open_Date, 'DD/MM/YYYY'), 14, ' ') As Effective_Date
      ,Rpad(' ', 14, ' ') As Closing_Date
      ,Decode(a.Acc_Status, 'NORM', 1, 2) As Acct_Status
      ,Lpad(To_Char(a.Status_Since, 'DD/MM/YYYY'), 14) As Acct_Stat_Mod_Dt
      ,Lpad(a.branch_code, 10) As Agency_Acnt_Code
      ,Lpad((Select Bank_Code
            From   Sttm_Bank)
           ,16) As Bank_Code
      ,Decode(a.Account_Type, 'S', 'S', 'U', 'C') As Accnt_Type
      ,Lpad(a.Cust_No, 24) As Cust_No
From   Sttm_Cust_Account a,sttm_customer b
Where  a.cust_no =b.customer_no
and    b.Customer_Type <> 'B'
and	   a.cust_ac_no in (
SELECT distinct substr(a1.key_id,24,16) FROM sttb_record_log a1 WHERE a1.function_id='STDCUSAC'
Union
Select Cust_ac_no from Custacc_Temp_09Oct2015)
and    a.Record_Stat = 'O'
And    a.Auth_Stat = 'A'
And    a.Once_Auth = 'Y'
;
