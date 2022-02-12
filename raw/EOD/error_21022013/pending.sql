set line 300
set head off
set verify off
set feed oFF
set echo OFF
set serverout on
spool /home/oracle/SPOOL/$$$.SQL

declare
key_id varchar2(50);
sqltext varchar2(1000);
PARAMCOUNT NUMBER(2) ;
COLLIST varchar2(1000);
TYPELIST varchar2(1000);
LTABLE_NAME VARCHAR2(100);
begin
FOR X IN (SELECT KEY_ID FROM XAFNFC.STTB_RECORD_LOG WHERE AUTH_STAT = 'U')
LOOP
    KEY_ID := X.KEY_ID;
    PARAMCOUNT := 2;
    LTABLE_NAME := xafnfc.cspke_misc.FN_GetParam(KEY_ID,2);
    SQLTEXT :=  'SELECT * FROM ' || LTABLE_NAME  || ' WHERE ';
    WHILE TRUE
    LOOP
    SELECT COLUMN_LIST,DATA_TYPE_LIST INTO COLLIST,TYPELIST FROM XAFNFC.sttb_pk_cols WHERE TABLE_NAME = LTABLE_NAME;
    SQLTEXT := SQLTEXT || cspke_misc.FN_GetParam(COLLIST,PARAMCOUNT) || ' = ''';
    SQLTEXT := SQLTEXT || cspke_misc.FN_GetParam(KEY_ID,PARAMCOUNT+1) || ''' AND ';
    PARAMCOUNT := PARAMCOUNT + 1;
      IF cspke_misc.FN_GetParam(KEY_ID,PARAMCOUNT) = 'EOPL' THEN
         EXIT;
      END IF;   
    END LOOP;
    SQLTEXT := SUBSTR(SQLTEXT,1,LENGTH(SQLTEXT)-33) || ';' ;
    DBMS_OUTPUT.PUT_LINE(SQLTEXT);
END LOOP;    
END;
/
spool off

set echo on
set head on
set linesize 10000
set pagesize 50000
set long 10000

set feedback on
set colsep ";"
spool c:\pend.spl

Select	substr(a.contract_ref_no,1,3) br, a.module md,
		a.contract_ref_no rn, '' mt, b.event_descr ev, maker_id id
from	XAFNFC.cstbs_contract_event_log a, cstbs_event b
where	a.event_code = b.event_code
	and a.module = b.module and a.contract_status <> 'H'
	and	a.module <> 'SI' and a.event_seq_no =
					(
					Select	min(event_seq_no)
					from	XAFNFC.cstbs_contract_event_log
					where	contract_ref_no = a.contract_ref_no
					and		auth_status = 'U'
					) ;

Select	branch_code br, 'MA' md, object_desc rn,'' mt, '' ev, '' id
from	XAFNFC.stvws_unauth_forms ;

select * from XAFNFC.sttb_record_log where auth_stat = 'U';

select "BR","MD","RN","MT","EV","ID" from XAFNFC.devws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.cyvws_pending_items ;

select distinct brn,'IC',NULL,NULL,eipkss.get_txt('IC-ED0006'),NULL
from XAFNFC.icvws_inv_acc0 ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.lqvws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.cavws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.sivws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.mivws_pending_items ;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.acvws_pending_items ;

select 	branch_code br,'DE' md, batch_no||nvl(description,'  '||description) rn, '' mt,'Unauthorized' ev,last_oper_id id
	from XAFNFC.detbs_batch_master where auth_stat = 'U';

select 	branch_code br,'DE' md, till_id||' '||tv_name rn,
	''mt,eipkss.get_txt('DE-TB01') ev, user_id
	from XAFNFC.detms_til_vlt_master where balanced_ind = 'N';

select * from XAFNFC.actbs_daily_log where auth_stat = 'U' and delete_stat <> 'D';

select auth_stat, count(*) from XAFNFC.sttb_record_log group by auth_stat;

select auth_stat,function_id, count(*) from XAFNFC.sttb_record_log 
where auth_stat='U'
group by auth_stat,function_id;


select "BR","MD","RN","MT","EV","ID" from XAFNFC.csvws_pending_items;

select substr(a.match_ref_no,1,3) br,'RE' md, a.match_ref_no rn, '' mt,
       a.event ev, a.maker_id id
from	XAFNFC.retbs_match_event_log a
where a.checker_id is null;

select substr(a.reference_number,1,3) br,'FS' md, a.reference_number rn, '' mt,
       '' ev, a.maker_id id
from     XAFNFC.fstbs_cls_status_browser a
where	 a.maker_id is not null
and	 a.checker_id is null;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.REFVWS_PENDING_ITEMS;

select "BR","MD","RN","MT","EV","ID" from XAFNFC.PCVWS_PENDING_ITEMS;

SELECT  DISTINCT
            ed.BRANCH_CODE "BR",
            'CL' "MD",
            ed.ACCOUNT_NUMBER "RN",
            NULL "MT",
            ed.event_code "EV",
            ed.MAKER_ID "ID"
            from XAFNFC.CLTB_ACCOUNT_EVENTS_DIARY ed
            WHERE ed.AUTH_STATUS='U' AND
                  ed.EVENT_SEQ_NO IS NOT NULL;

SELECT 	branch,  'MS', reference_no, dcn, 'Unauthorized', maker_id
  FROM 	XAFNFC.mstbs_dly_msg_out
WHERE  branch_date = GLOBAL.application_date 
     AND PDE_status = 'Y';

SELECT branch, 'MS', reference_no, dcn, 'Unauthorized', maker_id
  FROM XAFNFC.mstbs_dly_msg_in
WHERE branch_date = GLOBAL.application_date 
    AND PDE_status = 'Y';
                  
SELECT branch br,'MS' md, reference_no rn, msg_type mt, '' ev, maker_id id
FROM XAFNFC.mstbs_dly_msg_out
WHERE hold_status='Y' and msg_status <> 'C' and suppress_flag = 'N';

PROMPT SELECTING FROM EIVW_PENDIG_ITEMS ALSO AS THE SITE VIEW MIGHT HAVE SOME CUSTOMIZATIONS

SELECT * FROM XAFNFC.EIVW_PENDING_ITEMS;

@C:\$$$.SQL

spool off