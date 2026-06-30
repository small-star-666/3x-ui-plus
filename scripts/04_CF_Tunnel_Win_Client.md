# Windows 客户端 SSH 隧道打通指南

## 1. 下载本地控制程序
* 访问 GitHub 官方下载最新 Windows 64 位版本：
  👉 [cloudflared-windows-amd64.exe](https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe)
* 下载后，将文件重命名为：**`cloudflared.exe`**。
* **优雅放置**：直接将该文件剪切粘贴到本地电脑的 **`C:\Windows\`** 目录下（无需手动配置环境变量，全局即刻生效）。

## 2. 拦截本地 SSH 路由规则
在你的 Windows 电脑上，定位到当前用户的 SSH 核心配置目录：`C:\Users\<你的电脑用户名>\.ssh\`。
新建或编辑一个没有后缀名的文本文件，命名为 **`config`**，追加写入以下内容：

```text
Host ssh.<你的域名>.com
    ProxyCommand cloudflared access ssh --hostname %h
    IdentityFile "C:\Users\<你的电脑用户名>\.ssh\gce_key"
    PubkeyAuthentication yes
```
# 直接SSH连接 root可以改成其他用户名
    ssh root@<你的域名>
#   ssh root@xxx.com