select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.TRN_REF_NO,a.TRN_CODE, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
--WHERE substr(a.AC_NO,1,9) between '370000000' and '371119000'
--WHERE substr(a.AC_NO,1,2) in ('32'/*,'34','37','38'*/)
WHERE a.AC_NO = '0232830101431424'
--and a.AC_BRANCH ='022'
and a.TRN_DT between '01/01/2020' and '26/03/2020';


-- Detail with customer and related account 
select * from 
(select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.TRN_REF_NO,a.TRN_CODE,a.RELATED_ACCOUNT ,acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT) Narrative
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
--WHERE substr(a.AC_NO,1,9) between '45300000' and '453999999'
WHERE  substr(a.AC_NO,1,9) in ('371119000')
--WHERE a.AC_NO = '0241730104811187'
--and a.AC_BRANCH ='022'
and a.TRN_DT between '01/01/2020' and '30/04/2020'
order by a.TRN_REF_NO, a.TRN_CODE );


--- Detail with Related account and customer for TDs
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.related_account,sa.ac_natural_gl Reporting_gl,c.customer_name1,
 a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT, x.deposit_amount AMONUT, u.ude_value INT_RATE, x.value_date Start_date, x.td_maturity_date Maturity_date
from acvw_all_ac_entries a , sttm_customer c, tdvw_td_details x,ictm_acc_udevals u, sttb_account sa
where substr(a.related_account,9,6) = c.customer_no  
and x.account_no = a.related_account
and u.acc = a.related_account
and a.related_account = sa.ac_gl_no
/*and u.ude_id='INT_RATE'*/ 
--and substr(a.AC_NO,1,9) between '453000000' and '453999999' 
and substr(a.AC_NO,1,9) in ('719006000')
---and substr(a.AC_NO,1,16) in ('0241720104483279') 
--and substr(a.RELATED_ACCOUNT,4,2)='57'
and a.trn_dt  between '01-JAN-2018' and '30-DEC-2018'
--and substr(a.related_account,9,6) ='044832'
--and a.ac_branch ='042';
--and a.batch_no ='9999'
--and acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT) like 'PROCESSING%';

SELECT * FROM gltm_glmaster WHERE gl_code like '982%';

select  a.AC_BRANCH, a.AC_NO,a.TRN_DT, a.TRN_REF_NO,a.TRN_CODE, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) = '381004000' 
--where substr(a.AC_NO,1,9) between '2000000000' and '299999999' 
and  a.TRN_DT  between '01-MAR-2015' and '31-OCT-2018';



------- extraction compte 381006000(western union)
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,
 a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) between '328000000' and '328009999' 
and a.TRN_DT between '01/01/2019' and '30/04/2019' 
---and a.AC_BRANCH='051'
 ORDER BY a.AC_BRANCH, a.TRN_DT ;

--- Extraction connaissant le product code 



--- extraction d'une ecriture comptable connaissant le montant et la date
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNselect  a.AC_BRANCH, a.AC_NO,a.TRN_DT, a.TRN_REF_NO,a.RELATED_ACCOUNT, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where a.AC_NO = '280141000 ' and '296600000'
--and substr(a.related_account,4,1) ='1'
--and substr(a.TRN_REF_NO,4,4) in ('DIOC','DTOC')
and  a.TRN_DT between '01/01/2017' and '31/12/2017'-- order by a.AC_BRANCH,a.AC_NO,a.TRN_DT ;T else 0 end  CREDIT
from acvw_all_ac_entries a 
where a.LCY_AMOUNT=9566
and a.TRN_DT ='14-APR-2015';


 

and a.MODULE ='DE'
and a.TRN_DT between '01/05/2012' and '31/01/2012';

-- Solde des GLs � une periode donn�e

SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc, gl.dr_bal_lcy, gl.cr_bal_lcy 
FROM gltb_gl_bal gl, gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
and gl.gl_code between '620000000' and '629999999'
and a.TRN_DT between '01/01/2018' and '31/10/2018'
 ---and fin_year='FY2016' and period_code ='M06' 
order by gl.branch_code,gl.gl_code;
 
