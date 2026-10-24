#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# @Time     : 2026-06-26 04:40:00
# @Author   : LookBack
# @Site     : Asia.DSTW.com
# @Project  : DSTW-Docker-Tomcat
# @File     : install-tomcat.sh
# @Software : Bash
# @Desc     : 下载、校验并安装 Apache Tomcat。
# @License  : (C) Copyright 2013-2026, DSTW Corporation Limited.
# @Contact  : admin@dstw.com

set -Eeuo pipefail

TOMCAT_MAJOR="${TOMCAT_MAJOR:-11.0}"
TOMCAT_VERSION="${TOMCAT_VERSION:-latest}"
CATALINA_HOME="${CATALINA_HOME:-/opt/tomcat}"
case "$TOMCAT_MAJOR" in
    8|8.5) APACHE_DIST_BASE="${APACHE_DIST_BASE:-https://archive.apache.org/dist/tomcat}" ;;
    *) APACHE_DIST_BASE="${APACHE_DIST_BASE:-https://downloads.apache.org/tomcat}" ;;
esac

usage() {
    cat <<'EOF'
Usage:
  install-tomcat.sh
  install-tomcat.sh --print-version
  install-tomcat.sh --print-url
  install-tomcat.sh --print-sha512-url

Environment:
  TOMCAT_MAJOR=11.0
  TOMCAT_VERSION=latest
  CATALINA_HOME=/opt/tomcat
EOF
}

tomcat_dist_major() {
    case "$TOMCAT_MAJOR" in
        8|8.5) echo "8" ;;
        9|9.0) echo "9" ;;
        10|10.1) echo "10" ;;
        11|11.0) echo "11" ;;
        *)
            echo "ERROR: unsupported TOMCAT_MAJOR: $TOMCAT_MAJOR" >&2
            exit 1
            ;;
    esac
}

tomcat_branch_prefix() {
    case "$TOMCAT_MAJOR" in
        8) echo "8.5" ;;
        9) echo "9.0" ;;
        10) echo "10.1" ;;
        11) echo "11.0" ;;
        *) echo "$TOMCAT_MAJOR" ;;
    esac
}

tomcat_download_page_id() {
    case "$(tomcat_dist_major)" in
        9) echo "90" ;;
        10) echo "10" ;;
        11) echo "11" ;;
    esac
}

resolve_latest_version() {
    local branch page page_content version
    branch="$(tomcat_branch_prefix)"
    page="https://tomcat.apache.org/download-$(tomcat_download_page_id).cgi"

    if ! page_content="$(curl -fsSL --connect-timeout 10 --max-time 30 "$page")"; then
        echo "错误：无法读取 Apache 官方下载页：${page}" >&2
        return 1
    fi

    version="$(
        printf '%s\n' "$page_content" |
            sed -n 's/.*apache-tomcat-\([0-9][0-9.]*\)\.tar\.gz.*/\1/p' |
            grep -E "^${branch//./\\.}[.][0-9]+$" |
            sort -t . -k1,1n -k2,2n -k3,3n |
            tail -n 1 || true
    )"

    if [ -z "$version" ]; then
        echo "错误：无法从 Apache 官方下载页解析 ${branch} 最新正式版本：${page}" >&2
        exit 1
    fi

    echo "$version"
}

resolved_version() {
    if [ "$(tomcat_branch_prefix)" = "8.5" ]; then
        case "$TOMCAT_VERSION" in
            latest|""|8.5.100) echo "8.5.100" ;;
            *)
                echo "错误：历史兼容分支仅支持 Tomcat 8.5.100" >&2
                exit 1
                ;;
        esac
        return
    fi
    if [ "$TOMCAT_VERSION" = "latest" ] || [ -z "$TOMCAT_VERSION" ]; then
        resolve_latest_version
    else
        echo "$TOMCAT_VERSION"
    fi
}

tomcat_url() {
    local dist_major version
    dist_major="$(tomcat_dist_major)"
    version="$(resolved_version)"
    echo "${APACHE_DIST_BASE}/tomcat-${dist_major}/v${version}/bin/apache-tomcat-${version}.tar.gz"
}

tomcat_sha512_url() {
    echo "$(tomcat_url).sha512"
}

install_tomcat() {
    local version url sha_url tmpdir tarball sha_file
    version="$(resolved_version)"
    url="$(tomcat_url)"
    sha_url="$(tomcat_sha512_url)"
    tmpdir="$(mktemp -d)"
    tarball="${tmpdir}/apache-tomcat-${version}.tar.gz"
    sha_file="${tarball}.sha512"

    echo "安装 Tomcat: ${version}"
    echo "下载地址: ${url}"

    curl -fL "$url" -o "$tarball"
    curl -fL "$sha_url" -o "$sha_file"

    (
        cd "$tmpdir"
        sha512sum -c "$(basename "$sha_file")"
    )

    rm -rf "$CATALINA_HOME"
    mkdir -p "$CATALINA_HOME"
    tar -xzf "$tarball" -C "$CATALINA_HOME" --strip-components=1

    # 用系统属性提供旧镜像端口变量；运行时不改写配置，兼容只读配置挂载。
    sed -i 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="${dstw.tomcat.http.port:-8080}" protocol="HTTP\/1.1"/' "$CATALINA_HOME/conf/server.xml"
    if ! grep -F 'port="${dstw.tomcat.http.port:-8080}"' "$CATALINA_HOME/conf/server.xml" > /dev/null; then
        echo "错误：未找到默认 HTTP Connector，无法安装端口兼容配置" >&2
        return 1
    fi

    rm -rf "$CATALINA_HOME/webapps/docs" \
        "$CATALINA_HOME/webapps/examples" \
        "$CATALINA_HOME/webapps/host-manager" \
        "$CATALINA_HOME/webapps/manager"

    chmod +x "$CATALINA_HOME"/bin/*.sh
    echo "$version" > "$CATALINA_HOME/TOMCAT_VERSION"
    echo "$(tomcat_branch_prefix)" > "$CATALINA_HOME/TOMCAT_MAJOR"
    echo "$url" > "$CATALINA_HOME/TOMCAT_DOWNLOAD_URL"
    rm -rf "$tmpdir"
}

case "${1:-}" in
    --help|-h)
        usage
        ;;
    --print-version)
        resolved_version
        ;;
    --print-url)
        tomcat_url
        ;;
    --print-sha512-url)
        tomcat_sha512_url
        ;;
    "")
        install_tomcat
        ;;
    *)
        echo "ERROR: unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
esac
