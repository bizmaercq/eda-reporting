SELECT "Libell� Poste","Code Poste",round(sum("[0,5[")) "[0,5[" ,round(sum("[5,10[")) "[5,10[",round(sum("[10,15[")) "[10,15[", round(sum("[15,20[")) "[15,20[", 
nvl(round(sum("[0,5[")),0)+nvl(round(sum("[5,10[")),0)+nvl(round(sum("[10,15[")),0)+ nvl(round(sum("[15,20[")),0) Total
from
(
 SELECT decode(tb.central_bank_code,
'H51','Bons de Caisse',
'H52','Certificats de D�p�t',
'H55','Autres Comptes � r�gime sp�cial',
'H59','',
'H61','Comptes de d�pot � terme',
'H69','',
'H71','Comptes courants cr�diteurs',
'H72','Comptes de ch�ques cr�diteurs',
'H73','Comptes sur livrets',
'H74','D�p�ts de garantie recus de la cli�ntele',
'H79','',
'H81','',
'H82','',
'H84',''
) "Libell� Poste" ,tb.central_bank_code "Code Poste",tb.account_number,
case when tb.amount between 0 and 4999999 then tb.amount/1000000 end "[0,5[", 
case when tb.amount between 5000000 and 9999999 then tb.amount/1000000 end "[5,10[", 
case when tb.amount between 10000000 and 14999999 then tb.amount/1000000  end "[10,15[", 
case when tb.amount between 15000000 and 19999999 then tb.amount/1000000  end "[15,20[" 
FROM vw_trial_balance tb  
WHERE  tb.central_bank_code in ('H51','H5B','H51','H52','H53','H54','H55','H61','H7B','H71','H72','H73','H74','H77','H0B')
and nvl(tb.residence,1) =&Residence

union
 SELECT decode(tb.central_bank_code,'H74','D�p�ts de garantie recus de la cli�ntele') "Libell� Poste" ,tb.central_bank_code "Code Poste",tb.account_number,
case when tb.gl_closing_balance between 0 and 4999999 then tb.gl_closing_balance/1000000 end "[0,5[", 
case when tb.gl_closing_balance between 5000000 and 99999999 then tb.gl_closing_balance/1000000 end "[5,10[", 
case when tb.gl_closing_balance between 10000000 and 14999999 then tb.gl_closing_balance/1000000  end "[10,15[", 
case when tb.gl_closing_balance between 15000000 and 19999999 then tb.gl_closing_balance/1000000  end "[15,20[" 
FROM vw_trial_balance tb  
WHERE  tb.central_bank_code in ('H74')
and nvl(tb.residence,1) =&Residence
) cb
group by  "Libell� Poste","Code Poste";


SELECT * FROM vw_trial_balance tb WHERE tb.account_number ='374007100'

SELECT * FROM vw_trial_balance