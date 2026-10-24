# 发布 Runbook

本文件记录发布流程；后续批次仍须单独取得发布授权。2026-10-24 本批已完成 13 个 Alpine Tomcat/JDK 组合的双架构构建、证书信任、正常 HTTPS 和最小 JSP 验收，arm64 为 QEMU 模拟，详见[构建报告](Alpine版Tomcat多架构构建验收报告-20261024211645-20261024211645.md)。本批 OCI 已保留，53 个标签已上传 Docker Hub 并核对双架构 digest，概览已更新并读回，详见[发布与标签核验报告](Alpine版Tomcat发布与标签核验报告-20261024213303-20261024213303.md)。后续发布应使用已验收产物并核对 digest。其他系统后续补齐，版本映射见 `docs/TAGS.md`。

## 已验收 OCI 的发布路径

本批发布直接使用构建报告登记的 OCI 归档，不执行 `make prepare` 或重新构建。先验证归档 SHA-256，在支持多平台载入的 containerd image store 中执行 `docker load`，确认源镜像 `docker image inspect` 的 `.Descriptor.digest` 与原验收 index 一致。然后按低到高逐组合 `docker tag`、`docker push`；每个标签读回 root index 及 amd64、arm64 manifest digest，匹配才继续。

每组精确版本日期标签 → 精确版本标签 → 分支日期标签 → 分支别名。52 个标签全部完成后，独立将默认组合推至 `latest` 并核对，最后更新概览并读回正文。任一步失败即停止，保留已发布状态和原始归档；不以重新构建替代发布。以下准备和构建章节仅用于新批次。

## 1. 前置检查

```bash
export DSTW_SSH_KEY_PATH="$HOME/2026-Work/RSA/LookBack_ed25519_20260821000056"

make prepare
make remote-check
```

检查点：

- 本地脚本语法通过。
- Bake 文件能生成。
- 远程构建节点可连接。
- 远程 Docker 和 Buildx 可用。
- `/data` 空间足够。

拉取基础镜像前按需完成第 4 节的 Docker Hub 认证。未登录可能触发 `429 Too Many Requests`；先解决认证或限流原因，不反复重跑构建。认证配置使用本任务独立的 `DOCKER_CONFIG`，限制目录权限并在任务收尾时清除，不覆盖共享登录配置。登录仅用于拉取时，不代表获得镜像推送授权。

## 2. 同步到远程构建节点

```bash
export DSTW_SSH_KEY_PATH="$HOME/2026-Work/RSA/LookBack_ed25519_20260821000056"

make remote-sync
```

远程目录：

```text
/data/DSTW-Docker-Tomcat
```

## 3. 单 target 多架构验证

先验证一个目标，不直接全矩阵发布。

```bash
cd /data/DSTW-Docker-Tomcat

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg BASE_IMAGE=benyoo/jdk:17.0.21.0.2-alpine3.24-20261024 \
  --build-arg TOMCAT_MAJOR=11.0 \
  --build-arg TOMCAT_VERSION=11.0.27 \
  --build-arg JDK_VERSION=17.0.21.0.2 \
  --build-arg BUILD_DATE=20261024 \
  -t benyoo/tomcat:11.0-jdk17-alpine3.24-multiarch-test \
  --output type=oci,dest=/data/DSTW-Docker-Tomcat/out/tomcat-11.0-jdk17-alpine3.24.oci.tar \
  .
```

验证 OCI index：

```bash
mkdir -p /data/DSTW-Docker-Tomcat/out/oci-check
tar -xf /data/DSTW-Docker-Tomcat/out/tomcat-11.0-jdk17-alpine3.24.oci.tar \
  -C /data/DSTW-Docker-Tomcat/out/oci-check
python3 - <<'PY'
import json
from pathlib import Path

root = Path("/data/DSTW-Docker-Tomcat/out/oci-check")
index = json.loads((root / "index.json").read_text())
platforms = []

for item in index.get("manifests", []):
    digest = item["digest"].split(":", 1)[1]
    nested = json.loads((root / "blobs" / "sha256" / digest).read_text())
    for manifest in nested.get("manifests", []):
        platform = manifest.get("platform", {})
        if platform:
            platforms.append(f"{platform.get('os')}/{platform.get('architecture')}")

platforms = sorted(set(platforms))
print("oci_platforms=" + ",".join(platforms))

if "linux/amd64" not in platforms or "linux/arm64" not in platforms:
    raise SystemExit("ERROR: OCI index missing linux/amd64 or linux/arm64")
PY
```

## 4. DockerHub 登录（需要时在构建拉取前完成）

认证信息必须通过环境变量传入，不在命令、日志或文档中写明文密码。

```bash
[ -n "$DOCKERHUB_USERNAME" ] && echo "DOCKERHUB_USERNAME is set" || echo "DOCKERHUB_USERNAME is missing"
[ -n "$DOCKERHUB_TOKEN" ] && echo "DOCKERHUB_TOKEN is set" || echo "DOCKERHUB_TOKEN is missing"

echo "$DOCKERHUB_TOKEN" | docker login \
  -u "$DOCKERHUB_USERNAME" \
  --password-stdin
```

## 5. 分组发布

```bash
cd /data/DSTW-Docker-Tomcat

docker buildx bake -f docker-bake.generated.hcl tomcat11-0-alpine3-24-jdk17 --push
```

全矩阵发布前按顺序分组：

```text
1. Tomcat 8.5（本批包含历史兼容配置时）
2. Tomcat 9.0
3. Tomcat 10.1
4. Tomcat 11.0
```

任何分组失败都停止，不降级为单架构。

每条线先发布并核验精确标签，再更新该线移动别名；仅在获授权时最后更新 `latest`，然后提交并读回 Repository overview。不得对默认全矩阵直接执行 `--push`。

## 6. 发布后验证

```bash
docker buildx imagetools inspect benyoo/tomcat:11.0-jdk17-alpine3.24

docker run -d \
  --name tomcat-release-test \
  -p 18180:8080 \
  benyoo/tomcat:11.0-jdk17-alpine3.24

curl -fsS http://127.0.0.1:18180/
docker exec tomcat-release-test catalina.sh version
docker rm -f tomcat-release-test
```

## 7. 认证失败处理

如果 DockerHub 登录或推送失败：

- 停止发布动作。
- 保留远程工作区。
- 保留已生成产物。
- 不回滚、不 reset、不切换账号；先保护有效产物、独有修改和最小诊断材料，再清理本任务确认无用的临时资源。
- 等待提供可用认证信息后继续。
