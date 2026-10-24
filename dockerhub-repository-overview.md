# benyoo/tomcat

## 2026-10-24 Alpine 构建完成（尚未发布）

本批已完成 Tomcat 9.0.123、10.1.61、11.0.27，以及独立的 Tomcat 8.5.100 + JDK 8 历史兼容组合构建。JDK 为 8u511-b32、11.0.33.0.2、17.0.21.0.2、21.0.13.0.2、25.0.5.0.2。本批仅 Alpine 3.24，共 13 个组合，amd64 原生和 arm64 QEMU 模拟的版本、证书信任、正常 HTTPS 及最小 JSP 检查均通过；尚未上传 Docker Hub。真实业务、自定义 truststore 和 ARM 真机未验收，其他系统后续补齐。以下公开标签与 digest 仍属于历史版本记录，新批次标签尚未发布。

Tomcat 8.5 已停止上游维护，仅供旧业务兼容；JDK 更新不代表 Tomcat 自身漏洞已修复。获授权发布完成后，应以实测版本、架构和 digest 更新本节并同步线上概览。

基于 `benyoo/jdk` 的 Apache Tomcat 多架构运行镜像，覆盖 Tomcat `9.0`、`10.1`、`11.0` 当前维护分支。项目主推 Alpine 3.24 变体，同时保留 CentOS Stream 9、Rocky Linux 9 兼容变体。

## 特性

| 能力 | 说明 |
|---|---|
| 多架构 | `linux/amd64`、`linux/arm64` |
| 多 Tomcat 分支 | `9.0`、`10.1`、`11.0` |
| 多 JDK 版本 | JDK `8 / 11 / 17 / 21 / 25`，按 Tomcat 兼容矩阵生成 |
| 主推基础系统 | Alpine 3.24 |
| 兼容基础系统 | CentOS Stream 9、Rocky Linux 9 |
| 可追溯标签 | 短标签、完整版本标签、日期标签、完整日期标签 |
| 启动验证 | 构建期执行 `java -version` 和 `catalina.sh version` |

## 快速开始

```bash
docker run -d \
  --name tomcat \
  -p 8080:8080 \
  benyoo/tomcat:11.0-jdk17-alpine3.24
```

验证：

```bash
curl -fsS http://127.0.0.1:8080/
docker exec tomcat catalina.sh version
```

## 常用标签

| 标签 | 说明 |
|---|---|
| `11.0-jdk17-alpine3.24` | Tomcat 11.0 + JDK 17 + Alpine 3.24，主推标签 |
| `11.0-jdk21-alpine3.24` | Tomcat 11.0 + JDK 21 + Alpine 3.24 |
| `10.1-jdk11-alpine3.24` | Tomcat 10.1 + JDK 11 + Alpine 3.24 |
| `10.1-jdk17-centos9-stream` | Tomcat 10.1 + JDK 17 + CentOS Stream 9，兼容变体 |
| `9.0-jdk8-alpine3.24` | Tomcat 9.0 + JDK 8 + Alpine 3.24 |
| `9.0-jdk17-alpine3.24` | Tomcat 9.0 + JDK 17 + Alpine 3.24 |

## 标签格式

| 格式 | 示例 |
|---|---|
| `<tomcat>-jdk<jdk>-<os>` | `11.0-jdk17-alpine3.24` |
| `<tomcat-full>-jdk<jdk-full>-<os>` | `11.0.23-jdk17.0.19-alpine3.24` |
| `<tomcat>-jdk<jdk>-<os>-<date>` | `11.0-jdk17-alpine3.24-20260626` |
| `<tomcat-full>-jdk<jdk-full>-<os>-<date>` | `11.0.23-jdk17.0.19-alpine3.24-20260626` |

生产环境建议使用完整版本或完整日期标签，便于回滚和审计。

## 兼容矩阵

| Tomcat | JDK 8 | JDK 11 | JDK 17 | JDK 21 | JDK 25 |
|---|---:|---:|---:|---:|---:|
| `9.0` | yes | yes | yes | yes | yes |
| `10.1` | no | yes | yes | yes | yes |
| `11.0` | no | no | yes | yes | yes |

基础系统均提供：

```text
alpine3.24
centos9-stream
rockylinux9
```

## 环境变量和路径

| 变量 / 路径 | 说明 |
|---|---|
| `CATALINA_HOME` | `/opt/tomcat` |
| `CATALINA_BASE` | `/opt/tomcat` |
| `TOMCAT_VERSION` | 完整 Tomcat 版本 |
| `JAVA_HOME` | 从 `benyoo/jdk` 继承 |
| `TIMEZONE` | 默认 `Asia/Shanghai` |
| `/usr/local/tomcat` | 指向 `/opt/tomcat` 的兼容软链 |
| `/webapps` | 可选业务 war 挂载目录 |
| `/logs` | 可选日志挂载目录 |
| `APP_WAR` | 可选，启动时部署指定 war |

## 挂载 war 示例

```bash
docker run -d \
  --name tomcat-app \
  -p 8080:8080 \
  -e APP_WAR="/webapps/app.war" \
  -v "$PWD/app.war:/webapps/app.war:ro" \
  benyoo/tomcat:10.1-jdk17-alpine3.24
```

## 多架构验证

```bash
docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-alpine3.24
```

应包含：

```text
linux/amd64
linux/arm64
```

## 版本说明

- Tomcat `8.5.100` 仅提供独立历史兼容配置；`10.0`、`7`、`8.0` 不纳入新镜像矩阵。
- Tomcat `9.0.x` 官方支持结束日期为 `2027-03-31`。
- Tomcat `9.1.x` 将用于承接 Java EE 8 / Servlet 4.0 业务；待 Apache 正式发布后再纳入本镜像矩阵。

## 注意事项

- 本镜像不建议使用 `latest` 作为生产部署入口。
- Alpine 变体继承 `benyoo/jdk` 的 Oracle JDK 运行兼容策略。
- 跨大版本迁移时请注意 Java EE 到 Jakarta EE 的包名变化，Tomcat 9 及以前的应用不能无改造直接运行在 Tomcat 10+。
