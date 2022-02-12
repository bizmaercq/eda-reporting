----57 caise
select q.branch_code,q.gl_code,q.ccy_code,q.dr_bal_lcy,q.cr_bal_lcy from gltb_gl_bal q 
where q.gl_code like'57%' and q.fin_year='FY2019' 
and q.period_code='M11' --and q.dr_bal_lcy<>'0'
and q.leaf='Y' and (q.dr_bal_lcy<>'0' or q.cr_bal_lcy<>'0')
----56 caise 
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M11'
and r.gl_code like '56%'
--and  r.cr_bal_lcy<> '0'
and r.dr_bal_lcy<> '0'
union
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M11'
and r.gl_code like '56%'
and  r.cr_bal_lcy<> '0'
--and r.dr_bal_lcy<> '0'
----- grand livre manuelle
select  a.AC_BRANCH,a.module, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a
where substr(a.AC_NO,1,9) like '72%'
--where substr(a.AC_NO,1,9) between '200000000' and '249999999'
and a.TRN_DT between '01/01/2019' and '31/12/2019'
and a.module in('DE')
order by a.AC_BRANCH,a.trn_dt
---35 echu 36,54 depot � terme echu
SELECT  distinct ee.branch_code,
      ee.gl_code,
      ee.cust_ac_no,
      aa.ac_desc,
      ee.cr_bal_lcy,
      tt.Date_of_Open,
      tt.TD_Maturity_date,
      tt.Total_interest_Payable,
      tt.Projected_Interest,
      tt.record_stat,
      y.ude_value
 FROM gltb_cust_acc_breakup ee,
      sttm_cust_account     aa,
      tdvw_td_details       tt,
      ictm_acc_udevals      y
where ee.gl_code like '35%'
  and ee.fin_year = 'FY2019'
  --and ee.period_code = 'M12'
  and ee.cr_bal_lcy <> '0'
  and ee.cust_ac_no = aa.cust_ac_no
  and ee.cust_ac_no = tt.Account_no
  and tt.Account_no = y.acc
  and tt.Date_of_Open between '01/12/2019' and '14/12/2019'
  and y.ude_id='INT_RATE'

-----56 et 37  compte client crediteur ou solde d'un compte a une date donn�e
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M12'
and r.gl_code like '37%'
and  r.cr_bal_lcy<> '0'
----36 term deposit encours, 35 time deposit encours et 54 time and term deposit microfinance
SELECT  distinct ee.branch_code,
      ee.gl_code,
      ee.cust_ac_no,
      aa.ac_desc,
      ee.cr_bal_lcy,
      tt.Date_of_Open,
      tt.TD_Maturity_date,
      tt.Total_interest_Payable,
      tt.Projected_Interest,
      tt.record_stat,
      y.ude_value
 FROM gltb_cust_acc_breakup ee,
      sttm_cust_account     aa,
      tdvw_td_details       tt,
      ictm_acc_udevals      y
where ee.gl_code like '36%'
  and ee.fin_year = 'FY2019'
  and ee.period_code = 'M12'
  and ee.cr_bal_lcy <> '0'
  and ee.cust_ac_no = aa.cust_ac_no
  and ee.cust_ac_no = tt.Account_no
  and tt.Account_no = y.acc
 -- and tt.TD_Maturity_date >='30/11/2019'
  and y.ude_id='INT_RATE'
