select cust_ac_no,customer_name1 "IDENTITE DU DETENTEUR",
decode(m.cust_mis_2 
,'SA',  'SOCIETE ANONYME',
'SAS','SOCIETE PAR ACTIONS SIMPLIFIEES',
'SASU','SOCIETE PAR ACTIONS SIMPLIFIEES UNIPERSONNELLES',  
'SARL','SOCIETE A RESPONSABILITE LIMITEE',
'EURL','ENTREPRISE UNIPERSONNELLE A RESPONSABILITE LIMITEE', 
'SCS','SOCIETE EN COMMANDITE SIMPLE',
'SCA','SOCIETE EN COMMANDITE PAR ACTION',
'SNC','SOCIETE EN NOM COLLECTIF',
'SASP','SOCIETE ANONYME SPORTIVE PROFESSIONNELLE', 
'SP','SOCIETE EN PARTICIPATION',
'GIE','GROUPEMENT D’INTERETS ECONOMIQUES',
'ASCO','AUTRES SOCIETES COMMERCIALES'
,'AUTRES FORMES JURIDIQUES')
"FORME JURIDIQUE",null "OUVERT PAR",null "FONCTION",a.ac_open_date "DATE OUVERTURE",
(select max(trn_dt) from actb_history h where h.ac_no = a.cust_ac_no ) as "DATE DERNIER MOUVEMENT", a.ac_desc "OBJET DU COMPTE",null "EXIGENCE AUTORISATION MINFI", nvl(a.lcy_curr_balance,0) SOLDE,null "JUSTIF DES SOLDES DEBITEURS"
from sttm_cust_account a join sttm_customer c on a.cust_no = c.customer_no
                       join mitm_customer_default m on c.customer_no = m.customer
where account_class in ('161','162','163','171','191');
