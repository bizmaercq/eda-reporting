select pa.fon_agence, pa.fon_matricule, pa.fon_intitule, pa.fon_fcubs_account, pa.fon_date_creation, sa.sal_montant,nvl(po.pos_balance,0) pos_balance,'01/2013' sal_periode, po.pos_status_dormant, po.pos_no_debit
from sal_cenadi sa , paie_fonctionnaire pa , positions po
where sa.sal_matricule = pa.fon_matricule
and po.pos_ubs_account = pa.fon_fcubs_account
--and pa.fon_date_creation < '01/01/2013'
--and po.pos_status_dormant ='Y'
and to_char(sa.sal_date_paie,'MM/YYYY') = '01/2013'
order by pa.fon_agence, nvl(po.pos_balance,0) desc
