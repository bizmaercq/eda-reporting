set head on
set colsep ";"
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
spool c:\FBTB_details.spl

select * from fbtb_txnlog_details 
where xrefid in (select external_ref_no from actb_daily_log where trn_dt='26/10/2012') ;

select * from fbtb_txnlog_master 
where xrefid in (select external_ref_no from actb_daily_log where trn_dt='26/10/2012') ;

select * from fbtb_txnlog_details_hist 
where xrefid in (select external_ref_no from actb_daily_log where trn_dt='26/10/2012') ;

spool off
