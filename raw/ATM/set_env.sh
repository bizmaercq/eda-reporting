#!/bin/sh
# If IBM Websphere Application Server, specify APP_SERVER_NAME=WAS
# If Oracle 10g Application Server, specify APP_SERVER_NAME=OC4J
# If Oracle Web logic Server, specify APP_SERVER_NAME=WEBLOGIC
#set -v

export GW_CALL=EJB

export APP_SERVER_NAME=WEBLOGIC

# JAVA HOME 

export JAVA_HOME=/home/weblogic/jdk1.6.0_17

export PROJECT_DIR=/home/XAFNFC/SWIG

export ANT_HOME=/home/weblogic/Oracle/Middleware/modules/org.apache.ant_1.7.1

export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PATH

echo "Press Enter to Continue ..."
read 
clear