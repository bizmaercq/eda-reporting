#!/bin/bash
# Franco ATEKWANA 02/01/2019
#
################################################################
#export dans les fichiers à transférer
#transfert des fichiers vers le serveur INTERSYST
#
lftp  172.20.50.22 << EOT
user flexcube Nfc*123
cd systac_upload
mirror -R  /home/XAFNFC/debug/Upload/incoming/processed
quit
EOT 