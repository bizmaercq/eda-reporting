accept REPORT_MONTH_END_DT  PROMPT 'Enter the Current REPORT_MONTH_END_DT (Ex: 31-MAY-2012) >'
set array 1
set head on
set feedback on
set line 10000
set pagesize 10000
set echo on

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
              ,(-amount) Amount
              ,Cb_Specific_Client
              ,Line
              ,Cust_Gl
              ,Category
              ,Loc_Code
              ,Customer_Cat
              ,Module
              ,Financial_Cycle
              ,Periodic_Code
              ,Gl_Opening_Balance
              ,Gl_Closing_Balance
              ,Ib
              ,Trn_Dt
              ,Book_Date
        From   (Select Ac_No
                      ,Ac_Desc
                      ,Gl_Code1
                      ,Gl_Code2
                      ,Gl_Int
                      ,(Select Distinct Sd.Cbank_Line_Dr
                        From   Gltm_Glmaster Sd
                        Where  Sd.Gl_Code = Gl_Code2) Cbf
                      ,Residence
                      ,Institutional_Unit
                      ,Geographical_Location
                      ,Economic_Activity
                      ,Case
                           When Amount < 0 Then
                            'D'
                           Else
                            'C'
                       End Drcr_Ind
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
                      ,Cust_Gl
                      ,(Select Category
                        From   Gltm_Glmaster
                        Where  Gl_Code = Gl_Code2) Category
                      ,Loc_Code
                      ,Customer_Cat
                      ,Module
                      ,Financial_Cycle
                      ,Periodic_Code
                      ,Gl_Opening_Balance
                      ,Gl_Closing_Balance
                      ,Ib
                      ,Trn_Dt
                      ,Book_Date
                From   (Select Cam.Account_Number Ac_No
                              ,(Select Product_Desc
                                From   Cltm_Product
                                Where  Product_Code = Cam.PRODUCT_CODE) Ac_Desc
                              ,Substr(Ee.Gl_Code, 1, 5) Gl_Code1
                              ,Ee.Gl_Code Gl_Code2
                              ,Case
                                   When Substr(Ee.Gl_Code, 1, 2) In ('68', '66', '25') Then
                                    Substr(Ee.Gl_Code, 1, 2)
                                   When Substr(Ee.Gl_Code, 1, 2) In ('20', '19', '28', '69', '93', '98', '99') Then
                                    Substr(Ee.Gl_Code, 1, 4)
                                   When Substr(Ee.Gl_Code, 1, 3) In
                                        ('321', '344', '345', '471', '472', '611', '623', '644', '651', '791') Then
                                    Substr(Ee.Gl_Code, 1, 4)
                                   Else
                                    Substr(Ee.Gl_Code, 1, 3)
                               End Gl_Int
                              ,Decode((Select Distinct Resident_Status
                                      From   Sttm_Cust_Personal
                                      Where  Customer_No = Ee.Customer_Id)
                                     ,'N'
                                     ,'0'
                                     ,'R'
                                     ,'1'
                                     ,Decode((Select r_Country
                                             From   Sttm_Cust_Corporate
                                             Where  Customer_No = Ee.Customer_Id)
                                            ,'CM'
                                            ,1
                                            ,0)) Residence
                              ,(Select Nn.Cust_Mis_1
                                From   Mitm_Customer_Default Nn
                                Where  Nn.Customer = Ee.Customer_Id) Institutional_Unit
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
                                 Where  Ss.Customer_No = Ee.Customer_Id)) Geographical_Location
                              ,(Select Decode(Substr(Cust_Mis_3, 1, 1)
                                             ,'G'
                                             ,'9'
											 ,'0'
											 ,'9'
                                             ,Substr
                                              
                                              (Cust_Mis_3, 1, 1))
                                From   Mitm_Customer_Default
                                Where  Customer = Ee.Customer_Id) Economic_Activity
                              ,'' Drcr_Ind
                              ,'' Debit
                              ,'' Credit
                              ,To_Date(Cam.BOOK_DATE, 'DD-MM-RRRR') Placement_Date
                              ,To_Date(Cam.Maturity_Date, 'DD-MM-RRRR') Maturity_Date
                              ,Ee.Customer_Id Cif_No
                              ,Cam.Branch_Code Branch
                              ,Cam.Currency Ac_Ccy
                              ,Bipks_Report_Loan.Fn_Get_Loan_Intrate(Cam.Account_Number) Rate
                              ,Bipks_Report_Loan.Fn_Get_Principal_Arrears_Asdt(Cam.Account_Number
                                                                              ,To_Date('&REPORT_MONTH_END_DT'
                                                                                      ,'dd-MM-yyyy')) Amount
								--,bipks_report_loan.Fn_Get_Outstanding_Balance(Cam.Account_Number) Amount
                              ,Case
                                   When (Select Decode(Cust_Mis_4, 'F1121', 'F1121')
                                         From   Mitm_Customer_Default
                                         Where  Customer = Ee.Customer_Id) = 'F1121' Then
                                    'F1121'
                                   When (Select Decode(Cust_Mis_5, 'F1122', 'F1122')
                                         From   Mitm_Customer_Default
                                         Where  Customer = Ee.Customer_Id) = 'F1122' Then
                                    'F1122'
                                   Else
                                    ''
                               End Cb_Specific_Client
                              ,'' Line
                              ,'G' As Cust_Gl --s.Cust_Gl
                              ,'' Category
                              ,(Select Loc_Code
                                From   Sttm_Customer
                                Where  Customer_No = Ee.Customer_Id) Loc_Code
                              ,(Select Distinct Customer_Category
                                From   Sttm_Customer
                                Where  Customer_No = Ee.Customer_Id) Customer_Cat
                              ,Cam.Module_Code Module
                              ,'' Financial_Cycle
                              ,'' Periodic_Code
                              ,'' Gl_Opening_Balance
                              ,'' Gl_Closing_Balance
                              ,'' Ib
                              ,'' Trn_Dt
                              ,Cam.Book_Date
                        From   Cltb_Account_Master Cam
                              ,(Select a.Account_Number
                                      ,a.Gl_Code
                                      ,d.Customer_Id
                                From   Cltb_Account_Comp_Bal_Breakup a
                                      ,Cltb_Account_Master           d
                                Where  a.Account_Number = d.Account_Number
                                And    a.Status_Code = d.User_Defined_Status
                                And    a.Branch_Code = d.Branch_Code
                                And    a.Gl_Code = a.Gl_Code
                                And    a.Component = 'PRINCIPAL'
                                And    Creation_Date = (Select Max(Creation_Date)
                                                        From   Cltb_Account_Comp_Bal_Breakup
                                                        Where  Account_Number = a.Account_Number
                                                        And    Creation_Date <= '&REPORT_MONTH_END_DT'
                                                        And    Component = 'PRINCIPAL'
                                                        And    Status_Code = a.Status_Code)) Ee
                        Where  Cam.Account_Number = Ee.Account_Number
                        And    Cam.Module_Code = 'CL' and cam.account_status <> 'L'));

