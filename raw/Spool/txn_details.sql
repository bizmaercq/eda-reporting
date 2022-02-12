set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999
SPOOL c:\txn_details.SPL


select * from fbtb_till_totals where branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

select * from fbtb_till_txn_detail where branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

select * from fbtb_till_txn_detail_hist where branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

select branchcode,postingdate,functionid,xrefid,txnstageid,locked,lockedby,lockedtime,txnstatus,stagestatus,reconciled,
onlinestatus,eligible,assignedto,wfinitdate,wfenddate,stagestartdate,makerid,checkerid,checkerdatestamp from fbtb_txnlog_master where functionid in ('9007','9008') and branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

select branchcode,postingdate,functionid,xrefid,txnstageid,locked,lockedby,lockedtime,txnstatus,stagestatus,reconciled,
onlinestatus,eligible,assignedto,wfinitdate,wfenddate,stagestartdate,makerid,checkerid,checkerdatestamp from fbtb_txnlog_master_hist where functionid in ('9007','9008') and branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

select * from acvw_all_ac_entries where ac_branch in ('030','031')
and trn_dt = to_date('19-OCT-2012','DD-MON-RRRR') and external_ref_no in 
(select xref from fbtb_till_txn_detail where branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR')
union
select xref from fbtb_till_txn_detail_hist where branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR'));

set echo off
spool off
