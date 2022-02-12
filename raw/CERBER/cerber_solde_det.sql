select '31-JAN-2021' dar, 
r.branch_code age,
r.cust_ac_no com,
'01' cle, 
r.ccy_code dev,
m.customer_name1 cli,
substr(r.gl_code,1,5)  chal,
(r.cr_bal_lcy-r.dr_bal_lcy) sldd,
 (r.cr_bal_lcy-r.dr_bal_lcy) sldcv,
 m.nationality nat,
 nvl(j.cust_mis_8, 'RESIDENT') res,
 '1' txb,
 r.cr_mov_lcy cumc,
 r.dr_mov_lcy cumd,
decode (j.cust_mis_8,'RESIDENT','001','NRCAMER','002','NRCEMAC','003','NRWORLD','004','001') chal1,
case
when  substr(r.cust_ac_no,4,3)='161' then 'Administration Publiques Centrale'
when  substr(r.cust_ac_no,4,3)='162' then 'Administration Publiques Local'
when  substr(r.cust_ac_no,4,3)='163' then 'Organisme Publiques'
when  substr(r.cust_ac_no,4,3)='164' then 'Administration Privee'
when  substr(r.cust_ac_no,4,3)='171' then 'Entreprise Publiques'
when  substr(r.cust_ac_no,4,3)='172' then 'Entreprise Privee' 
when  substr(r.cust_ac_no,4,3)='173' then 'Entreprise Individuelles' 
when  substr(r.cust_ac_no,4,3) in('281','282','283','284','285','383','382','381','384','385','386','387') then 'Particuliers'   
ELSE 'RAS' end chl2, 
case
when  to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2))  between 01 and 09 then 'Agriculture'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 10 and 14 then 'Extraction'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 15 and 37 then 'Fabrication'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 40 and 45 then 'BTP_Energie'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 50 and 55 then 'Commerce'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 60 and 64 then 'Transport_communication'
when  to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2))between 65 and 67 then 'Activit_financiere'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 70 and 75 then 'Service'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 80 and 85 then 'Education'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 91 and 99 then 'Autre_activity'
ELSE 'RAS' end chl3,    
m.country chal4,
case
when  to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2))  between 01 and 09 then 'A'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 10 and 14 then 'B'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 15 and 37 then 'C'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 40 and 45 then 'F'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 50 and 55 then 'G'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 60 and 64 then 'H'
when  to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2))between 65 and 67 then 'K'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 70 and 75 then 'N'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 80 and 85 then 'P'
when to_number(substr(decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3),1,2)) between 91 and 99 then 'S'
ELSE 'RAS' end chl5,
m.udf_3 chal6,
case
when  r.branch_code  between '010' and '024' then '102'
when  r.branch_code  between '030' and '032' then '107'
when  r.branch_code  between '040' and '042' then '110'
when  r.branch_code  between '050' and '051' then '105'  
 end chl7,   
decode(j.cust_mis_3,'GRP999','93.0',j.cust_mis_3) chal8,
'chal9' chal9,
'chal10' chal10,
'chal11' chal11,
'chal12' chal12,
'chal13' chal13,
'chal14' chal14,
'chal15' chal15,
'chal16' chal16,
'chal17' chal17,
'chal18' chal18,
'chal19' chal19,
'chal20' chal20,
'31-JAN-2021' dcre,
'31-JAN-2021' dmod,
'CERBER' uticre,
'CERBER' utimod
from gltb_cust_accbreakup r ,mitm_customer_default j,sttm_customer m
where substr(r.cust_ac_no,9,6)=j.customer
and  substr(r.cust_ac_no,9,6)=m.customer_no
and r.fin_year='FY2021'
 and r.period_code='M01'
 and r.gl_code like '37%'
 order by r.branch_code
 
 
 
 
 
 
 
 
