--- Liste des dépots

SELECT ac.description,ca.branch_code,ca.cust_ac_no,ca.ac_desc,ca.ac_open_date,ca.record_stat
from sttm_cust_account ca, sttm_account_class ac
WHERE ac.account_class = ca.account_class 
and substr(ca.account_class,1,1)  in ('1','2','3','5','0')
and ca.ac_open_date<='30-JUN-2017'
and ca.record_stat='O'
order by ac.account_class,ca.branch_code,ca.cust_ac_no;


-- liste des crédits
SELECT am.ACCOUNT_NUMBER , cu.customer_name1,am.BOOK_DATE,am.VALUE_DATE,am.MATURITY_DATE,am.AMOUNT_FINANCED,uv.ude_value
FROM  cltb_account_master am,cltb_account_ude_values uv,sttm_customer cu
WHERE am.ACCOUNT_NUMBER = uv.account_number 
and am.CUSTOMER_ID = cu.customer_no
and uv.ude_id ='INTEREST_RATE'
and am.BOOK_DATE between '01-JAN-2017' and '30-JUN-2017' ;

-- Liste des découvert special rate

select r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date,p.ude_value
from gltb_cust_acc_breakup r, sttm_cust_account y,ICTM_ACC_UDEVALS P
where /*r.period_code='M06' and*/ r.fin_year='FY2017' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01-JAN-2017' and '30-JUN-2017'
--AND p.ude_id='OD_RATE' AND R.CUST_AC_NO=P.ACC
and r.cust_ac_no=y.cust_ac_no
AND Y.CUST_AC_NO=P.ACC
AND P.UDE_VALUE<>'0'
AND P.UDE_ID='OD_RATE';

-- Normal Rate

select r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date 
from gltb_cust_acc_breakup r, sttm_cust_account y
where /*r.period_code='M12' and*/ r.fin_year='FY2017' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01-JAN-2017' and '30-JUN-2017'
--AND p.ude_id='OD_RATE' AND R.CUST_AC_NO=P.ACC
and r.cust_ac_no=y.cust_ac_no;

SELECT * FROM sttm_cust_account WHERE cust_no ='014314'


-- Saving accounts opened
select a1.account,cu.customer_name1,ca.ac_open_date,a1.lcy_closing_bal,a2.lcy_closing_bal Open_Balance 
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu, actb_accbal_history a2
where a1.account = ca.cust_ac_no
and a2.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and a1.bkg_date >= all (select bkg_date from actb_accbal_history a3 where a1.account = a3.account and a3.bkg_date <='&As_Of_Date')
and a2.bkg_date <= all (select bkg_date from actb_accbal_history a4 where a1.account = a4.account and a4.bkg_date <='&As_Of_Date')
and a1.bkg_date <= '&As_Of_Date'
and a1.lcy_closing_bal > 0
and length(a1.account) = 16
and substr(ca.account_class,1,2) ='38'
and ca.ac_open_date between '01-JAN-2017' and '30-JUN-2017'
order by a1.lcy_closing_bal desc;

-- Bons de caisse

select a1.account,cu.customer_name1,a1.bkg_date,ca.ac_open_date,a1.lcy_closing_bal,
(
       SELECT SUM(T.LCY_AMOUNT) FROM ACVW_ALL_AC_ENTRIES T WHERE a1.account = T.RELATED_ACCOUNT AND T.AC_NO LIKE '359%' AND T.VALUE_DT between '01-JAN-2017' and '30-JUN-2017' AND T.RELATED_ACCOUNT=a1.account AND T.TRN_CODE='FDA'
) "Intérêt provisioné"
from actb_accbal_history a1 , sttm_cust_account ca, sttm_customer cu
where a1.account = ca.cust_ac_no
and ca.cust_no = cu.customer_no
and bkg_date >= all (select bkg_date from actb_accbal_history a2 where a1.account = a2.account and a2.bkg_date <='&As_Of_Date')
and a1.bkg_date <= '&As_Of_Date'
and a1.lcy_closing_bal > 0
and length(a1.account) = 16
and substr(ca.account_class,1,1) ='5'
and ca.ac_open_date between '01-JAN-2017' and '30-JUN-2017'
order by a1.lcy_closing_bal desc;

-- Bon de caisse avec montant provisionné / Time deposit -- 
SELECT y.branch_code,y.gl_code,y.cust_ac_no,x.customer_Name,x.Date_of_Open,x.TD_Maturity_date, x.Deposit_amount,s.ude_value INTEREST_RATE,x.Total_interest_Payable
FROM gltb_cust_accbreakup y, tdvw_td_details x,ictm_acc_udevals s where y.gl_code like '54%'-- and y.period_code='M06'
and y.fin_year='FY2017' and y.cr_bal_lcy<>'0'
and s.ude_id='INT_RATE'
and x.TD_Maturity_date between '01-JAN-2017' and '30-JUN-2017'
and y.cust_ac_no=x.Account_no
AND X.Account_no=S.ACC


