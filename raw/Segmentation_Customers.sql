SELECT ca.branch_code,ac.account_class,ac.description,count(*) 
FROM sttm_cust_account ca, sttm_account_class ac 
WHERE ca.account_class = ac.account_class 
and ca.record_stat = 'O'
and ca.ac_open_date <= '31-dec-2017'
and ca.branch_code ='&Branch_Code'
group by ca.branch_code,ac.account_class, ac.description
order by ca.branch_code,ac.account_class;


SELECT am.BRANCH_CODE,pr.product_description,count(*),sum(am.AMOUNT_FINANCED) total
FROM cltb_account_master am, cstm_product pr
WHERE am.PRODUCT_CODE = pr.product_code
and (am.BOOK_DATE<='31-dec-2017') and (am.MATURITY_DATE>='31-dec-2017')
and am.BRANCH_CODE ='&Branch_Code'
group by am.BRANCH_CODE,pr.product_description
order by am.BRANCH_CODE;



select c.local_branch Agence,decode('S.'||substr(m.cust_mis_1,1,3),
                                    'S.121','Banque Centrale',
                                    'S.122','Autres institutions de d�p�ts',
                                    'S.123', 'Autres interm�diaires financiers, � l�exclusion des soci�t�s',
                                    'S.124', 'Auxiliaires financiers',
                                    'S.125' ,'Soci�t�s d�assurance et fonds de pension',
                                    'S.131', 'Administration Publique',
                                    'S.141', 'Employeurs',
                                    'S.142','Travailleurs pour leur propre compte',
                                    'S.143', 'Salari�s',
                                    'S.144', 'B�n�ficiaires de revenus de la propri�t� et de transferts',
                                    'S.112', 'Soci�t�s non financi�res priv�es nationales', 
                                    'S.113', 'Soci�t�s non financi�res sous contr�le �tranger',
                                    'S.111','Soci�t�s non financi�res Publiques',
                                    'S.150', 'Institutions sans but lucratif au service des m�nages (ISBL)',
                                    'S.200', 'Autres',
                                    'Autres'
 )"SECTEUR INSTITUTIONNEL",count(*)
from xafnfc.sttm_customer c , mitm_customer_default m
WHERE  c.customer_no = m.customer
and c.record_stat ='O'
and c.local_branch ='&Branch_Code'
and c.cif_creation_date <='31-dec-2017'
group by c.local_branch ,'S.'||substr(m.cust_mis_1,1,3)
order by c.local_branch  ;

select c.local_branch, decode('S.'||substr(m.cust_mis_1,1,3),
                                    'S.121','Banque Centrale',
                                    'S.122','Autres institutions de d�p�ts',
                                    'S.123', 'Autres interm�diaires financiers, � l�exclusion des soci�t�s',
                                    'S.124', 'Auxiliaires financiers',
                                    'S.125' ,'Soci�t�s d�assurance et fonds de pension',
                                    'S.131', 'Administration Publique',
                                    'S.141', 'Employeurs',
                                    'S.142','Travailleurs pour leur propre compte',
                                    'S.143', 'Salari�s',
                                    'S.144', 'B�n�ficiaires de revenus de la propri�t� et de transferts',
                                    'S.112', 'Soci�t�s non financi�res priv�es nationales', 
                                    'S.113', 'Soci�t�s non financi�res sous contr�le �tranger',
                                    'S.111','Soci�t�s non financi�res Publiques',
                                    'S.150', 'Institutions sans but lucratif au service des m�nages (ISBL)',
                                    'S.200', 'Autres',
                                    'Autres'
 )"SECTEUR INSTITUTIONNEL",count(*)
from xafnfc.sttm_customer c , mitm_customer_default m
WHERE  c.customer_no = m.customer
and c.cif_creation_date <='31-dec-2017'
and c.local_branch ='&Branch_Code'
and c.record_stat ='O'
group by c.local_branch, 'S.'||substr(m.cust_mis_1,1,3) ;

