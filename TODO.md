# DSTW-Docker-Tomcat TODO

## 当前批次：Alpine 优先（2026-10-24）

- [x] 本批配置仅启用 Alpine 3.24；CentOS Stream 和 Rocky Linux 留待后续补齐。
- [x] JDK 8 / 11 / 17 / 21 / 25 均引用用户指定的完整版本日期标签，公开查询已确认五个标签及双架构元数据。
- [x] 维护矩阵缩为 12 个 Alpine target，历史兼容配置缩为 1 个 Alpine target，共 13 个组合。
- [x] 远程完成 13 个 Alpine 组合、26 个平台结果的构建及运行验收，包含版本、架构、证书信任、正常 HTTPS 和最小 JSP；arm64 为 QEMU 模拟。
- [x] 复核 OCI 归档哈希，清理本任务构建器、容器、临时镜像标签、认证配置及基础镜像副本，保留有效产物和证据。
- [ ] 真实业务 WAR、自定义 truststore 和业务接口验收（未提供业务包）。
- [x] 按低到高发布 13 组合、52 版本标签，最后更新 latest；全部 53 标签及双架构 digest 核验通过。
- [x] 同步线上概览并读回，核对其他 145 个历史标签未被改动。
- [ ] 生产部署（本轮不涉及）。

详细结果见[本批构建验收报告](docs/Alpine版Tomcat多架构构建验收报告-20261024211645-20261024211645.md)。

发布详情见[发布与标签核验报告](docs/Alpine版Tomcat发布与标签核验报告-20261024213303-20261024213303.md)。

以下保留此前决策与阶段检查记录；涉及旧的三系统矩阵或 JDK 待发布状态时，以本节及 `docs/TAGS.md` 当前批次说明为准。

## 0. 决策确认

- [x] 明确项目目标：基于 `benyoo/jdk` 创建 Tomcat 镜像工程。
- [x] 明确 JDK 策略：继承 `DSTW-Docker-JDK`，只使用 Oracle JDK 基础镜像。
- [x] 明确系统矩阵：CentOS Stream 9 / Rocky Linux 9 / Alpine 3.24。
- [x] 明确架构矩阵：`linux/amd64` / `linux/arm64`。
- [x] 明确首批 Tomcat 分支：`9.0` / `10.1` / `11.0`。
- [x] 明确不纳入维护矩阵的分支：Tomcat 8.5 / 10.0 / 7 / 8.0；8.5.100 后续按明确需求增加独立历史兼容配置。
- [x] 确认覆盖所有兼容 JDK 组合。
- [x] 确认 DockerHub 镜像名固定为 `benyoo/tomcat`。

## 0.1 2026-10-24：Tomcat 8.5.100 历史兼容配置

- [x] 增加独立 `docker-bake.legacy.hcl`，仅 JDK 8，三个系统变体，声明双架构。
- [x] 固定 JDK 8u511-b32 安全维护批次及 digest，固定 Tomcat 8.5.100 和 Apache 归档下载来源。
- [x] 标注上游停止维护状态，保留现有维护分支默认矩阵。
- [x] 脚本语法、归档地址、版本限制、Bake 参数及原矩阵回归检查通过；Apache 归档包实际下载与 SHA-512 校验通过。
- [x] 远程双架构构建、证书检查及 HTTPS 探针运行验收；业务 WAR 仍见当前批次待办。
- [x] 发布并核验 Docker Hub 标签及仓库概览。

## 1. 文档落地

### 2026-10-24：四条版本线候选配置更新

