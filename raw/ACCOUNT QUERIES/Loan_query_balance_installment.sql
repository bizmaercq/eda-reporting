select a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,a.lcy_curr_balance solde_en_compte,a.tod_limit autorisation,sc.lcy_amount salaire,b.balance encours_engagement,sum(nvl(s.amount,0)) engagement_initial,sum(nvl(s.emi_amount,0)) engagement_mensuel
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s,
 (SELECT h.ac_no,h.lcy_amount FROM actb_history h WHERE h.trn_dt ='24/08/2016' and h.trn_code ='SAL' and h.drcr_ind ='C') sc
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and a.cust_ac_no = sc.ac_no
and b.component='PRINCIPAL'
--and a.cust_ac_no='0212820100839270'
and a.cust_ac_no in('0422820103383944',
'0202820100248361',
'0213728023546055',
'0212820100787666',
'0202820100210046',
'0422820103402471',
'0202820100244578',
'0212820101072458',
'0202820100696695',
'0422820103405672',
'0202820100107517',
'0502820103881822',
'0202820100308792',
'0212820100859834',
'0212820100992142',
'0302820104319592',
'0212820100833838',
'0202820100086080',
'0212820100849164',
'0212820101108542',
'0402820102960181',
'0212820100912020',
'0432820104539005',
'0422820103401307',
'0202820100305397',
'0402820102704004',
'0212820100937240',
'0212820100989329',
'0212820100928316',
'0302820102051538',
'0212820101119115',
'0212820100900962',
'0212820100918422',
'0212820100861386',
'0422820103391607',
'0202820100092967',
'0212820100986031',
'0212820100818609',
'0212820100933457',
'0402820102551326',
'0202820100229155',
'0422820103399852',
'0202820104175309',
'0212820100823944',
'0202820200296489',
'0422820103552045',
'0202820100682436')
and b.balance<>0
group by a.branch_code,c.customer_name1,a.cust_ac_no,a.ac_desc,a.lcy_curr_balance,a.tod_limit,sc.lcy_amount,b.balance
--having sum(nvl(s.emi_amount,0)) > sc.lcy_amount/3
order by a.cust_ac_no;


 

