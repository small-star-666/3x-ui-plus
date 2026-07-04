#!/bin/bash
# ====================================================================
# 1. 安装 Docker 容器引擎 (优化版)
# ====================================================================

# 确保以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 或 root 用户运行此脚本"
  exit 1
fi

set -e # 任何命令失败即退出

echo "正在更新系统软件包..."
apt-get update && apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "清理残留的 Docker 环境..."
apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "配置 Docker 官方安全密钥..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "配置软件源..."
# 动态获取系统代号并写入源文件
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "安装 Docker 全家桶..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "启动并设置开机自启..."
systemctl enable docker
systemctl start docker

echo "验证 Docker 安装状态..."
docker --version
systemctl status docker --no-pager