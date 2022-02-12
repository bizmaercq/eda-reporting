accept VAL_DATE PROMPT 'Enter value the of date >'
 

declare cursor c1 is (SELECT distinct cc.branch_code,cc.ccy1,cc.ccy2,cc.mid_rate,cc.rate_date FROM XAFNFC.CYTB_RATES_HISTORY cc
where cc.RATE_DATE = (SELECT MAX(RATE_DATE) FROM CYTB_RATES_HISTORY WHERE RATE_DATE <= '&VAL_DATE') );

begin

delete from xafnfc.temp_rate;
for var_c1 in c1 loop

insert into xafnfc.temp_rate values (
var_c1.branch_code,var_c1.ccy1,var_c1.ccy2,var_c1.mid_rate, var_c1.rate_date);

END LOOP;

COMMIT;

end;
/
