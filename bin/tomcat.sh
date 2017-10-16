#!/bin/bash
#########################################################################
# File Name: tomcat.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2017年10月15日 星期日 15时55分30秒
#########################################################################

TOMCAT_HTTP_PORT=${TOMCAT_HTTP_PORT:-8080}
TOMCAT_AJP_PORT=${TOMCAT_AJP_PORT:-8009}
TOMCAT_SERVER_PORT=${TOMCAT_SERVER_PORT:-8005}

sed -i "s/8080/$TOMCAT_HTTP_PORT/" $CATALINA_HOME/conf/server.xml
sed -i "s/8009/$TOMCAT_AJP_PORT/" $CATALINA_HOME/conf/server.xml
sed -i "s/8005/$TOMCAT_SERVER_PORT/" $CATALINA_HOME/conf/server.xml

if [ ! -f ${CATALINA_HOME}/.tomcat_created ]; then
  ${CATALINA_HOME}/bin/create_tomcat_user.sh
fi

DIR=${DEPLOY_DIR:-/webapps}
echo "Checking *.war in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.war; do
     file=$(basename $i)
     echo "Linking $i --> ${CATALINA_HOME}/webapps/$file"
     ln -s $i ${CATALINA_HOME}/webapps/$file
  done
fi

DIR=${LIBS_DIR:-/libs}
echo "Checking tomcat extended libs *.jar in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.jar; do
     file=$(basename $i)
     echo "Linking $i --> ${CATALINA_HOME}/lib/$file"
     ln -s $i ${CATALINA_HOME}/lib/$file
  done
fi

# Autorestart possible?
#-XX:OnError="cmd args; cmd args"
#-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdump.hprof -XX:OnOutOfMemoryError="sh ~/cleanup.sh"
LANG=${LANG:-zh_CN.UTF-8}
JAVA_OPTS=${JAVA_OPTS:--Duser.language=en -Duser.country=US}

export LANG="${LANG}"
export JAVA_OPTS="$JAVA_OPTS"
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="$CATALINA_OPTS -Xmx${JAVA_MAXMEMORY}m -DjvmRoute=${TOMCAT_JVM_ROUTE} -Dtomcat.maxThreads=${TOMCAT_MAXTHREADS} -Dtomcat.minSpareThreads=${TOMCAT_MINSPARETHREADS} -Dtomcat.httpTimeout=${TOMCAT_HTTPTIMEOUT} -Djava.security.egd=file:/dev/./urandom"
exec ${CATALINA_HOME}/bin/catalina.sh run