-- Dat
SELECT ACCOUNT_NO,
       CUSTOMER_NAME,
       TO_CHAR(TRUNC(DATE_OF_OPEN), 'dd/MM/YYYY') OPEN_DATE,
       bipks_report.fn_get_TD_Rate(branch_code,account_no) TD_RATE,
       DEPOSIT_AMOUNT,
       TO_CHAR(TRUNC(TD_MATURITY_DATE), 'dd/MM/YYYY') maturity_date,
       TOTAL_INTEREST_PAYABLE,
       MATURITY_AMOUNT, TD.branch_code, TD.product_code, TD.Product_Title
 FROM TDVW_TD_DETAILS TD
 WHERE /*TRUNC(CHECKER_DT)*/TD.TD_Maturity_date BETWEEN '01-JAN-2017' and '30-JUN-2017'
 --and RECORD_STAT = 'O' 
 --DEPOSIT_AMOUNT <> MATURITY_AMOUNT
 ORDER BY BRANCH_NAME, PRODUCT_CODE;

-- Fx sale and purchase

select 
a.Trn_dt,a.trn_ref_no,a.xref,cu.customer_name1,a.txn_acc, pr.product_description,a.txn_ccy,a.ofs_ccy,a.exch_rate,
a.txn_amount,a.ofs_amount,
a.ofs_acc Credit_Account,
a.txn_acc Debit_Account,
a.benef_name--,
--(select ac.AC_DESC from xafnfc.sttm_cust_account ac where a.TXN_ACC = ac.CUST_AC_NO) Account_Description
from XAFNFC.detb_rtl_teller a, sttm_customer cu, cstm_product pr
where cu.customer_no = a.rel_customer
and a.product_code = pr.product_code
and (a.product_code in( 'FXPW','FXSW','FXSB','FXFX','FXFW') or (a.txn_ccy <> a.ofs_ccy and a.product_code in ('CHDP','CHWL')))
and a.trn_dt  between '01-JAN-2017' and '30-JUN-20117';

--- journal entries
SELECT ae.TRN_REF_NO "ID Transaction" ||'|'||acpks_stmt.fn_get_rtl_narrative_desc(ae.TRN_REF_NO,
                                                   ae.MODULE,
                                                   'TXN',
                                                   ae.TRN_CODE,
                                                   'ENG',
                                                   Ae.AC_NO,
                                                   Ae.AC_BRANCH,
                                                   ae.ac_ccy,
                                                   ae.trn_dt,
                                                   Ae.LCY_AMOUNT) "Description"
           ||'|'|| ae.TRN_DT "date de la transaction"||'|'||ae.VALUE_DT "Date de valeur"||'|'||ae.USER_ID||'|'||
           ae.AC_ENTRY_SR_NO "Ligne journal"||'|'||ae.AC_NO "Compte grand-livre"||'|'||
           case when ae.DRCR_IND ='D' then ae.LCY_AMOUNT end "DEBIT" ||'|'||
           case when ae.DRCR_IND ='C' then ae.LCY_AMOUNT end "CREDIT" ||'|'||ae.USER_ID||'|'||ae.AUTH_ID
           FROM acvw_all_ac_entries ae WHERE  ae.module ='DE' AND  ae.VALUE_DT between '01-JAN-2016' and '30-JUN-2016'
  order by ae.TRN_REF_NO ASC ;


-- Balances as of date

--- Detailed
select aa.branch_code,aa.account,c.customer_name1,aa.bkg_date LAST_MVT_DATE,'&Date' Period_End_Date, aa.lcy_closing_bal from
actb_accbal_history aa , sttm_customer c
where substr(aa.account,9,6) = c.customer_no 
and aa.bkg_date =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&Date' 
and a.account = aa.account)
--and aa.account = '&Account'
and aa.account in
(select ac.cust_ac_no from sttm_cust_account ac where substr(ac.account_class,1,1)in ('3') and ac.record_stat ='O');

--- TOD history
SELECT * FROM  sttb_cust_tod_hist 
where 
appl_date  between '01/01/2015' and '30/06/2015'
and account_no in
('0202820100318007',
'0202820100347786',
'0202820100076089',
'0202820100087535',
'0202820100310732',
'0212820101153841',
'0402820102503505',
'0402820102506997',
'0502820103880367',
'0502820103881143',
'0502820103881434',
'0502820103882016',
'0502820103882210',
'0502820103882404',
'0502820103882986')
order by account_no,appl_date;

