# DSTW-Docker-Tomcat 项目开发规划

2026-10-25状态：HTTP端口兼容修复的39组合、78平台、156默认/非默认端口场景完成验收；按用户要求复用1024标签并保留旧OCI。详情见[端口兼容修复与全矩阵验收报告](Tomcat端口兼容修复与全矩阵验收报告-20261025015531-20261025015531.md)。生产尚未切换。

2026-10-24 当前状态：三系统 39 组合、78 个平台运行结果及 157 个标签（含 latest）完成构建、探针验收、发布和双架构 digest 核验。amd64 原生、arm64 QEMU；生产和真实业务未验收。详见[三系统构建发布验收报告](三系统Tomcat构建发布与双架构验收报告-20261024223534-20261024223534.md)。

## 1. 我的理解和假设

我的理解是：本项目要从 `DSTW-Docker-JDK` 继承 Oracle JDK-only 基础镜像体系，构建一套可长期维护的 Tomcat Docker 镜像工程。

这里我先假设：

- 镜像名使用 `benyoo/tomcat`。
- 基础 JDK 镜像只使用 `benyoo/jdk`，不在本项目重复下载或安装 JDK。
- Tomcat 分支只纳入 Apache 官方仍维护的稳定分支。
- 首批纳入 Tomcat `9.0`、`10.1`、`11.0`。
- `9.1` 当前作为预留项，等 Apache 正式发布后再加入构建矩阵。
- Alpine 3.24 作为项目主推基础系统；CentOS Stream 9 和 Rocky Linux 9 保留为兼容变体。
- CentOS 指 CentOS Stream 9，对齐 `benyoo/jdk` 的现有基础镜像。
- 规划后已获授权并完成远程构建和 Docker Hub 发布；生产部署不在本轮范围。

如果后续你希望“所有长期维护版本”只表示每个 Tomcat 分支绑定最低 JDK，而不是覆盖所有兼容 JDK，我会把矩阵从 36 个 target 收缩成 9 个 target。

## 2. 可验证目标

1. 文档能明确说明支持哪些 Tomcat 分支。 -> verify: `README.md` 和本文档有版本矩阵。
2. 文档能明确说明支持哪些基础系统和架构。 -> verify: 矩阵包含 CentOS/Rocky/Alpine 和 amd64/arm64。
3. 文档能明确说明后续开发 TODO。 -> verify: `TODO.md` 有可逐项执行的 checklist。
4. 文档能明确说明构建、发布、验证边界。 -> verify: 包含远程构建、多架构、DockerHub 认证和验证命令。

## 3. 官方版本边界

| 分支 | 当前规划状态 | 最低 Java | 纳入原因 |
|---|---|---:|---|
| Tomcat 9.0 | 纳入 | 8 | 当前仍维护，兼容 Java EE 8 / Servlet 4.0 业务 |
| Tomcat 10.1 | 纳入 | 11 | 当前仍维护，面向 Jakarta EE 10 |
| Tomcat 11.0 | 纳入 | 17 | 当前仍维护，面向 Jakarta EE 11 |
| Tomcat 9.1 | 预留 | 待确认 | 用于承接 Tomcat 9.0 生命周期结束后的 Java EE 8 业务 |

不纳入：

| 分支 | 原因 |
|---|---|
| Tomcat 8.5 | 已结束维护 |
| Tomcat 10.0 | 已结束维护 |
| Tomcat 7 / 8.0 | 已结束维护 |

参考：

- <https://tomcat.apache.org/whichversion.html>
- <https://tomcat.apache.org/tomcat-9.0.x-eos.html>

## 4. 基础镜像策略

本项目不直接选择 OS 镜像，而是选择已经完成 JDK 安装和运行时约束的 `benyoo/jdk` 镜像。

