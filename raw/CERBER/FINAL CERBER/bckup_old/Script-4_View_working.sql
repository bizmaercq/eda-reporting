Prompt "Please enter M12 as period if it is year end"
CREATE OR REPLACE VIEW VW_TRIAL_BALANCE AS
Select Account_Number
      ,Description
      ,Glcode1
      ,Glcode2
      ,Gl_Leaf
      ,Gl_Interface
      ,
       --gl_closING,
       Nvl(Central_Bank_Code_a
          ,Case
               When Gl_Closing_Balance_b < 0 Then
                (Select Distinct Sd.Cbank_Line_Dr
                 From   Gltm_Glmaster Sd
                 Where  Sd.Gl_Code = Glcode2)
               When Gl_Closing_Balance_b > 0 Then
                (Select Distinct Sd.Cbank_Line_Cr
                 From   Gltm_Glmaster Sd
                 Where  Sd.Gl_Code = Glcode2)
               Else
                Nvl((Select Distinct Sd.Cbank_Line_Cr
                    From   Gltm_Glmaster Sd
                    Where  Sd.Gl_Code = Glcode2)
                   ,(Select Distinct Sd.Cbank_Line_Dr
                    From   Gltm_Glmaster Sd
                    Where  Sd.Gl_Code = Glcode2))
           End) Central_Bank_Code
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
      ,Gl_Closing_Balance_b Gl_Closing_Balance
      ,Nvl(Gl_Opening_Balance
          ,(Select (Sum(Open_Cr_Bal_Lcy) - Sum(Open_Dr_Bal_Lcy))
           From   Gltb_Gl_Bal
           Where  Gl_Code = Glcode2
           And    Fin_Year = '&FINANCIAL_CYCLE'
           And    Period_Code = '&REPORT_PERIOD_CODE')) Gl_Opening_Balance
      ,Ib
      ,Trn_Dt
      ,Book_Date
From   (Select
         Account_Number
        ,Description
        ,Glcode1
        ,Glcode2
        ,(Select Leaf
           From   Gltm_Glmaster
           Where  Gl_Code = Glcode2) Gl_Leaf
        ,Case
              When Substr(Gl_Code2, 1, 2) In ('68', '66', '25') Then
               Substr(Gl_Code2, 1, 2)
              When Substr(Gl_Code2, 1, 2) In ('20', '19', '28', '69', '93', '98', '99') Then
               Substr(Gl_Code2, 1, 4)
              When Substr(Gl_Code2, 1, 3) In ('321', '344', '345', '471', '472', '611', '623', '644', '651', '791') Then
               Substr(Gl_Code2, 1, 4)
              Else
               Substr(Gl_Code2, 1, 3)
          End Gl_Interface
        ,Central_Bank_Code_a
        ,'' Central_Bank_Code_b
        ,
          --NVL(RESIDENCE,'1') RESIDENCE,
          Residence
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
        ,'' Financial_Cycle
        ,'' Periodic_Code
        ,Nvl(Gl_Closing_Balance_a, 0) Gl_Closing_Balance_a
        ,Nvl((Select (Sum(Nvl(Cr_Bal_Lcy, 0)) - Sum(Nvl(Dr_Bal_Lcy, 0)))
              From   Gltb_Gl_Bal
              Where  Gl_Code = Glcode2
              And    Gl_Code = Account_Number
              And    Fin_Year = '&FINANCIAL_CYCLE'
              And    Period_Code = '&REPORT_PERIOD_CODE'
              And    (Category In ('1', '2', '5', '6', '7', '8', '9') Or (Category In ('3', '4') And Ccy_Code = 'XAF')))
             ,0) Gl_Closing_Balance_b
        , Gl_Opening_Balance
        ,Ib
        ,Trn_Dt
        ,Book_Date        
        From   ( Select
                  Nvl(a.Account_Number, b.Gl_Code) Account_Number
                 ,Nvl(a.Description, b.Gl_Desc) Description
                 ,Nvl(Glcode1, Substr(b.Gl_Code, 1, 5)) Glcode1
                 ,b.Gl_Code Gl_Code2
                 ,Nvl(a.Glcode2, b.Gl_Code) Glcode2
                 ,Gl_Interface
                 ,a.Central_Bank_Code Central_Bank_Code_a
                 ,a.Residence Residence
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
                 ,Nvl(a.Ccy, Nvl(b.Res_Ccy, 'XAF')) Ccy
                 ,Rate
                 ,Amount
                 ,Cb_Specific_Clients
                 ,Line
                 ,Nvl(a.Cust_Gl, 'G') Cust_Gl
                 ,Nvl(a.Category, b.Category) Category
                 ,Loc_Code
                 ,Customer_Cat
                 ,Module
                 ,Gl_Opening_Balance
                 ,a.Gl_Closing_Balance Gl_Closing_Balance_a
                 ,'' Gl_Closing_Balance_b
                 ,Ib
                 ,Trn_Dt
                 ,Book_Date
                 From   Trial_Balance a
                        ,Gltm_Glmaster b
                 Where  a.Glcode2(+) = b.Gl_Code
                 And    b.Leaf = 'Y'))
