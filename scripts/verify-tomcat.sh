#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# @Time     : 2026-06-26 04:40:00
# @Author   : LookBack
# @Site     : Asia.DSTW.com
# @Project  : DSTW-Docker-Tomcat
# @File     : verify-tomcat.sh
# @Software : Bash
# @Desc     : 验证 Tomcat 镜像可以启动并响应 HTTP。
# @License  : (C) Copyright 2013-2026, DSTW Corporation Limited.
# @Contact  : admin@dstw.com

set -Eeuo pipefail

IMAGE="${IMAGE:-benyoo/tomcat:11.0-jdk17-alpine3.24}"
CONTAINER_NAME="${CONTAINER_NAME:-tomcat-verify}"
PORT="${PORT:-18080}"

cleanup() {
    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

cleanup

docker run -d \
    --name "$CONTAINER_NAME" \
    -p "${PORT}:8080" \
    "$IMAGE" >/dev/null

for _ in $(seq 1 30); do
    if curl -fsS "http://127.0.0.1:${PORT}/" >/dev/null; then
        docker exec "$CONTAINER_NAME" catalina.sh version
        cleanup
        echo "Tomcat HTTP 验证通过: $IMAGE"
        exit 0
    fi
    sleep 1
done

docker logs "$CONTAINER_NAME" || true
cleanup
echo "ERROR: Tomcat HTTP 验证失败: $IMAGE" >&2
exit 1
