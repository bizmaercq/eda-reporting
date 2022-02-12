select * from INSTITUTIONS t ; 


--- NFC BANK
SELECT '255000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(to_number(ef.eft_amount),7,0) 
from eft_upload ef
WHERE ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and substr(ef.eft_account,4,3) in ('282')
UNION
SELECT '255000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(to_number(ef.eft_amount),7,0) 
from eft_upload ef
WHERE ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and substr(ef.eft_account,4,3) in ('282')
and ef.eft_account in ('0221730101338326','0221720101243606')
------ RIC

Select '22',ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
where ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in('0221730101338326')
; 
---RIC TEXT
select '255000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(to_number(ef.eft_amount),7,0) LINE
from eft_upload ef where  ef.eft_account  in('0221730101338326')  and ef.eft_date='23042021' and ef.eft_matricule is not null
----MONEY OPORTUNITY
Select ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
where ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in('0221720101243606');
--- Cremin Cam
--SELECT '000000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(ef.eft_amount,7,0 )
SELECT ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
WHERE ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in ('0231510101537851');
---- Peoples Finance

--SELECT '000000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(ef.eft_amount,7,0 )
SELECT ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
WHERE ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in ('0231510101585672');

--- AFIB
SELECT '000000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(ef.eft_amount,7,0 )
--SELECT ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
WHERE ef.eft_date ='23042021'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in ('0231630101465386');

--- Action Finance 
--SELECT '000000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(ef.eft_amount,7,0 )
SELECT ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
WHERE ef.eft_date ='24102019'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in ('0231510105218419');

--- PWD Mamf� 
--SELECT '000000'||ef.eft_matricule||rpad(ef.eft_name,27,' ')||substr(ef.eft_account,1,9)||lpad(ef.eft_amount,7,0 )
SELECT ef.eft_matricule,ef.eft_name,ef.eft_account,to_number(ef.eft_amount) eft_amount
from eft_upload ef
WHERE ef.eft_date ='24102019'
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_account in ('0221510101217863');



-- Civil servants NFC Bank's customers
-- Summary
SELECT ca.branch_code,count(*) 
FROM xafnfc.sttm_cust_account ca, eft_upload ef
WHERE ef.eft_account = ca.cust_ac_no
and ca.cust_ac_no not in (/*'0221730101338326','0221720101243606',*/'0201720100667844','0221510106096866','0231510105218419','0311510106944511','0231510101585672','0231510101537851','0231630101465386','0221510101217863')
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_date='24102019'
group by ca.branch_code;
-- Detailed
SELECT ef.eft_date, ca.branch_code,ca.cust_ac_no, ca.ac_desc, ef.eft_matricule, ef.eft_name,ef.eft_amount
FROM xafnfc.sttm_cust_account ca, eft_upload ef
WHERE ef.eft_account = ca.cust_ac_no
and ef.eft_date='24102019'
and ca.cust_ac_no not in (/*'0221730101338326','0221720101243606',*/'0201720100667844','0221510106096866','0231510105218419','0311510106944511','0231510101585672','0231510101537851','0231630101465386','0221510101217863')
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')

--- Civl servants paid in Microfinancial institutions
--- Summary
SELECT ca.ac_desc,ca.cust_ac_no,count(*) 
FROM xafnfc.sttm_cust_account ca, eft_upload ef
WHERE ef.eft_account = ca.cust_ac_no
and ca.cust_ac_no in ('0221730101338326','0221720101243606','0201720100667844','0221510106096866','0231510105218419','0311510106944511','0231510101585672','0231510101537851','0231630101465386','0221510101217863')
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_date='24102019'
group by ca.ac_desc,ca.cust_ac_no;
--- Detailed
SELECT ef.eft_date, ca.branch_code,ca.cust_ac_no, ca.ac_desc, ef.eft_matricule, ef.eft_name,ef.eft_amount
FROM xafnfc.sttm_cust_account ca, eft_upload ef
WHERE ef.eft_account = ca.cust_ac_no
and ca.cust_ac_no in ('0221730101338326','0221720101243606','0201720100667844','0221510106096866','0231510105218419','0311510106944511','0231510101585672','0231510101537851','0231630101465386','0221510101217863')
and substr(ef.eft_matricule,2,1)  in ('0','1','2','3','4','5','6','7','8','9')
and ef.eft_date='24102019'
order by ca.cust_ac_no;

------liste des fonctionnaire du mois n-1 qui sont pas l� au mois n
select ef.eft_date DAT,ef.eft_account COMPTE,ef.eft_amount MONTANT,ef.eft_name NOM ,ef.eft_matricule MATRICULE from  eft_upload ef
where ef.eft_date='23042021'
and substr(ef.eft_account,4,3)='282'
and ef.eft_matricule not in (
select ef.eft_matricule  from  eft_upload ef
where ef.eft_date='24042020'
and substr(ef.eft_account,4,3)='282')

------SQLLOADER
 From CENADI File on CD
sqlldr delta23/nfc@delta control = x:\load\salaires_sup.ctl data=x:\files\Nfc_Act_Et_Pen_201506_sup.txt log = x:\files\Nfc_Act_Et_Pen_201506_sup.log bad= x:\files\Nfc_Act_Et_Pen_201506_sup.bad;
--- From EFT Upload file from SYSTAC
sqlldr nfcread/nfcread1@fcubs control = x:\load\eft.ctl data=x:\files\eftupd.txt log = x:\files\eftupd.log bad= x:\eftupd.bad;






--- File for Upload RIC ex date :24/06/2013

--------------------------


RURAL INVESTMENT CREDIT CURRENT ACCOUNT INDIVIDUAL ENTERPRISES	0221730101338326
CREMIN -CAM CURRENT ACCOUNT COOPERATIVES AUTHORIZED BY FINANCE	0231510101537851
OPUS SECURITATIS SOLIDARITY LIMITED	0311510106944511
PEOPLE FINANCE S.A	0231510101585672
MONEY OPPORTUNITY S.C.A.C SA CURRENT ACCOUNT PRIVATE ENTERPRISES	0221720101243606
ACTION FINANCE D AFRIQUE	0231510105218419
SOCIETE COOPERATIVE SACREC FINANCE	0221510106096866
ACE FINANCE OF BUSINESS CURRENT ACCOUNT PUBLIC ORGANIZATION	0231630101465386
PWD MAMFE COOPERATIVE CREDIT U CURRENT ACCOUNT COOPERATIVES AUTHORIZED BY FINANCE	0221510101217863

