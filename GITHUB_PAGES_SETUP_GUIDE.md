# GitHub Pages 部署设置指南

## 当前状态
- ✅ 网站代码已推送到GitHub仓库 (eth3p/ai-gas-website)
- ✅ 自定义404页面已创建 (`layouts/_default/404.html`)
- ✅ CNAME文件已添加 (`aigas.top`)
- ✅ 网站已构建到`docs/`文件夹
- ⚠️  GitHub Pages设置需要手动配置

## 需要手动完成的步骤

### 1. 启用GitHub Pages
1. 访问GitHub仓库: https://github.com/eth3p/ai-gas-website
2. 点击"Settings"选项卡
3. 在左侧菜单中找到"Pages"
4. 配置以下设置:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/docs`
5. 点击"Save"

### 2. 等待GitHub Pages构建和部署
- 构建通常需要1-3分钟
- 可以在仓库的"Actions"选项卡中查看构建状态
- 构建完成后，会显示绿色的部署状态

### 3. 验证自定义域名
1. 在GitHub Pages设置页面底部，找到"Custom domain"
2. 输入: `aigas.top`
3. 勾选"Enforce HTTPS"
4. 点击"Save"

### 4. 更新DNS记录（域名提供商）
如果aigas.top还没有正确指向GitHub Pages，需要在域名注册商处添加以下记录：

#### A 记录：
```
aigas.top → 185.199.108.153
aigas.top → 185.199.109.153  
aigas.top → 185.199.110.153
aigas.top → 185.199.111.153
```

#### CNAME 记录（可选）：
```
www.aigas.top → eth3p.github.io
```

## 验证部署

### 测试网址：
1. GitHub Pages URL: https://eth3p.github.io/ai-gas-website/
2. 自定义域名: https://aigas.top/
3. 不存在的页面: https://aigas.top/notexist-page.html

### 预期结果：
- 主页面返回200状态码，显示AI Gas网站内容
- 不存在的页面返回404状态码，显示自定义404页面
- HTTPS强制启用

## 自定义404页面功能
已创建的404页面包含：
- 清晰的404错误信息
- 导航按钮返回首页和相关分类
- 搜索功能（需要后端支持）
- 热门内容推荐
- Google AdSense广告位
- Google Analytics事件跟踪

## 故障排除

### 如果GitHub Pages返回404：
1. 检查`docs/`文件夹中是否有`CNAME`文件
2. 确保GitHub Pages设置中分支和文件夹配置正确
3. 查看仓库的Actions标签页是否有构建错误

### 如果自定义域名不工作：
1. 等待DNS传播（最长48小时）
2. 验证DNS记录设置正确
3. 在GitHub Pages设置中重新保存自定义域名

### 如果HTTPS无法启用：
1. 在GitHub Pages设置中勾选"Enforce HTTPS"
2. 等待Let's Encrypt证书签发（最长24小时）

## 后续优化
1. 添加搜索功能后端
2. 优化404页面SEO
3. 添加更多相关文章推荐
4. 添加用户反馈表单

## 联系方式
如果遇到问题，请检查GitHub仓库的Issues或联系管理员。

---
*最后更新: 2026-04-17*  
*状态: 等待GitHub Pages设置完成*