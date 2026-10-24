variable "IMAGE" {
  default = "benyoo/tomcat"
}

variable "PLATFORMS" {
  default = ["linux/amd64", "linux/arm64"]
}

group "default" {
  targets = [
    "tomcat9-0-centos9-stream-jdk8",
    "tomcat9-0-centos9-stream-jdk11",
    "tomcat9-0-centos9-stream-jdk17",
    "tomcat9-0-centos9-stream-jdk21",
    "tomcat9-0-centos9-stream-jdk25",
    "tomcat9-0-rockylinux9-jdk8",
    "tomcat9-0-rockylinux9-jdk11",
    "tomcat9-0-rockylinux9-jdk17",
    "tomcat9-0-rockylinux9-jdk21",
    "tomcat9-0-rockylinux9-jdk25",
    "tomcat9-0-alpine3-24-jdk8",
    "tomcat9-0-alpine3-24-jdk11",
    "tomcat9-0-alpine3-24-jdk17",
    "tomcat9-0-alpine3-24-jdk21",
    "tomcat9-0-alpine3-24-jdk25",
    "tomcat10-1-centos9-stream-jdk11",
    "tomcat10-1-centos9-stream-jdk17",
    "tomcat10-1-centos9-stream-jdk21",
    "tomcat10-1-centos9-stream-jdk25",
    "tomcat10-1-rockylinux9-jdk11",
    "tomcat10-1-rockylinux9-jdk17",
    "tomcat10-1-rockylinux9-jdk21",
    "tomcat10-1-rockylinux9-jdk25",
    "tomcat10-1-alpine3-24-jdk11",
    "tomcat10-1-alpine3-24-jdk17",
    "tomcat10-1-alpine3-24-jdk21",
    "tomcat10-1-alpine3-24-jdk25",
    "tomcat11-0-centos9-stream-jdk17",
    "tomcat11-0-centos9-stream-jdk21",
    "tomcat11-0-centos9-stream-jdk25",
    "tomcat11-0-rockylinux9-jdk17",
    "tomcat11-0-rockylinux9-jdk21",
    "tomcat11-0-rockylinux9-jdk25",
    "tomcat11-0-alpine3-24-jdk17",
    "tomcat11-0-alpine3-24-jdk21",
    "tomcat11-0-alpine3-24-jdk25",
  ]
}

target "_common" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = PLATFORMS
}


target "tomcat9-0-centos9-stream-jdk8" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:8u511-b32-centos9-stream-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "8u511-b32"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk8-centos9-stream",
    "${IMAGE}:9.0.123-jdk8u511-b32-centos9-stream",
    "${IMAGE}:9.0-jdk8-centos9-stream-20261024",
    "${IMAGE}:9.0.123-jdk8u511-b32-centos9-stream-20261024",
  ]
}

target "tomcat9-0-centos9-stream-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk11-centos9-stream",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-centos9-stream",
    "${IMAGE}:9.0-jdk11-centos9-stream-20261024",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-centos9-stream-20261024",
  ]
}

target "tomcat9-0-centos9-stream-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk17-centos9-stream",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-centos9-stream",
    "${IMAGE}:9.0-jdk17-centos9-stream-20261024",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-centos9-stream-20261024",
  ]
}

target "tomcat9-0-centos9-stream-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk21-centos9-stream",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-centos9-stream",
    "${IMAGE}:9.0-jdk21-centos9-stream-20261024",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-centos9-stream-20261024",
  ]
}

target "tomcat9-0-centos9-stream-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk25-centos9-stream",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-centos9-stream",
    "${IMAGE}:9.0-jdk25-centos9-stream-20261024",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-centos9-stream-20261024",
  ]
}

target "tomcat9-0-rockylinux9-jdk8" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:8u511-b32-rockylinux9-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "8u511-b32"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk8-rockylinux9",
    "${IMAGE}:9.0.123-jdk8u511-b32-rockylinux9",
    "${IMAGE}:9.0-jdk8-rockylinux9-20261024",
    "${IMAGE}:9.0.123-jdk8u511-b32-rockylinux9-20261024",
  ]
}

