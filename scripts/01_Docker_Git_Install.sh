#!/bin/bash
# ====================================================================
# 1. 安装 Docker 容器引擎
# ====================================================================
echo "正在更新系统软件包并安装依赖..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "配置 Docker 官方安全密钥与软件源..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 注意：此处针对基于 Debian/Ubuntu 系统的 Docker 源配置
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "开始安装 Docker 全家桶..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "启动 Docker 并设置开机自启..."
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

# ====================================================================
# 2. 安装 Git 并拉取目标项目
# ====================================================================
echo "开始安装 Git 并克隆 3x-ui-plus 仓库..."
sudo apt install git -y
git clone https://github.com/small-star-666/3x-ui-plus.git

echo "切换至指定 cert 分支..."
cd 3x-ui-plus || exit
git checkout cert

echo "基础环境安装完成！请在 cert 文件夹中放入你的公钥和私钥证书。"