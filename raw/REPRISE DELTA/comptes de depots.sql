select c.comw_age BRANCH, substr(c.comw_cha,1,3) CLASS ,decode(substr(c.comw_cha,1,3)
,'351','BONS DE CAISSES',
'352','CERTIFICATS DE DEPOSIT',
'353','PLAN EPARGNE LOGEMENT',
'354','PLAN EPARGNE RETRAITE',
'355','COMPTE A REGIME SPECIAL',
'355','BONS DE CAISSES A PLUS DE 2 ANS',
'360','DAT',
'361','BONS DE CAISSES PARTICULIER',
'362','DAT DE 3 A 6 MOIS',
'363','DAT DE 6 MOIS A 1 AN',
'364','DAT DE 1 AN A 2 ANS',
'365','DAT DE PLUS DE  2 ANS',
'369','DETTES RATTACHEES AUX COMPTES DEBITEURS',
'371','COMPTES COURANTS ENTREPRISES',
'372','COMPTES COURANTS INDIVIDUS',
'373','COMPTES EPARGNE',
'374','DEPOTS DE GARANTIE',
'375','AVANCES SUR DAT',
'376','NANTISSEMENTS',
'378','CREANCES RATTACHEES',
'379','DETTE RATTACHEE AUX COMPTES CREDITEURS',
'AUTRES DEPOTS'
) Type, count(*) COUNT ,sum(c.comw_sde) AMOUNT
from compte2011 c 
where c.comw_cha between '35000' and '37999'
group by c.comw_age, substr(c.comw_cha,1,3) 
having sum(c.comw_sde) <>0
order by c.comw_age,substr(c.comw_cha,1,3);
