/* Branch Transaction for the current branch Date */

select txn_mast.branchcode BRANCH,
       txn_mast.postingdate POSTING_DATE, 
       txn_mast.functionid FUNCTION_ID,
       txn_mast.xrefid Branch_reference_no,
        txn_mast.txnstatus TRANSACTION_STATUS,
       txn_mast.makerid MAKER_ID,
       txn_mast.checkerid CHECKER_ID,
       TXN_DETAIL.Ccycode CCY,
       sum( (TXN_DETAIL.Inflow*ccy_denom.denomination_value)) INFLOW,
       sum((TXN_DETAIL.Outflow*ccy_denom.denomination_value))OUTFLOW
from  fbtb_txnlog_master txn_mast , fbtb_till_txn_detail TXN_DETAIL , fbtb_ccy_denom ccy_denom
where txn_mast.postingdate= '&posting_date'
and   txn_mast.makerid    = '&teller_id'     
and   txn_mast.branchcode = TXN_DETAIL.Branchcode
and   txn_mast.xrefid=TXN_DETAIL.Xref
/* and   txn_mast.postingdate=TXN_DETAIL.Postingdate
and   ccy_denom.ccy_code =  TXN_DETAIL.Ccycode */
and   ccy_denom.denomination_code = TXN_DETAIL.Denomcode
and   txn_mast.txnstatus ='COM'
group by txn_mast.branchcode, txn_mast.postingdate, txn_mast.functionid , txn_mast.xrefid,
         TXN_DETAIL.Ccycode , txn_mast.txnstatus,txn_mast.stagestatus, txn_mast.makerid,txn_mast.checkerid
order by xrefid,ccycode


/* Branch Transaction from history Tables */

select  txn_mast.branchcode BRANCH,
       txn_mast.postingdate POSTING_DATE, 
       txn_mast.functionid FUNCTION_ID,
       txn_mast.xrefid Branch_reference_no,
        txn_mast.txnstatus TRANSACTION_STATUS,
       txn_mast.makerid MAKER_ID,
       txn_mast.checkerid CHECKER_ID,
       TXN_DETAIL.Ccycode CCY,
       sum( (TXN_DETAIL.Inflow*ccy_denom.denomination_value)) INFLOW,
       sum((TXN_DETAIL.Outflow*ccy_denom.denomination_value))OUTFLOW
from  fbvw_all_txnlog_master txn_mast , fbvw_all_till_txn_detail TXN_DETAIL , fbtb_ccy_denom ccy_denom
where txn_mast.postingdate= '&posting_date'
and   txn_mast.makerid    = '&teller_id'     
and   txn_mast.branchcode = TXN_DETAIL.Branchcode
and   txn_mast.xrefid=TXN_DETAIL.Xref
/* and   txn_mast.postingdate=TXN_DETAIL.Postingdate
and   ccy_denom.ccy_code =  TXN_DETAIL.Ccycode */
and   ccy_denom.denomination_code = TXN_DETAIL.Denomcode
and   txn_mast.txnstatus ='COM'
group by txn_mast.branchcode, txn_mast.postingdate, txn_mast.functionid , txn_mast.xrefid,
         TXN_DETAIL.Ccycode , txn_mast.txnstatus,txn_mast.stagestatus, txn_mast.makerid,txn_mast.checkerid
order by xrefid,ccycode


