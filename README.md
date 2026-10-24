# DSTW Docker Tomcat

源码仓库：[xiaoyawl/docker-tomcat](https://github.com/xiaoyawl/docker-tomcat)；代码同步维护于私有仓库。维护者：Manta <manta.ops.dstw@gmail.com>。

![Docker](https://img.shields.io/badge/docker-buildx-blue)
![Arch](https://img.shields.io/badge/arch-amd64%20%7C%20arm64-green)
![Tomcat](https://img.shields.io/badge/tomcat-9.0%20%7C%2010.1%20%7C%2011.0-orange)

## Overview

本项目规划基于自有 `benyoo/jdk` 基础镜像创建 Tomcat 容器镜像，继承 `DSTW-Docker-JDK` 的 Oracle JDK-only、多系统、多架构策略。

默认目标：

- Tomcat 长期维护分支：`9.0`、`10.1`、`11.0`
- 主推基础系统：Alpine 3.24
- 兼容系统：CentOS Stream 9、Rocky Linux 9，已补齐构建及发布
- CPU 架构：`linux/amd64`、`linux/arm64`
- JDK 来源：只使用 `benyoo/jdk` 镜像，不在 Tomcat 项目里重新安装 JDK
- 构建方式：Docker Buildx 多架构构建

**2026-10-25 已修复旧镜像 HTTP 端口变量兼容缺失**：`TOMCAT_HTTP_PORT=9027` 现可让 Tomcat 实际监听9027，保留原 `JAVA_OPTS` / `CATALINA_OPTS`，默认8080保持可用。三系统 **39组合、78平台、156端口场景** 已重新构建并通过回归；157个标签及双架构digest已核对。

按用户要求继续使用 **20261024标签**，其digest已更新；实际构建时间记录为20261025。已有客户端必须重新pull，历史回滚使用已记录的旧digest/OCI。`latest` 最后更新，继续指向 **Tomcat11.0.27 + JDK17.0.21.0.2 + Alpine3.24**。详情见[端口兼容修复与全矩阵验收报告](docs/Tomcat端口兼容修复与全矩阵验收报告-20261025015531-20261025015531.md)和[完整修复清单](docs/Tomcat端口兼容修复镜像清单-20261025015531-20261025015531.json)。

生产仍保留用户已恢复的旧镜像；真实业务交易、自定义truststore和ARM真机未验收。amd64为原生、arm64为QEMU模拟。[Docker Hub概览](https://hub.docker.com/r/benyoo/tomcat)已同步，公开文档入口只指向GitHub。

> 维护分支矩阵按 Apache Tomcat 官方维护状态制定。另提供按需构建的 `JDK 8 + Tomcat 8.5.100` 历史兼容配置；Tomcat 10.0 不纳入矩阵。Tomcat 9.1 在上游发布后作为 9.0 退场前的迁移分支纳入规划。

## Tomcat 8.5 历史兼容组合

新增配置在 `docker-bake.legacy.hcl`，仅支持 Tomcat **8.5.100 + Oracle JDK 8u511-b32**，覆盖 Alpine 3.24、CentOS Stream 9、Rocky Linux 9。基础镜像固定到 `20261024` 安全维护批次及多架构 index digest，Tomcat 从 Apache 官方归档下载并校验 SHA-512。

Tomcat 8.5 已于 **2024-03-31** [停止上游维护](https://tomcat.apache.org/tomcat-85-eol.html)。此组合仅用于旧业务兼容；更新 JDK 不会修复 Tomcat 本身的后续漏洞，镜像带有 `dstw.tomcat.lifecycle=eol` 标记。

以下命令在远程构建节点执行；`--print` 仅检查配置，不构建、不上传：

```bash
docker buildx bake -f docker-bake.legacy.hcl --print
docker buildx bake -f docker-bake.legacy.hcl tomcat8-5-alpine3-24-jdk8
```

兼容配置共 3 个 target，维护分支为 36 个 target，总计 39 个组合、78 个架构产物。本批双架构构建、探针验收及发布已完成，下面的标签已可拉取：

```text
benyoo/tomcat:8.5-jdk8-alpine3.24
benyoo/tomcat:8.5.100-jdk8u511-b32-alpine3.24-20261024
```

验收需覆盖实际 Java/Tomcat 版本、Oracle CheckCerts、业务 WAR、正常 HTTPS、持久化路径及两个架构的启动；不以默认首页可访问代替业务验收。

## Version Policy

| Tomcat 分支 | Jakarta/Servlet 世代 | 最低 Java | 本项目状态 | 说明 |
|---|---|---:|---|---|
| `9.0.x` | Java EE 8 / Servlet 4.0 | 8 | 纳入 | 当前维护分支，需规划 9.1 迁移 |
| `10.1.x` | Jakarta EE 10 / Servlet 6.0 | 11 | 纳入 | 当前维护分支 |
| `11.0.x` | Jakarta EE 11 / Servlet 6.1 | 17 | 纳入 | 当前维护分支 |
| `9.1.x` | Java EE 8 / Servlet 4.0 | 待官方最终确认 | 预留 | 上游发布后补入矩阵 |

参考官方页面：

- Apache Tomcat version matrix: <https://tomcat.apache.org/whichversion.html>
- Apache Tomcat 9.0 end of life notice: <https://tomcat.apache.org/tomcat-9.0.x-eos.html>
- Apache Tomcat downloads: <https://tomcat.apache.org/download-90.cgi>、<https://tomcat.apache.org/download-10.cgi>、<https://tomcat.apache.org/download-11.cgi>

## Capability Matrix

| 能力 | amd64 | arm64 | 说明 |
|---|---:|---:|---|
| Tomcat 9.0 | yes | yes | 支持 JDK 8 / 11 / 17 / 21 / 25 |
| Tomcat 10.1 | yes | yes | 支持 JDK 11 / 17 / 21 / 25 |
| Tomcat 11.0 | yes | yes | 支持 JDK 17 / 21 / 25 |
| Alpine 3.24 | yes | yes | 主推基础系统，基于 `benyoo/jdk:<jdk>-alpine3.24-*` |
| CentOS Stream 9 | yes | yes | 已构建、验收并发布 |
| Rocky Linux 9 | yes | yes | 已构建、验收并发布 |

## Build Matrix

完整矩阵按“Tomcat 分支 + 兼容 JDK + 基础系统 + CPU 架构”生成。

| Tomcat | JDK 8 | JDK 11 | JDK 17 | JDK 21 | JDK 25 | 基础系统 |
|---|---:|---:|---:|---:|---:|---|
| `8.5.100` | yes | no | no | no | no | 三系统，独立历史兼容配置 |
| `9.0` | yes | yes | yes | yes | yes | Alpine / CentOS Stream / Rocky Linux |
| `10.1` | no | yes | yes | yes | yes | Alpine / CentOS Stream / Rocky Linux |
| `11.0` | no | no | yes | yes | yes | Alpine / CentOS Stream / Rocky Linux |

当前启用 39 个构建 target：

- Tomcat 8.5.100：1 个 JDK × 3 个基础系统，独立兼容配置
- Tomcat 9.0：5 个 JDK × 3 个基础系统
- Tomcat 10.1：4 个 JDK × 3 个基础系统
- Tomcat 11.0：3 个 JDK × 3 个基础系统

每个 target 默认构建 `linux/amd64` 和 `linux/arm64`。

## Image Tags

推荐镜像名：

```text
benyoo/tomcat
```

推荐标签格式：

| Tag | 说明 |
|---|---|
| `<tomcat>-jdk<jdk>-<os>` | 稳定别名，例如 `11.0-jdk17-alpine3.24` |
| `<tomcat-full>-jdk<jdk-full>-<os>` | 完整版本，例如 `11.0.27-jdk17.0.21.0.2-alpine3.24` |
| `<tomcat>-jdk<jdk>-<os>-<build-date>` | 日期锁定别名，例如 `11.0-jdk17-alpine3.24-20261024` |
| `<tomcat-full>-jdk<jdk-full>-<os>-<build-date>` | 完整可追溯版本 |

本批已发布标签示例（其他组合见完整清单）：

```text
benyoo/tomcat:9.0-jdk8-alpine3.24
benyoo/tomcat:9.0.123-jdk8u511-b32-alpine3.24-20261024
benyoo/tomcat:10.1-jdk11-alpine3.24
benyoo/tomcat:10.1.61-jdk11.0.33.0.2-alpine3.24-20261024
benyoo/tomcat:11.0-jdk17-alpine3.24
benyoo/tomcat:11.0.27-jdk17.0.21.0.2-alpine3.24-20261024
benyoo/tomcat:9.0.123-jdk8u511-b32-centos9-stream-20261024
benyoo/tomcat:10.1.61-jdk11.0.33.0.2-rockylinux9-20261024
```

## Planned Repository Layout

```text
DSTW-Docker-Tomcat/
├── Dockerfile
├── Makefile
├── README.md
├── TODO.md
├── dockerhub-repository-overview.md
├── docker-bake.hcl
├── docker-bake.generated.hcl
├── docker-bake.legacy.hcl
├── compose.yaml
├── docs/
│   ├── PROJECT_PLAN.md
│   ├── RELEASE_RUNBOOK.md
│   ├── TAGS.md
│   ├── TOMCAT_9_TO_9_1_TRACKING.md
│   └── VERSION_UPGRADE_RUNBOOK.md
├── examples/
│   └── webapp/
│       └── compose.yaml
└── scripts/
    ├── docker-entrypoint.sh
    ├── generate-bake.sh
    ├── install-tomcat.sh
    └── verify-tomcat.sh
```

## Runtime Contract

Tomcat 镜像应提供以下默认行为：

| 变量 / 路径 | 用途 |
|---|---|
| `CATALINA_HOME` | Tomcat 安装目录，默认 `/opt/tomcat` |
| `CATALINA_BASE` | Tomcat 运行目录，默认 `/opt/tomcat` |
| `TOMCAT_VERSION` | 完整 Tomcat 版本 |
| `JAVA_HOME` | 从 `benyoo/jdk` 基础镜像继承 |
| `TOMCAT_HTTP_PORT` | 默认8080；支持1～65535的固定HTTP端口，例如9027 |
| `JAVA_OPTS` / `CATALINA_OPTS` | 保留业务JVM参数；端口属性追加到CATALINA_OPTS |
| `TIMEZONE` | 推荐时区入口，默认 `Asia/Shanghai` |
| `/usr/local/tomcat` | 兼容官方 Tomcat 镜像常见路径，软链到 `CATALINA_HOME` |
| `/webapps` | 可选业务 war 挂载目录 |
| `/logs` | 可选日志挂载目录 |
| `APP_WAR` | 可选，容器启动时复制或链接指定 war |

默认启动命令：

```bash
catalina.sh run
```

## 旧镜像端口迁移

```yaml
services:
  tomcat:
    image: benyoo/tomcat:9.0.123-jdk8u511-b32-alpine3.24-20261024
    network_mode: host
    environment:
      TOMCAT_HTTP_PORT: "9027"
      JAVA_OPTS: "-Duser.timezone=Etc/GMT+4"
```

host网络直接使用应用监听端口，ports映射不起作用。自定义只读server.xml应使用 `port="${dstw.tomcat.http.port:-8080}"`，否则其硬编码端口优先。此修复只涉及HTTP端口；管理应用沿用既有禁用状态。

## Build

`make test` 校验入口和端口边界；本次复用标签批次可使用 `make prepare TAG_DATE=20261024`。`BUILD_DATE` 默认真实北京时间日期，`TAG_DATE` 默认跟随它，只有明确要求复用标签时才单独设置。

真正构建镜像时默认在远程构建节点执行，不在本地直接构建发布镜像。

构建前检查：

```bash
docker buildx version
docker buildx ls
```

生成 Bake 文件：

```bash
export IMAGE="benyoo/tomcat"
export BUILD_DATE="$(TZ=Asia/Shanghai date +%Y%m%d)"

./scripts/generate-bake.sh docker-bake.generated.hcl
docker buildx bake -f docker-bake.generated.hcl --print
```

也可以使用 Makefile：

```bash
make prepare
```

每次新建构建批次都先执行 `make prepare`。该入口只做脚本语法检查、从 Apache 官方下载页重新解析 9.0 / 10.1 / 11.0 的最新正式补丁版、生成并解析 Bake 配置；不会构建、推送或部署。8.5 已停止维护，继续固定为 8.5.100。

三个维护分支全部解析成功后才原子替换 `docker-bake.generated.hcl`；解析失败会停止并保留原文件，不能将原文件当成本次刷新成功继续构建。生成后，本批所有系统、JDK 和架构组合使用同一组精确 Tomcat 版本，避免构建中途版本漂移。新批次再次执行 `make prepare`；失败续跑同一批次时保留已验收版本，不中途刷新。

后续构建统一使用这次生成的矩阵；`docker-bake.hcl` 与 Dockerfile 默认值只是固定样板，绕过准备入口会继续使用其中的旧快照。这里的“最新”指本项目已纳入分支的最新正式补丁版，不自动跨到 9.1、12 等新分支，也不自动选择 RC / Beta。JDK 仍须独立核验已发布的安全批次、双架构及证书信任，不能由 Tomcat 版本刷新代替。

多架构构建：

```bash
IMAGE="benyoo/tomcat"

docker buildx bake -f docker-bake.generated.hcl
```

获授权后逐版本发布 DockerHub；先按发布手册完成低版本线，再处理高版本线，每条线先核验精确标签再更新移动别名。以下是新产物构建发布的示意，不对全矩阵直接推送；已验收 OCI 的发布应按 `docs/RELEASE_RUNBOOK.md` 的归档流程执行，避免重建改变 digest：

```bash
IMAGE="benyoo/tomcat"

docker buildx bake -f docker-bake.generated.hcl tomcat9-0-alpine3-24-jdk8 --push
```

## Verify

每个镜像至少验证：

```bash
docker run --rm benyoo/tomcat:11.0-jdk17-alpine3.24 java -version
docker run --rm benyoo/tomcat:11.0-jdk17-alpine3.24 catalina.sh version
docker run -d --name tomcat-test -p 8080:8080 benyoo/tomcat:11.0-jdk17-alpine3.24
curl -fsS http://127.0.0.1:8080/
docker rm -f tomcat-test
```

多架构发布后验证 manifest：

```bash
docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-alpine3.24
```

## Docs

| 文档 | 用途 |
|---|---|
| `docs/PROJECT_PLAN.md` | 项目规划和阶段目标 |
| `docs/TAGS.md` | 标签格式和完整版本策略 |
| `docs/RELEASE_RUNBOOK.md` | 远程构建、发布和验证步骤 |
| `docs/VERSION_UPGRADE_RUNBOOK.md` | Tomcat patch / JDK patch / 基础系统升级流程 |
| `docs/TOMCAT_9_TO_9_1_TRACKING.md` | Tomcat 9.0 EOL 和未来 9.1 迁移跟踪 |
| `dockerhub-repository-overview.md` | DockerHub Repository overview 同步源文档 |
| `TODO.md` | 当前执行进度 |

## 2026-06 历史发布记录

以下仅为 2026-06 的历史发布记录，本批状态以文首验收报告为准。此前已在远程构建节点完成 `benyoo/tomcat:11.0-jdk17-rockylinux9-test` 的 `linux/amd64 --load` smoke build，并完成 Tomcat `11.0`、`10.1` 和 `9.0` 组 DockerHub 多架构发布。

验证结果：

- Tomcat: `11.0.23`
- JDK: Oracle JDK `17.0.19`
- OCI 平台: `linux/amd64`、`linux/arm64`
- Tomcat 11.0 组: 9 个 target 已发布
- Tomcat 10.1 组: 12 个 target 已发布
- Tomcat 9.0 组: 15 个 target 已发布
- 全矩阵: 36 个 target 已按分组发布
- 当前主推基础系统: Alpine 3.24
- 当前主推标签: `benyoo/tomcat:11.0-jdk17-alpine3.24`
- DockerHub Repository overview: 源文档已调整为 Alpine 优先，线上待同步
- `catalina.sh version`: 通过
- HTTP 访问: 通过
- 镜像 label: 已记录 Tomcat/JDK/构建日期/基础镜像

Tomcat 11.0 已发布短标签：

| Tag | Digest |
|---|---|
| `11.0-jdk17-centos9-stream` | `sha256:269cdef69a3248f2c0407e78e7bae6cba23bc77b053b5cf6f8a073e13c567eb8` |
| `11.0-jdk21-centos9-stream` | `sha256:dbc193a092165ec6a6449a88378070cd9a6310f5584cd73eafa41816d26f0c74` |
| `11.0-jdk25-centos9-stream` | `sha256:4f09c5b1afe037a4262728ff3e8bd9b392e2f7344f4c4802675686f2998a9747` |
| `11.0-jdk17-rockylinux9` | `sha256:a11727ad77e1384e568d0fbab2f186c70a6a66047a99c9eb1e58d90758614872` |
| `11.0-jdk21-rockylinux9` | `sha256:bb01aff9243deda691c5f0d63426f45dd64a34e892ceeb404c6a5bbcc1676c2e` |
| `11.0-jdk25-rockylinux9` | `sha256:231bee51f03221e84069c5907fb0f17830fa8da5bbbb33d4e806e14ddc182b7b` |
| `11.0-jdk17-alpine3.24` | `sha256:80ccefeae98ab1d65f14e252f6fac75de2bd949cedb21c177e9b1863e60c4b1a` |
| `11.0-jdk21-alpine3.24` | `sha256:4ff93c9045a7797be50d560ca754a7e74e3e9fae4c9b91cfed50a795bfe9fc39` |
| `11.0-jdk25-alpine3.24` | `sha256:3d473d01fda5aef308816410127093e464231836aa9b829b6ed564ce5a1949db` |

Tomcat 10.1 已发布短标签：

| Tag | Digest |
|---|---|
| `10.1-jdk11-centos9-stream` | `sha256:cd5cee71c81d0306bb385ef2a4067435973e5c43e03335c6e93550656ec6ffe4` |
| `10.1-jdk17-centos9-stream` | `sha256:ed2e93b5561f134d8357e1c891b1cd0293dabb34866e2243e15f3105883b8412` |
| `10.1-jdk21-centos9-stream` | `sha256:1819439396a997700600e8b4205eb1eca27ae6c99db60312f3d915741be5cce8` |
| `10.1-jdk25-centos9-stream` | `sha256:cb41a6172be024e0703f3e17036a34ae7b84a52fb927488b70f2e2ebe496d6fb` |
| `10.1-jdk11-rockylinux9` | `sha256:0ff83aa74ff61d6fd43e52e993280a3f045f2cd2a3a94400184600c859b8b19b` |
| `10.1-jdk17-rockylinux9` | `sha256:ef6c4dcbc094140c113e70a866a6e1291b1392f5b72f257d661d53c3f936a232` |
| `10.1-jdk21-rockylinux9` | `sha256:96472827851dc8cbc558ee8be2d4704de354bbceb670ad0cf8879da6784c4016` |
| `10.1-jdk25-rockylinux9` | `sha256:7cf7772627acffb2ad2e9eafd94d75950ab3cf6c1bf2080a79e339cc88c9bb9e` |
| `10.1-jdk11-alpine3.24` | `sha256:0490ae63b578659bb78819520d03b2fa4fb80073bae37856d99634add3d809e8` |
| `10.1-jdk17-alpine3.24` | `sha256:f19b730706f38440659f89872b166245424cd2247dad57e6874f496abdac39e7` |
| `10.1-jdk21-alpine3.24` | `sha256:79e0ca2c8db1bc69afcb1805ef25f5d4f1777de7511d7d64b017f3671cc3a492` |
| `10.1-jdk25-alpine3.24` | `sha256:a1fb6a71b94ad9ef3479f6be7f5e26e0c1ca8ec174ed5e8e9647ba4dc833a74f` |

Tomcat 9.0 已发布短标签：

| Tag | Digest |
|---|---|
| `9.0-jdk8-centos9-stream` | `sha256:9d6738c4bc8c607b37836ceffd2f99dcda607511b79fd91c9c660e3631df46df` |
| `9.0-jdk11-centos9-stream` | `sha256:fe594b45376cdf39ce89f1c1876e63c606ad90680b9b19bdd2e1af73f088a8e3` |
| `9.0-jdk17-centos9-stream` | `sha256:a12eca7a0cb4427e4b5adc49603718bbe4e400c1719012303ba019884b9d224e` |
| `9.0-jdk21-centos9-stream` | `sha256:119e27eb6098e211c43dd4aa26d5c098314ec83db9b19a2b5d896147f0b26a4f` |
| `9.0-jdk25-centos9-stream` | `sha256:dbce2b6059b87c682e40731a188f368da0789dc3422ec43de3c2e70dbe1f9883` |
| `9.0-jdk8-rockylinux9` | `sha256:2e3eaad6d7b95a64c0ed3cfa0bcca17ec095b2d15c48937b0ff6d3ccbc1c9cd1` |
| `9.0-jdk11-rockylinux9` | `sha256:f2c5bbe7e8b326a2b3c9b25445128ab695cdc40e9980ac986e42a79bde405375` |
| `9.0-jdk17-rockylinux9` | `sha256:d3f41b255c0c525aa8c9ae6abcbde16420b358c6619a58f67d5f3b610cc1e820` |
| `9.0-jdk21-rockylinux9` | `sha256:eece7b7cc891adbeb979eaf4985c2534593aee35be6b01f03e66f6e6f59d8dea` |
| `9.0-jdk25-rockylinux9` | `sha256:a8d243c0bca4b7dc69c7bf3ace31a6ce696170e9019ca3f1d25fb4a70cb4bd19` |
| `9.0-jdk8-alpine3.24` | `sha256:7509a967f3474fa3ad6c221cb63903ad88cee4cf117f927639e5800932ec821e` |
| `9.0-jdk11-alpine3.24` | `sha256:e3c3d82fa42c512edcec54ccb299cc9eab07791fc5fda7da90d140c17caa45f6` |
| `9.0-jdk17-alpine3.24` | `sha256:6e6ee68223016114f354fb37ad0321ac08ab5165b8fe7499f2243a378434ea9f` |
| `9.0-jdk21-alpine3.24` | `sha256:25eed71a9e36cd092ac41ab66029e3493eb930a4a55016504a4b8a89cd3e03a0` |
| `9.0-jdk25-alpine3.24` | `sha256:8b1bc4ad6dcc49a97ec5caba0a6c9bda54053141de2fb8ad5c956c5b02ac4944` |

## Notes

- 文档命令默认在 root 环境执行，不加 `sudo`。
- DockerHub 登录必须使用 token 和 `--password-stdin`，不在文档、脚本或日志中输出密码。
- 如果某个 Tomcat/JDK/基础系统组合在 `arm64` 缺少上游产物，不静默降级为 `amd64`。
- Alpine 变体继承 `benyoo/jdk` 的 glibc 兼容策略，Tomcat 项目不重复处理 Oracle JDK 动态库兼容问题。
