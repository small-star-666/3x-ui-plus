---

### 📄 文件 5：`05_System_BBR_Optimize.sh`
> **📌 功能：** 独立出来的 Linux 服务器内核网络优化模块，一键开启 Google BBR 拥塞控制算法，显著降低网络丢包延迟。

```bash
#!/bin/bash
# ====================================================================
# 5. Linux 内核网络优化（开启 Google BBR 拥塞控制）
# ====================================================================

echo "正在向系统内核配置 (sysctl.conf) 注入 FQ 队列与 BBR 拥塞控制算法..."
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf

echo "正在刷新内核参数使其立即生效..."
sudo sysctl -p

echo "===================================================="
echo "🔔 验证环节："
echo "当前系统的 TCP 拥塞控制算法已切换为："
sudo sysctl net.ipv4.tcp_congestion_control
echo "若上方输出包含 'bbr'，则说明网络加速优化大功告成！"
echo "===================================================="