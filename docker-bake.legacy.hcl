# 历史兼容组合：Tomcat 8.5 已停止上游维护，仅按需构建，不纳入维护分支默认矩阵。
# JDK 安全维护不能修复 Tomcat 8.5 自身停止维护后的漏洞。
variable "IMAGE" {
  default = "benyoo/tomcat"
}

variable "BUILD_DATE" {
  default = "20261024"
}

variable "PLATFORMS" {
  default = ["linux/amd64", "linux/arm64"]
}

group "default" {
  targets = [
    "tomcat8-5-alpine3-24-jdk8",
  ]
}

target "_legacy" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = PLATFORMS
  args = {
    TOMCAT_MAJOR = "8.5"
    TOMCAT_VERSION = "8.5.100"
    JDK_VERSION = "8u511-b32"
    BUILD_DATE = BUILD_DATE
  }
  labels = {
    "dstw.tomcat.lifecycle" = "eol"
    "org.opencontainers.image.description" = "历史兼容版本：Tomcat 8.5.100 已停止上游维护；JDK 更新不代表 Tomcat 漏洞已修复。"
  }
}

target "tomcat8-5-alpine3-24-jdk8" {
  inherits = ["_legacy"]
  args = {
    BASE_IMAGE = "benyoo/jdk:8u511-b32-alpine3.24-20261024@sha256:16fba9f4d801129c5201019b5bd90dcdbef6ece550b71d010f5244929b26379e"
  }
  tags = [
    "${IMAGE}:8.5-jdk8-alpine3.24",
    "${IMAGE}:8.5.100-jdk8u511-b32-alpine3.24",
    "${IMAGE}:8.5-jdk8-alpine3.24-${BUILD_DATE}",
    "${IMAGE}:8.5.100-jdk8u511-b32-alpine3.24-${BUILD_DATE}",
  ]
}

