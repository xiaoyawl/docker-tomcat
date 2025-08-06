# AlpineLinux with a Oracle Java and Tomcat
FROM benyoo/jdk:alpine.1.8.131.b11
MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

# Tomcat Version and other ENV
ARG TOMCAT_MAJOR=${TOMCAT_MAJOR:-8}
ARG TOMCAT_VERSION=${TOMCAT_VERSION:-8.5.100}

ENV TOMCAT_HOME=/opt/tomcat \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_OUT=/dev/null \
    DEPLOY_DIR=/data/webapps \
    LIBS_DIR=/libs \
    LANG=zh_CN.UTF-8 \
    TERM=linux

RUN set -ex && \
    [ ! -d ${TOMCAT_HOME} ] && mkdir -p ${TOMCAT_HOME} && \
    [ ! -d ${DEPLOY_DIR} ] && mkdir -p ${DEPLOY_DIR} && \
    apk upgrade --update && apk add --update curl axel pwgen ca-certificates && \
    # 解决Let's Encrypt证书问题
    mkdir -p /certs && cd /certs && \
    wget https://letsencrypt.org/certs/isrgrootx1.pem && \
    wget https://letsencrypt.org/certs/lets-encrypt-r3.pem && \
    wget https://letsencrypt.org/certs/trustid-x3-root.pem && \
    JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) && \
    TRUSTSTORE="$JAVA_HOME/jre/lib/security/cacerts" && \
    keytool -import -noprompt -trustcacerts -alias isrgrootx1 -keystore "$TRUSTSTORE" -file isrgrootx1.pem -storepass changeit && \
    keytool -import -noprompt -trustcacerts -alias letsencryptr3 -keystore "$TRUSTSTORE" -file lets-encrypt-r3.pem -storepass changeit && \
    keytool -import -noprompt -trustcacerts -alias trustidx3 -keystore "$TRUSTSTORE" -file trustid-x3-root.pem -storepass changeit && \
    TomcatUrl="http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
    curl -jkSL ${TomcatUrl} | tar xz -C /opt/tomcat --strip-components=1 && \
    #rm -rf ${TOMCAT_HOME}/webapps/* && \
    addgroup -S -g 433 tomcat && \
    adduser -u 433 -S -h ${CATALINA_HOME} -s /sbin/nologin -g 'Docker image user' -G tomcat tomcat && \
    # 配置信任库
    echo "export JAVA_OPTS=\"\$JAVA_OPTS -Djavax.net.ssl.trustStore=$JAVA_HOME/jre/lib/security/cacerts -Djavax.net.ssl.trustStorePassword=changeit\"" > $CATALINA_HOME/bin/setenv.sh && \
    chmod +x $CATALINA_HOME/bin/setenv.sh && \
    chown -R tomcat:tomcat ${CATALINA_HOME} && \
    # Remove unneeded apps and files
    #rm -rf ${CATALINA_HOME}/{{RELEASE-NOTES,RUNNING.txt},webapps/{examples,docs,ROOT,host-manager},bin/{*.bat,*.tar.gz}} && \
    apk del axel && \
    rm -rf /tmp/* /var/lib/{apt,dpkg,cache,log}/*

ENV PATH=$CATALINA_HOME/bin:$PATH \
    JAVA_MAXMEMORY=256 \
    TOMCAT_MAXTHREADS=250 \
    TOMCAT_MINSPARETHREADS=4 \
    TOMCAT_HTTPTIMEOUT=20000 \
    TOMCAT_JVM_ROUTE=tomcat80

COPY conf/ ${CATALINA_HOME}/conf/
COPY bin/ ${CATALINA_HOME}/bin/
#RUN set -ex && whoami && \
#    chown -R tomcat:tomcat ${CATALINA_HOME} && \
#    chmod +x ${CATALINA_HOME}/bin/*.sh

#VOLUME ["/logs"]
EXPOSE 8080
EXPOSE 8009

#USER tomcat
CMD ["/opt/tomcat/bin/tomcat.sh"]
