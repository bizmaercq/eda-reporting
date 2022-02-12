accept FINANCIAL_CYCLE PROMPT 'Enter the Current FINANCIAL_CYCLE >'
accept REPORT_PERIOD_CODE  PROMPT 'Enter the Current REPORT_PERIOD_CODE >'
accept REPORT_PERIOD_END_DT  PROMPT 'Enter the Current REPORT_PERIOD_END_DT (Ex: 31-07-2012 for sup schmea 31-MAY-2014 fr live) >'
set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on
set time on timing on;
Declare
    Cursor C1 Is
        Select Ac_No
              ,Ac_Desc
              ,Gl_Code1
              ,Gl_Code2
              ,Gl_Int
              ,Cbf
              ,Residence
              ,Institutional_Unit
              ,Geographical_Location
              ,Economic_Activity
              ,Drcr_Ind
              ,Debit
              ,Credit
              ,Placement_Date
              ,Maturity_Date
              ,Cif_No
              ,Branch
              ,Ac_Ccy
              ,Rate
              ,Amount
              ,Cb_Specific_Client
              ,Line
              ,Ac_Or_Gl
              ,Category
              ,Loc_Code
              ,Customer_Cat
              ,Module
              ,Financial_Cycle
              ,Periodic_Code
              ,Gl_Closing_Balance
              ,Gl_Opening_Balance
              ,Ib
              ,Trn_Dt
              ,Book_Date
        From   (Select Ac_No
                      ,Ac_Desc
                      ,Substr(Gl_Code2, 1, 5) Gl_Code1
                      ,Gl_Code2
                      ,Case
                           When Substr(Gl_Code2, 1, 2) In
                               
                                ('68', '66', '25') Then
                            Substr(Gl_Code2, 1, 2)
                           When Substr(Gl_Code2, 1, 2) In ('20'
                                                          ,'19'
                                                          ,'28'
                                                          ,'69'
                                                          ,
                                                           
                                                           '93'
                                                          ,'98'
                                                          ,'99') Then
                            Substr(Gl_Code2, 1, 4)
                           When Substr(Gl_Code2, 1, 3) In
                                ('321', '344', '345', '471', '472', '611', '623', '644', '651', '791') Then
                            Substr(Gl_Code2, 1, 4)
                           Else
                            Substr(Gl_Code2, 1, 3)
                       End Gl_Int
                      ,Case
                           When Amount < 0 Then
                            (Select Distinct Sd.Cbank_Line_Dr
                             From   Gltm_Glmaster Sd
                             Where  Sd.Gl_Code = Gl_Code2)
                           Else
                            (Select Distinct Sd.Cbank_Line_Cr
                             From   Gltm_Glmaster Sd
                             Where  Sd.Gl_Code = Gl_Code2)
                       End Cbf
                      ,Residence
                      ,Case
                           When Amount < 0 Then
                            'D'
                           Else
                            'C'
                       End Drcr_Ind
                      ,Institutional_Unit
                      ,Geographical_Location
                      ,Economic_Activity
                      ,Placement_Date
                      ,Maturity_Date
                      ,'' Line
                      ,'' Gl_Opening_Balance
                      ,'' Gl_Closing_Balance
                      ,'' Debit
                      ,'' Credit
                      ,Cif_No
                      ,Loc_Code
                      ,Branch
                      ,Ac_Ccy
                      ,Rate
                      ,Amount
                      ,Cb_Specific_Client
                      ,Ac_Or_Gl
                      ,(Select Category
                        From   Gltm_Glmaster
                        Where  Gl_Code = Gl_Code2) Category
                      ,Customer_Cat
                      ,Module
                      ,'' Financial_Cycle
                      ,'' Periodic_Code
                      ,Ib
                      ,'' Trn_Dt
                      ,'' Book_Date
                From   (Select Ac_No
                              ,Ac_Desc
                              ,Residence
                              ,Economic_Activity
                              ,Placement_Date
                              ,Maturity_Date
                              ,Decode(Ac_Or_Gl
                                     ,'A'
                                     ,Decode
                                      
                                      (Substr(Amount, 1, 1)
                                     ,'-'
                                     ,(Select Sc.Dr_Gl
                                       From   Sttm_Cust_Account Sc
                                       Where  Sc.Cust_Ac_No = Ac_No)
                                     ,(Select Sc.Cr_Gl
                                       From   Sttm_Cust_Account Sc
                                       Where  Sc.Cust_Ac_No = Ac_No))
                                     ,Ac_No) Gl_Code2
                              ,Cb_Specific_Client
                              ,Cif_No
                              ,Branch
                              ,Ac_Ccy
                              ,Rate
                              ,Amount
                              ,Institutional_Unit
                              ,Geographical_Location
                              ,Ac_Or_Gl
                              ,Category
                              ,Loc_Code
                              ,Customer_Cat
                              ,Module
                              ,Ib
                        From   (Select b.Ac_Gl_No   Ac_No
                                      ,b.Ac_Gl_Desc Ac_Desc
                                      ,
                                       --DRCR_IND,
                                       Decode(Ac_Or_Gl
                                             ,'A'
                                             ,Decode((Select Distinct Resident_Status
                                                     From   Sttm_Cust_Personal
                                                     Where  Customer_No = b.Cust_No)
                                                    ,'N'
                                                    ,'0'
                                                    ,'R'
                                                    ,'1'
                                                    ,Decode((Select r_Country
                                                            From   Sttm_Cust_Corporate
                                                            Where  Customer_No = b.Cust_No)
                                                           ,'CM'
                                                           ,1
                                                           ,0))
                                             ,'G'
                                             ,Null) Residence
                                      ,(SELECT amap.institutional_unit FROM trial_bal_map amap WHERE amap.account_class=b.Ac_Class) Institutional_Unit
                                      ,((Select Case
                                                    When Local_Branch In ('010', '020', '021', '022', '023', '024') Then
                                                     '102'
                                                    When Local_Branch In ('030', '031', '032') Then
                                                     '107'
                                                    When Local_Branch In ('040', '041', '042', 043) Then
                                                     '110'
                                                    When Local_Branch In ('050', '051') Then
                                                     '105'
                                                    Else
                                                     ' '
                                                End Case
                                         From   Sttm_Customer Ss
                                         Where  Ss.Customer_No = b.Cust_No)) Geographical_Location
                                      ,(Select Decode(Substr(Cust_Mis_3, 1, 1)
                                             ,'G'
                                             ,'9'
											 ,'0'
											 ,'9'
                                             ,Substr
                                              (Cust_Mis_3, 1, 1))
                                From   Mitm_Customer_Default
                                Where  Customer = b.Cust_No) Economic_Activity
                                      ,(Select Date_of_Open
                                        From   Tdvw_Td_Details Where                                         
                                         Account_No = Ac_Gl_No)    Placement_Date
                                      ,(Select
                                         Td_Maturity_Date
                                        From   Tdvw_Td_Details
                                        Where 
                                         Account_No = Ac_Gl_No) Maturity_Date
                                      ,(SELECT amap.cb_specific_clients FROM trial_bal_map amap WHERE amap.account_class=b.ac_class) Cb_Specific_Client
                                      ,b.Cust_No Cif_No
                                      ,Branch_Code Branch
                                      ,Ac_Gl_Ccy Ac_Ccy
                                      ,'' Rate
                                      ,(Select (Sum(Nvl(a.Cr_Bal_Lcy, 0)) - Sum(Nvl(a.Dr_Bal_Lcy, 0)))
                                        From   Gltb_Cust_Acc_Breakup a
                                        Where  Cust_Ac_No = b.Ac_Gl_No
                                        And    a.Fin_Year = '&FINANCIAL_CYCLE'
                                        And    a.Period_Code = '&REPORT_PERIOD_CODE') Amount
                                      ,Ac_Or_Gl
                                      ,'' Category
                                      ,(Select Loc_Code
                                        From   Sttm_Customer
                                        Where 
                                         Customer_No = b.Cust_No) Loc_Code
                                      ,b.Customer_Cat
                                      ,'' Module
                                      ,'' Ib
                                From   Sttb_Account b
                                Where  Ac_Or_Gl = 'A')));
    Type Ty_Trial_Balance Is Table Of C1%Rowtype;
    l_Trial_Balance Ty_Trial_Balance;
    Dml_Errors Exception;
    Pragma Exception_Init(Dml_Errors, -24381);
