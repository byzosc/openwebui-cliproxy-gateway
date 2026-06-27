#!/usr/bin/env bash
# 查：容器状态 + 网关健康(能否列出模型 = OAuth 通)。
set -euo pipefail
cd "$(dirname "$0")/.."

# 读 .env 取端口和 key
set -a; [ -f .env ] && . ./.env; set +a
PORT="${CLIPROXY_PORT:-8317}"
KEY="${CLIPROXY_API_KEY:-}"

echo "== 容器状态 =="
docker compose --env-file .env ps

echo
echo "== 网关健康:GET /v1/models =="
if curl -fsS "http://localhost:${PORT}/v1/models" -H "Authorization: Bearer ${KEY}" >/tmp/aigw_models.json 2>/dev/null; then
  n=$(grep -o '"id"' /tmp/aigw_models.json | wc -l | tr -d ' ')
  echo "OK —— 列出 ${n} 个模型(OAuth 已通)。"
else
  echo "FAIL —— /v1/models 不通。检查:容器是否起、key 是否对、是否还没在管理后台登录任何一家 OAuth。"
  exit 1
fi
