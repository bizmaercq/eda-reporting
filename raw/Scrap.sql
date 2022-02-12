SELECT * FROM eivw_pending_items;-- where id ='LTAH';

SELECT * FROM fbtb_txnlog_master tl WHERE tl.xrefid ='FJB1935406193561' FOR UPDATE NOWAIT; 
SELECT * FROM fbtb_txnlog_master tl WHERE tl.makerid ='CMANGWI' and tl.txnstatus <>'COM' FOR UPDATE NOWAIT; 

SELECT * FROM fbtb_txnlog_master_hist tl WHERE tl.branchcode='024' and tl.postingdate ='15/07/2019'

create table FJB1824005386167_rtl_teller as 
SELECT * FROM detb_rtl_teller rt WHERE rt.xref = 'FJB1824005386167' FOR UPDATE NOWAIT; 

insert into detb_rtl_teller SELECT * FROM  FJB1824005386167_rtl_teller 

SELECT * FROM fbtbs_till_master tm WHERE tm.branch_code ='021' --FOR UPDATE NOWAIT; 

SELECT * FROM sttb_record_log rl WHERE rl.auth_stat ='U' and rl.maker_id ='CMANGWI'

SELECT * FROM detb_batch_master bm WHERE bm.batch_no ='7713'

SELECT * FROM fbtb_txnlog_details tl WHERE tl.xrefid ='FJB1834105567057' FOR UPDATE NOWAIT; 

FJB1820405325005, FJB1820405325027 and  FJB1820405325037

SELECT * FROM actb_daily_log dl WHERE dl.batch_no ='7713'
SELECT * FROM fbtb_txnlog_master_hist tl WHERE tl.xrefid ='FJB1834005563288' FOR UPDATE NOWAIT;

SELECT th.branchcode,th.postingdate,th.xrefid,th.txnamtdet,th.makerid,th.checkerid 
and th.postingdate between '01-jan-2015' and '31-dec-2017';

SELECT ae.TRN_DT,ae.AC_BRANCH,ae.TRN_REF_NO,ae.EXTERNAL_REF_NO,ae.AC_NO,ae.EVENT,ae.TRN_CODE,ae.DRCR_IND,ae.LCY_AMOUNT,ae.USER_ID,ae.AUTH_ID
FROM acvw_all_ac_entries ae WHERE ae.EVENT ='REVR' and ae.TRN_DT between '01-jan-2015' and '31-dec-2017'

SELECT * FROM detb_rtl_teller_hist th WHERE /*th.txn_trn_code ='REV' and*/ th.maker_id <>'FLEXSWITCH'

create table FJB1824005386167_table as FJB1834105567061

FJB1834105567057
 SELECT * FROM actb_daily_log dl WHERE dl.external_ref_no ='023ATCW190220089' FOR UPDATE NOWAIT; 
insert into actb_daily_log SELECT * FROM FJB1824005386167_table

SELECT * FROM sttm_cust_account ca WHERE ca.ac_desc like '%LOGANE%'

SELECT * FROM sttb_record_log WHERE auth_stat = 'U' FOR UPDATE NOWAIT; 

SELECT * FROM sttbs_account ca WHERE ca.cust_no ='046670' FOR UPDATE NOWAIT; 

SELECT * FROM actb_history ah WHERE ah.trn_ref_no ='020BCIG181140002'

SELECT * FROM sttm_cust_account ca WHERE ca.cust_ac_no ='0202820100403173' FOR UPDATE NOWAIT; 

SELECT * FROM swtm_terminal_details td FOR UPDATE NOWAIT; 

SELECT * FROM sttm_cust_account ca WHERE ca.acy_tank_dr <>0

SELECT * FROM smtb_current_users FOR UPDATE NOWAIT; 

SELECT * FROM sitb_contract_master cm WHERE cm.contract_ref_no ='020SIOO161100004';

