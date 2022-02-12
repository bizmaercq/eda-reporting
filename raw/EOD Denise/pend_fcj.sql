set echo on
set head on
set linesize 10000
set pagesize 50000
set long 10000

set feedback on
set colsep ";"
spool C:\pend_fcj.spl


PROMPT UNAUTHORISED CONTRACT EVENTS

SELECT substr(a.contract_ref_no,1,3) br, a.module md,
		a.contract_ref_no rn, '' mt, a.event_code ev, maker_id id
           FROM Cstb_Contract_Event_Log a
          WHERE  Auth_Status = 'U'
                AND ( (Contract_Status <> 'H' AND Module <> 'LD')
                     OR (Module = 'LD' AND Contract_Status NOT IN ('I', 'H')));


PROMPT UNAUTHORISED MAINTENANCES
SELECT *
           FROM Sttb_Record_Log
          WHERE (Auth_Stat = 'U' AND Nvl (Tanking_Status, 'N') <> 'T'); 
			
PROMPT UNAUTHORISED DE BATCHES			
SELECT branch_code,batch_no,description
           FROM Detb_Batch_Master m
          WHERE     m.Auth_Stat = 'U'
                AND EXISTS
                       (SELECT 1
                          FROM Detb_Jrnl_Log l
                         WHERE l.Batch_No = m.Batch_No);    
			
			
PROMPT UNAUTHORISED TILL			
SELECT *
           FROM Detms_Til_Vlt_Master
          WHERE Balanced_Ind = 'N';   

PROMPT UNAUTHORISED CLEARING		  
SELECT product_code,txn_branch,reference_no
           FROM Cstb_Clearing_Master
          WHERE  Auth_Stat = 'U';     

PROMPT UNAUTHORISED RATES
SELECT branch_code,ccy1,ccy2,rate_type
           FROM Cytm_Rates
          WHERE  Int_Auth_Stat = 'U'; 


PROMPT UNAUTHORISED LIQUIDATION EVENTS		  
SELECT liq_ref_no,liq_event_seq_no,liq_event_code,liq_status
           FROM Cstbs_Liq_Events a
          WHERE    a.Liq_Event_Code IN ('ZRLQ', 'ZRVR')
                AND a.Liq_Status IN ('OS', 'COL', 'REV')
                AND a.Liq_Auth_Status = 'U';      
				
PROMPT UNAUTHORISED CHEQUE BOOK				
SELECT *
           FROM Catm_Check_Book
          WHERE Auth_Stat = 'U';                



PROMPT UNAUTHORISED CHEQUE DETAILS		  
SELECT *
          FROM Catm_Check_Details
          WHERE Auth_Stat = 'U';

PROMPT UNAUTHORISED STOP PAYMENTS		  
SELECT *
           FROM Catm_Stop_Payments
          WHERE Auth_Stat = 'U';
        
PROMPT UNAUTHORISED AMOUNT BLOCKS		
SELECT *
           FROM Catm_Amount_Blocks
          WHERE Auth_Stat = 'U';  

PROMPT UNAUTHORISED MIS 		  
SELECT branch_code,unit_type,adj_ref_no1,adj_ref_no2,mis_class
           FROM Mitb_Adj
          WHERE Auth_Stat = 'U';          

PROMPT UNAUTHORISED ACCOUNTING ENTRIES		  
SELECT *
           FROM Actb_Daily_Log
          WHERE  Auth_Stat = 'U' AND Delete_Stat = ' ';          

PROMPT UNAUTHORISED MESSAGES		  
SELECT  branch,dcn,reference_no,module
           FROM Mstb_Dly_Msg_Out
          WHERE Auth_Stat = 'U' ;     

PROMPT UNAUTHORISED CL ACCOUNTS
		  
SELECT branch_code,account_number,component_name,event_code,
           FROM Cltb_Account_Events_Diary 
          WHERE  Auth_Status = 'U'
                AND Event_Seq_No IS NOT NULL;          

PROMPT UNAUTHORISED IC RESOLUTION LOG				
SELECT *
           FROM ictb_resolution_log 
          WHERE Auth_Stat = 'U';                
		  
PROMPT UNAUTHORISED JOB BROWSER
SELECT *
			FROM   cstb_job_browser
			WHERE  module IN ('DE', 'MS')
			AND    process IN ('JOB_START_UPLOAD_DE', 'PR_BG_GEN_MSG_OUT')
			AND    status <> decode(process, 'JOB_START_UPLOAD_DE', 'S', 'PR_BG_GEN_MSG_OUT', 'H');		            
			
PROMPT SELECTING FROM EIVW_PENDIG_ITEMS ALSO AS THE SITE VIEW MIGHT HAVE SOME CUSTOMIZATIONS

SELECT * FROM EIVW_PENDING_ITEMS;			
			
spool off			