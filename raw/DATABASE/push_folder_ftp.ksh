#!/bin/bash
# Franco ATEKWANA 20/09/2016
#
################################################################
#export dans les fichiers à transférer
#transfert des fichiers vers le serveur INTERSYST
#
lftp  172.20.50.22 << EOT
user EODREPORT Nfcerty02
mirror -R  /home/obiee/oracle/products/2016-09-19
quit
EOT 