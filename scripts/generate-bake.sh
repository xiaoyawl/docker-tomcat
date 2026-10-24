#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# @Time     : 2026-06-26 04:40:00
# @Author   : LookBack
# @Site     : Asia.DSTW.com
# @Project  : DSTW-Docker-Tomcat
# @File     : generate-bake.sh
# @Software : Bash
# @Desc     : 生成 Tomcat 多版本多基础镜像 Buildx Bake 文件。
# @License  : (C) Copyright 2013-2026, DSTW Corporation Limited.
# @Contact  : admin@dstw.com

set -Eeuo pipefail

IMAGE="${IMAGE:-benyoo/tomcat}"
OUTPUT="${1:-docker-bake.generated.hcl}"
BUILD_DATE="${BUILD_DATE:-$(TZ=Asia/Shanghai date +%Y%m%d)}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"

BASE_TARGETS=(
    "alpine3-24|alpine3.24|benyoo/jdk:%s-alpine3.24-20261024"
)
# 当前批次仅启用 Alpine；CentOS Stream 和 Rocky Linux 后续补入。

TOMCAT_TARGETS=(
    "9.0|8 11 17 21 25"
    "10.1|11 17 21 25"
    "11.0|17 21 25"
)

jdk_full_version() {
    case "$1" in
        8) echo "8u511-b32" ;;
        11) echo "11.0.33.0.2" ;;
        17) echo "17.0.21.0.2" ;;
        21) echo "21.0.13.0.2" ;;
        25) echo "25.0.5.0.2" ;;
        *)
            echo "ERROR: unsupported JDK version: $1" >&2
            exit 1
            ;;
    esac
}

tomcat_full_version() {
    TOMCAT_MAJOR="$1" TOMCAT_VERSION=latest ./scripts/install-tomcat.sh --print-version
}

platform_list() {
    local input="$1" first rest output
    first="${input%%,*}"
    output="\"${first}\""
    rest="${input#*,}"
    while [ "$rest" != "$input" ]; do
        output="${output}, \"${rest%%,*}\""
        [ "$rest" = "${rest#*,}" ] && break
        rest="${rest#*,}"
    done
    echo "$output"
}

write_header() {
    cat > "$OUTPUT" <<EOF
variable "IMAGE" {
  default = "${IMAGE}"
}

variable "PLATFORMS" {
  default = [$(platform_list "$PLATFORMS")]
}

group "default" {
  targets = [
EOF
}

write_common() {
    cat >> "$OUTPUT" <<'EOF'
  ]
}

target "_common" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = PLATFORMS
}

EOF
}

write_target_list() {
    local item tomcat jdks base target_name os_name base_pattern jdk
    for item in "${TOMCAT_TARGETS[@]}"; do
        tomcat="${item%%|*}"
        jdks="${item#*|}"
        for base in "${BASE_TARGETS[@]}"; do
            target_name="${base%%|*}"
            for jdk in $jdks; do
                printf '    "tomcat%s-%s-jdk%s",\n' "${tomcat//./-}" "$target_name" "$jdk" >> "$OUTPUT"
            done
        done
    done
}

write_target() {
    local tomcat="$1" tomcat_full="$2" jdk="$3" jdk_full="$4" target_name="$5" os_name="$6" base_pattern="$7"
    local base_image target
    base_image="$(printf "$base_pattern" "$jdk_full")"
    target="tomcat${tomcat//./-}-${target_name}-jdk${jdk}"

    cat >> "$OUTPUT" <<EOF
target "${target}" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "${base_image}"
    TOMCAT_MAJOR = "${tomcat}"
    TOMCAT_VERSION = "${tomcat_full}"
    JDK_VERSION = "${jdk_full}"
    BUILD_DATE = "${BUILD_DATE}"
  }
  tags = [
    "\${IMAGE}:${tomcat}-jdk${jdk}-${os_name}",
    "\${IMAGE}:${tomcat_full}-jdk${jdk_full}-${os_name}",
    "\${IMAGE}:${tomcat}-jdk${jdk}-${os_name}-${BUILD_DATE}",
    "\${IMAGE}:${tomcat_full}-jdk${jdk_full}-${os_name}-${BUILD_DATE}",
  ]
}

EOF
}

write_targets() {
    local item tomcat tomcat_full jdks base target_name rest os_name base_pattern jdk jdk_full
    local version_index=0
    for item in "${TOMCAT_TARGETS[@]}"; do
        tomcat="${item%%|*}"
        tomcat_full="${TOMCAT_FULL_VERSIONS[$version_index]}"
        version_index=$((version_index + 1))
        jdks="${item#*|}"
        for base in "${BASE_TARGETS[@]}"; do
            target_name="${base%%|*}"
            rest="${base#*|}"
            os_name="${rest%%|*}"
            base_pattern="${rest#*|}"
            for jdk in $jdks; do
                jdk_full="$(jdk_full_version "$jdk")"
                write_target "$tomcat" "$tomcat_full" "$jdk" "$jdk_full" "$target_name" "$os_name" "$base_pattern"
            done
        done
    done
}

# 先完成全部分支的版本发现；任一失败都保留原构建配置，不回退旧版本。
TOMCAT_FULL_VERSIONS=()
for item in "${TOMCAT_TARGETS[@]}"; do
    tomcat="${item%%|*}"
    tomcat_full="$(tomcat_full_version "$tomcat")"
    TOMCAT_FULL_VERSIONS+=("$tomcat_full")
    echo "已解析 Tomcat ${tomcat} 最新正式版本：${tomcat_full}"
done

OUTPUT_FINAL="$OUTPUT"
OUTPUT="$(mktemp "${OUTPUT_FINAL}.tmp.XXXXXX")"
cleanup_output() {
    if [ -f "$OUTPUT" ]; then
        unlink "$OUTPUT"
    fi
}
trap cleanup_output EXIT

write_header
write_target_list
write_common
write_targets
chmod 644 "$OUTPUT"
mv "$OUTPUT" "$OUTPUT_FINAL"

echo "已生成候选构建配置：${OUTPUT_FINAL}；构建前须确认所有固定 JDK 基镜像均已发布并通过验收"
