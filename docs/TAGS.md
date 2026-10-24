# 镜像标签与发布清单

## 标签格式

| 格式 | 示例 | 用途 |
|---|---|---|
| `<tomcat>-jdk<jdk>-<os>` | `11.0-jdk17-alpine3.24` | 稳定别名 |
| `<tomcat-full>-jdk<jdk-full>-<os>` | `11.0.27-jdk17.0.21.0.2-alpine3.24` | 完整组件版本别名；历史回滚使用已记录的digest/OCI |
| `<tomcat>-jdk<jdk>-<os>-<tag-date>` | `11.0-jdk17-alpine3.24-20261024` | 发布批次；固定内容需使用digest |
| `<tomcat-full>-jdk<jdk-full>-<os>-<tag-date>` | `11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` | 完整组件与发布批次；本次按授权修订内容 |

## 当前版本映射

| 组件 | 版本 |
|---|---|
| Tomcat 8.5 | 固定 `8.5.100`，独立历史兼容配置，仅 JDK 8 |
| Tomcat 9.0 | `9.0.123`，本次解析后固定在生成文件 |
| Tomcat 10.1 | `10.1.61`，本次解析后固定在生成文件 |
| Tomcat 11.0 | `11.0.27`，本次解析后固定在生成文件 |
| JDK 8 | `8u511-b32` |
| JDK 11 | `11.0.33.0.2` |
| JDK 17 | `17.0.21.0.2` |
| JDK 21 | `21.0.13.0.2` |
| JDK 25 | `25.0.5.0.2` |

以上是 2026-10-24 已构建并发布的版本。本批覆盖 Alpine 3.24、CentOS Stream 9、Rocky Linux 9：36 个维护 target 加 3 个历史兼容 target，78 个平台运行结果已通过。五个 Alpine JDK 固定版本日期标签已核对双架构；本批 OCI、Java/Tomcat 版本、证书信任、正常 HTTPS 与最小 JSP 均已复核，arm64 为 QEMU 模拟验收。真实业务和自定义 truststore 另行验收。详见[构建报告](Alpine版Tomcat多架构构建验收报告-20261024211645-20261024211645.md)。

| JDK | 本批使用的 Alpine 基础镜像 |
|---|---|
| 8 | `benyoo/jdk:8u511-b32-alpine3.24-20261024` |
| 11 | `benyoo/jdk:11.0.33.0.2-alpine3.24-20261024` |
| 17 | `benyoo/jdk:17.0.21.0.2-alpine3.24-20261024` |
| 21 | `benyoo/jdk:21.0.13.0.2-alpine3.24-20261024` |
| 25 | `benyoo/jdk:25.0.5.0.2-alpine3.24-20261024` |

维护矩阵的基础镜像采用 `benyoo/jdk:<jdk-full>-<os>-20261024`；历史兼容配置另固定了已核实的多架构 index digest。后续升级须同时更新 JDK 完整版本映射和基础镜像批次日期，构建前核验 manifest、运行时与证书信任。

## 生成方式

```bash
export IMAGE="benyoo/tomcat"
export BUILD_DATE="$(TZ=Asia/Shanghai date +%Y%m%d)"

./scripts/generate-bake.sh docker-bake.generated.hcl
docker buildx bake -f docker-bake.generated.hcl --print
```

## 注意事项

- 生产部署优先使用完整版本日期标签。
- 短标签适合开发、测试和人工验证。
- `latest` 不作为生产部署建议标签。
- JDK 完整版本需要跟随 `DSTW-Docker-JDK` 发布记录同步更新。

## 本批发布核验

三系统合计 156 个版本标签及 `latest` 均已发布并核对双架构 digest。`latest` 最后独立更新至 `11.0.27-jdk17.0.21.0.2-alpine3.24-20261024`；不要将它加入各 target 的 Bake 标签，否则低版本任务可能提前覆盖默认入口。Alpine 首次发布记录见[发布与标签核验报告](Alpine版Tomcat发布与标签核验报告-20261024213303-20261024213303.md)。

三系统全部已发布标签及 digest 见[三系统构建发布验收报告](三系统Tomcat构建发布与双架构验收报告-20261024223534-20261024223534.md)和[机器可读清单](三系统Tomcat镜像发布清单-20261024223534-20261024223534.json)。CentOS Stream / Rocky Linux 的基镜像模式分别为 `benyoo/jdk:<完整版本>-centos9-stream-20261024` / `benyoo/jdk:<完整版本>-rockylinux9-20261024`。

## 2026-10-25端口兼容修订

按用户要求复用20261024标签，157个标签的digest已更新。原20261024归档及旧digest保留。`TAG_DATE=20261024` 与实际 `BUILD_DATE=20261025` 分离；生产切换前重新pull并核对本次清单。详见[端口兼容修复与全矩阵验收报告](Tomcat端口兼容修复与全矩阵验收报告-20261025015531-20261025015531.md)及[新旧digest清单](Tomcat端口兼容修复镜像清单-20261025015531-20261025015531.json)。