------transfert et virement � linternationale
select * from fttb_contract_master az where az.contract_ref_no like '%FT%' and az.accounting_date between '01/01/2019' and '30/11/2019'
---achat de devise
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
and a.trn_dt  between '01/01/2019' and '30/11/2019'
-----loan encours
SELECT am.BRANCH_CODE,cu.customer_no,cu.customer_name1, am.ACCOUNT_NUMBER,am.BOOK_DATE, am.AMOUNT_FINANCED,'&Date' "As_Of_Date", cb.balance
FROM cltb_account_comp_balances cb , cltb_account_master am, sttm_customer cu
WHERE am.ACCOUNT_NUMBER = cb.account_number
and am.CUSTOMER_ID = cu.customer_no
--and am.MATURITY_DATE >= sysdate -- ongoing
-- and am.Book_date between '' and '' -- for loans put in place at a specific period
and am.Maturity_date >'30/11/2019' -- for loans ongoing at a specific period
and cb.component_name='PRINCIPAL_OUTSTAND'
and cb.val_date = (select max(b.val_date) from cltb_account_comp_balances b
                  where b.val_date <= '&Date'
                  and b.account_number = cb.account_number
                  and b.component_name='PRINCIPAL_OUTSTAND');
                  
 ----- arr�t� compte d'epagne
 select distinct l.cust_ac_no,l.ac_desc,a.TRN_CODE,a.LCY_AMOUNT,a.TRN_DT DATE_TRANSACTION,a.TRN_DT +1 DATE_VALEUR  from acvw_all_ac_entries a,sttm_cust_account l
where  a.RELATED_CUSTOMER=l.cust_no
and a.MODULE='IC' 
and a.TRN_CODE='CRI' 
and a.TRN_DT between '01/01/2019' and '30/11/2019'
and substr(L.CUST_AC_NO,4,3)  like '3%'  
-----arr�t� compte courant
select distinct l.cust_ac_no,l.ac_desc,a.TRN_CODE,a.LCY_AMOUNT,a.TRN_DT DATE_TRANSACTION,a.TRN_DT +1 DATE_VALEUR  
from acvw_all_ac_entries a,sttm_cust_account l
where  a.RELATED_CUSTOMER=l.cust_no
and a.MODULE='IC' 
and a.TRN_CODE='DIN' 
and a.TRN_DT between '01/01/2019' and '30/11/2019'
and substr(L.CUST_AC_NO,4,3)  like '2%' 

-----loan encour avec taux interet
SELECT am.ACCOUNT_NUMBER , cu.customer_name1 customer_name,am.DR_PROD_AC Customer_account,am.BOOK_DATE,am.VALUE_DATE,am.MATURITY_DATE,am.AMOUNT_FINANCED,uv.ude_value INTEREST_RATE
,am.USER_DEFINED_STATUS,am.NO_OF_INSTALLMENTS
FROM  cltb_account_master am,cltb_account_ude_values uv,sttm_customer cu
WHERE am.ACCOUNT_NUMBER = uv.account_number 
and am.CUSTOMER_ID = cu.customer_no
and uv.ude_id ='INTEREST_RATE'
--and am.BRANCH_CODE='051'
--and substr(am.DR_PROD_AC,4,3)='282'
--and am.BOOK_DATE between to_date('&Date_Start','DDMMYYYY') and to_date('&Date_End','DDMMYYYY')
and am.MATURITY_DATE> = '30/11/2019'
order by am.book_date ;
            
------overdraft
select COSTOMER,sum(OVERDRAFT)*(-1) MONTANT_OVERDRAFT from (
select distinct n.account COSTOMER,n.lcy_closing_bal OVERDRAFT,n.bkg_date BOOK_DATE 
from  acvw_all_ac_entries a, actb_accbal_history n
where  a.AC_NO=n.account
and length(a.AC_NO)=16
and substr(a.AC_NO,4,3) in('282')
and a.TRN_DT BETWEEN '01/01/2019' and '26/12/2019'
and a.TRN_CODE in('ACW','CCQ','IIF') 
and a.DRCR_IND='D'
and n.lcy_closing_bal<0
order by n.bkg_date)
group by COSTOMER
    
