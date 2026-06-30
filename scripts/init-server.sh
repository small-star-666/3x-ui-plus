############ 优化网络配置 ############
# 1. 将 BBR 配置写入系统设置
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
# 2. 使配置生效
sudo sysctl -p
# 3. 验证是否开启成功
sudo sysctl net.ipv4.tcp_congestion_control