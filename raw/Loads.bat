REM Chargement de la table des fonctionnaires NB. ce chargement doit se faire une seule fois 
for %1 in (.\fon*.txt) do sqlldr delta23/nfc@delta control = x:\load\fonctionnaires data=%1

REM Chargement Périodique des salaires du mois
for %1 in (.\Nfc_*.txt) do sqlldr delta23/nfc@delta control = x:\load\salaires.ctl data= %1
