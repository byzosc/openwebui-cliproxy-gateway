# 凭证管理:增 / 删 / 改订阅登录态

> 网关要能用,先得把你的订阅 OAuth 登录态写进 CLIProxyAPI 的 `auth-dir`(挂载在 `${DATA_ROOT}/cliproxyapi/auths`,每家一个 JSON)。本文讲怎么自助管理,不用 SSH 进容器手搓。

## 核心概念

- **登录态 = `auths/` 里的 JSON**,每个云厂商一个文件。加一家 = 产出一个新 JSON;删一家 = 删对应 JSON。
- CLIProxyAPI 自带 **Web 管理后台**(`/management.html`),点几下就能 OAuth 登录、删旧凭证。
- 配置里 `remote-management.allow-remote: false` **只锁管理后台**(`/v0/management`),不影响 `/v1` 对外可用。所以管理后台默认**只能从宿主机本地访问**,这是安全设计。
- 改动 `auths/` 后,CLIProxyAPI 靠 **inotify 自动热加载**,一般不用重启容器。

## 怎么打开管理后台(三选一)

`allow-remote: false` 下,管理页只认"本地访问"。按你的网络情况选:

### 方式 1 —— 宿主机本地浏览器(最简单)
在跑容器的那台机器上直接开:
```
http://localhost:8317/management.html
```
输入 `config.yaml` 里的 `secret-key`(= `.env` 的 `CLIPROXY_MGMT_SECRET`)。

### 方式 2 —— 远程但走 SSH 隧道(没有图形界面的服务器)
从你的电脑:
```bash
ssh -L 8317:localhost:8317 user@your-host
# 然后本机浏览器开 http://localhost:8317/management.html
```
隧道让"本地访问"成立,既能远程管又不打开公网管理口。

### 方式 3 —— 私网直连(有 Tailscale / WireGuard 等)
若你给宿主机配了私有网络,可把 `host` 设为私网可达地址、或在私网内访问宿主端口。**切勿**为了图方便把管理后台暴露到公网。

## 加 / 删 / 改

进管理后台后:
- **加一家**:`OAuth 登录` → 点对应厂商(Claude / Codex / Gemini)→ 跳转授权 → 回调写入 `auths/`。
  - OAuth 回调用到容器端口 `8085 / 1455 / 54545`(compose 已暴露),别占用。
- **删一家**:`认证文件` → 删对应 JSON。
- **改 / 换号**:先删旧 JSON,再重新 OAuth 登录。
- 改完**验证**:`./scripts/status.sh` 能列出对应 `claude-*` / `gpt-*` / `gemini-*` 模型即成功。

## 进阶:独立「登录站」实例(凭证目录在别的机器上时)

如果 `auths/` 在一台 NAS 上、但你想从另一台电脑管(例如 NAS 没图形界面),可在电脑上跑一个**临时的 CLIProxyAPI 实例**,把它的 `auth-dir` 指到 NAS 的 `auths/`(经 SMB / NFS 挂载),只用它的管理 UI,不对外服务。

注意两条:
1. **刷新竞争**:两个实例同时常驻、都自动刷新 token,临到期极小概率撞刷新刷坏凭证。→ **登录站按需开、改完即关**,不要 24h 跟主实例并跑。
2. **凭证落多一处**:登录站会把凭证读进那台电脑内存。绑 `127.0.0.1`、走私网,用完关掉。

## 各家现状提醒

- **Gemini**:用 **Antigravity OAuth** 或 AI Studio 的 `gemini-api-key`。老的 `gemini-cli` 个人版 OAuth 已被官方下线 + 封禁第三方代理用法,别再用。
- Claude / Codex(GPT):标准 OAuth 登录即可。
