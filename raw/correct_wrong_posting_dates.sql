--- updates following wrong posting dates

SELECT * FROM actb_daily_log dl WHERE dl.trn_dt ='02/01/2020' and dl.module ='RT';
update actb_daily_log dl set dl.trn_dt='31/12/2019',dl.value_dt='31/12/2019'  WHERE dl.trn_dt ='02/01/2020' and dl.module ='RT';

SELECT * FROM fbtb_txnlog_master tm WHERE tm.postingdate ='02/01/2020';
update fbtb_txnlog_master tm set tm.postingdate='31/12/2019' WHERE tm.postingdate ='02/01/2020';


SELECT * FROM fbtb_till_totals tt WHERE tt.postingdate ='31/12/2019' and tt.branchcode='023';
update  fbtb_till_totals tt set tt.postingdate='31/12/2019' WHERE tt.postingdate ='02/01/2020' ;

SELECT * FROM fbtb_till_txn_detail td WHERE td.postingdate ='02/01/2020';
update fbtb_till_txn_detail td set td.postingdate='31/12/2019' WHERE td.postingdate ='02/01/2020';

SELECT * FROM actbs_daily_log dl WHERE dl.trn_dt ='02/01/2020'

SELECT * FROM fbtbs_till_totals tt WHERE tt.postingdate ='31/12/2019' and tt.branchcode='023'


commit;
