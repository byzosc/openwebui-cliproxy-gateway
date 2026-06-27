#!/usr/bin/env bash
# 起：拉镜像(如需)并后台启动全部服务。
set -euo pipefail
cd "$(dirname "$0")/.."

[ -f .env ] || { echo "缺少 .env,先: cp .env.example .env 并填好"; exit 1; }
[ -f config/cliproxyapi/config.yaml ] || { echo "缺少 config/cliproxyapi/config.yaml,先从 .example 复制并填好"; exit 1; }
[ -f config/mihomo/config.yaml ] || { echo "缺少 config/mihomo/config.yaml,先从 .example 复制并填好节点"; exit 1; }

docker compose --env-file .env up -d "$@"
echo "已启动。用 ./scripts/status.sh 检查健康。"
