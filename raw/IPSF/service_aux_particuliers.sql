select * from acvw_all_ac_entries c;
select * from gltm_glmaster l where substr(l.gl_code,1,9) in('729001200')  ;
select * from sttm_trn_code t where t.trn_code in('CBC')

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----fonctionnement et gestion de compte
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- detail
select * from acvw_all_ac_entries c 
where c.AC_NO in ('729001200')
and c.TRN_DT between '&from_date' and '&end_date';

---summary
select 'A.1.1 - Frais de clôture du compte' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729003200'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.1.3 - Extrait de compte à la demande (par page)' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729003100'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.1.6 - Consultation par sms' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729001500'
and c.TRN_DT between '&from_date' and '&end_date'
--and c.AC_BRANCH=020
and c.TRN_CODE like 'SMS'
union
select 'A.1.9 - Consultation par internet' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='728402000'
and c.AC_BRANCH=020
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2.1 - Carte nationale de bas standing' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c  
where c.AC_NO='728302200'
--and f.customer_type ='I' 
and c.TRN_DT between '&from_date' and '&end_date'
--AND c.LCY_AMOUNT=7000
union
select 'A.2.2 - Carte nationale de moyen standing' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c  
where c.AC_NO='728302500'
--AND c.LCY_AMOUNT=12000
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2.3 - Carte nationale de haut standing' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c 
where c.AC_NO='728303300'
--AND c.LCY_AMOUNT=20000
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2 - Carte staff' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c 
where c.AC_NO='728322000'
--AND c.LCY_AMOUNT=20000
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2.7 - Retrait par carte bancaire dans les distributeurs autres que ceux de la banque' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='728340000'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2.13 - Réédition du code secret de carte à initiative du client' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='728301200'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.2.15 - Opposition sur carte à initiative du client' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='728302300'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.3.1 and A.3.2  - Remise de chéquier ' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729001200'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.3.3  - Remise à encaissement du chèque dans les caisses dune autre banque ' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='721001000'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.3.5  - Emission de chèque de Banque ' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='722001000'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.3.6  - Emission de chèque certifié ' ,round(sum(c.LCY_AMOUNT)/1000000,4) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='722002000'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.3.8 and  A.3.9 - Opposition sur chèque à linitiative du client ' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729005100'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.5.1 and A.5.2 - Virement vers un confrère : électronique' ,round(sum(c.LCY_AMOUNT)/1000000,4) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='72900600'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.5.5  - Virement permanent : suppression ' ,round(sum(c.LCY_AMOUNT)/1000000,4) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729001000'
and c.TRN_DT between '&from_date' and '&end_date'
union
select 'A.6.3  - Attestations diverses ' ,round(sum(c.LCY_AMOUNT)/1000000,4) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO='729003300'
and c.TRN_DT between '&from_date' and '&end_date'
; 


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Commission Transfert Entrant hors zone CEMAC
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
select
cr_amount MONTANT ,
sum(MANCCLAS) Commission_fonds_reçus,
sum(CORRCCLS)Commission_de_change,
sum(DOCCLS)Commission_sur_ordre,
sum(EXCCLS) Mise_à_disposition_client,
sum(SWIFTFCLS) Autres_frais_fixes,
sum(TRFCLS) Commission_de_change
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
AND   CC.BOOK_DATE between '&from_date' and '&end_date'
AND   FCM.EVENT_SEQ_NO=(SELECT MAX(FCM1.EVENT_SEQ_NO) FROM fttb_contract_master fcm1 WHERE FCM1.CONTRACT_REF_NO=FCM.CONTRACT_REF_NO)
order by FCM.DR_ACCOUNT_BRANCH)
where Product in('DIOC','ZODC','S14S','S13S','M14S','S06S','S07S','M06S','M07S','L06S','	L07S','S12S')
and cr_amount between '&from_amount' and '&to_amount' 
group by Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,dr_ACC_CLASS,cr_cust_name,cr_cust_account,cr_ACC_CLASS,maker_id,checker_id
order by book_date







