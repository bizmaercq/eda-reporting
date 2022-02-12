select a.branch_code,p.fon_matricule,c.customer_name1,'1002500'||a.cust_ac_no RIB,a.ac_desc,a.lcy_curr_balance solde_en_compte,a.tod_limit autorisation,b.balance encours_engagement,sum(nvl(s.amount,0)) engagement_initial,sum(nvl(s.emi_amount,0)) engagement_mensuel
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s, paie_fonctionnaire@delta_link p
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and a.cust_ac_no = p.fon_fcubs_account
and b.component='PRINCIPAL'
--and a.cust_ac_no='0402820102632321'
and a.cust_ac_no in
('0422820103399852',
'0402820102580529',
'0402820102704004',
'0302820104319592',
'0212820100833062',
'0202820100249816',
'0202820100595330')
and b.balance<>0
group by a.branch_code,p.fon_matricule,c.customer_name1,a.cust_ac_no,a.ac_desc,a.lcy_curr_balance,a.tod_limit,b.balance
order by a.branch_code,c.customer_name1
