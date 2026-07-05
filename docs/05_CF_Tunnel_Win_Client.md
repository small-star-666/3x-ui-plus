# 🎛️ Windows 客户端 SSH 隧道打通指南 (可选 - 用于内网穿透)

本指南介绍如何在 Windows 客户端配置 Cloudflare Tunnel 隧道，实现无需公网 IP 即可通过安全隧道直接 SSH 连接到你的内网服务器。

---

## 1. 💾 下载与安装本地控制程序

1. **下载程序**：点击 GitHub 官方链接下载最新 Windows 64 位版本：
   👉 [cloudflared-windows-amd64.exe](https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe)
2. **重命名**：将下载下来的文件重命名为短名称：**`cloudflared.exe`**。
3. **全局部署**：直接将该文件剪切，粘贴到本地电脑的 **`C:\Windows\`** 目录下。
   > **💡 优雅之处**：放入 `C:\Windows\` 目录后，无需手动繁琐地去配置系统环境变量，即可在全局任意终端直接调用 `cloudflared` 命令。

---

## 2. 📝 配置本地 SSH 路由规则

在你的 Windows 电脑上，利用配置让 SSH 流量自动走 Cloudflare 隧道：

1. **定位 SSH 目录**：打开你的 Windows 文件管理器，前往当前用户的 SSH 核心配置目录：
   `C:\Users\<你的电脑用户名>\.ssh\`
2. **创建配置文件**：在该目录下新建（或编辑）一个**没有任何后缀名**的文本文件，命名为 **`config`**。
3. **写入配置内容**：将以下内容追加写入到 `config` 文件中：

```text
Host ssh.<你的域名>.com
    ProxyCommand cloudflared access ssh --hostname %h
```
或者
```text
Host ssh.<你的域名>.com
ProxyCommand cloudflared access ssh --hostname %h
IdentityFile "C:\Users\<你的电脑用户名>\.ssh\gce_key"
PubkeyAuthentication yes

```

4. 格式：ssh 用户名@ssh.<你的域名>.com
```text
ssh root@ssh.<你的域名>.com
```
