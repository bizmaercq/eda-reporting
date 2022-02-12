--CHANGE THE TRN_REF_NO AND EVENT_SEQ_NO before sending

DECLARE


  CURSOR CUR_ACC IS
                    SELECT  TRN_REF_NO,EVENT_SR_NO,ac_no,AC_BRANCH,USER_ID,batch_no,LCY_AMOUNT,DRCR_IND,event,trn_dt,RELATED_ACCOUNT 
    FROM ACTB_DAILY_LOG
    where auth_stat = 'U'
AND USER_ID ='HESENI'
AND batch_no in ('7800')
and SUBSTR(trn_ref_no,1,3) IN ('010','020','021','022','023','024','030','031','032','040','041','042','043','050','051')
        and NVL(delete_stat,'H') <> 'D';
     
    
  PERRCODE   VARCHAR2(100);
  PPARAM   VARCHAR2(1000);

  I     NUMBER ;

BEGIN


global.pr_init ('010','FATEKWANA');

        i := 0 ;

  FOR C1 IN CUR_ACC LOOP

    IF ACPKSS.fn_acservice
         (
      C1.AC_BRANCH ,
      global.application_date,
      global.lcy    ,
      C1.trn_ref_no ,
      C1.event_sr_no ,
      'A' ,
      'TBELEKE' , -- Change the user id
      pErrCodE,
      pParam  
         ) THEN
          DEBUG.PR_DEBUG('AC','SUCCESS - '||C1.trn_ref_no);
    ELSE
        DEBUG.PR_DEBUG('AC','ERROR - '||C1.trn_ref_no || SQLERRM);
    END IF;

    I:=I+1;

    DEBUG.PR_DEBUG('AC','FINAL COUNT'||I);
          commit;
  END LOOP;

  COMMIT;


EXCEPTION
  WHEN OTHERS
  THEN debug.pr_debug('AC','WOT - ' || SQLERRM);
  ROLLBACK;

END;
/