Begin

    For Var_C1 In C1
    Loop
    
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
            (Var_C1.Ac_No
            ,Var_C1.Ac_Desc
            ,Var_C1.Gl_Code1
            ,Var_C1.Gl_Code2
            ,Var_C1.Gl_Int
            ,Var_C1.Cbf
            ,Var_C1.Residence
            ,Var_C1.Institutional_Unit
            ,Var_C1.Geographical_Location
            ,Var_C1.Economic_Activity
            ,Var_C1.Drcr_Ind
            ,Var_C1.Debit
            ,Var_C1.Credit
            ,Var_C1.Placement_Date
            ,Var_C1.Maturity_Date
            ,Var_C1.Cif_No
            ,Var_C1.Branch
            ,Var_C1.Ac_Ccy
            ,Var_C1.Rate
            ,Var_C1.Amount
            ,Var_C1.Cb_Specific_Client
            ,Var_C1.Line
            ,Var_C1.Cust_Gl
            ,Var_C1.Category
            ,Var_C1.Loc_Code
            ,Var_C1.Customer_Cat
            ,Var_C1.Module
            ,Var_C1.Financial_Cycle
            ,Var_C1.Periodic_Code
            ,Var_C1.Gl_Closing_Balance
            ,Var_C1.Gl_Opening_Balance
            ,Var_C1.Ib
            ,Var_C1.Trn_Dt
            ,Var_C1.Book_Date);
    End Loop;
    Commit;
End;
/
