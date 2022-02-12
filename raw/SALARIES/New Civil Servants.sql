-- Print list to send to CENADI
SELECT ncs_matricule,ncs_code_minfi,ncs_fcubs,ncs_nom,ncs_prenom FROM new_civil_servants WHERE status = 0;


select ncs_matricule || ncs_code_minfi || ncs_fcubs ||
       rpad(upper(ncs_nom), 25, ' ') || rpad(upper(ncs_prenom), 25, ' ')
  from new_civil_servants 
where to_char(ncs_date,'DD/MM/YYYY')= '02/08/2012';


select ncs_matricule Matricule , ncs_code_minfi CODE_MINFI , ncs_fcubs RIB,
       rpad(upper(ncs_nom), 25, ' ') NOM , rpad(upper(ncs_prenom), 25, ' ') PRENOMS
  from new_civil_servants 
where to_char(ncs_date,'DD/MM/YYYY')= '09/12/2015';

    

                         
select * from new_civil_servants;

truncate table new_accounts;
insert into new_accounts(na_matricule,na_fcubs_account)
select ncs_matricule,substr(ncs_fcubs,8,16)
from new_civil_servants;

select * from temp_new_accounts;

update tmp_paie_fonctionnaire set fon_fcubs_account = (select account from temp_new_accounts where mat = fon_matricule and account is not null)
where fon_matricule in (select mat from temp_new_accounts)

update tmp_paie_fonctionnaire set fon_agence =substr(fon_fcubs_account,2,2)
where fon_matricule in (select mat from temp_new_accounts)


select * from tmp_paie_fonctionnaire

select * from paie for update

insert into  tmp_sal_cenadi select * from sal_cenadi

select * from  tmp_sal_cenadi    where   to_char(sal_date_paie,'DD/MM/YYYY') ='25/09/2012'

create table back_temp_paie as select * from tmp_paie_fonctionnaire

   insert into temp_salaire 
   select sc.sal_matricule,sc.sal_date_paie,sum(sc.sal_montant) sal_montant ,'26/09/2012'
   from tmp_sal_cenadi sc
   where   to_char(sal_date_paie,'DD/MM/YYYY') ='25/09/2012'
   group by sc.sal_matricule,sc.sal_date_paie;
   
      update tmp_paie_fonctionnaire pf set (pf.fon_montant_mois_actuel,pf.fon_date_dernier_salaire) =
   (select sum(sc.sal_montant),sc.sal_value_date
    from temp_salaire sc
    where sc.sal_matricule = pf.fon_matricule
    group by sc.sal_value_date
   ) ;
