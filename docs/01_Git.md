# 3x-ui-plus 项目部署指南

本指南将帮助你快速安装基础环境并拉取目标项目。

---

## 🛠️ 基础环境安装与项目拉取

请在你的服务器终端中依次执行以下命令：

```bash
# 更新并安装 Git
sudo apt update && sudo apt install git -y

# 拉取目标项目仓库
git clone https://github.com/small-star-666/3x-ui-plus.git

# 进入项目目录
cd 3x-ui-plus

# 切换到证书专用分支
git checkout cert

# 基础环境安装完成！请在 cert 文件夹中放入你的公钥 gegeda.crt 和私钥证书 gegeda.key
```


