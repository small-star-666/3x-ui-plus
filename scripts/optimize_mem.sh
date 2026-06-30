#!/bin/bash

# 确保脚本以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 权限或 sudo 运行此脚本！"
  exit 1
fi

echo "=========================================="
echo "      开始进行 500MB 级别小内存极限优化     "
echo "=========================================="

# 1. 创建并启用 1GB Swap (虚拟内存)
if [ -f /swapfile ]; then
    echo "[*] 检测到已存在 /swapfile，跳过创建..."
else
    echo "[+] 正在创建 1GB 虚拟内存 (Swap)..."
    # 使用 dd 保证在所有文件系统（如 Btrfs）上都能较好兼容
    dd if=/dev/zero of=/swapfile bs=1M count=1024 status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    # 写入开机自启
    if ! grep -q "/swapfile" /etc/fstab; then
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
    echo "[✓] Swap 创建并启用成功！"
fi

# 2. 优化系统内核参数 (Sysctl)
echo "[+] 正在优化内核内存管理参数..."
SYSCTL_CONF="/etc/sysctl.conf"

# 备份原配置
cp $SYSCTL_CONF "${SYSCTL_CONF}.bak"

# 移除可能存在的旧配置，防止重复
sed -i '/vm.swappiness/d' $SYSCTL_CONF
sed -i '/vm.vfs_cache_pressure/d' $SYSCTL_CONF
sed -i '/vm.overcommit_memory/d' $SYSCTL_CONF

# 写入极限优化参数
cat << EOF >> $SYSCTL_CONF
# 激进使用 Swap，物理内存稍微紧张就将后台静默进程移到虚拟内存
vm.swappiness=80
# 倾向于更迅速地回收目录项和索引节点缓存（释放 buff/cache）
vm.vfs_cache_pressure=500
# 允许适度超发内存，防止因为严格检查导致进程直接被杀
vm.overcommit_memory=1
EOF

# 使配置立刻生效
sysctl -p
echo "[✓] 内核参数优化成功！"

# 3. 释放当前的临时内存缓存 (buff/cache)
echo "[+] 正在清理当前系统缓存..."
sync && echo 3 > /proc/sys/vm/drop_caches
echo "[✓] 缓存清理完毕！"

# 4. 针对 x-ui 的 Go 语言内存极限榨干 (GOGC & GOMEMLIMIT)
# 检查是否存在 x-ui 的 systemd 服务文件
XUI_SERVICE="/etc/systemd/system/x-ui.service"
if [ -f "$XUI_SERVICE" ]; then
    echo "[+] 检测到 x-ui 服务，正在注入 Go 内存限制环境变量..."
    
    # 移除可能存在的旧配置
    sed -i '/Environment="GOGC=/d' $XUI_SERVICE
    sed -i '/Environment="GOMEMLIMIT=/d' $XUI_SERVICE
    
    # 在 [Service] 标签下方插入环境变量
    # GOGC=10: 极为激进的GC，内存增幅10%就触发垃圾回收（默认100）
    # GOMEMLIMIT=35MiB: 严格限制该 Go 进程的软内存上限在 35MB 左右
    sed -i '/\[Service\]/a Environment="GOGC=10"\nEnvironment="GOMEMLIMIT=35MiB"' $XUI_SERVICE
    
    # 重载并重启服务
    systemctl daemon-reload
    systemctl restart x-ui
    echo "[✓] x-ui 内存激进回收策略已生效！"
else
    echo "[*] 未检测到标准的 x-ui systemd 服务，略过此步。"
fi

echo "=========================================="
echo "    极限内存优化完成！请使用 top 查看效果    "
echo "=========================================="
