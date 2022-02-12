SELECT * FROM SWTB_TXN_LOG TL WHERE tl.msg_type <>'0800';

SELECT * FROM SWTB_TXN_LOG TL WHERE tl.msg_type <>'0800';

SELECT * FROM swtb_txn_hist ;

-- Erroneous transactions
SELECT  substr(th.trn_ref_no,1,3) Branch_Code,th.term_id, th.trans_dt_time "TRANSACTION DATE",th.trn_ref_no,th.from_acc "CUST_ACCOUNT",ae.AC_NO,th.txn_amt AMOUNT,th.pan CARD_NO, th.rrn, th.resp_code, ae.USER_ID, ae.AUTH_ID
FROM swtb_txn_hist th , acvw_all_ac_entries ae
WHERE th.trn_ref_no = ae.TRN_REF_NO
and th.resp_code is null;

SELECT * FROM swtm_terminal_details;

SELECT * from swtb_txn_hist WHERE rrn ='509077531097';

SELECT * FROM actb_history WHERE trn_ref_no ='023ATCW150960014';

SELECT * FROM sttm_cust_account WHERE cust_ac_no ='0232810101424393';

SELECT * FROM swtb_settlement WHERE rrn='509077531097';
SELECT * FROM swtb_settlement_hist WHERE rrn='509077531097';
