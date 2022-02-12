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
sum(TITCO_AMT) TITCO_AMT,
sum(TITCE_AMT) TITCE_AMT,
sum(TOSTC_AMT) TOSTC_AMT,
exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,dr_ACC_CLASS,cr_cust_name,cr_cust_account,cr_ACC_CLASS,maker_id,checker_id
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
        case when ic.amount_tag = 'TITCO_AMT' then ic.settlement_amt else 0 end TITCO_AMT,
        case when ic.amount_tag = 'TITCE_AMT' then ic.settlement_amt else 0 end TITCE_AMT,
        case when ic.amount_tag = 'TOSTC_AMT' then ic.settlement_amt else 0 end TOSTC_AMT,
        FCM.EXCHANGE_RATE,
        CC.BOOK_DATE,
        FCM.DR_VALUE_DATE DR_VALUE_DATE,
        (SELECT SCA.AC_DESC FROM STTM_CUST_ACCOUNT SCA WHERE SCA.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_NAME,
        (SELECT SCA2.CUST_AC_NO FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.DR_ACCOUNT) DR_CUST_ACCOUNT,
        (SELECT SCA2.ACCOUNT_CLASS FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.DR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.DR_ACCOUNT) DR_ACC_CLASS,
        (SELECT SCA1.AC_DESC FROM STTM_CUST_ACCOUNT SCA1 WHERE SCA1.BRANCH_CODE=FCM.CR_ACCOUNT_BRANCH AND SCA1.CUST_AC_NO=FCM.CR_ACCOUNT) CR_CUST_NAME,
        (SELECT SCA2.CUST_AC_NO FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.CR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.CR_ACCOUNT) CR_CUST_ACCOUNT,
        (SELECT SCA2.ACCOUNT_CLASS FROM STTM_CUST_ACCOUNT SCA2 WHERE SCA2.BRANCH_CODE=FCM.CR_ACCOUNT_BRANCH AND SCA2.CUST_AC_NO=FCM.CR_ACCOUNT) CR_ACC_CLASS,
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
AND   CC.BOOK_DATE between '01-jan-2019' AND '31-dec-2019'
--AND   CC.counterparty = NVL(:PM_BY_ORDER_OF,CC.counterparty)
AND   FCM.EVENT_SEQ_NO=(SELECT MAX(FCM1.EVENT_SEQ_NO) FROM fttb_contract_master fcm1 WHERE FCM1.CONTRACT_REF_NO=FCM.CONTRACT_REF_NO)
order by FCM.DR_ACCOUNT_BRANCH)
group by Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,dr_ACC_CLASS,cr_cust_name,cr_cust_account,cr_ACC_CLASS,maker_id,checker_id
order by book_date