set serverout on size unl feed off echo off time off timing off
set head off
set linesize 10000
set pagesize 50000
set long 10000
set colsep ";"
set trimspool on
column tm new_value file_time noprint
select to_char(sysdate, 'YYYYMMDD') tm from dual ;
prompt &file_time
spool logfile_id&file_time..log
Spool "/home/XAFNFC/GIMAC/ATM_spool/ATM_Txns_log_&file_time..log";
--Prompt ---------------------------------------------------------------------------------------------
Prompt "Sum of Amounts of Transactions happened Till date is :"                                     
Select Sum(Txn_Amt)
From   (Select Sum(Decode(a.Msg_Type,'0200',a.Txn_Amt,'0400',-a.Txn_Amt,'0420',-a.Txn_Amt,'0220',a.Txn_Amt,a.Txn_Amt)) As Txn_Amt
        From   Swtb_Txn_Log a Where  a.Msg_Type <> '0800' And a.Proc_Code like '01%' And a.Trn_Ref_No Is Not Null and a.Trn_Ref_No <> '0'
        Union
        Select Sum(Decode(Ahist.Msg_Type,'0200',Ahist.Txn_Amt,'0400',-ahist.Txn_Amt,'0420',-ahist.Txn_Amt,
                '0220',Ahist.Txn_Amt,Ahist.Txn_Amt)) As Txn_Amt
        From   Swtb_Txn_Hist Ahist  Where  Ahist.Msg_Type <> '0800' And   Ahist.Proc_Code like '01%' And Ahist.Trn_Ref_No Is Not Null and Ahist.Trn_Ref_No <> '0');
		
Prompt "GL Balance from gltb_gl_bal for all branches"
SELECT sum(cr_mov_lcy) as "Credit Balance Movement" FROM gltb_gl_bal WHERE gl_code='571222222';
--Prompt ---------------------------------------------------------------------------------------------
Prompt "Total Sum of Transactions happened Today is :" 
Select Sum(Decode(a.Msg_Type, '0200', a.Txn_Amt, '0400', -a.Txn_Amt, '0420', -a.Txn_Amt, '0220', a.Txn_Amt, a.Txn_Amt)) As Txn_Amt
From   Swtb_Txn_Log a
Where  a.Msg_Type <> '0800'
And    a.Proc_Code like '01%'
And    a.Trn_Ref_No Is Not Null and a.Trn_Ref_No <> '0'
And    a.Purge_Date > (Select Today
                       From   Sttm_Dates
                       Where  Branch_Code = '010');

Prompt "GL Balance from Daily log for all the branches" 					   
SELECT decode(balance_upd,'U','Balance Updated-','R','To be Updated-',balance_upd)||sum(lcy_amount) FROM actb_daily_log a WHERE ac_no='571222222'
group by balance_upd;
--Prompt ---------------------------------------------------------------------------------------------
Prompt "Successfully completed Cash Withdrawal Transactions for Today are Listed Below"
Prompt TRN_REF_NO            CUST_AC_NO         Amount
--Prompt ---------------------------------------------------------------------------------------------
SELECT a.trn_ref_no||'      '||a.from_acc || '   '||a.Txn_Amt FROM swtb_txn_log a WHERE a.msg_type <> '0800' AND A.PROC_CODE like '01%' AND A.WORK_PROGRESS ='S' And a.Purge_Date > (Select Today From Sttm_Dates Where  Branch_Code = '010') order by TRN_REF_NO;

Prompt "Failed Cash withdrawal Transactions Today"
Prompt TRN_REF_NO            CUST_AC_NO         Amount
--Prompt ---------------------------------------------------------------------------------------------
Select a.trn_ref_no||'      '||a.from_acc || '   '||a.Txn_Amt From   Swtb_Txn_Log a Where  a.Msg_Type <> '0800' and a.trn_ref_no is not null and a.Trn_Ref_No <> '0' And a.Proc_Code like '01%' And a.Work_Progress Not In ('C', 'S') And a.Purge_Date > (Select Today From Sttm_Dates  Where Branch_Code = '010');
--Prompt ---------------------------------------------------------------------------------------------
Prompt "Posted Transactions To be reconciled :"
Select count(1) From Swtb_Txn_Log a Where a.Msg_Type || a.Stan || a.Rrn || a.Term_Id In (Select b.Msg_Type || b.Stan || b.Rrn || b.Term_Id From Swtb_Settlement b Where Status Is Null) And a.Work_Progress Not In ('C','F');

Prompt "Settlement Count uploaded yet to reconciled:"
Select count(1) From  Swtb_Settlement b Where  Status Is Null;
--Prompt ---------------------------------------------------------------------------------------------
Prompt "List of unreconciled Transactions Till Date: "
Prompt TRN_REF_NO          CUST_AC_NO          TXN_AMT         RRN             purge_date
--Prompt ---------------------------------------------------------------------------------------------
Select x From(
SELECT A.TRN_REF_NO|| '    ' ||A.From_Acc|| '    ' || rpad(trunc(a.TXN_AMT),12,' ')|| '    ' || A.RRN|| '    ' || a.purge_date as x,a.purge_date FROM swtb_txn_log a WHERE a.Msg_Type <> '0800' and A.PROC_CODE like '01%' AND a.work_progress = 'S'
and a.purge_date <= (SELECT sd.today FROM sttm_dates sd WHERE branch_code='010')
and a.rrn not in (SELECT aa.rrn FROM swtb_txn_log aa WHERE aa.msg_type in ('0420','0400') and aa.work_progress ='S')
union all
SELECT B.TRN_REF_NO|| '    ' ||B.FROM_ACC||'    ' || rpad(trunc(B.TXN_AMT),12,' ')|| '    ' || B.RRN|| '    ' || b.purge_date as x,b.purge_date FROM swtb_txn_hist B WHERE b.Msg_Type <> '0800' and B.PROC_CODE like '01%' AND B.work_progress = 'S'
and b.rrn not in (SELECT bb.rrn FROM swtb_txn_hist bb WHERE bb.msg_type in ('0420','0400') and bb.work_progress ='S')) order by purge_date asc;
--Prompt ---------------------------------------------------------------------------------------------
Prompt "Missing Entries for Todays reconcile:"
Prompt TRN_REF_NO            CUST_AC_NO         Amount         Msg_Type
Select s.trn_ref_no||'      '||s.from_acc || '   '||s.Txn_Amt|| '   '|| s.Msg_Type From Swtb_Txn_Log s Where s.p_Key Not In (Select a.p_Key From Swtb_Txn_Log a Where a.Msg_Type || a.Stan || a.Rrn || a.Term_Id In (Select b.Msg_Type || b.Stan || b.Rrn || b.Term_Id From Swtb_Settlement b Where b.Status Is Null)) And s.Msg_Type <> '0800' And s.Proc_Code Like '01%' And s.Work_Progress ='S' order by s.TRN_REF_NO;
spool off;