target "tomcat9-0-rockylinux9-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk11-rockylinux9",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-rockylinux9",
    "${IMAGE}:9.0-jdk11-rockylinux9-20261024",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-rockylinux9-20261024",
  ]
}

target "tomcat9-0-rockylinux9-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk17-rockylinux9",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-rockylinux9",
    "${IMAGE}:9.0-jdk17-rockylinux9-20261024",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-rockylinux9-20261024",
  ]
}

target "tomcat9-0-rockylinux9-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk21-rockylinux9",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-rockylinux9",
    "${IMAGE}:9.0-jdk21-rockylinux9-20261024",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-rockylinux9-20261024",
  ]
}

target "tomcat9-0-rockylinux9-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk25-rockylinux9",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-rockylinux9",
    "${IMAGE}:9.0-jdk25-rockylinux9-20261024",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-rockylinux9-20261024",
  ]
}

target "tomcat9-0-alpine3-24-jdk8" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:8u511-b32-alpine3.24-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "8u511-b32"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk8-alpine3.24",
    "${IMAGE}:9.0.123-jdk8u511-b32-alpine3.24",
    "${IMAGE}:9.0-jdk8-alpine3.24-20261024",
    "${IMAGE}:9.0.123-jdk8u511-b32-alpine3.24-20261024",
  ]
}

target "tomcat9-0-alpine3-24-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk11-alpine3.24",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-alpine3.24",
    "${IMAGE}:9.0-jdk11-alpine3.24-20261024",
    "${IMAGE}:9.0.123-jdk11.0.33.0.2-alpine3.24-20261024",
  ]
}

target "tomcat9-0-alpine3-24-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk17-alpine3.24",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-alpine3.24",
    "${IMAGE}:9.0-jdk17-alpine3.24-20261024",
    "${IMAGE}:9.0.123-jdk17.0.21.0.2-alpine3.24-20261024",
  ]
}

target "tomcat9-0-alpine3-24-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk21-alpine3.24",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-alpine3.24",
    "${IMAGE}:9.0-jdk21-alpine3.24-20261024",
    "${IMAGE}:9.0.123-jdk21.0.13.0.2-alpine3.24-20261024",
  ]
}

target "tomcat9-0-alpine3-24-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "9.0"
    TOMCAT_VERSION = "9.0.123"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:9.0-jdk25-alpine3.24",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-alpine3.24",
    "${IMAGE}:9.0-jdk25-alpine3.24-20261024",
    "${IMAGE}:9.0.123-jdk25.0.5.0.2-alpine3.24-20261024",
  ]
}

target "tomcat10-1-centos9-stream-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk11-centos9-stream",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-centos9-stream",
    "${IMAGE}:10.1-jdk11-centos9-stream-20261024",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-centos9-stream-20261024",
  ]
}

target "tomcat10-1-centos9-stream-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk17-centos9-stream",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-centos9-stream",
    "${IMAGE}:10.1-jdk17-centos9-stream-20261024",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-centos9-stream-20261024",
  ]
}

target "tomcat10-1-centos9-stream-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk21-centos9-stream",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-centos9-stream",
    "${IMAGE}:10.1-jdk21-centos9-stream-20261024",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-centos9-stream-20261024",
  ]
}

target "tomcat10-1-centos9-stream-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk25-centos9-stream",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-centos9-stream",
    "${IMAGE}:10.1-jdk25-centos9-stream-20261024",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-centos9-stream-20261024",
  ]
}

target "tomcat10-1-rockylinux9-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk11-rockylinux9",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-rockylinux9",
    "${IMAGE}:10.1-jdk11-rockylinux9-20261024",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-rockylinux9-20261024",
  ]
}

target "tomcat10-1-rockylinux9-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk17-rockylinux9",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-rockylinux9",
    "${IMAGE}:10.1-jdk17-rockylinux9-20261024",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-rockylinux9-20261024",
  ]
}

target "tomcat10-1-rockylinux9-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk21-rockylinux9",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-rockylinux9",
    "${IMAGE}:10.1-jdk21-rockylinux9-20261024",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-rockylinux9-20261024",
  ]
}

