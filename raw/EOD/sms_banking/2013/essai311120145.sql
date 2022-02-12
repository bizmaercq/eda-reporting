select cc.TRN_REF_NO||'|'||cc.amount_tag||'|'||cc.TXN_INIT_DATE||'|'||cc.trn_dt||'|'||rownum||'|'||cc.AC_NO||'|'||cc.LCY_AMOUNT||'|'||decode(cc.DRCR_IND,'D','DEBIT','C','CREDIT')||'|'||cc.USER_ID||'|'||cc.AUTH_ID 
from xafnfc.acvw_all_ac_entries cc
where cc.TRN_DT between :ddate and :fdate;

