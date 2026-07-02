#!/bin/bash
# 确保以 root 权限运行
[ "$EUID" -ne 0 ] && echo "请使用 sudo 运行！" && exit 1

echo "=== 开始 500MB 小内存极限优化 ==="

# 1. 创建并启用 1GB Swap
if [ ! -f /swapfile ]; then
    echo "[+] 创建 1GB Swap..."
    dd if=/dev/zero of=/swapfile bs=1M count=1024 status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# 2. 优化系统内核参数
echo "[+] 优化内核参数..."
cat << EOF >> /etc/sysctl.conf
vm.swappiness=80
vm.vfs_cache_pressure=500
vm.overcommit_memory=1
EOF
sysctl -p

# 3. 清理当前缓存
sync && echo 3 > /proc/sys/vm/drop_caches

echo "=== 优化完成！ ==="