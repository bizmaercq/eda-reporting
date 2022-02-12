    -- * Vérication de l'équilibre des transactions
     SELECT Ac_Branch,SUM(Decode(Category,

                       '5',

                       0,

                       '6',

                       0,

                       '7',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'D', Lcy_Amount, 0)))  -

            SUM(Decode(Category,

                       '5',

                       0,

                       '6',

                       0,

                       '7',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Real_DIFF,

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '7',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '7',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Cont_DIFF,

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '5',

                       0,

                       '6',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '5',

                       0,

                       '6',

                       0,

                       '8',

                       0,

                       '9',

                       0,

                       Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Memo_DIFF,

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '5',

                       0,

                       '6',

                       0,

                       '7',

                       0,

                       Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -

            SUM(Decode(Category,

                       '1',

                       0,

                       '2',

                       0,

                       '3',

                       0,

                       '4',

                       0,

                       '5',

                       0,

                       '6',

                       0,

                       '7',

                       0,

                       Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Pos_DIFF,

            Financial_Cycle,

            Period_Code

       FROM xafnfc.Actbs_Daily_Log

      WHERE /* Balance_Upd = 'U'

        AND */ Nvl(Delete_Stat, 'X') <> 'D'

      GROUP BY Financial_Cycle, Period_Code,Ac_Branch
      ORDER BY Ac_Branch;