--- Users and roles
SELECT distinct us.user_id,us.user_name,ur.role_id ,us.start_date, decode(us.user_status,'E','ENABLED','D','DISABLED','LOCKED') Status,
us.last_signed_on,us.pwd_changed_on,us.record_stat, us.end_date
FROM smtb_user us,smtb_user_role ur 
WHERE us.user_id = ur.user_id 
and substr(us.user_id,1,1) not in ('1','2','3','4','5','6','7','8','9')
--and ur.role_id in ('ALLROLES','EOC_INPUT','EOD')
order by us.user_id;

-- Roles
SELECT role_id,role_description FROM smtb_role_master order by role_id;

-- Audit
SELECT to_date(lh.start_time,'DD/MM/YYYY')||'|'||lh.user_id||'|'||lh.start_time||'|'||lh.end_time||'|'||lh.function_id||'|'|| fd.description 
FROM smtb_sms_log_hist lh,smtb_function_description fd
WHERE lh.function_id = fd.function_id
and to_date(start_time,'DD/MM/YYY')  between '01/01/2015' and '30/06/2015'
order by to_date(lh.start_time,'DD/MM/YYYY'),lh.user_id;


--- Scripts Flexcube 

SELECT distinct mi.function_id,mi.module_id,decode(mi.frequency,'D','DAILY','M','MONTHLY','YEARLY') FROM eitm_modules_installed mi order by mi.function_id;

--- Account blocks and amount blocks

SELECT  ab.amount_block_no,ab.effective_date,cu.customer_name1,ab.account,ab.amount,ab.remarks ,ab.maker_id,ab.checker_id
FROM catm_amount_blocks ab , sttm_customer cu
WHERE cu.customer_no = substr(ab.account,9,6)
and ab.maker_id <>'SYSTEM'
and ab.effective_date  between '01/01/2015' and '30/06/2015'
order by ab.effective_date;

SELECT ac.cust_ac_no,ac.ac_desc,ac.ac_stat_no_dr FROM sttm_cust_account ac where ac.ac_stat_no_dr = 'Y';

select table_name from user_tables where table_name like '%BLOCK%';

--- miscellaneous queries
SELECT ae.TRN_DT,ae.VALUE_DT,ae.trn_ref_no,ae.AC_NO,tc.trn_desc,ae.LCY_AMOUNT 
FROM acvw_all_ac_entries ae , sttm_trn_code tc
where ae.TRN_CODE = tc.trn_code
and ae.trn_dt between  '01/01/2015' and '31/12/2015'
and length(ae.ac_no)<>9
and ae.TRN_CODE ='CRI' 
order by trn_dt;

SELECT * from acvw_all_ac_entries;

SELECT DISTINCT BRN,
                ACC,
                BRN_DATE,
                NVL(RTRIM(SUBSTR(OLD_VAL, 5), '~'), 0) OLD_TOD,
                NVL(RTRIM(SUBSTR(NEW_VAL, 5), '~'), 0) NEW_TOD
FROM ictb_acc_action
WHERE BRN = '023'
AND ACC = '0212820100758081'
AND KEY_VAL LIKE '%ACCOUNT_TOD%'
ORDER BY BRN_DATE;

SELECT ac.branch_code,  ACCOUNT_NO,ac.account_class,ac.cr_gl,
       CUSTOMER_NAME,
       TO_CHAR(TRUNC(DATE_OF_OPEN), 'dd/MM/YYYY') DATE_OPEN,
       bipks_report.fn_get_TD_Rate(td.branch_code,td.account_no) RATE,
       DEPOSIT_AMOUNT,
       TO_CHAR(TRUNC(TD_MATURITY_DATE), 'dd/MM/YYYY') MATURITY_DATE,
       TOTAL_INTEREST_PAYABLE,
       MATURITY_AMOUNT
 FROM TDVW_TD_DETAILS TD,sttm_cust_account ac
 WHERE td.Account_no = ac.cust_ac_no
 and (TRUNC(TD.TD_Maturity_date)>= '31-DEC-2015' )
 and (TRUNC(DATE_OF_OPEN)  <= '31-DEC-2015')
 --and td.MATURITY_AMOUNT <> td.Deposit_amount
 and td.RECORD_STAT = 'O'
 order by td.Date_of_Open;


