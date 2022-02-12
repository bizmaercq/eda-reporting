#!/bin/bash
#Script to Perform Datapump Export backup Every Day
################################################################
#Change History
#================
#--------- ----------------------- --------------------------------- -----------
#2-APR-2012 DEEPAK BARANWAL SCRIPT FOR FULL EXPORT FCUBS 2-APR-2012
#
#
#
################################################################
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_SID=FCUBS
export PATH=$PATH:$ORACLE_HOME/bin
#expdp backup/backup dumpfile=expdp-full-`date +'%d%m%Y_%H%M%S'`.dmp directory=dump logfile=expdp-full-`date '+%d%m%Y_%H%M%S'`.log full=y
expdp backup/backup dumpfile=expdp-full-`date +'%d%m%Y_%H%M%S'`.dmp full=GETB_UTILS_LOG_HISTORY,STTB_NOTIFICATION_HISTORY,ELTB_UTIL_TXN_LOG_HISTORY,FBTB_TXNLOG_DETAILS_HIST,ICTB_ICALC_STMT directory=dump logfile=expdp-full-`date '+%d%m%Y_%H%M%S'`.log full=y compression=all parallel=16 EXCLUDE=statistics
############################################################################
 
#Granting permissions for Dump files
chmod -R 775 /u01/app/oracle/dmp/*
#################################################################################
#Compressing files
#/bin/gzip /u01/app/oracle/dmp/expdp-full-`date +'%d%m%Y_%H%M%S'`.dmp 
/bin/gzip /u01/app/oracle/dmp/*.dmp
#################################################################################33
#######Removing 100 days old dump files
/usr/bin/find /u01/app/oracle/dmp/expdp* -mtime +20 -exec rm {} \;
######################################################################################