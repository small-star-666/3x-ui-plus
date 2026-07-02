# WireProxy (WARP) 极简一键部署指南

本项目用于在 Linux (X86_64) 服务器上快速静默安装 `wireproxy`，并在本地 `40000` 端口拉起一个全局 WARP 的 Socks5 代理，配合 3x-ui 或 Xray 实现特定域名的隐私洗白。

---

## 🚀 安装 （请用root用户运行 sudo -i）

1. wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh
2. 选择2 简体中文
3. 选择12 安装 wireproxy，让 WARP 在本地创建一个 socks5 代理 (bash menu.sh w)

```bash
