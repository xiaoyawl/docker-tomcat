# 此文件是固定版本的样板快照，不会自行跟踪上游；新批次统一执行 make prepare，使用生成矩阵。
variable "IMAGE" {
  default = "benyoo/tomcat"
}

variable "PLATFORMS" {
  default = ["linux/amd64", "linux/arm64"]
}

group "default" {
  targets = ["tomcat11-alpine3-24-jdk17"]
}

target "_common" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = PLATFORMS
}

target "tomcat11-alpine3-24-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk17-alpine3.24",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-alpine3.24",
    "${IMAGE}:11.0-jdk17-alpine3.24-20261024",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024",
  ]
}
