# benyoo/tomcat

基于自有 `benyoo/jdk` 的 Apache Tomcat 多架构镜像。本次已发布 13 个 Alpine 3.24 组合，提供 `linux/amd64`、`linux/arm64`；共 52 个版本标签及最后更新的 `latest`。

## 默认推荐版本

`latest` 指向 **Tomcat 11.0.27 + Oracle JDK 17.0.21.0.2 + Alpine 3.24**，与 `benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` 为同一份已验收产物。

多架构 index digest：`sha256:53c820a52941ec2918d10623111661f9c8b72b628fe5ab28d45a8fab22b62568`。生产部署建议使用完整版本日期标签或 digest。

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

## 已发布的 Alpine 组合

| Tomcat | Oracle JDK | 完整版本日期标签 |
|---|---|---|
| 11.0.27 | 25.0.5.0.2 | `11.0.27-jdk25.0.5.0.2-alpine3.24-20261024` |
| 11.0.27 | 21.0.13.0.2 | `11.0.27-jdk21.0.13.0.2-alpine3.24-20261024` |
| 11.0.27 | 17.0.21.0.2 | `11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` |
| 10.1.61 | 25.0.5.0.2 | `10.1.61-jdk25.0.5.0.2-alpine3.24-20261024` |
| 10.1.61 | 21.0.13.0.2 | `10.1.61-jdk21.0.13.0.2-alpine3.24-20261024` |
| 10.1.61 | 17.0.21.0.2 | `10.1.61-jdk17.0.21.0.2-alpine3.24-20261024` |
| 10.1.61 | 11.0.33.0.2 | `10.1.61-jdk11.0.33.0.2-alpine3.24-20261024` |
| 9.0.123 | 25.0.5.0.2 | `9.0.123-jdk25.0.5.0.2-alpine3.24-20261024` |
| 9.0.123 | 21.0.13.0.2 | `9.0.123-jdk21.0.13.0.2-alpine3.24-20261024` |
| 9.0.123 | 17.0.21.0.2 | `9.0.123-jdk17.0.21.0.2-alpine3.24-20261024` |
| 9.0.123 | 11.0.33.0.2 | `9.0.123-jdk11.0.33.0.2-alpine3.24-20261024` |
| 9.0.123 | 8u511-b32 | `9.0.123-jdk8u511-b32-alpine3.24-20261024` |
| 8.5.100 | 8u511-b32 | `8.5.100-jdk8u511-b32-alpine3.24-20261024` |

每个组合还提供以下三种同内容别名：

- `<Tomcat完整版本>-jdk<JDK完整版本>-alpine3.24`
- `<Tomcat分支>-jdk<JDK大版本>-alpine3.24-20261024`
- `<Tomcat分支>-jdk<JDK大版本>-alpine3.24`

例如 `11.0-jdk17-alpine3.24`、`11.0-jdk17-alpine3.24-20261024`、`11.0.27-jdk17.0.21.0.2-alpine3.24` 与该组合的完整版本日期标签指向同一 digest。`latest` 在本批所有版本完成后最后更新。

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

- 13 个组合共 26 个平台运行结果已通过：Java/Tomcat 版本、默认信任库相关证书检查、正常 HTTPS 和最小 JSP 请求。
- amd64 为原生验收；arm64 为 QEMU 模拟验收，未做 ARM 真机验收。所有 53 个公开标签的 index digest、amd64/arm64 manifest digest 均已核对，与已验收 OCI 一致。
- Tomcat 8.5.100 已停止上游维护，仅用于历史业务兼容；更新 JDK 不会修复 Tomcat 自身后续漏洞。
- Tomcat 9 使用 Java EE 的 `javax.*` API；Tomcat 10.1、11 使用 Jakarta EE 的 `jakarta.*` API，跨大版本迁移须检查业务与依赖兼容。
- 新 JDK 默认信任库已按本次安全维护方案处置相关根证书；业务自定义 truststore 和实际外部接口仍需独立验收。
- 本批仅更新 Alpine。CentOS Stream、Rocky Linux 的既有标签属于历史版本，未纳入本次发布。生产部署、真实业务 WAR、数据库与业务接口不属于本次镜像探针验收。

## 文档与维护

- [项目代码与文档（私有仓库，需访问权限）](https://git.dwhd.org/lookback/DSTW-Docker-Tomcat)
- [Apache Tomcat 官方版本说明](https://tomcat.apache.org/whichversion.html)
- [Apache Tomcat 官方安全公告](https://tomcat.apache.org/security.html)
- 许可证与版权声明以镜像中随附的 Tomcat `LICENSE` / `NOTICE` 和 JDK 许可文件为准，本项目不变更上游声明。
- 维护者：Manta，联系邮箱：[manta.ops.dstw@gmail.com](mailto:manta.ops.dstw@gmail.com)。