- [x] 维护分支候选版本更新至 9.0.123 / 10.1.61 / 11.0.27，历史兼容分支固定 8.5.100。
- [x] JDK 映射更新为 8u511-b32 / 11.0.33.0.2 / 17.0.21.0.2 / 21.0.13.0.2 / 25.0.5.0.2，并引用固定版本日期基镜像。
- [x] 生成器与 Makefile 默认按北京时间生成构建日期，文档发布顺序改为低版本到高版本。
- [x] 四个 Shell 脚本语法检查通过；36 个维护 target 与 3 个兼容 target 的 Bake 解析、版本、平台、标签唯一性检查通过；默认样板配置一致。
- [x] 增加 `make prepare`：新批次重新解析维护分支最新正式版，全部发现成功后原子更新矩阵；8.5.100 保持固定，不执行镜像构建或上传。
- [x] 实测 `make prepare` 成功；模拟新增正式版本可刷新、RC 和跨分支版本被排除，网络失败和无有效版本时停止且原配置哈希保持不变。
- [x] JDK 11 / 17 / 21 / 25 新批次基镜像公开可用；本批继承镜像双架构和证书信任验收通过。
- [x] Tomcat 四条线 Alpine 远程构建、探针验收、发布及线上概览同步。

以下为原有工程文档清单：

- [x] 创建项目主文档 `README.md`。
- [x] 创建项目开发规划 `docs/PROJECT_PLAN.md`。
- [x] 创建执行清单 `TODO.md`。
- [x] 增加完整 tag 列表文档。
- [x] 增加发布 runbook。
- [x] 增加版本升级 runbook。
- [x] 增加 Tomcat 9.0 到 9.1 迁移跟踪说明。
- [x] 增加 DockerHub Repository overview 源文档。

## 2. 基础工程文件

- [x] 创建 `Dockerfile`。
- [x] 创建 `docker-bake.hcl`。
- [x] 创建 `Makefile`。
- [x] 创建 `compose.yaml`。
- [x] 创建 `examples/webapp/compose.yaml`。
- [x] 创建 `scripts/install-tomcat.sh`。
- [x] 创建 `scripts/docker-entrypoint.sh`。
- [x] 创建 `scripts/generate-bake.sh`。
- [x] 创建 `scripts/verify-tomcat.sh`。
- [x] 创建 `.dockerignore`。

## 3. Tomcat 版本解析

- [x] 支持手工指定完整版本，例如 `11.0.23`。
- [x] 支持按分支解析最新 patch，例如 `TOMCAT_MAJOR=11`。
- [x] 支持 Apache 官方下载 URL 生成。
- [x] 支持 sha512 校验。
- [x] 下载失败时明确报错，不静默换源。
- [x] 记录实际安装版本到镜像 label。
- [x] 输出实际解析后的 `TOMCAT_VERSION` 环境变量。

## 4. Dockerfile

- [x] 使用 `ARG BASE_IMAGE` 继承 `benyoo/jdk`。
- [x] 使用 `ARG TOMCAT_MAJOR`。
- [x] 使用 `ARG TOMCAT_VERSION`。
- [x] 安装 Tomcat 到 `/opt/tomcat`。
- [x] 创建 `/usr/local/tomcat` 软链。
- [x] 设置 `CATALINA_HOME=/opt/tomcat`。
- [x] 设置 `CATALINA_BASE=/opt/tomcat`。
- [x] 暴露 `8080`。
- [x] 默认命令为 `catalina.sh run`。
- [x] 保留 `catalina.sh version` 构建期验证。
- [x] 保留 `java -version` 构建期验证。

## 5. Entrypoint

- [x] 支持 `TIMEZONE` 设置并导出 `TZ`。
- [x] 支持 `CATALINA_OPTS`。
- [x] 支持 `JAVA_OPTS`。
- [x] 支持 `APP_WAR` 挂载部署。
- [x] 支持空参数时默认执行 `catalina.sh run`。
- [x] 支持用户传入自定义命令。
- [x] 不覆盖用户挂载的 `webapps` 内容。

## 6. Buildx Bake

- [x] 生成 Tomcat 9.0 + JDK 8/11/17/21/25 + 3 OS target。
- [x] 生成 Tomcat 10.1 + JDK 11/17/21/25 + 3 OS target。
- [x] 生成 Tomcat 11.0 + JDK 17/21/25 + 3 OS target。
- [x] 默认平台为 `linux/amd64,linux/arm64`。
- [x] 生成短标签。
- [x] 生成完整版本标签。
- [x] 生成日期标签。
- [x] `docker buildx bake --print` 输出可读。
- [x] 不生成 Tomcat/JDK 不兼容组合。

