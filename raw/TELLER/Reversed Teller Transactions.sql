select t.branchcode BRANCH ,t.postingdate,t.xrefid REFERENCE,h.trn_code,t.txnbrndet ACCOUNT,t.txnactdet ACCOUNT,t.txnamtdet AMOUNT,t.txnccydet CCY,t.makerid MAKER,t.checkerid CHEKER,t.txnstatus STATUS
from fbtb_txnlog_master_hist t, (select distinct external_ref_no,trn_code from actb_history) h
where t.xrefid = h.external_ref_no
and t.txnstatus ='REV'