-----transfert internationnale
select Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,
sum(CORRCCLS) CORRCCLS,
sum(DOCCLS) DOCCLS,
sum(EXCCLS) EXCCLS,
sum(SWIFTFCLS) SWIFTFCLS,
sum(TRFCLS) TRFCLS,
sum(TFTCC_AMT) TFTCC_AMT,
sum(TFTDOC_AMT) TFTDOC_AMT,
sum(TFTEXC_AMT) TFTEXC_AMT,
sum(TFTSWC_AMT) TFTSWC_AMT,
sum(TFTTRC_AMT) TFTTRC_AMT,
sum(OCTSCLS) OCTSCLS,
sum(TOCTS_AMT) TOCTS_AMT,
sum(MANCCLAS) MANCCLAS,
sum(OSTCCLS) OSTCCLS,
sum(TITCO) TITCO,
sum(TOSTC) TOSTC,
exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,ACC_CLASS,cr_cust_name,maker_id,checker_id
from (
select distinct substr(fcm.CONTRACT_REF_NO,4,4) PRODUCT,
        fcm.CONTRACT_REF_NO,
        FCM.DR_ACCOUNT_BRANCH,
        FCM.DR_CCY,
        FCM.CR_CCY,
        FCM.DR_AMOUNT,
        FCM.CR_AMOUNT,
        case when ic.amount_tag = 'CORRCCLS' then ic.settlement_amt else 0 end CORRCCLS,
        case when ic.amount_tag = 'DOCCLS' then ic.settlement_amt else 0 end DOCCLS,
        case when ic.amount_tag = 'EXCCLS' then ic.settlement_amt else 0 end EXCCLS,
        case when ic.amount_tag = 'SWIFTFCLS' then ic.settlement_amt else 0 end SWIFTFCLS,
        case when ic.amount_tag = 'TRFCLS' then ic.settlement_amt else 0 end TRFCLS,
        case when ic.amount_tag = 'TFTCC_AMT' then ic.settlement_amt else 0 end TFTCC_AMT,
        case when ic.amount_tag = 'TFTDOC_AMT' then ic.settlement_amt else 0 end TFTDOC_AMT,
        case when ic.amount_tag = 'TFTEXC_AMT' then ic.settlement_amt else 0 end TFTEXC_AMT,
        case when ic.amount_tag = 'TFTSWC_AMT' then ic.settlement_amt else 0 end TFTSWC_AMT,
        case when ic.amount_tag = 'TFTTRC_AMT' then ic.settlement_amt else 0 end TFTTRC_AMT,
        case when ic.amount_tag = 'OCTSCLS' then ic.settlement_amt else 0 end OCTSCLS,
        case when ic.amount_tag = 'TOCTS_AMT' then ic.settlement_amt else 0 end TOCTS_AMT,
        case when ic.amount_tag = 'MANCCLAS' then ic.settlement_amt else 0 end MANCCLAS,
        case when ic.amount_tag = 'OSTCCLS' then ic.settlement_amt else 0 end OSTCCLS,
        case when ic.amount_tag = 'TITCO' then ic.settlement_amt else 0 end TITCO,
        case when ic.amount_tag = 'TOSTC' then ic.settlement_amt else 0 end TOSTC,
        FCM.EXCHANGE_RATE,
        to_char(CC.BOOK_DATE,'DD/MM/YYYY') BOOK_DATE,
        to_char(FCM.DR_VALUE_DATE,'DD/MM/YYYY') DR_VALUE_DATE,
        (SELECT SCA.AC_DESC FROM STTM_CUST_ACCOUNT SCA WHERE SCA.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_NAME,
        (SELECT SCA2.CUST_AC_NO FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_ACCOUNT,
        (SELECT SCA2.ACCOUNT_CLASS FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.DR_ACCOUNT) ACC_CLASS,
        (SELECT SCA1.AC_DESC FROM STTM_CUST_ACCOUNT SCA1 WHERE SCA1.BRANCH_CODE=FCM.CR_ACCOUNT_BRANCH AND SCA1.CUST_AC_NO=FCM.CR_ACCOUNT) CR_CUST_NAME,
        (SELECT ccel.maker_id FROM cstb_contract_event_log ccel WHERE ccel.contract_ref_no=fcm.contract_ref_no and ccel.event_code='BOOK' and ccel.event_seq_no =
                 (SELECT max(ccel1.event_seq_no) FROM cstb_contract_event_log ccel1 WHERE ccel1.contract_ref_no=ccel.contract_ref_no AND ccel1.event_code=ccel.event_code) ) maker_id,
        (SELECT ccel.checker_id FROM cstb_contract_event_log ccel WHERE ccel.contract_ref_no=fcm.contract_ref_no and ccel.event_code='BOOK' and ccel.event_seq_no =
                 (SELECT max(ccel1.event_seq_no) FROM cstb_contract_event_log ccel1 WHERE ccel1.contract_ref_no=ccel.contract_ref_no AND ccel1.event_code=ccel.event_code) ) checker_id
from fttb_contract_master fcm,CSTB_CONTRACT CC,istb_contractis ic
where FCM.CONTRACT_REF_NO=CC.CONTRACT_REF_NO
and fcm.contract_ref_no = ic.contract_ref_no
and ic.settlement_amt is not null
AND   CC.MODULE_CODE='FT'
and fcm.exchange_rate <> 1

--AND   ((FCM.DR_CCY !='XAF' OR FCM.CR_CCY !='XAF') AND (FCM.CR_CCY !='XAF' OR FCM.DR_CCY !='XAF'))
AND   CC.BOOK_DATE between '01/01/2020' AND '31/10/2020'
--AND   CC.counterparty = NVL(:PM_BY_ORDER_OF,CC.counterparty)
AND   FCM.EVENT_SEQ_NO=(SELECT MAX(FCM1.EVENT_SEQ_NO) FROM fttb_contract_master fcm1 WHERE FCM1.CONTRACT_REF_NO=FCM.CONTRACT_REF_NO)
order by FCM.DR_ACCOUNT_BRANCH)
group by Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,ACC_CLASS,cr_cust_name,maker_id,checker_id
order by book_date
------user flexcube with role
select distinct aa.user_name, aa.user_id,ro.role_description , aa.start_date, decode (aa.user_status,'E','ENABLED','D','DISABLED','L','LOCKED','HOLD') Status, aa.status_changed_on,aa.last_signed_on,aa.pwd_changed_on,bb.branch_name
from smtb_user aa , smtb_user_role rr , SMTB_ROLE_MASTER ro, sttm_branch bb
where rr.user_id = aa.user_id
and rr.role_id = ro.role_id
and bb.branch_code = aa.home_branch
and  aa.record_stat='O'
order by user_id
-----compte courant et epagne
select l.branch_code,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance,l.record_stat
 from sttm_cust_account l
 where substr(l.cust_ac_no,4,3) like '2%'
 and l.ac_open_date <='30/11/2019'
 union
 select l.branch_code,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance,l.record_stat
 from sttm_cust_account l
 where substr(l.cust_ac_no,4,3) like '3%'
 and l.ac_open_date <='30/11/2019'
 -----COMPTE DEBITEUR AND CREDITEUR
 -----CREDITEUR
 select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2018' and r.period_code='M12'
and r.gl_code like '56%'
and  r.cr_bal_lcy<> '0'
and substr(bb.cust_ac_no,4,3) not like '1%'
union
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M11'
and r.gl_code like '374%'
and  r.cr_bal_lcy<> '0'
and substr(bb.cust_ac_no,4,3) not like '1%'
-----DEBITEUR
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M11'
and r.gl_code like '56%'
and  r.cr_bal_lcy<> '0'
and substr(bb.cust_ac_no,4,3) not like '1%'
union
select r.branch_code,r.gl_code,r.cust_ac_no,bb.ac_desc,r.dr_bal_lcy,r.cr_bal_lcy from gltb_cust_accbreakup r, sttm_cust_account bb
where r.cust_ac_no=bb.cust_ac_no and r.fin_year='FY2019' and r.period_code='M11'
and r.gl_code like '37%'
and  r.cr_bal_lcy<> '0'
and substr(bb.cust_ac_no,4,3) not like '1%'
-----COMPTE COURANT ET EPAGNE
select l.branch_code,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance,l.record_stat
 from sttm_cust_account l
 where substr(l.cust_ac_no,4,3) like '2%'
 and l.ac_open_date <='30/11/2019'
 union
 select l.branch_code,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance,l.record_stat
 from sttm_cust_account l
 where substr(l.cust_ac_no,4,3) like '3%'
 and l.ac_open_date <='30/11/2019'
 ----OCCOUNT OPENING
select yy.branch_code,yy.cust_ac_no,yy.ac_desc,yy.lcy_curr_balance,yy.ac_open_date,yy.account_class,yy.address1
from sttm_cust_account yy
where  yy.ac_open_date between '01/01/2019'  and '12/12/2019'
and yy.account_class not in ('551',
'552',
'553',
'570',
'571',
'573',
'580',
'581')
------374000
select q.branch_code,q.gl_code,q.ccy_code,q.dr_bal_lcy,q.cr_bal_lcy
from gltb_gl_bal q
where q.gl_code like'374%'
and q.fin_year='FY2019'
and q.period_code='M12' --and q.dr_bal_lcy<>'0'
and q.leaf='Y'
and (q.dr_bal_lcy<>'0' or q.cr_bal_lcy<>'0')
order by  q.branch_code
-----civil servant with last salary
select distinct a.AC_NO,l.ac_desc,l.lcy_curr_balance,a.TRN_CODE,l.record_stat ,max(a.TRN_DT)
from acvw_all_ac_entries a,sttm_cust_account l
where a.AC_NO=l.cust_ac_no
and length(a.AC_NO)=16
and substr(a.AC_NO,4,3)='282'
and a.TRN_DT between '01/09/2018' and '31/01/2020'
and a.DRCR_IND='C'
and a.TRN_CODE='SAL'
group by a.AC_NO,l.ac_desc,l.lcy_curr_balance,a.TRN_CODE,l.record_stat
order by a.AC_NO
-----new overdraf
select distinct r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date,p.ude_value
from gltb_cust_acc_breakup r, sttm_cust_account y,ICTM_ACC_UDEVALS P,actb_accbal_history ah
where /*r.period_code='M06' and*/ r.fin_year='FY2020' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01/01/2020' and '31/10/2020'
and ah.bkg_date>= all (select h.bkg_date  from actb_accbal_history h where ah.account = y.cust_ac_no and h.bkg_date <='31/10/2020')
and r.cust_ac_no=y.cust_ac_no
and y.cust_ac_no = ah.account
AND Y.CUST_AC_NO=P.ACC
AND P.UDE_VALUE<>'0'
AND P.UDE_ID='OD_RATE'
-----signature charge
select distinct substr(k.key_id,22,6),k.branch_code,g.cust_ac_no,g.ac_desc,trunc(k.maker_dt_stamp),trunc(k.checker_dt_stamp)
  from sttb_record_log_hist k,sttm_cust_account g
 where substr(k.key_id,22,6)=g.cust_no
 and  k.function_id='SVDCIFSG'
 and trunc(k.maker_dt_stamp) between '01/01/2020' and '31/10/2020'
 ----bank garanti
 SELECT * FROM LCTB_CONTRACT_MASTER d where d.issue_date between '01/01/2020' and '31/10/2020' and d.operation_code='OPN'
 -----si 
 select * from cstb_contract n where n.book_date
between '01/01/2020' and '31/10/2020' and n.module_code='SI'

------CHECKBOKK
SELECT * FROM CATM_CHECK_BOOK F WHERE F.ORDER_DATE
BETWEEN '01/01/2020' and '31/10/2020' and f.record_stat='O'
