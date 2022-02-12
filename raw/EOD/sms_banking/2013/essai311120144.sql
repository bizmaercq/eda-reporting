select f.product_code, decode(f.product_code,'FTOC',substr(dr_account,9,6),'ITBK',substr(dr_account,9,6),substr(cr_account,9,6)) reference
, decode(c.customer_name1,null,(SELECT decode(SCA.AC_DESC,'STANDARD CHARTERED BANK FRANKFURT','NFC BANK',SCA.AC_DESC) FROM STTM_CUST_ACCOUNT SCA WHERE SCA.BRANCH_CODE=f.DR_ACCOUNT_BRANCH AND SCA.CUST_AC_NO=f.DR_ACCOUNT),c.customer_name1) designation
     , decode(f.product_code,'FTOC',cr_amount,'ITBK',cr_amount,dr_amount) montant, lcy_equiv montant_CFA, decode(f.product_code,'FTOC','D','FTOB','D','C') sens, decode(f.product_code,'FTOC',cr_ccy,dr_ccy) devise
     , accounting_date dateope, 'TR' typeope
     , case 
       when nvl(by_order_of6,'CM') = 'CM' and nvl(ult_beneficiary6,'CM') <> 'CM' then ult_beneficiary6
       when nvl(by_order_of6,'CM') <> 'CM' and nvl(ult_beneficiary6,'CM') = 'CM' then by_order_of6
       else null
       end code_pays
     , u.field_val_2 code_motif
     , decode(f.product_code,'FTOC',ult_beneficiary2,'FTOB',ult_beneficiary1,by_order_of1) commentaires, f.CONTRACT_REF_NO
, decode(decode(f.product_code,'FTOC',substr(dr_account,9,6),substr(cr_account,9,6)),'039184',0,round(lcy_equiv*0.004)) commission
from FTTB_CONTRACT_MASTER f, sttm_customer c, CSTM_CONTRACT_USERDEF_FIELDS u
where decode(f.product_code,'FTOC',substr(dr_account,9,6),substr(cr_account,9,6)) = c.customer_no(+)
  and f.contract_ref_no = u.contract_ref_no (+)
  and accounting_date between :date1 and :date2
  and f.product_code in ('FTOC','ITCE','ITCO','ITBK','FTOB')
  and f.event_code <> 'REVR'
order by accounting_date, product_code;
