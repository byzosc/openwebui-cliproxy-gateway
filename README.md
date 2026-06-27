# Self-Hosted Private AI Gateway Kit

> 把你**订阅的** Claude / Codex(GPT)/ Gemini 等账号,变成一个**自托管、自用**的 OpenAI 兼容网关 + 多模型并排聊天前端。一份 `docker compose` 起全套。
>
> Turn your **own** Claude / Codex / Gemini subscriptions into a self-hosted,
> OpenAI-compatible gateway with a multi-model chat UI. One `docker compose` to run it all.

中文 ｜ [English below](#english)

---

## 这是什么

三个开源组件,被编排成一条闭环,**全部跑在你自己的机器上、用你自己的凭证**:

```
  浏览器 / 任意 OpenAI 兼容客户端
        │
        ▼
   Open WebUI ───────────────► CLIProxyAPI (:8317/v1)
   多模型并排前端                把订阅 OAuth 暴露成 /v1
        │                            │
        │                            ▼
        │                        mihomo  ──规则分流──► 国外 AI 上游
        │                        出站代理              (国内模型直连)
        ▼
   (可选) Cloudflare 隧道 → 公网入口 + 邮箱白名单
```

- **CLIProxyAPI**(模型来源):把 Claude / Codex / Gemini 的订阅登录态,统一成一个 OpenAI 兼容接口。
- **Open WebUI**(界面):多模型并排、合成单一答案(MoA)、数据全本地、手机 PWA。
- **mihomo**(网络):只让"调用国外 AI 那一跳"走代理,国内模型直连。
- **Cloudflare 隧道**(可选):给个公网地址,套邮箱白名单,出门也能用。

**它不是什么**:不是一个"用别人额度"的 API 中转站。它不含任何凭证;你接的是**你自己的订阅**。

---

## 快速开始

前置:一台常开的机器(NAS / VPS / 旁路由皆可)+ Docker + Docker Compose。

```bash
git clone https://github.com/<owner>/openwebui-cliproxy-gateway
cd openwebui-cliproxy-gateway

# 1) 配置
cp .env.example .env                                            # 改端口/密钥/域名
cp config/cliproxyapi/config.example.yaml config/cliproxyapi/config.yaml   # 填 key/mgmt 密钥
cp config/mihomo/config.example.yaml      config/mihomo/config.yaml        # 填你的代理节点

# 2) 起
./scripts/up.sh

# 3) 登录订阅(把 OAuth 登录态写进网关)
#    浏览器开 http://<host>:8317/management.html → 用 mgmt 密钥登录
#    → OAuth 登录 → 分别点 Claude / Codex / Gemini 登录

# 4) 验证
./scripts/status.sh         # 能列出模型 = OAuth 已通

# 5) 用
#    浏览器开 http://<host>:3000 建管理员账号,开始多模型并排聊天
```

起停:`./scripts/up.sh` · `./scripts/down.sh` · `./scripts/status.sh`

### 进一步

- 📕 [部署手册 / 故障排查 / 升级](docs/deploy.md) —— 前置、公网入口、系统级坑(inotify)、排错表
- 🔑 [凭证管理](docs/credentials.md) —— 怎么增 / 删 / 改订阅登录态,远程管理的安全做法

---

## ⚠️ 须知 / Disclaimer

- 用订阅凭证反代成 API,**可能违反相应服务商的使用条款**。本套件不规避任何条款;**凭证与账号风险由你自负**。请仅用于个人自托管、自用场景。
- 本套件**不内置任何凭证 / 节点 / 密钥**。所有密钥请自行生成强随机值,且**永不提交到 git**(`.env` 与真实 `config.yaml` 已在 `.gitignore`)。

---

## 许可

套件自有代码(脚本 / compose / 模板 / 文档)= **MIT**。
内嵌的三个组件各自许可,见 [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)(本套件不打包它们,运行时拉官方镜像)。

---

<a name="english"></a>

## English

**What it is.** Three open-source components orchestrated into one loop, all running
**on your own machine with your own credentials**: CLIProxyAPI (exposes your
Claude/Codex/Gemini subscription OAuth as an OpenAI-compatible `/v1`), Open WebUI
(multi-model side-by-side chat UI), and mihomo (routes only the overseas-AI hop
through a proxy). Optional Cloudflare tunnel for a public entry with an email allowlist.

**What it is not.** Not a "use-someone-else's-quota" API reseller. It ships **no
credentials** — you connect **your own** subscriptions.

**Quick start.** See the Chinese section above; commands are language-neutral.
`cp .env.example .env`, copy the two `config/*.example.yaml`, fill in your keys and
proxy nodes, then `./scripts/up.sh`. Log in to your subscriptions at
`http://<host>:8317/management.html`, verify with `./scripts/status.sh`, and open the
UI at `http://<host>:3000`.

**Disclaimer.** Proxying subscription credentials as an API may violate the
respective providers' Terms of Service. This kit circumvents no terms; **credential
and account risk is yours**. For personal, self-hosted use only.

**License.** Kit's own code is **MIT**. Bundled components keep their own licenses
(see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)); the kit pulls official images
rather than redistributing them.
