drop table customer;
create table customer ( 
customer_branch number,
customer_Delta_RIB varchar2(23),
customer_FCUBS_RIB varchar2(23),
customer_Title varchar2(10),
customer_Name varchar2(50),
customer_Address varchar2(50));

-------------------------------------------------------------------------------------------------------------------------
-- Initialisation des comptes Flexcube des fonctionnaires basées sur le mapping.                                       --
-- Cette Mise à jour ne concerne que les éventuels fonctionnaire dont les comptes viennent d'être ajouté dans Flexcube --
-- Elle n'est pas obligatoire                                                                                          --
-------------------------------------------------------------------------------------------------------------------------

update customer set customer_fcubs_rib =
(select '1002500'||ma.fcubs_account_no
from delta23.cp_map_delta_fcubs ma
 where substr(customer_delta_rib,6,18) = ma.delta_account_no
) where customer_fcubs_rib is null;



select * from customer order by customer_branch, customer_name;

 
