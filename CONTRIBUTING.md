# 贡献指南 / Contributing

感谢你愿意投入时间。这个项目是**部署/运维套件**(脚本 + compose + 模板 + 文档),不重新发明上游组件,所以贡献多集中在"让别人更容易跑起来"。

Thanks for your time. This is a **deployment/ops kit** (scripts + compose + templates + docs) — it doesn't reinvent the upstream components, so contributions mostly focus on making it easier for others to run.

## 欢迎的贡献 / Welcome

- 🐛 **Bug**:某个环境跑不起来、脚本报错、文档步骤对不上。
- 📖 **文档**:更清楚的步骤、更多平台(群晖/威联通/各家 VPS)的部署注记、翻译。
- 🌐 **分流规则**:`config/mihomo/config.example.yaml` 里更完善的 AI 上游域名规则。
- 🧩 **示例**:更多 OpenAI 兼容客户端的接入示例。

## 提交流程 / How to

1. Fork → 新建分支。
2. 改动尽量小而聚焦;**绝不提交任何真实密钥 / 凭证 / 节点 / 域名**(`.env`、真实 `config.yaml`、`data/` 已在 `.gitignore`,请勿绕过)。
3. 改了脚本:确认是 **LF 行尾**(`.gitattributes` 已强制),且能在 Linux 跑。
4. 开 PR,说明动机和测试环境(OS / Docker 版本)。

## 提 Issue / Filing issues

请附:部署平台、`docker compose` 版本、相关日志(**记得先抹掉 key / 域名等敏感信息**)、复现步骤。

## 行为准则 / Conduct

友善、就事论事。这是个业余维护的小项目,响应可能不及时,见谅。
Be kind and constructive. This is a hobby project; responses may be slow.
