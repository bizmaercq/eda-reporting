CREATE OR REPLACE FORCE VIEW "XAFNFC"."SWVW_ACCBAL" ("BRANCH_CODE", "SEPERATOR", "CUST_AC_NO", "CCY_CODE", "AC_TYPE", "AC_STAT", "DR_CR", "AVL_BAL", "BLCKD_AMT", "FCLTY_AMT", "BAL_DATE") AS 
 Select Distinct a_Rec.Branch_Code,
                '|' As Seperator,
                a_Rec.Cust_Ac_No,
                (Select A1.Iso_Num_Ccy_Code
                   From Cytm_Ccy_Defn A1
                  Where A1.Ccy_Code = a_Rec.Ccy) As Ccy_Code,
                Decode(a_Rec.Account_Type, 'U', 11, 'S', 10) As Ac_Type,
                Decode(a_Rec.Acc_Status, 'NORM', 0, 1) As Ac_Stat,
                (Select Case
                          When a_Rec.Acy_Avl_Bal < 0 Then
                           'D'
                          Else
                           'C'
                        End Case
                   From Dual) As Dr_Cr,
                CASE
                  WHEN a_Rec.Ccy = 'XAF' THEN
                   (SELECT coalesce(Lpad(Abs(a_Rec.Acy_Avl_Bal - b.Min_Balance), 12, 0) ,Lpad(Abs(a_Rec.Acy_Avl_Bal), 12, 0))
                      from sttm_accls_ccy_balances b
                     where b.account_class = a_Rec.account_class
                       and b.ccy_code = a_Rec.Ccy)
                  ELSE
                   Lpad(Abs(a_Rec.Acy_Avl_Bal), 12, 0)
                END Avl_Bal,
                '000000000000' Blckd_Amt,
                '000000000000' As Fclty_Amt,
                To_Char(a.Today, 'DDMMYYYY') As Bal_Date
  From Sttm_Cust_Account a_Rec, Swtms_Card_Details Crd, Sttm_Dates a
 Where a_Rec.Record_Stat = 'O'
   And a_Rec.Auth_Stat = 'A'
   And a_Rec.Account_Type In ('S', 'U')
   And a_Rec.Branch_Code = Crd.Fcc_Acc_Brn
   And a_Rec.Cust_Ac_No = Crd.Fcc_Acc_No
   And Crd.Once_Auth = 'Y'
   And Crd.Record_Stat = 'O'
   And a_Rec.Branch_Code = a.Branch_Code
;
