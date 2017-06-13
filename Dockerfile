# AlpineLinux with a Oracle Java and Tomcat
FROM benyoo/jdk:alpine.1.7.80.b15
MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

# Tomcat Version and other ENV
ARG TOMCAT_MAJOR=${TOMCAT_MAJOR:-7}
ARG TOMCAT_VERSION=${TOMCAT_VERSION:-7.0.78}

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
    apk upgrade --update && apk add --update curl axel && \
    TomcatUrl="http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
    curl -jkSL ${TomcatUrl} | tar xz -C /opt/tomcat --strip-components=1 && \
    #rm -rf ${TOMCAT_HOME}/webapps/* && \
    addgroup -S -g 433 tomcat && \
    adduser -u 433 -S -h ${CATALINA_HOME} -s /sbin/nologin -g 'Docker image user' -G tomcat tomcat && \
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
