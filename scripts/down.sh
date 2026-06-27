#!/usr/bin/env bash
# 停：停止并移除容器(数据卷保留,不丢历史)。
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose --env-file .env down "$@"
echo "已停止。数据仍在 \${DATA_ROOT}(默认 ./data),不丢。"