target "tomcat10-1-rockylinux9-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk25-rockylinux9",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-rockylinux9",
    "${IMAGE}:10.1-jdk25-rockylinux9-20261024",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-rockylinux9-20261024",
  ]
}

target "tomcat10-1-alpine3-24-jdk11" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:11.0.33.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "11.0.33.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk11-alpine3.24",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-alpine3.24",
    "${IMAGE}:10.1-jdk11-alpine3.24-20261024",
    "${IMAGE}:10.1.61-jdk11.0.33.0.2-alpine3.24-20261024",
  ]
}

target "tomcat10-1-alpine3-24-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk17-alpine3.24",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-alpine3.24",
    "${IMAGE}:10.1-jdk17-alpine3.24-20261024",
    "${IMAGE}:10.1.61-jdk17.0.21.0.2-alpine3.24-20261024",
  ]
}

target "tomcat10-1-alpine3-24-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk21-alpine3.24",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-alpine3.24",
    "${IMAGE}:10.1-jdk21-alpine3.24-20261024",
    "${IMAGE}:10.1.61-jdk21.0.13.0.2-alpine3.24-20261024",
  ]
}

target "tomcat10-1-alpine3-24-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "10.1"
    TOMCAT_VERSION = "10.1.61"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:10.1-jdk25-alpine3.24",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-alpine3.24",
    "${IMAGE}:10.1-jdk25-alpine3.24-20261024",
    "${IMAGE}:10.1.61-jdk25.0.5.0.2-alpine3.24-20261024",
  ]
}

target "tomcat11-0-centos9-stream-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk17-centos9-stream",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-centos9-stream",
    "${IMAGE}:11.0-jdk17-centos9-stream-20261024",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-centos9-stream-20261024",
  ]
}

target "tomcat11-0-centos9-stream-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk21-centos9-stream",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-centos9-stream",
    "${IMAGE}:11.0-jdk21-centos9-stream-20261024",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-centos9-stream-20261024",
  ]
}

target "tomcat11-0-centos9-stream-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-centos9-stream-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk25-centos9-stream",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-centos9-stream",
    "${IMAGE}:11.0-jdk25-centos9-stream-20261024",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-centos9-stream-20261024",
  ]
}

target "tomcat11-0-rockylinux9-jdk17" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:17.0.21.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "17.0.21.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk17-rockylinux9",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-rockylinux9",
    "${IMAGE}:11.0-jdk17-rockylinux9-20261024",
    "${IMAGE}:11.0.27-jdk17.0.21.0.2-rockylinux9-20261024",
  ]
}

target "tomcat11-0-rockylinux9-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk21-rockylinux9",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-rockylinux9",
    "${IMAGE}:11.0-jdk21-rockylinux9-20261024",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-rockylinux9-20261024",
  ]
}

target "tomcat11-0-rockylinux9-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-rockylinux9-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk25-rockylinux9",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-rockylinux9",
    "${IMAGE}:11.0-jdk25-rockylinux9-20261024",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-rockylinux9-20261024",
  ]
}

target "tomcat11-0-alpine3-24-jdk17" {
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

target "tomcat11-0-alpine3-24-jdk21" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:21.0.13.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "21.0.13.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk21-alpine3.24",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-alpine3.24",
    "${IMAGE}:11.0-jdk21-alpine3.24-20261024",
    "${IMAGE}:11.0.27-jdk21.0.13.0.2-alpine3.24-20261024",
  ]
}

target "tomcat11-0-alpine3-24-jdk25" {
  inherits = ["_common"]
  args = {
    BASE_IMAGE = "benyoo/jdk:25.0.5.0.2-alpine3.24-20261024"
    TOMCAT_MAJOR = "11.0"
    TOMCAT_VERSION = "11.0.27"
    JDK_VERSION = "25.0.5.0.2"
    BUILD_DATE = "20261025"
  }
  tags = [
    "${IMAGE}:11.0-jdk25-alpine3.24",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-alpine3.24",
    "${IMAGE}:11.0-jdk25-alpine3.24-20261024",
    "${IMAGE}:11.0.27-jdk25.0.5.0.2-alpine3.24-20261024",
  ]
}