Begin
    Global.Pr_Init('010', 'SUPPORT3');
    Debug.Pr_Debug('**', 'ajay');
    Open C1;
    Loop
        Fetch C1 Bulk Collect
            Into l_Trial_Balance Limit 1000;
        Forall x In 1 .. l_Trial_Balance.Count Save Exceptions
            Insert Into Trial_Balance
                (Account_Number
                ,Description
                ,Glcode1
                ,Glcode2
                ,Gl_Interface
                ,Central_Bank_Code
                ,Residence
                ,Institutional_Unit
                ,Geographical_Location
                ,Economic_Activity
                ,Drcr_Ind
                ,Debit
                ,Credit
                ,Placement_Date
                ,Maturity_Date
                ,Customer_Id
                ,Branch
                ,Ccy
                ,Rate
                ,Amount
                ,Cb_Specific_Clients
                ,Line
                ,Cust_Gl
                ,Category
                ,Loc_Code
                ,Customer_Cat
                ,Module
                ,Financial_Cycle
                ,Periodic_Code
                ,Gl_Closing_Balance
                ,Gl_Opening_Balance
                ,Ib
                ,Trn_Dt
                ,Book_Date)
            Values
                (l_Trial_Balance(x).Ac_No
                ,l_Trial_Balance(x).Ac_Desc
                ,l_Trial_Balance(x).Gl_Code1
                ,l_Trial_Balance(x).Gl_Code2
                ,l_Trial_Balance(x).Gl_Int
                ,l_Trial_Balance(x).Cbf
                ,l_Trial_Balance(x).Residence
                ,l_Trial_Balance(x).Institutional_Unit
                ,l_Trial_Balance(x).Geographical_Location
                ,l_Trial_Balance(x).Economic_Activity
                ,l_Trial_Balance(x).Drcr_Ind
                ,l_Trial_Balance(x).Debit
                ,l_Trial_Balance(x).Credit
                ,l_Trial_Balance(x).Placement_Date
                ,l_Trial_Balance(x).Maturity_Date
                ,l_Trial_Balance(x).Cif_No
                ,l_Trial_Balance(x).Branch
                ,l_Trial_Balance(x).Ac_Ccy
                ,l_Trial_Balance(x).Rate
                ,l_Trial_Balance(x).Amount
                ,l_Trial_Balance(x).Cb_Specific_Client
                ,l_Trial_Balance(x).Line
                ,l_Trial_Balance(x).Ac_Or_Gl
                ,l_Trial_Balance(x).Category
                ,l_Trial_Balance(x).Loc_Code
                ,l_Trial_Balance(x).Customer_Cat
                ,l_Trial_Balance(x).Module
                ,l_Trial_Balance(x).Financial_Cycle
                ,l_Trial_Balance(x).Periodic_Code
                ,l_Trial_Balance(x).Gl_Closing_Balance
                ,l_Trial_Balance(x).Gl_Opening_Balance
                ,l_Trial_Balance(x).Ib
                ,l_Trial_Balance(x).Trn_Dt
                ,l_Trial_Balance(x).Book_Date);
        Exit When C1%Notfound;
    End Loop;
    Close C1;
    Commit;
    Null;
Exception
    When Dml_Errors Then
        Debug.Pr_Debug('**', Sql%Bulk_Exceptions.Count);
        For i In 1 .. Sql%Bulk_Exceptions.Count
        Loop
            Debug.Pr_Debug('**'
                          ,'Error #' || i || ' at ' || 'iteration
      #' || Sql%Bulk_Exceptions(i).Error_Index);
            Debug.Pr_Debug('**', 'Error message is ' || Sqlerrm(-sql%Bulk_Exceptions(i).Error_Code));
        End Loop;
    When Others Then
        Debug.Pr_Debug('**', Dbms_Utility.Format_Error_Backtrace);
        Debug.Pr_Debug('**', 'failed' || Sqlerrm);
End;
/
delete from TRIAL_BALANCE WHERE nvl(amount,0) = 0;
commit;
/
