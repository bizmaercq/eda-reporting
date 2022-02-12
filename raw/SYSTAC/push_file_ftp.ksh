#!/bin/bash
# Franco ATEKWANA 20/02/2016
#
################################################################
#export dans les fichiers à transférer
#transfert des fichiers vers le serveur INTERSYST
#
ftp -n -v 172.20.50.54 << EOT
ascii
user si_ftp Systac@nfc1
prompt
lcd /home/XAFNFC/debug/Upload/outgoing/ready
mput *.txt
quit
EOT 