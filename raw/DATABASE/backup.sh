DATE=$(date "+%Y_%m_%d")
export DATE
mkdir -p /rman_stby/$DATE
export BACKUP_DEST=/rman_stby/$DATE
export ORACLE_HOME=/oracle/app/database/product/11.2.0/dbhome_2
export ORACLE_SID=FCUBS
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/oracle/bin:/oracle/app/database/product/11.2.0/dbhome_2/bin
$ORACLE_HOME/bin/rman target / nocatalog log=$BACKUP_DEST/backup_$DATE.log <<EOF
run {
CONFIGURE RETENTION POLICY TO REDUNDANCY 1;
allocate channel ch1 device type disk format '$BACKUP_DEST/nfcrman_%U.bkp';
allocate channel ch2 device type disk format '$BACKUP_DEST/nfcrman_%U.bkp';
backup as compressed backupset database plus archivelog not backed up 1 times;
backup current controlfile;
crosscheck archivelog all;
delete force noprompt archivelog until time 'SYSDATE-7';
crosscheck backup;
DELETE NOPROMPT OBSOLETE;
}
exit;
EOF

