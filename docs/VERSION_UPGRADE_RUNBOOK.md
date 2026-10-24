# 版本升级 Runbook

## 1. 适用范围

本 runbook 用于维护 `benyoo/tomcat` 镜像矩阵中的版本升级：

- Tomcat patch 版本升级，例如 `11.0.23 -> 11.0.x`。
- Oracle JDK patch 版本升级，例如 `17.0.19 -> 17.0.x`。
- 基础系统标签升级，主推 `alpine3.24`，兼容 `centos9-stream`、`rockylinux9` 相关 JDK 基础镜像。

默认仍然只使用 `benyoo/jdk` 作为 JDK 来源，不在本项目重新下载或安装 JDK。

2026-10-24 候选配置：8.5.100（独立历史兼容配置）、9.0.123、10.1.61、11.0.27。本批仅启用 Alpine 3.24，五个 JDK 基镜像均已公开可用且包含双架构元数据；CentOS Stream 和 Rocky Linux 后续补齐。具体引用见 `docs/TAGS.md`，配置和 manifest 检查不代表镜像已构建或运行验收。

本批随后已完成 13 个组合、26 个平台的实际构建与探针验收，详见[构建报告](Alpine版Tomcat多架构构建验收报告-20261024211645-20261024211645.md)；尚未向 Docker Hub 发布。以下流程用于后续批次，每批仍须重新执行相应验收。

## 2. 升级前检查

```bash
make prepare
```

每个新批次先执行此入口，重新发现各维护分支最新正式补丁版并冻结本批版本。它不构建、不上传。失败必须停止，不能复用原文件冒充本次准备成功；同批失败续跑则沿用已经验收的版本，不在中途刷新。8.5.100 保持固定历史兼容版本。

检查点：

- `scripts/*.sh` 语法通过。
- `docker-bake.generated.hcl` 能生成。
- 维护矩阵为 12 个 Alpine target；另有 `docker-bake.legacy.hcl` 的 1 个 Alpine 历史兼容 target。
- 不生成 Tomcat/JDK 不兼容组合。

## 3. Tomcat Patch 升级

查看当前上游解析结果：

```bash
TOMCAT_MAJOR="9.0" TOMCAT_VERSION="latest" ./scripts/install-tomcat.sh --print-version
TOMCAT_MAJOR="10.1" TOMCAT_VERSION="latest" ./scripts/install-tomcat.sh --print-version
TOMCAT_MAJOR="11.0" TOMCAT_VERSION="latest" ./scripts/install-tomcat.sh --print-version
```

重新生成 Bake 文件：

```bash
export IMAGE="benyoo/tomcat"
export BUILD_DATE="$(TZ=Asia/Shanghai date +%Y%m%d)"

./scripts/generate-bake.sh docker-bake.generated.hcl
docker buildx bake -f docker-bake.generated.hcl --print
```

验证重点：

- Tomcat `9.0` 下载页仍能解析最新 `9.0.x`。
- Tomcat `10.1` 下载页仍能解析最新 `10.1.x`。
- Tomcat `11.0` 下载页仍能解析最新 `11.0.x`。
- 下载 URL 和 `.sha512` URL 都来自 Apache 官方下载域名。
- 不选择 RC / Beta 或跨分支升级；官方页面不可达、无有效版本时停止。全部分支解析成功且配置生成完成后，才替换原矩阵。

## 4. JDK Patch 升级

JDK patch 版本来自 `DSTW-Docker-JDK` 发布记录。升级步骤：

1. 确认 `benyoo/jdk` 已发布新的 JDK 基础镜像。
2. 更新 `scripts/generate-bake.sh` 中的 `jdk_full_version()` 映射及 `BASE_TARGETS` 固定批次日期。
3. 重新生成 `docker-bake.generated.hcl`。
4. 只先构建一个样板 target 做 smoke。
5. 样板通过后再按 Tomcat 分支分组发布。

需要检查的映射：

```bash
grep -n "jdk_full_version" -A20 scripts/generate-bake.sh
```

验证：

```bash
make syntax
make bake
docker buildx bake -f docker-bake.generated.hcl --print
```

## 5. 基础系统升级

基础系统入口在 `scripts/generate-bake.sh` 的 `BASE_TARGETS`：

```bash
grep -n "BASE_TARGETS" -A8 scripts/generate-bake.sh
```

升级原则：

- 本批仅启用 Alpine 3.24；CentOS Stream 9、Rocky Linux 9 在后续明确启用时再恢复对应配置并验收。
- 所有基础系统的 tag 命名必须和 `benyoo/jdk` 保持一致。
- 不能只更新 Tomcat 项目的标签文本，必须先确认对应 `benyoo/jdk:<jdk-full>-<os>-<date>` 多架构 manifest 存在，并记录 digest。
- 如果某个基础镜像缺少 `linux/arm64`，停止发布，不降级为单架构。

检查示例：

```bash
docker buildx imagetools inspect benyoo/jdk:17.0.21.0.2-alpine3.24-20261024
```

## 6. 发布节奏

不要直接一次性发布全矩阵。默认按分支分组：

```text
1. Tomcat 8.5（本批包含历史兼容配置时）
2. Tomcat 9.0
3. Tomcat 10.1
4. Tomcat 11.0
```

每组失败都停止，不继续下一组，不静默降级为 `amd64`。

每条线先发布并验证精确标签，再更新该线移动别名；仅在获授权时最后更新 `latest`，然后更新并读回 Repository overview。不要直接对默认全矩阵执行 `--push`。

## 7. 发布后验证

每个分支至少抽查一个短标签：

```bash
docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-alpine3.24
docker buildx imagetools inspect benyoo/tomcat:10.1-jdk11-alpine3.24
docker buildx imagetools inspect benyoo/tomcat:9.0-jdk8-alpine3.24
```

运行验证：

```bash
IMAGE="benyoo/tomcat:11.0-jdk17-alpine3.24" PORT="18183" ./scripts/verify-tomcat.sh
IMAGE="benyoo/tomcat:10.1-jdk11-alpine3.24" PORT="18186" ./scripts/verify-tomcat.sh
IMAGE="benyoo/tomcat:9.0-jdk8-alpine3.24" PORT="18187" ./scripts/verify-tomcat.sh
```

## 8. 文档更新

升级完成后必须同步更新：

- `README.md`
- `TODO.md`
- `docs/TAGS.md`
- `dockerhub-repository-overview.md`

DockerHub overview 只写公开使用信息，不写远程构建节点、SSH、VPN、内部目录或 token 处理细节。

## 9. 失败处理

如果 DockerHub 认证失败：

- 停止发布动作。
- 保留远程工作区。
- 保留已生成产物。
- 不回滚、不 reset、不切换账号；保护产物和独有修改，按统一收尾规范清理本任务确认无用的临时资源。

如果构建失败：

- 保留最小诊断日志、独有修改和有效产物，再按任务归属清理确认无用的中间资源。
- 先确认失败 target、基础镜像 manifest、Tomcat 下载和 sha512 校验。
- 不降级为单架构，除非重新确认发布策略。
