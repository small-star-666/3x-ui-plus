# 🌐 域名与 Cloudflare SSL 证书配置指南

本指南详细介绍如何从零开始购买域名、托管至 Cloudflare，并生成 15 年长效的源服务器证书进行落地部署。

---

## 1. 📂 域名准备与托管
* **购买域名**：前往 [Spaceship](https://www.spaceship.com) 购买你心仪的域名（例如：`xxx.xyz`）。
* **修改 DNS**：进入 Spaceship 域名管理后台，修改 **名称服务器 (Nameservers)**，将其修改为 Cloudflare 分配给你的自定义名称服务器，将域名托管至 Cloudflare。

---

## 2. ⚡ Cloudflare DNS 基础设置
* **添加站点**：登录 [Cloudflare 控制台](https://dash.cloudflare.com)。
* **完成接管**：点击 **“添加站点”**，输入你购买的域名，选择免费计划（Free），并按照提示完成 DNS 托管接管。

---

## 3. 🔑 生成 Origin Auths 源服务器证书
为了让你的后端节点或面板拥有合法的 15 年长效证书，直接在 Cloudflare 后台生成：

1. **进入证书页面**：在 Cloudflare 左侧导航栏中，点击进入 **SSL/TLS** -> **源服务器 (Origin Server)**。
2. **创建证书**：点击 **创建证书 (Create Certificate)**。
3. **保持默认配置**：
   * 密钥生成类型保持默认。
   * 证书主机名确保包含你的根域名（如 `xxx.xyz`）及泛域名（`*.xxx.xyz`）。
   * 证书有效期建议保持默认的 **15 年**。
4. **保存密文**：点击确定后，系统会生成两段密文，请立刻复制并妥善保存：
   * **源证书 (Origin Certificate)** —— 对应 **公钥 (CRT)**
   * **私钥 (Private Key)** —— 对应 **私钥 (KEY)**

---

## 4. 🚀 落地部署与命名规范

在你的 Ubuntu 服务器上，进入刚才克隆的项目目录，将两段密文写入 `cert` 文件夹中：

```bash
# 进入项目证书文件夹
cd 3x-ui-plus/cert