select aa.account,ac.ac_desc,ac.ac_stat_no_dr,/*aa.bkg_date LAST_MVT_DATE,*/'&Date' Period_End_Date,
case when aa.lcy_closing_bal <0 then -nvl(aa.lcy_closing_bal,0) end Debit_Balance,
case when aa.lcy_closing_bal >0 then nvl(aa.lcy_closing_bal,0) end Credit_Balance
from
actb_accbal_history aa , sttm_cust_account ac
where aa.account = ac.cust_ac_no 
and aa.bkg_date =
(select max(a.bkg_date) from actb_accbal_history a 
where a.bkg_date <= '&Date' 
and a.account = aa.account)
and ac.ac_stat_no_dr ='Y'
and nvl(aa.lcy_closing_bal,0)<>0
order by aa.branch_code, aa.account;

SELECT * FROM sttm_account_class c order by c.account_class;

SELECT * from smtb_user WHERE user_id ='FATEKWANA' FOR UPDATE NOWAIT; 

SELECT U.User_Id, U.START_DATE, U.User_Name, U.Last_Signed_On, U.Home_Branch, U.  from smtb_user U


/********************** Update AOUT 2016 *********************/

/** New DAT **/
SELECT D.*, d.Account_no, d.customer_Name,d.value_date Date_de_debut, d.TD_Maturity_date  "Date d'échéance", tt.ude_value "Taux intérêt", d.Projected_Interest  "Montant intérêt" 
,(
       SELECT SUM(T.LCY_AMOUNT)/*, T.RELATED_ACCOUNT*/ FROM ACVW_ALL_AC_ENTRIES T WHERE d.account_no = T.RELATED_ACCOUNT AND T.AC_NO LIKE '369%' AND T.VALUE_DT between '01-01-2016' and '30-06-2016'  AND T.TRN_CODE='FDA' GROUP BY T.RELATED_ACCOUNT
) "Intérêt provisionné"

from tdvw_td_details d, ictm_acc_udevals tt  
where d.Account_no=tt.acc 
AND tt.ude_id='INT_RATE' 
AND date_of_open between '01-01-2016' AND '30-06-2016'

-- Découvert taux Spéciaux
select r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date,p.ude_value INTEREST_RATE
from gltb_cust_acc_breakup r, sttm_cust_account y,ICTM_ACC_UDEVALS P
where r.period_code='M06'  and r.fin_year='FY2016' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01-01-2016' and '30-06-2016'
--AND p.ude_id='OD_RATE' AND R.CUST_AC_NO=P.ACC
and r.cust_ac_no=y.cust_ac_no
AND Y.CUST_AC_NO=P.ACC
AND P.UDE_VALUE<>'0'
AND P.UDE_ID='OD_RATE'

--OD - Découvert taux Normal
select r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date from gltb_cust_acc_breakup r, sttm_cust_account y
where r.period_code='M06' and r.fin_year='FY2016' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01-01-2016' and '30-06-2016'
--AND p.ude_id='OD_RATE' AND R.CUST_AC_NO=P.ACC
and r.cust_ac_no=y.cust_ac_no;

--- Loans

SELECT ca.cust_ac_no, ca.ac_desc, am.account_number,am.book_date,am.amount_financed,am.value_date, am.maturity_date ,uv.ude_value "INTEREST"
FROM cltb_account_master am , CLTB_ACCOUNT_UDE_VALUES uv, sttm_cust_account ca
WHERE am.account_number = uv.account_number 
and ca.cust_ac_no = am.dr_prod_ac
and uv.ude_id ='INTEREST_RATE'
and am.BOOK_DATE between  '01-JAN-2017' and '30-JUN-2017'
order by book_date ;



---- Accounting entries
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT, a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
--where substr(a.AC_NO,1,3) = '359'   
where substr(a.AC_NO,1,9) between '350000000' and '369999999'
and  a.TRN_DT  between '01-JAN-2017' and '30-JUN-2015';

- date de saisie de l'écriture ;
- date comptable de l'écriture ;
- périodes comptables sur un exercice ;
- libellé du compte comptable ;
- numéro du compte comptable ;
- regroupement client de compte comptable ;
- identifiant de l'utilisateur ayant saisi l'écriture ;
- nom de l'utilisateur ayant saisi l'écriture ;
- devise du montant ;
- champ permettant de déterminer si le montant est débité ou crédité ;
- nom du journal ;
- libellé de l'écriture ;
- numéro de l'écriture ;
- libellé de la ligne de l'écriture ;
- numéro de la ligne de l'écriture ;
- identifiant de l'utilisateur ayant mis à jour l'écriture ;
- nom de l'utilisateur ayant mis à jour l'écriture ;
- montant de la transaction (exprimé en valeur absolue) ;
- montant débité ;
- montant crédité ;
