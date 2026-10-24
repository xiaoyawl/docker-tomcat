# Tomcat 9.0 到 9.1 迁移跟踪

## 1. 当前结论

Apache 已公告 Tomcat `9.0.x` 支持将在 `2027-03-31` 结束。Tomcat `9.1.x` 用于承接 Java EE 8 / Servlet 4.0 业务，官方说明 9.1.x 分支会在 9.0.x 支持结束前后提供，并延续到 `2030-12-31`。

本项目当前处理策略：

- 继续发布 Tomcat `9.0` 镜像，满足现有 Java EE 8 业务。
- 保留 Tomcat `9.1` 作为迁移分支，不提前生成未发布分支的镜像。
- Apache 正式发布 9.1.x 下载页和发行包后，再补入矩阵。

参考：

- <https://tomcat.apache.org/tomcat-9.0.x-eos.html>
- <https://tomcat.apache.org/whichversion.html>

## 2. 关键日期

| 日期 | 事件 | 本项目动作 |
|---|---|---|
| `2026-02-11` | Apache 公告 Tomcat 9.0.x 支持结束计划 | 保留迁移 TODO |
| `2027-03-31` | Tomcat 9.0.x 支持结束 | 停止把 9.0 当作长期新增默认分支 |
| `2027-06-30` 后 | Tomcat 9.0.x 下载链接预计从镜像系统移除 | 需要依赖 archive 或切换到 9.1 |
| `2030-12-31` | Tomcat 9.1.x 支持计划结束 | 后续再规划 Java EE 8 业务替代方案 |

## 3. 技术差异跟踪

当前官方说明的迁移差异较小，但需要特别跟踪：

- Tomcat `9.1.x` 不再提供 APR/Native Connector。
- NIO + OpenSSL 和 NIO2 + OpenSSL 将通过 Tomcat Native 2.x 继续支持。
- 9.1.x 会继续承接 9.0.x 的安全修复、bug 修复和新功能回传模式。

## 4. 本项目改造点

Apache 正式发布 9.1.x 后，按以下最小改动补入：

1. `scripts/install-tomcat.sh`
   - 增加 `TOMCAT_MAJOR=9.1` 的解析。
   - 增加对应下载页 ID。
   - 保持 sha512 校验。

2. `scripts/generate-bake.sh`
   - 增加 `9.1|8 11 17 21 25`，前提是官方最低 Java 仍满足该矩阵。
   - 生成 `tomcat9-1-*` target。

3. `docs/TAGS.md`
   - 增加 `9.1` 标签示例。

4. `README.md`
   - 把 `9.1` 从预留状态改为纳入状态。
   - 明确 `9.0` 的维护边界。

5. `dockerhub-repository-overview.md`
   - 增加 `9.1` 使用说明。

## 5. 迁移验证

9.1 样板验证建议从最小组合开始：

```bash
docker buildx bake -f docker-bake.generated.hcl tomcat9-1-alpine3-24-jdk8 --push
docker buildx imagetools inspect benyoo/tomcat:9.1-jdk8-alpine3.24
IMAGE="benyoo/tomcat:9.1-jdk8-alpine3.24" PORT="18191" ./scripts/verify-tomcat.sh
```

验证通过后再分组发布：

```text
Tomcat 9.1
= JDK 8 / 11 / 17 / 21 / 25
× Alpine 3.24 / CentOS Stream 9 / Rocky Linux 9
= 15 target
```

## 6. 迁移前置条件

以下条件全部满足后再纳入 9.1：

- Apache 官方已发布 9.1.x 下载页和 tar.gz 包。
- `install-tomcat.sh --print-version` 可以解析 9.1 最新 patch。
- sha512 校验可以独立通过。
- `benyoo/jdk` 仍提供对应 JDK 和基础系统的 `linux/amd64`、`linux/arm64` manifest。
- 至少完成主推基础系统 `9.1-jdk8-alpine3.24` 的 HTTP 和 `catalina.sh version` 验证。

## 7. 当前状态

| 项目 | 状态 |
|---|---|
| Tomcat 9.0 发布 | 已完成 |
| Tomcat 9.0 EOL 跟踪 | 已建立 |
| Tomcat 9.1 镜像矩阵 | 待 Apache 正式发布后补入 |
| Tomcat 9.1 样板构建 | 未执行 |
| Tomcat 9.1 DockerHub 发布 | 未执行 |
