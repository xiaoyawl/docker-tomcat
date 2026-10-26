# benyoo/tomcat

基于自有 `benyoo/jdk` 的 Apache Tomcat 多架构镜像。已发布 39 个组合，覆盖 Alpine 3.24、CentOS Stream 9、Rocky Linux 9，提供 `linux/amd64`、`linux/arm64`；共 156 个版本标签及最后更新的 `latest`。

## JDK依赖刷新（2026-10-26）

全部39组合已基于本次确认的15个JDK digest重新构建。继承中英文字体、图形/AWT运行库、JDK8三系统的旧OpenSSL ABI兼容库，以及JDK源码包和下载缓存清理。78个平台通过安全运行时、字体绘图、PNG/JPEG/GIF、AWT与8080/9027回归。

日期标签仍为20261024，**digest已更新**；实际构建日期为20261026，需重新pull并重建容器。JDK8旧OpenSSL已结束支持，仅用于既有JNI兼容；业务本地组件仍须匹配系统及CPU架构。桌面窗口需要额外显示服务。

## HTTP端口兼容修复（2026-10-25）

现已恢复旧镜像变量 `TOMCAT_HTTP_PORT`：默认8080，支持例如9027的固定监听端口；原JAVA_OPTS/CATALINA_OPTS保持生效，默认配置支持只读挂载。39组合的78个平台、156个默认/非默认端口场景及证书/HTTPS均通过回归。

按用户要求继续使用20261024标签，**标签digest已更新**；已缓存镜像须重新pull，docker restart不会更新镜像。构建实际时间单独记录，旧digest/OCI保留用于回滚。

## 默认推荐版本

`latest` 指向 **Tomcat 11.0.27 + Oracle JDK 17.0.21.0.2 + Alpine 3.24**，与 `benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` 为同一份已验收产物。

多架构 index digest：`sha256:b80627f45e9880be27476817fcf12cc3916d8ce6007e1b47eef42a86a082f162`。生产部署建议使用完整版本日期标签或 digest。

## 快速开始

```bash
docker pull benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024
docker run -d \
    --name dstw-tomcat \
    --restart always \
    -p 8080:8080 \
    -e TIMEZONE=Asia/Shanghai \
    benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024
curl -fsS http://127.0.0.1:8080/
docker exec dstw-tomcat catalina.sh version
```

## 已发布的三系统组合

