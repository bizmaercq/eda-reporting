SELECT table_name from user_tables ut WHERE ut.table_name like '%LOG%'
SELECT * FROM CLTB_ACCOUNT_CHANGE_LOG cl WHERE cl.date_changed ='01/11/2019';
SELECT * FROM CSTB_CONTRACT_CHANGE_LOG cl  WHERE cl.date_changed ='01/11/2019';
SELECT * FROM STTBS_RECORD_LOG_HIST lh WHERE trunc(lh.maker_dt_stamp) ='01/11/2019';
SELECT * FROM CSTB_CONTRACT_EVENT_LOG el WHERE trunc(el.maker_dt_stamp) ='01/11/2019';



SELECT * FROM cltb_account_master am WHERE am.ACCOUNT_NUMBER ='020S14S193050003'

SELECT * FROM DETB_JRNL_LOG;

SELECT * FROM sttm_cust_account ca WHERE ca.cust_no ='014260'
