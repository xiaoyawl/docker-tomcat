IMAGE ?= benyoo/tomcat
BUILD_DATE ?= $(shell TZ=Asia/Shanghai date +%Y%m%d)
BAKE_FILE ?= docker-bake.generated.hcl
REMOTE_HOST ?= 158.69.107.254
REMOTE_PORT ?= 22992
REMOTE_USER ?= root
REMOTE_DIR ?= /data/DSTW-Docker-Tomcat

.PHONY: syntax bake bake-print prepare remote-check remote-sync

syntax:
	bash -n scripts/install-tomcat.sh
	bash -n scripts/docker-entrypoint.sh
	bash -n scripts/generate-bake.sh
	bash -n scripts/verify-tomcat.sh

bake:
	IMAGE="$(IMAGE)" BUILD_DATE="$(BUILD_DATE)" ./scripts/generate-bake.sh "$(BAKE_FILE)"

bake-print: bake
	docker buildx bake -f "$(BAKE_FILE)" --print

prepare: syntax
	$(MAKE) bake-print
	docker buildx bake -f docker-bake.legacy.hcl --print
	@echo "项目准备完成：三系统矩阵，维护分支已刷新并锁定正式版本，8.5 固定为 8.5.100；尚未构建、上传或部署"

remote-check:
	ssh -i "$${DSTW_SSH_KEY_PATH}" \
		-p "$(REMOTE_PORT)" \
		-o IdentitiesOnly=yes \
		-o BatchMode=yes \
		"$(REMOTE_USER)@$(REMOTE_HOST)" \
		'hostname && uname -a && nproc && df -h /data && docker version && docker buildx version && docker buildx ls'

remote-sync:
	ssh -i "$${DSTW_SSH_KEY_PATH}" \
		-p "$(REMOTE_PORT)" \
		-o IdentitiesOnly=yes \
		-o BatchMode=yes \
		"$(REMOTE_USER)@$(REMOTE_HOST)" \
		'mkdir -p "$(REMOTE_DIR)"'
	COPYFILE_DISABLE=1 tar \
		--exclude='./.agents' \
		--exclude='./.codex' \
		--exclude='./.git' \
		--exclude='./logs' \
		--exclude='./out' \
		--exclude='./AGENTS.md' \
		--exclude='./tmp' \
		-czf - . | ssh -i "$${DSTW_SSH_KEY_PATH}" \
		-p "$(REMOTE_PORT)" \
		-o IdentitiesOnly=yes \
		-o BatchMode=yes \
		"$(REMOTE_USER)@$(REMOTE_HOST)" \
		'cd "$(REMOTE_DIR)" && tar -xzf - && find . -name "._*" -type f -delete'
