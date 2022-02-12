--- Dépôts à terme à une date précise

select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.related_account,sa.ac_natural_gl Reporting_gl,c.customer_name1,
 a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT, x.deposit_amount AMONUT, u.ude_value INT_RATE, x.value_date Start_date, x.td_maturity_date Maturity_date
from acvw_all_ac_entries a , sttm_customer c, tdvw_td_details x,ictm_acc_udevals u, sttb_account sa
where substr(a.related_account,9,6) = c.customer_no  
and x.account_no = a.related_account
and u.acc = a.related_account
and a.related_account = sa.ac_gl_no
/*and u.ude_id='INT_RATE'*/ 
--and substr(a.AC_NO,1,3) between '570000000' and '579999999' 
and substr(a.AC_NO,1,16) in ('0241720104483279') 
--and substr(a.RELATED_ACCOUNT,4,2)='57'
and a.trn_dt  between '01-JAN-2018' and '30-JUN-2018'
--and substr(a.related_account,9,6) ='044832'
--and a.ac_branch ='042',
--and a.batch_no ='9999',

-- Solde des GLs à une periode donnée

SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc, gl.dr_bal_lcy, gl.cr_bal_lcy 
FROM gltb_gl_bal gl, gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
--and gl.gl_code between '340000000' and '229999999' ---and fin_year='FY2016' and period_code ='M06' 
and substr(gl.gl_code,1,2)='34' ---and fin_year='FY2016' and period_code ='M06'
and gl.branch_code in ('040','041','042','043')
order by gl.branch_code,gl.gl_code;

-- Fx sale and purchase (LISTE DES OPERATIONS DE CHANGE EFFECTUES POUR LES CLIENTS)

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
and (a.product_code in( 'FXPW','FXSW','FXSB','FXFX','FXFW') or (a.txn_ccy <> a.ofs_ccy and a.product_code in ('CHDP','CHWL'))),
--and a.trn_dt  between '01-JAN-2017' and '30-JUN-20117',


-- Bon de caisse avec montant provisionné / Time deposit -- 

SELECT distinct y.branch_code,y.gl_code,y.cust_ac_no,x.customer_Name,x.Date_of_Open,x.TD_Maturity_date, x.Deposit_amount,s.ude_value INTEREST_RATE,x.Total_interest_Payable
FROM gltb_cust_accbreakup y, tdvw_td_details x,ictm_acc_udevals s where y.gl_code like '36%'or y.gl_code like '54%'-- and y.period_code='M06'
and y.fin_year='FY2017' and y.cr_bal_lcy<>'0'
and s.ude_id='INT_RATE'
--and x.TD_Maturity_date > '30-apr-2017' --between '01/01/2018' and '30/06/2018'
and y.cust_ac_no=x.Account_no
AND X.Account_no=S.ACC
and x.TD_Maturity_date between '01-JAN-2018' and '30-JUN-2018',

-- Saving accounts opened LISTE DES COMPTES DEPARGNE

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
and ca.ac_open_date between '01-JAN-2018' and '30-JUN-2018'
order by a1.lcy_closing_bal desc,

-- Liste des découverts special rate

select r.branch_code,r.cust_ac_no,y.ac_desc,r.dr_bal_lcy,y.tod_limit,y.tod_start_date,p.ude_value
from gltb_cust_acc_breakup r, sttm_cust_account y,ICTM_ACC_UDEVALS P
where /*r.period_code='M06' and*/ r.fin_year='FY2017' and r.dr_bal_lcy<>'0'
and y.tod_start_date between '01-JAN-2018' and '30-JUN-2018'
--AND p.ude_id='OD_RATE' AND R.CUST_AC_NO=P.ACC
and r.cust_ac_no=y.cust_ac_no
AND Y.CUST_AC_NO=P.ACC
AND P.UDE_VALUE<>'0'
AND P.UDE_ID='OD_RATE',

-- liste des crédits

SELECT substr(am.account_number,1,3) agence ,am.ACCOUNT_NUMBER , cu.customer_name1,am.DR_PROD_AC,am.BOOK_DATE,am.VALUE_DATE,am.MATURITY_DATE,am.AMOUNT_FINANCED,uv.ude_value
FROM  cltb_account_master am,cltb_account_ude_values uv,sttm_customer cu
WHERE am.ACCOUNT_NUMBER = uv.account_number 
and am.CUSTOMER_ID = cu.customer_no
and uv.ude_id ='INTEREST_RATE'
--and am.BRANCH_CODE='051'
and am.maturity_date > '30-SEP-2018'
and substr(am.DR_PROD_AC,4,3)='282'
order by am.DR_ACC_BRN,cu.customer_name1
--and am.BOOK_DATE between '01-JAN-2018' and '30-SEP-2018' ,
SELECT * FROM sttm_cust_personal

----- liste des crédits avec date de naissance du client

SELECT substr(am.account_number,1,3) agence ,am.ACCOUNT_NUMBER loan_account , cu.customer_name1,jo.date_of_birth,am.DR_PROD_AC flex_account,am.BOOK_DATE,am.VALUE_DATE,am.MATURITY_DATE,am.AMOUNT_FINANCED,uv.ude_value
FROM  cltb_account_master am,cltb_account_ude_values uv,sttm_customer cu,sttm_cust_personal jo
WHERE am.ACCOUNT_NUMBER = uv.account_number 
and am.CUSTOMER_ID = cu.customer_no
and substr(am.DR_PROD_AC,9,6)=jo.customer_no 
and uv.ude_id ='INTEREST_RATE'
--and am.BRANCH_CODE='051'
and am.maturity_date > '30-SEP-2018'
and substr(am.DR_PROD_AC,4,3)='282'
order by am.DR_ACC_BRN,cu.customer_name1



--- FT Booked
select * from cltb_account_master
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
exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,cr_cust_name,maker_id,checker_id
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
        CC.BOOK_DATE BOOK_DATE,
        FCM.DR_VALUE_DATE DR_VALUE_DATE,
        (SELECT SCA.AC_DESC FROM STTM_CUST_ACCOUNT SCA WHERE SCA.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_NAME,
        (SELECT SCA2.CUST_AC_NO FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_ACCOUNT,
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
--AND   ((FCM.DR_CCY !='XAF' OR FCM.CR_CCY !='XAF') AND (FCM.CR_CCY !='XAF' OR FCM.DR_CCY !='XAF'))
AND   CC.BOOK_DATE between &PM_FROM_DATE AND &PM_TO_DATE
--AND   CC.counterparty = NVL(:PM_BY_ORDER_OF,CC.counterparty)
AND   FCM.EVENT_SEQ_NO=(SELECT MAX(FCM1.EVENT_SEQ_NO) FROM fttb_contract_master fcm1 WHERE FCM1.CONTRACT_REF_NO=FCM.CONTRACT_REF_NO)
order by FCM.DR_ACCOUNT_BRANCH)
group by Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,cr_cust_name,maker_id,checker_id,
