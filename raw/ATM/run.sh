#!/bin/sh

export APP_SERVER_NAME=WEBLOGIC
export APP_SERVER_LIB=/home/weblogic/Oracle/Middleware/wlserver_10.3/server/lib
export GW_CALL=EJB
export PROJECT_DIR=/home/XAFNFC/SWIG
export JAVA_HOME=/home/weblogic/jdk1.6.0_17
export PATH=$JAVA_HOME/bin:$PATH:
CLASSPATH=./:$PROJECT_DIR/lib/SWIG.jar:./:$PROJECT_DIR/lib/GW_EJB_Bean.jar:./:$PROJECT_DIR/lib/j2ee.jar:./:$PROJECT_DIR/lib/xercesImpl.jar:./:$PROJECT_DIR/lib/xalan.jar:
CLASSPATH=$CLASSPATH:$APP_SERVER_LIB/weblogic.jar
export CLASSPATH

$JAVA_HOME/bin/java -cp $CLASSPATH:$PROJECT_DIR/lib/GW_EJB_Bean.jar com.iflex.sw.server.SWManagerInitializer ../config/
