-- Clients
select cu.customer_no||';'||cu.customer_name1
from xafnfc.sttm_customer cu
where cu.staff ='Y'
order by cu.customer_no;


-- comptes
select ca.cust_ac_no||';'||ca.ac_desc||';'||ca.branch_code||';'||ca.cust_no
from xafnfc.sttm_cust_account ca
where ca.account_class='281'
order by ca.cust_ac_no;


-- purge de la table
truncate table web_actb_transaction_log

--solde d'ouverture � inserer le premier jour
insert into
 WEB_actb_transaction_log  (trn_date, value_date,  account,  trn_ref_no,  description,  debit,credit,  balance)
select   to_date('&Date','DD/MM/YYYY') TRN_DATE,to_date('&Date','DD/MM/YYYY') VALUE_DATE ,aa.account,'00000000000000' TRN_REF_NO,'OPENNING BALANCE' DESCRIPTION ,case when aa.lcy_closing_bal <0 then -aa.lcy_closing_bal else 0 end Debit,case when aa.lcy_closing_bal >=0 then aa.lcy_closing_bal else 0 end Credit, aa.lcy_closing_bal Balance 
from xafnfc.actb_accbal_history aa ,xafnfc.sttm_customer c 
where substr(aa.account,9,6)  = c.customer_no
and aa.bkg_date =
(select max(a.bkg_date) from xafnfc.actb_accbal_history a 
where a.bkg_date < '&Date' 
and a.account = aa.account)
and substr(aa.account,4,3)='281';

-- mise � jour du calcul de base

update web_actb_transaction_log set calc ='Y';


--Mouvements � partir d'une p�riode
insert into WEB_actb_transaction_log(trn_date, value_date,  account,  trn_ref_no,  description,  debit,credit,  balance)
select a.trn_dt TRN_DATE,a.value_dt,a.ac_no, a.TRN_REF_NO,substr(xafnfc.acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,A.LCY_AMOUNT) || ' / ' ||
'Teller Ref No:' || (SELECT XREF FROM xafnfc.DETB_RTL_TELLER WHERE TRN_REF_NO = a.TRN_REF_NO),1,100) DESCRIPTION
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT,0 BALANCE
from xafnfc.acvw_all_ac_entries a, xafnfc.sttm_customer c
where substr(a.AC_NO,9,6) = c.customer_no
and substr(a.AC_NO,4,3)='281'
and a.trn_dt >='&Date'
and a.TRN_DT<='&EndDate'
order by a.TRN_DT;


-- Mouvements

select rtrim(wl.trn_ref_no,' ')||';'||wl.account||';'||rtrim(wl.description,' ')||';'||wl.trn_date||';'||wl.value_date||';'||wl.debit||';'||wl.credit||';'||wl.balance from web_actb_transaction_log wl where gen='N' order by serial

select BALANCE   from web_actb_transaction_log  where serial = (select max(serial) from web_actb_transaction_log where account ='0232810101431474' and calc ='Y');