## 7. 本地非发布验证

- [x] `bash -n scripts/install-tomcat.sh`。
- [x] `bash -n scripts/docker-entrypoint.sh`。
- [x] `bash -n scripts/generate-bake.sh`。
- [x] `bash -n scripts/verify-tomcat.sh`。
- [x] `docker buildx bake -f docker-bake.generated.hcl --print`。
- [ ] 本地单架构测试构建一个 amd64 镜像。
- [ ] 本地运行 `catalina.sh version`。
- [ ] 本地运行 HTTP 访问测试。

说明：本地单架构测试只用于功能验证，不代表最终多架构镜像已完成。

## 8. 远程构建准备

- [x] 确认远程构建节点 SSH key 可用。
- [x] 连接远程构建节点。
- [x] 检查远程系统信息。
- [x] 检查 Docker 版本。
- [x] 检查 Buildx 版本。
- [x] 检查可用磁盘。
- [x] 准备 `/data/DSTW-Docker-Tomcat` 工作目录。
- [x] 同步项目文件到远程构建目录。

远程检查命令：

```bash
ssh -i "$DSTW_SSH_KEY_PATH" \
  -p 22992 \
  -o IdentitiesOnly=yes \
  -o BatchMode=yes \
  root@158.69.107.254 \
  'hostname && uname -a && nproc && df -h /data && docker version && docker buildx version'
```

## 9. 远程多架构构建

- [x] 在远程节点执行 `docker buildx ls`。
- [x] 必要时初始化 Buildx builder。
- [x] 执行 `docker buildx bake -f docker-bake.generated.hcl --print`。
- [x] 远程单架构 smoke build：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] 远程单 target 多架构 OCI 构建：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] 分组构建 Tomcat 11.0 target。
- [x] 分组构建 Tomcat 10.1 target。
- [x] 分组构建 Tomcat 9.0 target。
- [x] 构建失败时保留远程工作区和日志。
- [x] 不在 arm64 失败时降级为 amd64。

## 10. DockerHub 发布

- [x] 确认 `DOCKERHUB_USERNAME` 已设置。
- [x] 确认 `DOCKERHUB_TOKEN` 已设置但不打印内容。
- [x] 使用 `--password-stdin` 登录 DockerHub。
- [x] 单 target 样板 push：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] 单 target 样板 manifest 验证：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] Tomcat 11.0 组 push。
- [x] Tomcat 11.0 组 9 个短标签 manifest 验证。
- [x] Tomcat 10.1 组 push。
- [x] Tomcat 10.1 组 12 个短标签 manifest 验证。
- [x] Tomcat 9.0 组 push。
- [x] Tomcat 9.0 组 15 个短标签 manifest 验证。
- [x] 全矩阵 36 target 已按 `11.0` / `10.1` / `9.0` 分组执行 `--push`。
- [x] 每个 Tomcat 分支至少抽查一个 manifest。
- [ ] 发布失败时保留构建产物和工作区。
- [ ] 认证失败时停止发布，不回滚、不清理、不切换账号。

## 11. 发布后验证

- [x] 远程 smoke 验证 `benyoo/tomcat:11.0-jdk17-rockylinux9-test` 启动和 HTTP 响应。
- [x] 远程 OCI index 验证包含 `linux/amd64` 和 `linux/arm64`。
- [x] `docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-rockylinux9`。
- [x] Tomcat 11.0 组 9 个短标签均包含 `linux/amd64` 和 `linux/arm64`。
- [x] `docker buildx imagetools inspect benyoo/tomcat:9.0-jdk8-rockylinux9`。
- [x] `docker buildx imagetools inspect benyoo/tomcat:10.1-jdk11-rockylinux9`。
- [x] 验证 Tomcat 9.0 HTTP 启动。
- [x] 验证 Tomcat 10.1 HTTP 启动。
- [x] 验证 Tomcat 11.0 HTTP 启动。
- [x] 验证 Alpine 变体可以正常启动。
- [x] 验证 CentOS Stream 9 变体可以正常启动。
- [x] 验证 Rocky Linux 9 变体可以正常启动。