---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Commission Transfert Sortant HORS ZONE CEMAC
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
select cr_amount Montant_du_transfert,
sum(TRFCLS) Commission_de_transfert,
sum(DOCCLS) Frais_de_dossiers,
sum(CORRCCLS) Frais_correspondant,
sum(SWIFTFCLS) Frais_de_swift,
sum(MANCCLAS) Autres_frais_fixe,
sum(EXCCLS) Commisison_de_charger
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
and  FCM.CR_CCY!='XAF'
and FCM.DR_CCY='XAF'
AND   CC.BOOK_DATE between '&from_date' and '&end_date'
AND   FCM.EVENT_SEQ_NO=(SELECT MAX(FCM1.EVENT_SEQ_NO) FROM fttb_contract_master fcm1 WHERE FCM1.CONTRACT_REF_NO=FCM.CONTRACT_REF_NO)
order by FCM.DR_ACCOUNT_BRANCH)
where Product in('FTOC','FTOB','FTOW')
and cr_amount between '&from_amount' and '&to_amount' 
group by Product,contract_ref_no,Dr_account_branch,dr_ccy,cr_ccy,dr_amount,cr_amount,exchange_rate,book_date,dr_value_date,dr_cust_name,dr_cust_account,dr_ACC_CLASS,cr_cust_name,cr_cust_account,cr_ACC_CLASS,maker_id,checker_id
order by book_date


-----liste des clients qui ont les decouverts

select a.branch_code, a.cust_ac_no, a.ac_desc,a.lcy_curr_balance
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where h.tod_amount <>0 and appl_date between &date1 and &date2 group by h.account_no) x
where a.cust_no = c.customer_no 
and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between &date1 and &date2 and a.tod_limit >0 
and a.tod_limit<>0
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between &date1 and &date2
)

---liste des comptes avec cautions
select a.branch_code, a.cust_ac_no, a.ac_desc,a.lcy_curr_balance
 from   xafnfc.lctb_contract_master co ,xafnfc.sttm_cust_account a

where  a.cust_no = co.cif_id
and co.effective_date between &date1 and &date2  
order by a.branch_code

---list des client qui recoivent pas de sms
select L.BRANCH_CODE,l.cust_ac_no,l.ac_desc,l.lcy_curr_balance from sttm_cust_account L
where l.cust_ac_no not in 
(SELECT a.cust_ac_no  FROM sttm_cust_account a
WHERE a.cust_ac_no in 
                   (select ca.cust_ac_no from sttm_cust_account ca WHERE  ca.cust_ac_no not in 
                             (SELECT acc FROM ictm_acc_udevals  WHERE prod ='SMSC' and ude_id ='SMS_AMT' and ude_value =0)

union
SELECT acc FROM ictm_acc_udevals  WHERE prod ='SMSC' and ude_id ='SMS_AMT' and ude_value <>0
)

and to_char(a.maker_dt_stamp,'YYYY') between '2016' and '2018'

) ;

--DORMANT ACCOUNT
select count(*) Dormant,l.branch_code
from sttm_cust_account l
where  l.ac_stat_dormant like 'Y'
and substr(l.cust_ac_no,4,3) in('282','285')
group by l.branch_code
order by l.branch_code;
---ACTIVE ACCOUNT
select count(*) Active,l.branch_code
from sttm_cust_account l
where l.ac_stat_dormant like 'N'
and substr(l.cust_ac_no,4,3) in('282')
group by l.branch_code
order by l.branch_code;

-----LOAN
select a.branch_code,count(*) LOAN
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
--and b.component='PRINCIPAL'
and b.balance <> 0
--and l.BOOK_DATE between '&from_date' and '&end_date'
--and a.branch_code ='&Branch'
and a.account_class in ('282','285')-- Civil Servants
--and a.account_class in ('281','283','284','285')-- Non Civil Servants
group by a.branch_code
order by a.branch_code;

---- ODS
select a.branch_code, count(*) DECOUVERT
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where h.tod_amount <>0 --and appl_date between '&from_date' and '&end_date' 
   group by h.account_no) x
where a.cust_no = c.customer_no 
and a.cust_ac_no = x.account_no(+)
--and tod_limit_start_date between '&from_date' and '&end_date' and a.tod_limit >0 
and a.tod_limit<>0
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
--where acy_closing_avlbal<0 and bkg_date between '&from_date' and '&end_date'
)
AND substr(a.cust_ac_no,4,3) in('282','285')
GROUP BY a.branch_code
order by a.branch_code;

