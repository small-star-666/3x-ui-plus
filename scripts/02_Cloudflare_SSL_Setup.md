# 域名与 Cloudflare SSL 证书配置指南

## 1. 域名准备
* 前往 [Spaceship](https://www.spaceship.com) 购买你心仪的域名（例如：`xxx.xyz`）。
* 进入域名管理后台，修改 **名称服务器 (Nameservers)**，将其托管至 Cloudflare。

## 2. Cloudflare DNS 基础设置
* 登录 [Cloudflare 控制台](https://dash.cloudflare.com)。
* 点击“添加站点”，输入你购买的域名，按照提示完成 DNS 托管接管。

## 3. 生成 Origin Auths 边缘服务器证书 (SSL/TLS)
为了让你的 3x-ui 节点或面板拥有合法的自签证书，直接在 CF 后台生成 15 年长效证书：
1. 在 Cloudflare 左侧菜单中，点击进入 **SSL/TLS** -> **源服务器 (Origin Server)**。
2. 点击 **创建证书 (Create Certificate)**。
3. 保持默认设置（生成私钥类型、包含根域名及泛域名 `*.你的域名`）。
4. 点击确定后，系统会吐出两段密文：
    * **源证书 (Origin Certificate)** —— 即公钥
    * **私钥 (Private Key)** —— 即私钥

## 4. 落地部署
* 在你的 Ubuntu 服务器上，进入刚才克隆的项目的 `cert` 文件夹。
* 将上面的**源证书**保存为公钥文件，**私钥**保存为私钥文件，供容器挂载读取。