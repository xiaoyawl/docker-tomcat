# 镜像标签规划

## 标签格式

| 格式 | 示例 | 用途 |
|---|---|---|
| `<tomcat>-jdk<jdk>-<os>` | `11.0-jdk17-alpine3.24` | 稳定别名 |
| `<tomcat-full>-jdk<jdk-full>-<os>` | `11.0.27-jdk17.0.21.0.2-alpine3.24` | 完整版本回滚 |
| `<tomcat>-jdk<jdk>-<os>-<build-date>` | `11.0-jdk17-alpine3.24-20261024` | 构建批次锁定 |
| `<tomcat-full>-jdk<jdk-full>-<os>-<build-date>` | `11.0.27-jdk17.0.21.0.2-alpine3.24-20261024` | 完整可追溯标签 |

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

以上是 2026-10-24 已构建、尚未发布的版本。本批仅启用 Alpine：12 个维护 target，加 1 个 8.5.100 兼容 target，26 个平台运行结果已通过。CentOS Stream 和 Rocky Linux 后续补齐。五个 Alpine JDK 固定版本日期标签已核对双架构；本批 OCI、Java/Tomcat 版本、证书信任、正常 HTTPS 与最小 JSP 均已复核，arm64 为 QEMU 模拟验收。真实业务和自定义 truststore 另行验收。详见[构建报告](Alpine版Tomcat多架构构建验收报告-20261024211645-20261024211645.md)。

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