| 基础系统 | JDK 基础镜像标签模式 | 说明 |
|---|---|---|
| Alpine 3.24 | `benyoo/jdk:<jdk>-alpine3.24-<date>` | 主推基础系统，轻量镜像优先 |
| CentOS Stream 9 | `benyoo/jdk:<jdk>-centos9-stream-<date>` | 兼容变体，企业兼容和传统服务优先 |
| Rocky Linux 9 | `benyoo/jdk:<jdk>-rockylinux9-<date>` | 兼容变体，RHEL 兼容生产环境优先 |

JDK 版本来自 `DSTW-Docker-JDK` 当前矩阵：

```text
8 / 11 / 17 / 21 / 25
```

## 5. 构建矩阵

### 5.1 兼容 JDK 矩阵

| Tomcat | JDK 8 | JDK 11 | JDK 17 | JDK 21 | JDK 25 |
|---|---:|---:|---:|---:|---:|
| 9.0 | yes | yes | yes | yes | yes |
| 10.1 | no | yes | yes | yes | yes |
| 11.0 | no | no | yes | yes | yes |

### 5.2 基础系统矩阵

| Tomcat | Alpine 3.24 | CentOS Stream 9 | Rocky Linux 9 |
|---|---:|---:|---:|
| 9.0 | yes | yes | yes |
| 10.1 | yes | yes | yes |
| 11.0 | yes | yes | yes |

### 5.3 架构矩阵

| 架构 | 状态 |
|---|---|
| `linux/amd64` | 必须支持 |
| `linux/arm64` | 必须支持 |

### 5.4 Target 数量

```text
Tomcat 9.0  = 5 JDK * 3 OS = 15 target
Tomcat 10.1 = 4 JDK * 3 OS = 12 target
Tomcat 11.0 = 3 JDK * 3 OS =  9 target
Total       = 36 target
```

每个 target 构建 `linux/amd64` 和 `linux/arm64`。

## 6. 标签策略

推荐标签由四段组成：

```text
<tomcat-version>-jdk<jdk-version>-<os-suffix>[-<build-date>]
```

示例：

```text
9.0-jdk8-alpine3.24
9.0.119-jdk8u491-alpine3.24-20260626
10.1-jdk11-alpine3.24
10.1.56-jdk11.0.31-alpine3.24-20260626
11.0-jdk17-alpine3.24
11.0.23-jdk17.0.19-alpine3.24-20260626
```

标签原则：

- 短标签用于日常使用。
- 完整版本标签用于回滚和问题定位。
- 日期标签用于构建批次追踪。
- 不使用 `latest` 作为生产部署建议标签。

## 7. 目录和文件设计

| 文件 / 目录 | 用途 |
|---|---|
| `Dockerfile` | 基于 `benyoo/jdk` 安装 Tomcat |
| `docker-bake.hcl` | 静态 Buildx Bake 入口 |
| `docker-bake.generated.hcl` | 生成后的完整构建矩阵 |
| `scripts/install-tomcat.sh` | 下载、校验、安装 Tomcat |
| `scripts/generate-bake.sh` | 根据版本矩阵生成 Bake 文件 |
| `scripts/docker-entrypoint.sh` | Tomcat 运行入口 |
| `scripts/verify-tomcat.sh` | 本地容器验证 |
| `compose.yaml` | 单容器示例 |
| `examples/webapp/compose.yaml` | war 挂载示例 |
| `README.md` | 项目主文档 |
| `TODO.md` | 开发执行清单 |

## 8. 开发阶段规划

### Phase 1: 文档和矩阵确认

目标：

- 固化版本策略、构建矩阵、标签策略。
- 确认 Tomcat 版本解析方式。
- 确认是否需要覆盖所有兼容 JDK 组合。

验证：

```bash
find . -maxdepth 3 -type f
```

### Phase 2: Tomcat 安装脚本

目标：

- 实现 `scripts/install-tomcat.sh`。
- 支持指定 `TOMCAT_MAJOR` 和 `TOMCAT_VERSION`。
- 支持 Apache 官方下载源。
- 校验 tar.gz 完整性，优先使用 sha512。
- 安装到 `/opt/tomcat`。
- 创建 `/usr/local/tomcat` 兼容软链。