| Tomcat | Oracle JDK | 系统 | 完整版本日期标签 |
|---|---|---|---|
| 11.0.27 | 25.0.5.0.2 | Rocky Linux 9 | `11.0.27-jdk25.0.5.0.2-rockylinux9-20261024` |
| 11.0.27 | 25.0.5.0.2 | CentOS Stream 9 | `11.0.27-jdk25.0.5.0.2-centos9-stream-20261024` |
| 11.0.27 | 25.0.5.0.2 | Alpine 3.24 | `11.0.27-jdk25.0.5.0.2-alpine3.24-20261024` |
| 11.0.27 | 21.0.13.0.2 | Rocky Linux 9 | `11.0.27-jdk21.0.13.0.2-rockylinux9-20261024` |
| 11.0.27 | 21.0.13.0.2 | CentOS Stream 9 | `11.0.27-jdk21.0.13.0.2-centos9-stream-20261024` |
| 11.0.27 | 21.0.13.0.2 | Alpine 3.24 | `11.0.27-jdk21.0.13.0.2-alpine3.24-20261024` |
| 11.0.27 | 17.0.21.0.2 | Rocky Linux 9 | `11.0.27-jdk17.0.21.0.2-rockylinux9-20261024` |
| 11.0.27 | 17.0.21.0.2 | CentOS Stream 9 | `11.0.27-jdk17.0.21.0.2-centos9-stream-20261024` |
| 11.0.27 | 17.0.21.0.2 | Alpine 3.24 | `11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` |
| 10.1.61 | 25.0.5.0.2 | Rocky Linux 9 | `10.1.61-jdk25.0.5.0.2-rockylinux9-20261024` |
| 10.1.61 | 25.0.5.0.2 | CentOS Stream 9 | `10.1.61-jdk25.0.5.0.2-centos9-stream-20261024` |
| 10.1.61 | 25.0.5.0.2 | Alpine 3.24 | `10.1.61-jdk25.0.5.0.2-alpine3.24-20261024` |
| 10.1.61 | 21.0.13.0.2 | Rocky Linux 9 | `10.1.61-jdk21.0.13.0.2-rockylinux9-20261024` |
| 10.1.61 | 21.0.13.0.2 | CentOS Stream 9 | `10.1.61-jdk21.0.13.0.2-centos9-stream-20261024` |
| 10.1.61 | 21.0.13.0.2 | Alpine 3.24 | `10.1.61-jdk21.0.13.0.2-alpine3.24-20261024` |
| 10.1.61 | 17.0.21.0.2 | Rocky Linux 9 | `10.1.61-jdk17.0.21.0.2-rockylinux9-20261024` |
| 10.1.61 | 17.0.21.0.2 | CentOS Stream 9 | `10.1.61-jdk17.0.21.0.2-centos9-stream-20261024` |
| 10.1.61 | 17.0.21.0.2 | Alpine 3.24 | `10.1.61-jdk17.0.21.0.2-alpine3.24-20261024` |
| 10.1.61 | 11.0.33.0.2 | Rocky Linux 9 | `10.1.61-jdk11.0.33.0.2-rockylinux9-20261024` |
| 10.1.61 | 11.0.33.0.2 | CentOS Stream 9 | `10.1.61-jdk11.0.33.0.2-centos9-stream-20261024` |
| 10.1.61 | 11.0.33.0.2 | Alpine 3.24 | `10.1.61-jdk11.0.33.0.2-alpine3.24-20261024` |
| 9.0.123 | 25.0.5.0.2 | Rocky Linux 9 | `9.0.123-jdk25.0.5.0.2-rockylinux9-20261024` |
| 9.0.123 | 25.0.5.0.2 | CentOS Stream 9 | `9.0.123-jdk25.0.5.0.2-centos9-stream-20261024` |
| 9.0.123 | 25.0.5.0.2 | Alpine 3.24 | `9.0.123-jdk25.0.5.0.2-alpine3.24-20261024` |
| 9.0.123 | 21.0.13.0.2 | Rocky Linux 9 | `9.0.123-jdk21.0.13.0.2-rockylinux9-20261024` |
| 9.0.123 | 21.0.13.0.2 | CentOS Stream 9 | `9.0.123-jdk21.0.13.0.2-centos9-stream-20261024` |
| 9.0.123 | 21.0.13.0.2 | Alpine 3.24 | `9.0.123-jdk21.0.13.0.2-alpine3.24-20261024` |
| 9.0.123 | 17.0.21.0.2 | Rocky Linux 9 | `9.0.123-jdk17.0.21.0.2-rockylinux9-20261024` |
| 9.0.123 | 17.0.21.0.2 | CentOS Stream 9 | `9.0.123-jdk17.0.21.0.2-centos9-stream-20261024` |
| 9.0.123 | 17.0.21.0.2 | Alpine 3.24 | `9.0.123-jdk17.0.21.0.2-alpine3.24-20261024` |
| 9.0.123 | 11.0.33.0.2 | Rocky Linux 9 | `9.0.123-jdk11.0.33.0.2-rockylinux9-20261024` |
| 9.0.123 | 11.0.33.0.2 | CentOS Stream 9 | `9.0.123-jdk11.0.33.0.2-centos9-stream-20261024` |
| 9.0.123 | 11.0.33.0.2 | Alpine 3.24 | `9.0.123-jdk11.0.33.0.2-alpine3.24-20261024` |
| 9.0.123 | 8u511-b32 | Rocky Linux 9 | `9.0.123-jdk8u511-b32-rockylinux9-20261024` |
| 9.0.123 | 8u511-b32 | CentOS Stream 9 | `9.0.123-jdk8u511-b32-centos9-stream-20261024` |
| 9.0.123 | 8u511-b32 | Alpine 3.24 | `9.0.123-jdk8u511-b32-alpine3.24-20261024` |
| 8.5.100 | 8u511-b32 | Rocky Linux 9 | `8.5.100-jdk8u511-b32-rockylinux9-20261024` |
| 8.5.100 | 8u511-b32 | CentOS Stream 9 | `8.5.100-jdk8u511-b32-centos9-stream-20261024` |
| 8.5.100 | 8u511-b32 | Alpine 3.24 | `8.5.100-jdk8u511-b32-alpine3.24-20261024` |

