# 🐧 Linux 常用命令速查表 (安装与权限篇)

本项目用于记录在 Linux (X86_64 / ARM) 服务器上进行软件安装、脚本部署及权限管理时最常用的核心命令，方便日常维护与复制使用。

---

## 🔑 一、 权限管理 (Permission Control)
在执行下载的 `.sh` 脚本或配置系统文件时，权限是第一道关卡。
### 1. 赋予执行权限
刚下载的脚本默认没有执行权限，需要手动赋予：
```bash
chmod +x script.sh
```

### 2. 提升为 Root 权限 (切换用户)
某些机器默认是普通用户（如 azureuser, ubuntu），需要切换到最高权限：
```bash
sudo -i
sudo ./script.sh
```

### 3. 修改文件最高安全权限
例如配置 swapfile 或 SSH 私钥时，只允许文件所有者读写（防止被系统拒绝）：
```bash
chmod 600 /swapfile
```

## 🌐 二、 软件下载与安装 (Download & Install)
最常用的下载命令。-N 参数表示如果本地有同名文件且服务器未更新，则不重复下载：
```bash
wget -N [https://example.com/script.sh](https://example.com/script.sh)
```

## 📦 三、 Docker 与 Compose 运维
### 1. 查看容器运行状态与内存占用
```bash
docker stats
```
### 2. Docker Compose 核心控制 必须在包含 docker-compose.yml 的目录下执行
```bash
# 1. 后台启动并重建（修改配置、限制内存后用这个）
docker compose up -d
# 2. 停止并彻底删除容器、网络（彻底重构时用）
docker compose down
# 3. 查看当前 compose 组下的容器日志
docker compose logs -f
```
## 🛠️ 四、 系统状态检查
### 1. 查看实时内存与 Swap 状态
```bash
free -h
```

