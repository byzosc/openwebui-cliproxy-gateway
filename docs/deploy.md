# 部署手册 / 故障排查 / 升级

## 0. 前置

- 一台**常开**的机器:NAS(Synology DSM / 群晖、QNAP)、Linux VPS、小主机皆可。
- **Docker** + **Docker Compose v2**(`docker compose` 命令)。
- 国内机器还需一个**能出国的代理节点**(给 mihomo 用);海外 VPS 通常不需要,可让 mihomo 规则全 DIRECT 或直接去掉 mihomo。
- 内存:Open WebUI 空载 ~1G,**4G 起步够**(不在本机跑本地大模型的前提下)。

## 1. 一次性部署

```bash
git clone <this-repo> && cd <this-repo>

cp .env.example .env
cp config/cliproxyapi/config.example.yaml config/cliproxyapi/config.yaml
cp config/mihomo/config.example.yaml      config/mihomo/config.yaml
```

逐个填:

1. **`.env`** —— 改 `CLIPROXY_API_KEY` / `CLIPROXY_MGMT_SECRET` 为强随机值;端口/域名按需。
2. **`config/cliproxyapi/config.yaml`** —— 把 `api-keys` 和 `secret-key` 填成与 `.env` 一致(此文件不读 .env,要手填)。
3. **`config/mihomo/config.yaml`** —— 把你自己的代理节点填进 `proxies` 或 `proxy-providers`,并加进 `PROXY` / `AUTO` 组。海外机器可跳过。

起服务、登录、验证:

```bash
./scripts/up.sh
# 浏览器开 http://<host>:8317/management.html → 输 mgmt 密钥 → OAuth 登录各家
#   (管理后台只认本地访问,远程见 docs/credentials.md 的 SSH 隧道法)
./scripts/status.sh        # 列出模型 = 通
# 浏览器开 http://<host>:3000 → 建管理员账号 → 多模型并排聊天
```

## 2. 公网入口(可选)

想出门也能用,用 **Cloudflare 隧道**(免备案、不暴露家宽 IP):

1. Cloudflare Zero Trust 后台建 Tunnel,拿到 token 填进 `.env` 的 `CLOUDFLARE_TUNNEL_TOKEN`。
2. 取消 `docker-compose.yml` 里 `cloudflared` 服务的注释。
3. 在隧道里配两条 public hostname:
   - `${WEBUI_HOSTNAME}` → `http://open-webui:8080`
   - (可选)`${API_HOSTNAME}` → `http://cliproxyapi:8317`
4. **安全**:给 Web 界面套 **Cloudflare Access**(邮箱白名单 = `.env` 的 `ACCESS_ALLOWED_EMAILS`);
   API 子域若要暴露,**只放行 `/v1*`,屏蔽 `/v0/management` 与 `/management.html`**,靠强 key 保护。

## 3. 系统级坑

### inotify 上限(高频:导致 CLIProxyAPI 反复崩)
CLIProxyAPI 靠 inotify 监视 `auths/` 热加载。宿主 inotify **实例上限默认偏低(常见 128)**,被占满会让容器崩。抬高它:

```bash
# 临时
sudo sysctl -w fs.inotify.max_user_instances=512
# 永久(Linux)
echo 'fs.inotify.max_user_instances=512' | sudo tee /etc/sysctl.d/90-inotify.conf
```

> **群晖 DSM**:`/etc/sysctl.d` 重启可能不持久。改用**控制面板 → 任务计划 → 开机任务(root)**,命令:
> `echo 512 > /proc/sys/fs/inotify/max_user_instances`,扛每晚重启。

## 4. 升级

```bash
docker compose --env-file .env pull
./scripts/up.sh            # up -d 会用新镜像重建
```
数据在挂载卷(`${DATA_ROOT}`),升级不丢会话历史 / 凭证。建议给镜像 pin 版本而非 `:latest`,以便回滚。

## 5. 故障排查

| 症状 | 可能原因 / 处置 |
|---|---|
| `status.sh` 报 `/v1/models` 不通 | 容器没起(`docker compose ps`)/ key 不一致(`.env` vs `config.yaml`)/ 还没 OAuth 登录任何一家 |
| 管理后台打不开 / 403 | `allow-remote: false` 下只认本地访问 → 用 SSH 隧道(见 credentials.md) |
| 模型能列出但调用报错、超时 | 出站没通:mihomo 节点没填 / 节点对 AI API 不可用 → 换节点;海外机器确认走 DIRECT |
| CLIProxyAPI 反复重启 | inotify 上限(见 §3)/ 看 `docker logs cliproxyapi` |
| Open WebUI 首屏很慢 | 正常,前端整包大 + 跨境。**装 PWA**(浏览器"安装"/手机"加到主屏")后近乎秒开 |
| 国内模型(DeepSeek/智谱/Kimi)反而不通 | 它们走代理被拦了 → 确认 mihomo 规则 `GEOIP,CN,DIRECT` 生效 |
| Gemini 登录后不可用 | 用 Antigravity OAuth,别用已下线的 gemini-cli 个人版 OAuth(见 credentials.md) |
