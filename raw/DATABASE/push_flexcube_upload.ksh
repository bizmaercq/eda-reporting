#!/bin/bash
# Franco ATEKWANA 02/01/2019
#
################################################################
#export dans les fichiers à transférer
#transfert des fichiers vers le serveur INTERSYST
#
lftp  172.20.50.22 << EOT
user flexcube Nfc*123
cd flexcube_upload
mirror -R  /home/XAFNFC/GIUpload/processed
quit
EOT 