SELECT * FROM sitb_instruction sn  WHERE sn.instruction_no ='020SIOO161100004';

 FOR UPDATE NOWAIT; SELECT * FROM sitb_cycle_detail cd WHERE cd.contract_ref_no= '020SIOO161100004'
   
 SELECT * FROM sitb_cycle_due_exec cd WHERE cd.contract_ref_no= '020SIOO161100004' FOR UPDATE NOWAIT;
 
 SELECT * FROM sttm_cust_personal cp WHERE cp.customer_no ='047347' FOR UPDATE NOWAIT; 
 SELECT * FROM sttm_cust_account ca WHERE ca.cust_no ='051132'
 SELECT * FROM CSTM_FUNCTION_USERDEF_FIELDS cf WHERE cf.function_id='STDCIF' and substr(cf.rec_key,1,6) ='047347' 

SELECT * FROM fbtb_till_master tm WHERE tm.til_id = 'TILL_042_3'
SELECT *  FROM fbtb_till_totals tm WHERE tm.till_id = 'TILL_042_3' and tm.postingdate ='23/08/2019'
SELECT * FROM fbtb_till_detail_ccy td WHERE td.till_id ='TILL_042_3'  and td.ccycode ='XAF' FOR UPDATE NOWAIT; 

SELECT * FROM smtb_current_users /*where user_id='FATEKWANA' */FOR UPDATE NOWAIT; 

SELECT * FROM svtm_cif_sig_master sm WHERE sm.auth_stat ='U'

SELECT * FROM detb_batch_master_hist bm WHERE bm.batch_no ='9285' and trunc(bm.deletion_date) = '31-aug-2012'

SELECT * FROM detb_upload_master_hist mh WHERE mh.batch_no='9285'
SELECT * FROM detb_upload_detail_history ud WHERE ud.batch_no='8818' and ud.value_date ='29-dec-2017'

SELECT * FROM gltm_glmaster

SELECT * FROM actb_history ah WHERE ah.batch_no='6817' and ah.trn_dt ='19-sep-2017'

SELECT * FROM acvw_all_ac_entries ae WHERE ae.TRN_REF_NO ='023ATCW190220089' FOR UPDATE NOWAIT; 


SELECT * FROM acvw_all_ac_entries ae WHERE ae.INSTRUMENT_CODE =' 1730104773340002'


SELECT count(*) FROM cltb_account_master am WHERE am.CUSTOMER_ID ='014314'

select * from sttm_customer where customer_no in ('014314','026949')

SELECT * FROM sttm_cust_personal cp WHERE cp.customer_no='014220'

-- Correct the special characters in field id that prevents the field screen in Customer input
SELECT * FROM cstm_function_userdef_fields WHERE function_id='STDCIF' and substr(rec_key,1,6)='026945' FOR UPDATE NOWAIT; 

SELECT * FROM tdvw_td_details td WHERE td.Account_no ='0235732103999529'
SELECT * FROM acvw_all_ac_entries ae WHERE ae.RELATED_ACCOUNT ='0235732903999560' and ae.AMOUNT_TAG ='ILIQ' order by ae.TRN_DT

SELECT * FROM sttm_account_class

SELECT  TRN_REF_NO,EVENT_SR_NO,ac_no,AC_BRANCH,USER_ID,batch_no,LCY_AMOUNT,DRCR_IND,event,trn_dt,RELATED_ACCOUNT 
    FROM ACTB_DAILY_LOG
    where auth_stat = 'U'
AND USER_ID ='FATEKWANA'

SELECT * FROM detb_upload_master um WHERE um.batch_no ='0609'

SELECT table_name from user_tables WHERE table_name like '%LOG%'
SELECT * FROM acvw_all_ac_entries ae WHERE ae.AC_NO ='454101000' and ae.TRN_DT ='26-dec-2018'

SELECT * FROM smtb_current_users FOR UPDATE NOWAIT; 

SELECT * FROM sttm_cust_personal cp WHERE cp.Customer_No ='014218'

SELECT * FROM aetb_eoc_branches eb WHERE eb.branch_code ='010'

SELECT * FROM sttm_cust_account ca WHERE ca.alt_ac_no like '%250310%'

SELECT *  FROM Smtb_Sms_Log_Hist WHERE trunc( start_time) between '01-jan-2018' and '31-jan-2018'


SELECT * FROM swtm_card_details cd WHERE cd.atm_acc_no ='0233820107171544'

SELECT table_name from user_tables WHERE table_name like '%TANK%'

SELECT * FROM cstm_product
