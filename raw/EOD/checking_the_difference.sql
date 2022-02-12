 --- BRANCHES WITH DIFFERENCES IN BATCH ---
SELECT Ac_Branch,
       SUM(Decode(Category,'5',0,'6',0,'7',0,'8',0,'9',0,Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -
       SUM(Decode(Category,'5',0,'6',0,'7',0,'8',0,'9',0,Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Real_DIFF,
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Cont_DIFF,
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Memo_DIFF,
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,Decode(Drcr_Ind, 'D', Lcy_Amount, 0))) -
       SUM(Decode(Category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,Decode(Drcr_Ind, 'C', Lcy_Amount, 0))) Pos_DIFF,
       Financial_Cycle,
       Period_Code
FROM xafnfc.Actbs_Daily_Log
WHERE /*Balance_Upd = 'U'
         AND*/
Nvl(Delete_Stat, 'X') <> 'D'
GROUP BY Financial_Cycle, Period_Code, Ac_Branch;




select * from xafnfc.Actb_Daily_Log

--- BATCHES THAT ARE NOT BALANCED ---

select ac_branch,
       batch_no,
       USER_ID,
       sum(decode(drcr_ind, 'D', -lcy_amount, lcy_amount)) "BAL"
  from XAFNFC.actb_daily_log
 where Nvl(Delete_Stat, 'X') <> 'D'
   and batch_no is not null
 group by ac_branch, batch_no, USER_ID
 ORDER BY ac_branch, batch_no
--- CHECKING UNAUTHORIZED BATCHES AND DELETE THEM ---
SELECT * FROM xafnfc.detb_batch_master where auth_stat='U' for update;
SELECT count(*) from sttb_record_log where auth_stat = 'U';
SELECT * from xafnfc.sttb_record_log where auth_stat <> 'A' for update;
---