--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE bon

select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) ='454101000'
--where substr(a.AC_NO,1,9) between '200000000' and '249999999'
and a.TRN_DT between '01-JAN-2018' and '31-OCT-2018'
order by a.AC_BRANCH,a.trn_dt ;
---and a.AC_BRANCH='50';

------- tax et commission  dormant account corporate and salary
select sum(CREDIT) MONTANT_COMMISSION ,ACCOUNT_COSTOMER,BRANCH,GL from( 
select  a.AC_BRANCH BRANCH, a.AC_NO GL,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT,a.RELATED_ACCOUNT ACCOUNT_COSTOMER
from acvw_all_ac_entries a
where substr(a.AC_NO,1,9) in ('434003000') ---tax
--where substr(a.AC_NO,1,9) in ('714001000','721003000','719006000','729001500','729009300','719001000','728402000') gl commisison  salary
--where substr(a.AC_NO,1,9) in ('714001000','719006000','720101000','729001000','749001000','729001500','729009300','729001200','729005100','728402000') gl commisison  corporate
and substr (a.RELATED_ACCOUNT,4,3) in ('281','282','283','285') 
--and substr (a.RELATED_ACCOUNT,4,3)  in ('112','131','151','161','163','164','171','172','173','174','192') 
--and a.RELATED_ACCOUNT='0202820100256509'
and a.TRN_DT between '01/01/2018' and '31/12/2018')
where ACCOUNT_COSTOMER in (select distinct l.cust_ac_no
from sttm_cust_account l 
where l.date_last_cr_activity between '01/10/2017' and '01/03/2019'
and substr(l.cust_ac_no,4,3) in('281','282','283','285')
---and substr (a.RELATED_ACCOUNT,4,3)  in ('112','131','151','161','163','164','171','172','173','174','192')
and l.ac_stat_dormant like 'Y')
group by ACCOUNT_COSTOMER,BRANCH,GL;

--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,9) = '318001000'
---where substr(a.AC_NO,1,9) between '200000000' and '249999999'
and a.AC_BRANCH='31'
and a.TRN_DT between '01-JAN-2016' and '31-OCT-2018'
order by a.AC_BRANCH,a.TRN_DT;

--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE connaissant le client
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,ca.ac_desc,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a , sttm_cust_account ca
--where substr(a.AC_NO,1,9) = '714001000'
where substr(a.related_account,9,6) = ca.cust_no
and substr(a.AC_NO,1,9) between '660000000' and '669999999'
and a.TRN_DT between '01-JAN-2018' and '30-JUN-2018'
order by a.AC_BRANCH,a.TRN_DT;




--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE COMPTE MUTUEL fonctionnement
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0233640205006141' 
and a.TRN_DT between '01-OCT-2014' and '28-APR-2018';
--- extraction ecriture compte MUTUEL fonctionnement POUR UNE PERIODE pour compte client (avec TRN_code, Value date)
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT,a.VALUE_DT, a.TRN_CODE
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0233640205006141' 
and a.TRN_DT between '01-OCT-2014' and '29-OCT-2018'

--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE COMPTE MUTUEL principal
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0233640105006125'
and a.TRN_DT between '01-may-2018' and '28-aug-2018';

--- extraction ecriture compte MUTUEL principal POUR UNE PERIODE pour compte client (avec TRN_code, Value date)
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO,acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT,a.VALUE_DT, a.TRN_CODE
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0233640105006125' 
and a.TRN_DT between '30-APR-2014' and '29-JUN-2018'
--and a.TRN_DT='19-NOV-2015';


---- GL code  NAME OF CUSTOMER   AMOUNT   START DATE  MATURITY DATE  INTEREST RATE
SELECT distinct y.branch_code,y.gl_code,y.cust_ac_no,x.customer_Name,x.Date_of_Open, 
x.Deposit_amount,ss.ude_value INTEREST_RATE,x.Total_interest_Payable,x.TD_Maturity_date maturity_date
FROM gltb_cust_accbreakup y, tdvw_td_details x,ictm_acc_udevals ss 
where y.gl_code like '35%'-- and y.period_code='M06'
and y.fin_year='FY2015' --and y.cr_bal_lcy<>'0'
and ss.ude_id='INT_RATE'
and x.TD_Maturity_date >'31-dec-2015'
and y.cust_ac_no=x.Account_no
AND X.Account_no= ss.acc

