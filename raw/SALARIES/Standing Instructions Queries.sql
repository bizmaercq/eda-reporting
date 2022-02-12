--- Standing instructions Crédités au profit des sociétés d'assurances
select distinct ae.TXN_INIT_DATE,ae.TRN_REF_NO,cm.internal_remarks , ae.AC_BRANCH,ca.cust_ac_no ,  cu.customer_name1, ae.AC_NO, ae.DRCR_IND, ae.LCY_AMOUNT
from XAFNFC.ACVW_ALL_AC_ENTRIES_FIN ae
join XAFNFC.SITB_CONTRACT_MASTER cm on ae.TRN_REF_NO = cm.contract_ref_no
join XAFNFC.STTM_CUSTOMER cu on cu.customer_no = substr(cm.dr_account,9,6)
join XAFNFC.STTM_CUST_ACCOUNT ca on cm.dr_account = ca.cust_ac_no
where module ='SI'
and trn_code = 'SIP'
and event='SUXS'
and period_code ='&PERIOD'
and financial_cycle ='FY2021'
and ca.account_class in ('282','281','283','284','285')
--and drcr_ind = 'D'
--and ae.AC_NO in ('0501920101301570','0221730101301563','0401730102634752','0411730103070946','0421730103523921','0431920103575355','0301730102199372') -- Beneficial
--and ae.AC_NO in ('0221730101373246','0301730102199663','0221730101373246','0401730102667635','0411730103217416') -- Colina All Life
--and ae.AC_NO ='0301730102199663' -- Colina Bamenda
--and ae.AC_NO in ('0221730101373246') -- Colina Yaoundé 3
--and ae.AC_NO in ('0401730102667635') -- Colina Kumba 
--and ae.AC_NO in ('0411730103217416') -- Colina Muyuka
and ae.AC_NO   = '0221730101291863' -- SCE
--and ae.AC_NO ='0231120104202509' -- Crédit Foncier
--and ae.TXN_INIT_DATE between '01/04/2012' and '30/04/2013'
order by ae.TXN_INIT_DATE;

--- Standing instructions Crédités au profit de Beneficial Life
select rpad(nvl(substr(cm.internal_remarks,14,7),'NNNNNNN'),10,'L') ||Rpad(cu.customer_name1,32,' ')||ca.cust_ac_no ||to_char(ae.TXN_INIT_DATE,'YYYYMMDD')||'XXXXXXX'||lpad(ae.LCY_AMOUNT,15,'0')||'P'
from XAFNFC.ACVW_ALL_AC_ENTRIES_FIN ae
join XAFNFC.SITB_CONTRACT_MASTER cm on ae.TRN_REF_NO = cm.contract_ref_no
join XAFNFC.STTM_CUSTOMER cu on cu.customer_no = substr(cm.dr_account,9,6)
join XAFNFC.STTM_CUST_ACCOUNT ca on cm.dr_account = ca.cust_ac_no
where module ='SI'
and trn_code = 'SIP'
and event='SUXS'
and period_code ='M08'
and financial_cycle ='FY2016'
and ca.account_class ='282'
--and drcr_ind = 'D'
and ae.AC_NO in ('0501920101301570','0221730101301563','0401730102634752','0411730103070946','0421730103523921','0431920103575355','0301730102199372')
--and ae.AC_NO ='0301730102199663' -- Colina Bamenda
--and ae.AC_NO ='0221730101373246' -- Colina Yaoundé 3
--and ae.AC_NO ='0221730101291863' -- SCE
order by ae.TXN_INIT_DATE;


--- Standing instruction programmés pour une période

select distinct m.dr_acc_br,m.contract_ref_no,c.customer_name1,m.dr_account,m.cr_account,m.si_amt,i.book_date, m.si_expiry_date 
from sitb_instruction i , sitb_contract_master m, sttm_customer c
where m.instruction_no = i.instruction_no
and substr(m.dr_account,9,6) = c.customer_no
and m.si_expiry_date >='&Expiry_date'
--and i.book_date between '01/11/2014' and '30/11/2014'
and m.cr_account in ('0501920101301570','0221730101301563','0401730102634752','0411730103070946','0421730103523921','0431920103575355','0301730102199372')
--and m.cr_account ='0221730101291863' -- SCE
order by m.si_expiry_date;

-- contrats SI non executés

select distinct cm.contract_ref_no,cu.customer_name1, cm.dr_account,cm.cr_account, cm.si_amt,
case when ca.lcy_curr_balance < cm.si_amt then 'PROVISION'
     else
       case when ca.ac_stat_no_dr ='Y' then 'NO_DEBIT' 
          else 
            case when ca.ac_stat_dormant ='Y' then 'DORMANT' else 'OTHERS' end
               end
          end REASON
from sitb_cycle_detail cd, sitb_contract_master cm, sttm_customer cu, sttm_cust_account ca
where cm.contract_ref_no = cd.contract_ref_no  
and cu.customer_no = substr(cm.dr_account,9,6)
and cm.dr_account = ca.cust_ac_no
and cd.event_code is not null
and cd.retry_date between '&StartDate' and '&EndDate'
--and cm.cr_account in ('0501920101301570','0221730101301563','0401730102634752','0411730103070946','0421730103523921','0431920103575355','0301730102199372')
and cm.cr_account   = '0221730101291863' -- SCE
and cm.contract_ref_no not in (select dd.contract_ref_no from sitb_cycle_detail dd where dd.event_code = 'SUXS' and dd.retry_date between '&StartDate' and '&EndDate');



SELECT * FROM Smtb_User WHERE user_id ='FAWONDO' FOR UPDATE NOWAIT; 
