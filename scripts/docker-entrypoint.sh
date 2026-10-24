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
