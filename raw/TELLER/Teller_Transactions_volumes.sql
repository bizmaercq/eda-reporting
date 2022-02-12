--- Detail
SELECT trunc(tl.timestamp) Txn_Date, tl.branchcode, tl.userid, fd.description,count(*)
FROM fbtb_txnlog_details_hist tl , FBTB_FUNCTION_DESCRIPTION fd
WHERE tl.functionid = fd.function_id
and tl.txnstatus in ('COM','DIS')
and trunc(tl.timestamp) between '01-jan-2017' and '15-mar-2018'
group by trunc(tl.timestamp),tl.branchcode, tl.userid, fd.description
order by tl.branchcode,tl.userid;

--- Summary
SELECT trunc(tl.timestamp) Txn_Date, tl.branchcode, fd.description,count(*)
FROM fbtb_txnlog_details_hist tl , FBTB_FUNCTION_DESCRIPTION fd
WHERE tl.functionid = fd.function_id
and tl.txnstatus in ('COM','DIS')
and trunc(tl.timestamp) between '01-jan-2017' and '15-mar-2018'
group by trunc(tl.timestamp),tl.branchcode,  fd.description
order by to_date(trunc(tl.timestamp),'DD/MM/YYYY') ,tl.branchcode;

