select pf.fon_agence AGENCE, pf.fon_matricule MATRICULE, pf.fon_delta_account DELTA_ACCOUNT, pf.fon_fcubs_account FLEXCUBE_ACCOUNT, '1002500' || pf.fon_fcubs_account NEW_RIB, pf.fon_intitule
from delta23.paie_fonctionnaire pf WHERE pf.fon_matricule IN ('202363U', '518198U')