验证：

```bash
bash -n scripts/install-tomcat.sh
TOMCAT_MAJOR="11" TOMCAT_VERSION="11.0.23" ./scripts/install-tomcat.sh --print-url
```

### Phase 3: Dockerfile 和入口脚本

目标：

- 基于 `benyoo/jdk` 构建 Tomcat。
- 保持 `JAVA_HOME`、`PATH` 等 JDK 运行约束。
- 设置 `CATALINA_HOME`、`CATALINA_BASE`。
- 默认执行 `catalina.sh run`。
- 支持 `TIMEZONE`、`APP_WAR`、`CATALINA_OPTS`、`JAVA_OPTS`。

验证：

```bash
bash -n scripts/docker-entrypoint.sh
docker buildx build --platform linux/amd64 --load -t benyoo/tomcat:test .
docker run --rm benyoo/tomcat:test catalina.sh version
```

### Phase 4: Bake 生成器

目标：

- 实现 36 个 target 的自动生成。
- 默认平台为 `linux/amd64,linux/arm64`。
- 生成短标签、完整版本标签、日期标签。
- 不允许把不兼容组合写入 Bake 文件。

验证：

```bash
bash -n scripts/generate-bake.sh
./scripts/generate-bake.sh docker-bake.generated.hcl
docker buildx bake -f docker-bake.generated.hcl --print
```

### Phase 5: 远程多架构构建

目标：

- 在远程构建节点执行 Buildx 构建。
- 构建节点：`158.69.107.254`
- 工作目录：`/data/DSTW-Docker-Tomcat`
- 默认平台：`linux/amd64,linux/arm64`

验证：

```bash
docker buildx version
docker buildx ls
docker buildx bake -f docker-bake.generated.hcl --print
docker buildx bake -f docker-bake.generated.hcl
```

### Phase 6: 发布和运行验证

目标：

- 使用 DockerHub token 通过 `--password-stdin` 登录。
- 推送 `benyoo/tomcat` 多架构镜像。
- 验证 manifest 包含 amd64 和 arm64。
- 验证每个 Tomcat 分支至少一个运行样例。

验证：

```bash
docker buildx bake -f docker-bake.generated.hcl --push
docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-alpine3.24
docker run -d --name tomcat-test -p 8080:8080 benyoo/tomcat:11.0-jdk17-alpine3.24
curl -fsS http://127.0.0.1:8080/
docker rm -f tomcat-test
```

## 9. 风险和约束

| 风险 | 处理方式 |
|---|---|
| Tomcat 版本更新频繁 | 版本解析脚本要支持固定版本和最新 patch 两种模式 |
| Tomcat 9.0 生命周期接近结束 | 保留 9.1 迁移 TODO，不把 9.0 当无限期分支 |
| Alpine + Oracle JDK glibc 兼容 | 继承 `benyoo/jdk` 已有兼容策略，Tomcat 层只做运行验证 |
| arm64 上游包缺失 | 构建失败即停止，不降级为 amd64 |
| DockerHub 认证失败 | 保留构建产物和远程工作区，不清理、不回滚、不切换账号 |
| 矩阵过大 | 先用 Bake `--print` 审核，再分组构建和验证 |

## 10. 完成标准

项目进入可发布状态前必须满足：

- `README.md`、`TODO.md`、`docs/PROJECT_PLAN.md` 已更新。
- `Dockerfile` 可以构建至少一个 amd64 测试镜像。
- `scripts/*.sh` 通过 `bash -n`。
- `docker-bake.generated.hcl` 能生成 36 个 target。
- 至少完成 Tomcat 9.0 / 10.1 / 11.0 各一个样例运行验证。
- 多架构推送后 manifest 同时包含 `linux/amd64` 和 `linux/arm64`。
- 没有提交 token、密码、私钥、本地环境文件或构建临时产物。
