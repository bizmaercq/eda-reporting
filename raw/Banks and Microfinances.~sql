select cust_ac_no ACCOUNT, ac_desc,decode ( length(alt_ac_no),16, null,alt_ac_no ) "DELTA ACCOUNT" , acy_opening_bal "OPENING BALANCE", lcy_curr_balance "CURRENT BALANCE" ,dr_gl,cr_gl 
from sttm_cust_account where ( dr_gl in ('543902100','561910000','561221000','561921000','561933000','583001000')
 or cr_gl in ('543902100','561910000','561221000','561921000','561933000','583001000') )
 and lcy_curr_balance <>0
