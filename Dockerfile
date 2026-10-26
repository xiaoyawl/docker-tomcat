ARG BASE_IMAGE=benyoo/jdk:17.0.21.0.2-alpine3.24-20261024
FROM ${BASE_IMAGE}

ARG BASE_IMAGE=benyoo/jdk:17.0.21.0.2-alpine3.24-20261024
ARG TOMCAT_MAJOR=11.0
ARG TOMCAT_VERSION=11.0.27
ARG JDK_VERSION=17.0.21.0.2
ARG BUILD_DATE=20261026

LABEL org.opencontainers.image.title="DSTW Docker Tomcat" \
      org.opencontainers.image.authors="Manta <manta.ops.dstw@gmail.com>" \
      org.opencontainers.image.vendor="DSTW" \
      org.opencontainers.image.version="${TOMCAT_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.base.name="${BASE_IMAGE}" \
      dstw.tomcat.major="${TOMCAT_MAJOR}" \
      dstw.tomcat.version="${TOMCAT_VERSION}" \
      dstw.jdk.version="${JDK_VERSION}" \
      dstw.build.date="${BUILD_DATE}"

ENV CATALINA_HOME=/opt/tomcat \
    CATALINA_BASE=/opt/tomcat \
    TOMCAT_MAJOR="${TOMCAT_MAJOR}" \
    TOMCAT_VERSION="${TOMCAT_VERSION}" \
    JDK_VERSION="${JDK_VERSION}" \
    BUILD_DATE="${BUILD_DATE}" \
    PATH=/opt/tomcat/bin:$PATH

SHELL ["/bin/sh", "-c"]

COPY scripts/install-tomcat.sh /usr/local/bin/install-tomcat
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN set -eux; \
    chmod +x /usr/local/bin/install-tomcat /usr/local/bin/docker-entrypoint.sh; \
    TOMCAT_MAJOR="${TOMCAT_MAJOR}" TOMCAT_VERSION="${TOMCAT_VERSION}" install-tomcat; \
    ln -sfn "${CATALINA_HOME}" /usr/local/tomcat; \
    mkdir -p /webapps /logs; \
    java -version; \
    catalina.sh version

WORKDIR /opt/tomcat

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
