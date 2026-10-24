#!/usr/bin/env bash
# 作者：Manta <manta.ops.dstw@gmail.com>
# 回归旧镜像 HTTP 端口变量、参数保留与无效端口拒绝。
set -Eeuo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT
mkdir -p "$test_dir/conf"
printf '%s\n' '<Server><Connector port="${dstw.tomcat.http.port:-8080}" /></Server>' > "$test_dir/conf/server.xml"
chmod 444 "$test_dir/conf/server.xml"
original="$(cat "$test_dir/conf/server.xml")"

for port in 1 9027 09027 65534 65535; do
    env -i PATH="$PATH" CATALINA_HOME="$test_dir" TOMCAT_HTTP_PORT="$port" \
        CATALINA_OPTS='-Xms64m -Xmx256m' JAVA_OPTS='-Duser.timezone=Etc/GMT+4' \
        EXPECTED_PORT="$((10#$port))" \
        "$BASH" "$root/scripts/docker-entrypoint.sh" "$BASH" -c \
        '[[ "$CATALINA_OPTS" == "-Xms64m -Xmx256m -Ddstw.tomcat.http.port=${EXPECTED_PORT}" ]] && [[ "$JAVA_OPTS" == "-Duser.timezone=Etc/GMT+4" ]]'
done

env -i PATH="$PATH" CATALINA_HOME="$test_dir" CATALINA_OPTS='-Xmx256m' \
    "$BASH" "$root/scripts/docker-entrypoint.sh" "$BASH" -c \
    '[[ "$CATALINA_OPTS" == "-Xmx256m" ]]'

for port in 0 65536 99999 100000 -1 8080x '1+1' 00000; do
    if env -i PATH="$PATH" CATALINA_HOME="$test_dir" TOMCAT_HTTP_PORT="$port" \
        "$BASH" "$root/scripts/docker-entrypoint.sh" true > "$test_dir/rejection.log" 2>&1; then
        echo "错误：无效端口未被拒绝：$port" >&2
        exit 1
    else
        code=$?
        [[ "$code" = 64 ]]
        [[ "$(cat "$test_dir/rejection.log")" == *'TOMCAT_HTTP_PORT 必须是 1 至 65535 的整数'* ]]
    fi
done
[[ "$(cat "$test_dir/conf/server.xml")" == "$original" ]]
echo '入口脚本回归通过：端口、默认值、JVM参数保留、无效值拒绝、配置不改写。'
