#!/bin/bash
[ "$EUID" -ne 0 ] && echo "请使用 sudo -i 切到 root 用户运行！" && exit 1

echo "=========================================="
echo "          WireProxy (WARP) 部署          "
echo "=========================================="
echo "[*] 提示：脚本即将自动执行以下非交互操作："
echo "    -> 选择 2 (简体中文)"
echo "    -> 选择 12 (安装 wireproxy，在本地 40000 端口拉起 Socks5)"
echo "=========================================="
echo "[+] 正在下载并运行官方静默安装..."
echo "--------------------------------------"

# 核心一行核心代码，带 'w' 参数实现全自动静默安装
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh w