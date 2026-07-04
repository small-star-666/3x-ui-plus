# Cloudflare 路由流量分流与自动化部署指南

## 1. 场景目标
* **路由分流**：保留 `xxx.xyz/cl*`、`xxx.xyz/su*` 等路径用于后端穿透，避免被 Pages 覆盖。
* **自动化部署**：通过 GitHub 仓库实现前端博客的自动化持续集成（CI/CD）。

---

## 2. 路由分流与禁用配置
在 Cloudflare 中，“禁用 Workers”的操作实际上是建立一条优先级最高的“白名单”规则，告诉 Cloudflare 遇到这些路径时，不要触发任何 Workers 或 Pages，直接让其穿透到源站。

### 操作步骤：
1.  登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)。
2.  选择你的域名 `xxx.xyz`。
3.  点击左侧菜单栏的 **「Workers 路由 (Workers Routes)」**。
4.  点击 **「添加路由 (Add route)」**，依次配置以下规则（注意：设置 **Worker: 禁用 (Disabled)**）：

| 路由路径             | Worker 设置 |
|:-----------------| :--- |
| `xxx.xyz/cl/*`   | 禁用 |
| `xxx.xyz/su/*`   | 禁用 |
| `xxx.xyz/path/*` | 禁用 |
| `xxx.xyz/admin*` | 禁用 |

> **重要规则**: 确保上述路由在列表中已正确显示为 **“Workers 已在此路由上禁用”**。

---

## 3. 自动化部署 (Cloudflare Pages)
我们将通过 Pages 功能，让前端代码在提交到 GitHub 后自动完成编译并发布到剩余的流量路径。

### 第一步：创建 Pages 应用程序
1.  在控制台左侧菜单，点击 **「Workers 和 Pages」**。
2.  点击 **「创建应用程序 (Create application)」**。
3.  切换到 **「Pages」** 选项卡。
4.  点击 **「连接到 Git (Connect to Git)」**，授权并选中你的前端仓库（如 `fake-web`）。

### 第二步：配置构建参数
在配置构建设置时，填入以下关键信息：
* **框架预设 (Framework preset)**: `Vite`
* **构建命令 (Build command)**: `npm run build`
* **输出目录 (Output directory)**: `dist`

### 第三步：完成并部署
1.  点击 **「保存并部署 (Save and deploy)」**。
2.  Cloudflare 将自动拉取代码、执行 `npm install` 及 `npm run build`。
3.  部署完成后，系统会为你分配一个 `*.pages.dev` 的预览域名。

---

## 4. 整体流量转发逻辑说明

| 路径匹配 | 行为逻辑 | 最终处理 |
| :--- | :--- | :--- |
| `xxx.xyz/cl*` | 命中“禁用”路由 | 直接穿透至后端服务器 |
| `xxx.xyz/su*` | 命中“禁用”路由 | 直接穿透至后端服务器 |
| `xxx.xyz/*` | 命中 Pages 项目 | 展示你的 Vue 3 静态博客 |

---

## 5. 日常维护建议
* **更新博客内容**：直接在本地 `src/App.vue` 中修改，`git push` 到 GitHub，Cloudflare 会在 1-2 分钟内自动完成全量覆盖。
* **新增穿透路径**：如果未来增加了新的后端服务路径，记得同步到“Workers 路由”页面，执行相同的“禁用”操作。
* **查看部署日志**：若自动构建失败，请进入 `Workers 和 Pages` -> `项目名称` -> `Deployments` 查看详细错误日志。

---
**配置完成状态**：已实现流量的“精确拦截”与“自动化托管”。