--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE pour compte client (avec TRN_code, Value date)
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, a.TRN_CODE,acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT,a.VALUE_DT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0231720101508304' 
and a.TRN_DT between '30-APR-2012' and '30-JUN-2018'
--and a.TRN_DT='19-NOV-2015';
select * from acvw_all_ac_entries
--- extraction d'une ecriture comptable  compte CNPS  POUR UNE PERIODE pour compte client connaissant le montant
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where substr(a.AC_NO,1,16) ='0231630103999511' 
and a.TRN_DT between '12-MAR-2014' and '14-MAR-2014'
--and a.TRN_DT='13-MAR-2014';

--- extraction d'une ecriture comptable d'un compte POUR UNE PERIODE COMPTE MUTUEL principal
select  a.AC_BRANCH, a.AC_NO,a.TRN_DT,a.USER_ID,a.TRN_REF_NO, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a 
where a.AC_BRANCH='051'
and a.TRN_DT between '01-JAN-2018' and '28-jun-2018';

---SCRIPT DE RECHERCHE BIP--


SELECT  user_id    ,substr(trn_reF_no,1,3) posting_branch,ac_branch,trn_reF_no,  AC_NO ,ac_ccy, DRCR_IND,  DECODE(DRCR_IND ,'D', nvl(fCY_AMOUNT,0),0) dr_amount_fcy, DECODE(DRCR_IND ,'D', LCY_AMOUNT,0) dr_amount_lcy  ,
   DECODE(DRCR_IND ,'C', nvl(fCY_AMOUNT,0) ,0) cr_amount_fcy, DECODE(DRCR_IND ,'C', LCY_AMOUNT,0) cr_amount_lcy ,
    to_char(TRN_DT,'dd-MON-yyyy') POSTING_DATE, to_char(value_dt,'dd-MON-yyyy')  VALUE_DATE
    FROM ACVW_ALL_AC_ENTRIES
    WHERE
   TRN_DT='31-JUL-2018'
     AND BATCH_NO = '7377'
    -- AND
 --    substr(trn_reF_no,1,3) ='043'
   and IB ='N'
   order by drcr_ind , ac_no;
   
   SELECT * FROM Actb_Daily_Log dd where dd.batch_no = '7377' and STMT_DT='31-JUL-2018';


----nombre de sms et volume de transactions par ann�es 
select a.FINANCIAL_CYCLE, count(a.ac_no) nombre,sum(a.LCY_AMOUNT)volume
FROM acvw_all_ac_entries a  
where a.trn_code='SMS' and length(a.ac_no)<>9 
--and a.FINANCIAL_CYCLE='FY2016'
group by a.FINANCIAL_CYCLE;

----EXTRATCTION ECRITURE d'une liste de comptes client avec intitule de compte
select  a.AC_BRANCH, a.AC_NO,b.cust_name1,a.TRN_DT, a.TRN_REF_NO,a.TRN_CODE, acpks_stmt.fn_get_rtl_narrative_desc(a.TRN_REF_NO,a.MODULE,'TXN',a.TRN_CODE,'ENG',A.AC_NO,A.AC_BRANCH,a.ac_ccy,a.trn_dt,a.LCY_AMOUNT)
,case when a.DRCR_IND = 'D' then a.LCY_AMOUNT else 0 end  DEBIT, case when a.DRCR_IND = 'C' then a.LCY_AMOUNT else 0 end  CREDIT
from acvw_all_ac_entries a, sttb_account b 
where a.AC_NO=b.ac_gl_no 
and substr(a.AC_NO,1,16) in ('0202810100032003','0212810100031212','0222810100030906', '0232810101426042',
'0232810101430504','0232810104600173', '0432810200032159')
--where substr(a.AC_NO,1,9) between '2000000000' and '229999999' 
and  a.TRN_DT  between '13-sep-2016' and '14-sep-2016'
order by a.ac_branch;

