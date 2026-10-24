#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# @Time     : 2026-06-26 04:40:00
# @Author   : LookBack
# @Site     : Asia.DSTW.com
# @Project  : DSTW-Docker-Tomcat
# @File     : docker-entrypoint.sh
# @Software : Bash
# @Desc     : Tomcat 容器启动入口。
# @License  : (C) Copyright 2013-2026, DSTW Corporation Limited.
# @Contact  : admin@dstw.com

set -Eeuo pipefail

export CATALINA_HOME="${CATALINA_HOME:-/opt/tomcat}"
export CATALINA_BASE="${CATALINA_BASE:-$CATALINA_HOME}"

# 延续旧镜像的 HTTP 端口变量，不覆盖业务 JAVA_OPTS / CATALINA_OPTS。
if [ -n "${TOMCAT_HTTP_PORT:-}" ]; then
    if ! [[ "$TOMCAT_HTTP_PORT" =~ ^[0-9]{1,5}$ ]]; then
        echo "错误：TOMCAT_HTTP_PORT 必须是 1 至 65535 的整数" >&2
        exit 64
    fi
    tomcat_http_port="$((10#$TOMCAT_HTTP_PORT))"
    if ((tomcat_http_port < 1 || tomcat_http_port > 65535)); then
        echo "错误：TOMCAT_HTTP_PORT 必须是 1 至 65535 的整数" >&2
        exit 64
    fi
    export CATALINA_OPTS="${CATALINA_OPTS:-} -Ddstw.tomcat.http.port=${tomcat_http_port}"
fi

if [ -f "$CATALINA_HOME/TOMCAT_VERSION" ]; then
    export TOMCAT_VERSION="$(cat "$CATALINA_HOME/TOMCAT_VERSION")"
fi

if [ -n "${TIMEZONE:-}" ]; then
    export TZ="$TIMEZONE"
fi

if [ -n "${APP_WAR:-}" ]; then
    if [ ! -f "$APP_WAR" ]; then
        echo "ERROR: APP_WAR not found: $APP_WAR" >&2
        exit 1
    fi
    mkdir -p "$CATALINA_BASE/webapps"
    cp -f "$APP_WAR" "$CATALINA_BASE/webapps/ROOT.war"
fi

if [ "$#" -eq 0 ]; then
    set -- catalina.sh run
fi

exec "$@"
