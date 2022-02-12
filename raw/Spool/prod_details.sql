set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.999
SPOOL c:\prod_details.SPL

select * from cstm_product where product_code in ('SCCB','MSGC')
select * from fbtb_arc_maint where cod_prod_acc_cls in ('SCCB','MSGC');
select * from detm_til_vlt_ccy_params where branch_code in ('030','031');
select branchcode,postingdate,functionid,xrefid,txnstageid,locked,lockedby,lockedtime,txnstatus,stagestatus,reconciled,
onlinestatus,eligible,assignedto,wfinitdate,wfenddate,stagestartdate,makerid,checkerid,checkerdatestamp from fbtb_txnlog_master_hist 
where functionid in ('9007','9008','9009','9010') and branchcode in ('030','031')
and postingdate = to_date('19-OCT-2012','DD-MON-RRRR');

set echo off
spool off
