#!/bin/bash
# ===================可选（用于内网穿透）==================================
# 3. LINUX 安装与部署 Cloudflare Tunnel 服务端
# ====================================================================

# ⚠️ 注意：执行此脚本前，请确保已在 Cloudflare Zero Trust 网页端完成以下配置：
#   - 主机名配置: 子域名填写 ssh / 域名选择你的域名 / 路径留空
#   - 服务配置: 类型选择 SSH / URL 填写 localhost:22
#   - 并在网页上获取到了专属于你的守护进程 Token

TOKEN="<你的_CLOUDFLARED_TOKEN_保密>"

if [ "$TOKEN" = "<你的_CLOUDFLARED_TOKEN_保密>" ]; then
    echo "❌ 错误：请先编辑此脚本，将 TOKEN 变量替换为你真实的 Cloudflare 令牌！"
    exit 1
fi

echo "开始配置 Cloudflare 官方 GPG 密钥..."
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

echo "添加 cloudflared 官方 APT 软件源..."
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

echo "正在安装 cloudflared 客户端..."
sudo apt-get update && sudo apt-get install cloudflared -y

echo "将隧道注册为 Linux 系统级服务，实现开机盲自启..."
sudo cloudflared service install "$TOKEN"

echo "Cloudflare Tunnel 服务端部署完毕！请前往 CF 网页端查看运行状态是否亮绿灯。"