------DOUBTFUL LOAN DOUTEUX
SELECT BRANCH,count(*) DOUBTFUL from(
SELECT c.local_branch BRANCH,am.ACCOUNT_NUMBER,case when 
          (select count(*) from xafnfc.cltb_account_schedules ll where ll.ACCOUNT_NUMBER = am.account_number and ll.component_name = 'PRINCIPAL'
           and nvl(amount_due, 0) - nvl(amount_settled, 0) <> 0)/* UNPAID_INSTALLMENTS*/ <> no_of_installments 
           and USER_DEFINED_STATUS IN ('NORM')
           then 'SAIN' else 'NON SAIN' end SITUATION
from xafnfc.cltb_account_master am join xafnfc.sttm_customer c on am.customer_id = c.customer_no
    left outer join xafnfc.sttm_cust_corporate pr on c.customer_no = pr.customer_no
where value_date between '&from_date' and '&end_date'a
UNION
SELECT c.local_branch,a.cust_ac_no account_number,
case when  a.acc_status in ('NORM') then 'SAIN' else 'NON SAIN' end  SITUATION
from xafnfc.sttm_cust_account a, xafnfc.sttm_customer c,xafnfc.sttm_cust_corporate cc
, (select h.account_no, min(h.appl_date) m_appl_date, round(avg(h.tod_amount)) a_tod_amount from xafnfc.sttb_cust_tod_hist h
   where appl_date between '&from_date' and '&end_date' group by h.account_no) x
where a.cust_no = c.customer_no and a.cust_ac_no = x.account_no(+)
and tod_limit_start_date between '&from_date' and '&end_date' and a.tod_limit >0 
and a.cust_no = cc.customer_no
and a.cust_ac_no in (select account
from xafnfc.actb_accbal_history h
where acy_closing_avlbal<0 and bkg_date between '&from_date' and '&end_date'
)
)
group by BRANCH
ORDER BY BRANCH;



----commision
select f.local_branch, count(*) COMMISSION,round(sum(c.LCY_AMOUNT)/1000000,2) Montant 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
and f.customer_type ='I'
and c.AC_NO like '72%'
and c.TRN_DT between '&from_date' and '&end_date'
group by f.local_branch
order by f.local_branch;
---- OUTSTANDING LOAN montant qui reste du loan
select l.branch_code,count(*),sum(l.balance) OUTSTANDING_LOAN 
from CLTB_ACCOUNT_COMP_BAL_BREAKUP l 
group by l.branch_code
------OUTSTANDING LOAN montant qui reste du loan pour salary
select l.branch_code,count(*),sum(l.balance)/1000000 OUTSTANDING_LOAN 
from CLTB_ACCOUNT_COMP_BAL_BREAKUP l,cltb_account_master t,sttm_cust_account h
where l.account_number=t.ACCOUNT_NUMBER
and t.CUSTOMER_ID=h.cust_no
and substr(h.cust_ac_no,4,3) in('282','285')
and h.ac_stat_dormant like 'N'
--d t.book_date between '01/01/2018' and '08/04/2019'
group by l.branch_code
order by l.branch_code
----LISTE DES FONCTIONNAIRE QUI ON DES LOAN bon
select distinct a.branch_code,a.cust_ac_no,a.ac_desc,l.amount_financed,l.book_date,l.maturity_date,p.fon_montant_mois_actuel
from sttm_customer c,sttm_cust_account a,cltb_account_master l,cltb_account_comp_bal_breakup b, CLTB_ACCOUNT_COMP_SCH s,delta23.PAIE_FONCTIONNAIRE@delt p
where a.cust_ac_no=l.DR_PROD_AC
and b.account_number=l.ACCOUNT_NUMBER
and s.account_number = l.ACCOUNT_NUMBER
and c.customer_no=a.cust_no
and a.cust_ac_no=p.fon_fcubs_account
--and b.component='PRINCIPAL'
and b.balance <> 0
and l.book_date  <='31/03/2019'
and l.maturity_date>='30/03/2019'
--and l.BOOK_DATE between '&from_date' and '&end_date'
--and a.branch_code ='&Branch'
and a.account_class in ('282','285')-- Civil Servants
--and a.account_class in ('281','283','284','285')-- Non Civil Servants
--group by a.branch_code
order by a.branch_code

---------liste des customer qui ne recoivent pas des sms

select l.branch_code,l.cust_ac_no,l.ac_desc from sttm_cust_account l where l.cust_no not in(
select distinct f.customer_no--'A.1.6 - Consultation par sms' ,round(sum(c.LCY_AMOUNT)/1000000,2) Montant,round(sum(c.LCY_AMOUNT)/count(*))moyene,count(*) Nombre 
from acvw_all_ac_entries c ,sttm_customer f
where c.RELATED_CUSTOMER=f.customer_no
--and f.customer_type ='I'
and c.AC_NO='729001500'
and c.TRN_DT between '&from_date' and '&end_date'
--and c.AC_BRANCH=020
and c.TRN_CODE like 'SMS')
------commission salary
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,substr(a.TRN_REF_NO,4,4), acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) ='713001000'
--where substr(a.AC_NO,1,9) between '200000000' and '249999999'
and a.TRN_DT between '01/01/2018' and '05/01/2018'
--and substr(a.TRN_REF_NO,4,4) like 'ZODC'
order by a.AC_BRANCH,a.trn_dt ;

-------interet loan  COMPTE Salary

select yy.AC_BRANCH,sum(yy.LCY_AMOUNT)  from acvw_all_ac_entries yy 
where  yy.TRN_CODE='LAC' 
and yy.DRCR_IND='C'
and substr(yy.RELATED_ACCOUNT,7,1) like 'S'
and yy.AC_NO in('712004100','711001000','712001000','713001000')
AND YY.TRN_DT between '01/01/2012' and '31/12/2012'
group by yy.AC_BRANCH
order by yy.AC_BRANCH
-----COMMSIION SUITE

SELECT yy.AC_BRANCH,sum(yy.LCY_AMOUNT) FROM  acvw_all_ac_entries yy 
WHERE  yy.AC_NO in('714001000')
and substr(yy.trn_ref_no,4,4) like 'DIOC'
and substr(yy.related_account,4,3) LIKE '1%'
AND YY.TRN_DT between '01/01/2012' and '31/12/2012'
group by yy.AC_BRANCH
order by yy.AC_BRANCH

----loan par secteur d'activité
select 
decode (rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' '),
'ASC  ','PE',
'ASCI ','PE',
'ASCO ','ME',
'ASDP ','TPE',
'ASDPC','TPE',
'EURL ','PE',
'GIE  ','TPE',
'OP   ','TPE',
'SCP  ','PE',
'SEL  ','PE',
'SICA ','TPE',
'SNC  ','TPE',
'SA   ','ME',
'SARL ','PE',
'SAS  ','PE',
'SASO  ','TPE',
'SCA  ','TPE',
'SCEA ','PE',
'SCEC ','PE',
'SCI  ','PE',
'SCIC ','TPE',
'SCOP ','TPE',
'SM   ','ME',
'SP1  ','TPE','TPE') forme_juridique,count(*) Nombre,sum(l.amount_financed) Montant
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and c.customer_type ='C'
and l.BOOK_DATE between '01/01/2016'and '31/12/2016'
group by rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' ');--,'ASC','PE','ASCI','PE','ASCO','ME','ASDP','TPE','ASDPC','TPE','EURL','PE','GIE','TPE','OP','TPE','SCP','PE','SEL','PE','SICA','TPE','SNC','TPE','SA','ME','SARL','PE','SAS','PE','SASO','TPE','SCA','TPE','SCEA','PE','SCEC','PE''SCI','PE','SCIC','TPE','SCOP','TPE','SM','ME','SP1','TPE','ME') 
--- repartion de credit par secteur d'activité

select Annee, secteur,sum(nombre) Nombre,round(sum(montant)/1000000,0) Montant from(
select to_char(l.BOOK_DATE,'RRRR') Annee,   case
when  to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2))  between 01 and 09 then 'Agriculture'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 10 and 14 then 'Extraction'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 15 and 37 then 'Fabrication'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 40 and 45 then 'BTP_Energie'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 50 and 55 then 'Commerce'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 60 and 64 then 'Transport_communication'
when  to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2))between 65 and 67 then 'Activit_financiere'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 70 and 75 then 'Service'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 80 and 85 then 'Education'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 91 and 99 then 'Autre_activity' 
ELSE 'RAS' 
end Secteur                
,count(*) Nombre,sum(l.amount_financed) Montant
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and c.customer_type ='C'
--and l.BOOK_DATE between '01/01/2013'and '31/12/2013'
group by to_char(l.BOOK_DATE,'RRRR'),to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)))
group by Annee,secteur
order by Annee;
---- CREANCE EN SOUFFRANCE 
select Annee, secteur,sum(nombre) Nombre,round(sum(montant)/1000000,0) Montant,Unpaid/1000000 from(
select to_char(l.BOOK_DATE,'RRRR') Annee,   case
when  to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2))  between 01 and 09 then 'Agriculture'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 10 and 14 then 'Extraction'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 15 and 37 then 'Fabrication'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 40 and 45 then 'BTP_Energie'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 50 and 55 then 'Commerce'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 60 and 64 then 'Transport_communication'
when  to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2))between 65 and 67 then 'Activit_financiere'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 70 and 75 then 'Service'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 80 and 85 then 'Education'
when to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)) between 91 and 99 then 'Autre_activity' 
ELSE 'RAS' 
end Secteur                
,count(*) Nombre,sum(l.amount_financed) Montant,t.balance Unpaid
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l,CLTB_ACCOUNT_COMP_BAL_BREAKUP t 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and l.ACCOUNT_NUMBER=t.ACCOUNT_NUMBER
and c.customer_type ='C'
and t.balance!='0'
group by to_char(l.BOOK_DATE,'RRRR'),to_number(substr(decode(m.cust_mis_3,'GRP999','93.0',m.cust_mis_3),1,2)),t.balance)
group by Annee,secteur,Unpaid
order by Annee;





