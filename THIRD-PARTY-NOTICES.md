# 第三方组件声明 / Third-Party Notices

本套件(脚本、`docker-compose.yml`、配置模板、文档)以 **MIT** 许可。
本套件**不打包、不分发**下列组件的源码或二进制 —— 它们由 `docker-compose` 在你的机器上从各自官方仓库 / 镜像源拉取。各组件版权与许可归其原作者,使用须遵守其各自条款。

This kit (scripts, compose file, config templates, docs) is licensed **MIT**.
It does **not** bundle or redistribute the components below — they are pulled from
their official images at deploy time. Each remains under its own license.

| 组件 | 许可证 | 来源 |
|---|---|---|
| Open WebUI | 改版 BSD-3(含品牌条款)/ modified BSD-3 with branding clause | https://github.com/open-webui/open-webui |
| CLIProxyAPI | MIT | https://github.com/router-for-me/CLIProxyAPI |
| mihomo (Clash Meta) | GPL-3.0 | https://github.com/MetaCubeX/mihomo |

## 重要合规提醒 / Compliance notes

- **Open WebUI 品牌**:本套件按原样使用 Open WebUI,**保留其品牌**。其许可证限制在超过一定用户规模时移除品牌 —— 本套件不移除,你自行部署时若要改动须自查其条款。
- **mihomo (GPL-3.0)**:本套件仅通过官方镜像调用,未修改其源码(属"纯聚合",不触发 copyleft 传染)。若你 fork 并修改 mihomo 再分发,你需按 GPL-3.0 开源你的修改。
- **CLIProxyAPI**:MIT,自由使用。