## 12. 清理和收尾

- [x] 确认构建成功。
- [x] 确认镜像已推送。
- [x] 确认 manifest 验证通过。
- [x] 确认运行验证通过。
- [x] 确认没有认证失败阻塞。
- [x] 只清理当前任务临时文件。
- [x] 不清理 `/data` 根目录。
- [x] 不清理其他项目目录。
- [x] 汇报远程构建目录、构建结果、提交状态、上传状态、清理状态和残余风险。

## 13. 后续维护

- [ ] 定期检查 Apache Tomcat patch 更新。
- [ ] 定期检查 Tomcat 9.0 EOL 进度。
- [ ] Apache 发布 Tomcat 9.1 后补入矩阵。
- [ ] 同步 `DSTW-Docker-JDK` 新 JDK patch 版本。
- [ ] 同步基础 OS 镜像日期标签。
- [x] 维护版本升级 runbook。
- [ ] 维护发布记录。

## 14. 当前 smoke 记录

- [x] 执行位置：远程构建节点 `/data/DSTW-Docker-Tomcat`。
- [x] 构建镜像：`benyoo/tomcat:11.0-jdk17-rockylinux9-test`。
- [x] 构建方式：`docker buildx build --platform linux/amd64 --load`。
- [x] Tomcat 版本：`11.0.23`。
- [x] JDK 版本：`Oracle JDK 17.0.19`。
- [x] 验证方式：`scripts/verify-tomcat.sh`，使用宿主机端口 `18180`。
- [x] 验证结果：`catalina.sh version` 正常，HTTP 访问通过。
- [x] 多架构 OCI 构建：已执行。
- [x] 多架构 DockerHub 发布：已执行单 target 样板。
- [x] DockerHub 推送：已执行单 target 样板。

## 15. 当前多架构验证记录

- [x] 执行位置：远程构建节点 `/data/DSTW-Docker-Tomcat`。
- [x] 构建目标：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] 构建方式：`docker buildx build --platform linux/amd64,linux/arm64 --output type=oci`。
- [x] 产物路径：`/data/DSTW-Docker-Tomcat/out/tomcat-11.0-jdk17-rockylinux9.oci.tar`。
- [x] 产物大小：约 `555M`。
- [x] OCI 平台：`linux/amd64`、`linux/arm64`。
- [x] amd64 运行验证：`scripts/verify-tomcat.sh` 使用宿主机端口 `18181` 通过。
- [x] 镜像 label 验证：Tomcat `11.0.23`、JDK `17.0.19`、构建日期 `20260626`、基础镜像 `benyoo/jdk:17-rockylinux9`。
- [x] DockerHub manifest 验证：`linux/amd64`、`linux/arm64`。

## 16. 当前 DockerHub 样板发布记录

- [x] 镜像：`benyoo/tomcat`。
- [x] 发布目标：`Tomcat 11.0 + JDK 17 + RockyLinux 9`。
- [x] 发布 tag：`11.0-jdk17-rockylinux9`。
- [x] 发布 tag：`11.0.23-jdk17.0.19-rockylinux9`。
- [x] 发布 tag：`11.0-jdk17-rockylinux9-20260626`。
- [x] 发布 tag：`11.0.23-jdk17.0.19-rockylinux9-20260626`。
- [x] DockerHub digest：`sha256:68322d0047496639f13768f7ebe7d7ed6bd4a4966962f704d727a9b55461448a`。
- [x] manifest 平台：`linux/amd64`、`linux/arm64`。
- [x] 拉取验证：远程节点重新 `docker pull benyoo/tomcat:11.0-jdk17-rockylinux9`。
- [x] 运行验证：`scripts/verify-tomcat.sh` 使用宿主机端口 `18182` 通过。
- [x] label 验证：Tomcat `11.0.23`、JDK `17.0.19`、构建日期 `20260626`、基础镜像 `benyoo/jdk:17-rockylinux9`。
- [x] 全矩阵发布：已按 `11.0` / `10.1` / `9.0` 分组执行完成。