select * from sttm_cust_account a where a.cust_ac_no='0232810101421483' 

----nombre de carte et volume de transactions par ann�es 
select FINANCIAL_CYCLE, count(atm_card_no) nombre,sum(volume)/1000000 volume
from (SELECT a.FINANCIAL_CYCLE, cd.atm_card_no, sum(a.LCY_AMOUNT)volume  FROM acvw_all_ac_entries a ,swtm_card_details cd 
where a.AC_NO=cd.fcc_acc_no
and  a.trn_code ='ACW' and length(a.ac_no)<>9 
--and a.FINANCIAL_CYCLE='FY2016'
group by a.FINANCIAL_CYCLE,cd.atm_card_no)
group by FINANCIAL_CYCLE;

---- liste de client n'ayant pas eu de transaction il y a 6 mois compte courant
SELECT   a.AC_NO, b.cust_name1,max(a.TRN_DT) date_last_transaction
FROM acvw_all_ac_entries a ,sttb_account b 
where substr(a.AC_NO,9,6)= b.cust_no 
and substr(a.AC_NO,4,3)='282'
and a.TRN_CODE in ('ACW','FCW','CCW','CHW','BWO','BWT','CWT','IIP','IIF')
having max(a.TRN_DT)<=sysdate-720 
GROUP BY  a.AC_NO,b.cust_name1
order by substr(a.AC_NO,1,3),a.AC_NO
-----liste des compte dormant pour une agence
SELECT   a.AC_NO, b.cust_name1,max(a.TRN_DT) date_last_transaction
FROM acvw_all_ac_entries a ,sttb_account b 
where substr(a.AC_NO,9,6)= b.cust_no 
and a.AC_BRANCH='023'
and a.TRN_CODE in ('ACW','FCW','CCW','CHW','BWO','BWT','CWT','IIP','IIF')
having max(a.TRN_DT)<=sysdate-720 
GROUP BY  a.AC_NO,b.cust_name1
order by substr(a.AC_NO,1,3),a.AC_NO


---- liste de client n'ayant pas eu de transaction il y a 6 mois avec solde courrant par agence
SELECT   a.AC_NO, b.ac_desc,max(a.TRN_DT) date_last_transaction,b.acy_avl_bal solde_disponible
FROM acvw_all_ac_entries a ,sttm_cust_account b 
where a.AC_NO= b.cust_ac_no 
and a.AC_BRANCH='023'
and a.TRN_CODE in ('ACW','FCW','CCW','CHW','BWO','BWT','CWT','IIP','IIF')
having max(a.TRN_DT)<=sysdate-720 
GROUP BY  a.AC_NO,b.ac_desc,b.acy_avl_bal
order by substr(a.AC_NO,1,3),a.AC_NO

select * from acvw_all_ac_entries a  
WHERE substr(a.AC_NO,4,3) in ('164','165','170') and a.user_id='ONLINE' 

select * from tab where tabtype='TABLE' order by tname

--- liste corporate qui n'ont jamais fait les transactions online----
select b.branch_code agence,b.cust_ac_no compte, b.ac_desc,b.account_class  from  sttm_cust_account b 
where substr(b.cust_ac_no,4,3) in ('164','165','170') and   b.cust_ac_no NOT  in (select a.AC_NO from acvw_all_ac_entries a  
WHERE a.user_id='ONLINE' ) 
order by b.branch_code,b.ac_desc

---- liste de client n'ayant pas eu de transaction il y a 6 mois avec solde courrant
SELECT   a.AC_NO, b.ac_desc,max(a.TRN_DT) date_last_transaction,b.acy_avl_bal solde_disponible
FROM acvw_all_ac_entries a ,sttm_cust_account b 
where a.AC_NO= b.cust_ac_no 
and substr(a.AC_NO,4,3)='282'
and a.TRN_CODE='SAL'
GROUP BY  a.AC_NO,b.ac_desc,b.acy_avl_bal
order by substr(a.AC_NO,1,3),a.AC_NO

---
