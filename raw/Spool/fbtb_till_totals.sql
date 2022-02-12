set array 1
set line 1000
set head on
set pagesize 10000
set colsep ';'
SPOOL C:\DE_TILL1.SPL

prompt fbtb_till_totals

select * from fbtb_till_totals where postingdate ='&postingdate';


SPOOL OFF