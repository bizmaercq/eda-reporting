select 
decode (rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' '),
'ASC  ','PE',
'ASCI ','PE',
'ASCO ','ME',
'ASDP ','PE',
'ASDPC','PE',
'EURL ','PE',
'GIE  ','PE',
'OP   ','PE',
'SCP  ','PE',
'SEL  ','PE',
'SICA ','PE',
'SNC  ','PE',
'SA   ','ME',
'SARL ','PE',
'SAS  ','ME',
'SASO  ','PE',
'SCA  ','PE',
'SCEA ','PE',
'SCEC ','PE',
'SCI  ','PE',
'SCIC ','PE',
'SCOP ','PE',
'SM   ','ME',
'SP1  ','PE','TPE') forme_juridique,count(*) Nombre,sum(l.amount_financed)/1000000 Montant
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and c.customer_type ='C'
and l.BOOK_DATE between '01/01/2017'and '31/12/2017'
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

------repartition de credit par durée de credit

select 
decode (rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' '),
'ASC  ','PE',
'ASCI ','PE',
'ASCO ','ME',
'ASDP ','PE',
'ASDPC','PE',
'EURL ','PE',
'GIE  ','PE',
'OP   ','PE',
'SCP  ','PE',
'SEL  ','PE',
'SICA ','PE',
'SNC  ','PE',
'SA   ','ME',
'SARL ','PE',
'SAS ','ME',
'SASO ','PE',
'SCA  ','PE',
'SCEA ','PE',
'SCEC ','PE',
'SCI  ','PE',
'SCIC  ','PE',
'SCOP ','PE',
'SM   ','ME',
'SP1  ','PE','TPE') forme_juridique,
case 
when to_number(l.NO_OF_INSTALLMENTS)<3 then 'Tres_Court_Terme'
when to_number(l.NO_OF_INSTALLMENTS) between 3 and 12 then 'Court_Terme' 
when to_number(l.NO_OF_INSTALLMENTS) between 24 and 60 then 'Moyen_Terme'
when to_number(l.NO_OF_INSTALLMENTS) between 60 and 120 then 'Court_Terme'  
when to_number(l.NO_OF_INSTALLMENTS)>120 then 'Long_Terme' 
else 'Moyen_Terme'
end      
  ,count(*) Nombre,sum(l.amount_financed)/1000000 Montant
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and c.customer_type ='C'
and l.BOOK_DATE between '01/01/2013'and '31/12/2013'
group by rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' '),to_number(l.NO_OF_INSTALLMENTS);

----TEST
select 
rpad(decode(m.cust_mis_2,'FOR999','SARL',m.cust_mis_2),5,' ')
from xafnfc.sttm_customer c ,xafnfc.mitm_customer_default m ,cltb_account_master l 
where c.customer_no = m.customer 
and c.customer_no=l.CUSTOMER_ID
and c.customer_type ='C'
and l.BOOK_DATE between '01/01/2013'and '31/12/2013'