## 17. 当前 Tomcat 11.0 分组发布记录

- [x] 执行位置：远程构建节点 `/data/DSTW-Docker-Tomcat`。
- [x] 发布范围：Tomcat `11.0`，JDK `17 / 21 / 25`，CentOS Stream 9 / Rocky Linux 9 / Alpine 3.24。
- [x] target 数量：9。
- [x] 每个 target 平台：`linux/amd64`、`linux/arm64`。
- [x] 每个 target tag：短标签、完整版本标签、日期标签、完整日期标签。
- [x] manifest 验证：9 个短标签均包含 `linux/amd64` 和 `linux/arm64`。
- [x] Rocky 运行验证：`benyoo/tomcat:11.0-jdk17-rockylinux9`，宿主机端口 `18183`。
- [x] CentOS Stream 运行验证：`benyoo/tomcat:11.0-jdk17-centos9-stream`，宿主机端口 `18184`。
- [x] Alpine 运行验证：`benyoo/tomcat:11.0-jdk17-alpine3.24`，宿主机端口 `18185`。
- [x] Tomcat 10.1 分组发布。
- [x] Tomcat 9.0 分组发布。

## 18. 当前 Tomcat 10.1 分组发布记录

- [x] 执行位置：远程构建节点 `/data/DSTW-Docker-Tomcat`。
- [x] 发布范围：Tomcat `10.1`，JDK `11 / 17 / 21 / 25`，CentOS Stream 9 / Rocky Linux 9 / Alpine 3.24。
- [x] target 数量：12。
- [x] 每个 target 平台：`linux/amd64`、`linux/arm64`。
- [x] 每个 target tag：短标签、完整版本标签、日期标签、完整日期标签。
- [x] manifest 验证：12 个短标签均包含 `linux/amd64` 和 `linux/arm64`。
- [x] Rocky 运行验证：`benyoo/tomcat:10.1-jdk11-rockylinux9`，宿主机端口 `18186`。

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

## 19. 当前 Tomcat 9.0 分组发布记录

- [x] 执行位置：远程构建节点 `/data/DSTW-Docker-Tomcat`。
- [x] 发布范围：Tomcat `9.0`，JDK `8 / 11 / 17 / 21 / 25`，CentOS Stream 9 / Rocky Linux 9 / Alpine 3.24。
- [x] target 数量：15。
- [x] 每个 target 平台：`linux/amd64`、`linux/arm64`。
- [x] 每个 target tag：短标签、完整版本标签、日期标签、完整日期标签。
- [x] manifest 验证：15 个短标签均包含 `linux/amd64` 和 `linux/arm64`。
- [x] Rocky 运行验证：`benyoo/tomcat:9.0-jdk8-rockylinux9`，宿主机端口 `18187`。

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

## 20. 当前收尾记录

- [x] 版本升级 runbook 已落地：`docs/VERSION_UPGRADE_RUNBOOK.md`。
- [x] Tomcat 9.0 到 9.1 迁移跟踪已落地：`docs/TOMCAT_9_TO_9_1_TRACKING.md`。
- [x] DockerHub Repository overview 源文档已落地：`dockerhub-repository-overview.md`。
- [x] DockerHub Repository overview 已同步到 `benyoo/tomcat`。
- [x] 远程临时文件已按当前项目范围清理。
- [x] 最终交付报告已输出。

## 21. Alpine 主版本调整

- [x] `Dockerfile` 默认基础镜像调整为 `benyoo/jdk:17-alpine3.24`。
- [x] `docker-bake.hcl` 默认样板 target 调整为 `tomcat11-alpine3-24-jdk17`。
- [x] `scripts/generate-bake.sh` 基础系统生成顺序调整为 Alpine 优先。
- [x] `scripts/verify-tomcat.sh` 默认验证镜像调整为 `benyoo/tomcat:11.0-jdk17-alpine3.24`。
- [x] README、Runbook、标签文档和 Compose 示例调整为 Alpine 优先。
- [x] DockerHub Repository overview 源文档调整为 Alpine 优先。
- [ ] DockerHub Repository overview 已同步线上仓库。