每个组合还提供以下三种同内容别名：

- `<Tomcat完整版本>-jdk<JDK完整版本>-<系统>`
- `<Tomcat分支>-jdk<JDK大版本>-<系统>-20261024`
- `<Tomcat分支>-jdk<JDK大版本>-<系统>`

例如 `11.0-jdk17-alpine3.24`、`11.0-jdk17-alpine3.24-20261024`、`11.0.27-jdk17.0.21.0.2-alpine3.24` 与该组合的完整版本日期标签指向同一 digest。`latest` 在本批所有版本完成后最后更新。

## 自定义HTTP端口

```bash
docker run -d \
    --name dstw-tomcat-9027 \
    --network host \
    -e TOMCAT_HTTP_PORT=9027 \
    -e JAVA_OPTS=-Duser.timezone=Etc/GMT+4 \
    benyoo/tomcat:9.0.123-jdk8u511-b32-alpine3.24-20261024
```

host网络直接使用9027，不配置ports映射。自定义server.xml需包含 `port="${dstw.tomcat.http.port:-8080}"` 才能使用该变量；硬编码端口由自定义配置决定。该修复适用于本页矩阵中的本次修订标签，不适用于未更新的历史版本。

## 部署业务 WAR

`CATALINA_HOME`、`CATALINA_BASE` 默认均为 `/opt/tomcat`，`/usr/local/tomcat` 是兼容软链。使用 `APP_WAR` 时，入口会将指定文件复制到默认部署目录的 `ROOT.war`。

```bash
docker run -d \
    --name dstw-tomcat-app \
    --restart always \
    -p 8080:8080 \
    -e TIMEZONE=Asia/Shanghai \
    -e APP_WAR=/webapps/app.war \
    -v "$PWD/app.war:/webapps/app.war:ro" \
    -v "$PWD/logs:/opt/tomcat/logs" \
    benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024
```

也可将业务目录直接挂载到 `/opt/tomcat/webapps`。仅挂载 `/webapps` 或 `/logs` 不会自动改变 Tomcat 默认应用目录或日志目录。JVM 参数可通过 `JAVA_TOOL_OPTIONS`、`CATALINA_OPTS` 配置。

## 验收与兼容边界

- 39 个组合共 78 个平台运行结果已通过：Java/Tomcat版本、默认信任库证书检查、正常HTTPS、默认8080和自定义9027，以及JVM参数/只读配置回归。
- amd64 为原生验收；arm64 为 QEMU 模拟验收，未做 ARM 真机验收。所有 157 个本批公开标签的 index digest、amd64/arm64 manifest digest 均已核对，与已验收 OCI 一致。
- Tomcat 8.5.100 已停止上游维护，仅用于历史业务兼容；更新 JDK 不会修复 Tomcat 自身后续漏洞。
- Tomcat 9 使用 Java EE 的 `javax.*` API；Tomcat 10.1、11 使用 Jakarta EE 的 `jakarta.*` API，跨大版本迁移须检查业务与依赖兼容。
- 新 JDK 默认信任库已按本次安全维护方案处置相关根证书；业务自定义 truststore 和实际外部接口仍需独立验收。
- 本批三系统完整版本日期标签已更新；其他未列出的历史标签不属于本批次。生产部署、真实业务 WAR、数据库与业务接口不属于本次镜像探针验收。

## 文档与维护

- [项目代码与文档](https://github.com/xiaoyawl/docker-tomcat)
- [Apache Tomcat 官方版本说明](https://tomcat.apache.org/whichversion.html)
- [Apache Tomcat 官方安全公告](https://tomcat.apache.org/security.html)
- 许可证与版权声明以镜像中随附的 Tomcat `LICENSE` / `NOTICE` 和 JDK 许可文件为准，本项目不变更上游声明。
- 维护者：Manta，联系邮箱：[manta.ops.dstw@gmail.com](mailto:manta.ops.dstw@gmail.com)。
