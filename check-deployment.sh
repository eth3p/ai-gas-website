#!/bin/bash

# 部署检查脚本
# 用法: ./check-deployment.sh

echo "🔍 AI Gas 网站部署检查脚本"
echo "================================"
echo

# 1. 检查本地文件
echo "1. 检查本地文件:"
if [ -f "docs/CNAME" ]; then
    echo "   ✅ CNAME文件存在: $(cat docs/CNAME)"
else
    echo "   ❌ CNAME文件缺失"
fi

if [ -f "layouts/_default/404.html" ]; then
    echo "   ✅ 404页面模板存在"
else
    echo "   ❌ 404页面模板缺失"
fi

echo

# 2. 检查Git状态
echo "2. 检查Git状态:"
if git status --porcelain | grep -q docs/CNAME; then
    echo "   ⚠️  CNAME文件有未提交的更改"
else
    echo "   ✅ CNAME文件已提交"
fi

if git status --porcelain | grep -q layouts/_default/404.html; then
    echo "   ⚠️  404页面有未提交的更改"
else
    echo "   ✅ 404页面已提交"
fi

echo

# 3. 检查远程部署
echo "3. 远程部署测试:"
echo "   测试 GitHub Pages: https://eth3p.github.io/ai-gas-website/"
echo "   测试自定义域名: https://aigas.top/"
echo

# 4. 显示GitHub Pages配置指南
echo "4. GitHub Pages配置要求:"
echo "   ✅ 仓库: https://github.com/eth3p/ai-gas-website"
echo "   🔧 需要手动配置:"
echo "     1. Settings > Pages"
echo "     2. Source: Deploy from a branch"
echo "     3. Branch: main"
echo "     4. Folder: /docs"
echo "     5. Custom domain: aigas.top"
echo "     6. Enforce HTTPS: ✓"
echo

# 5. 显示DNS配置要求
echo "5. DNS配置要求 (aigas.top):"
echo "   A记录:"
echo "     aigas.top → 185.199.108.153"
echo "     aigas.top → 185.199.109.153"
echo "     aigas.top → 185.199.110.153"
echo "     aigas.top → 185.199.111.153"
echo "   CNAME记录 (可选):"
echo "     www.aigas.top → eth3p.github.io"
echo

# 6. 提供快速测试命令
echo "6. 快速测试命令:"
echo "   # 测试GitHub Pages"
echo "   curl -I https://eth3p.github.io/ai-gas-website/"
echo "   "
echo "   # 测试自定义域名"
echo "   curl -I https://aigas.top/"
echo "   "
echo "   # 测试404页面"
echo "   curl -I https://eth3p.github.io/ai-gas-website/nonexistent.html"
echo

echo "📋 操作步骤:"
echo "   1. 完成GitHub Pages设置"
echo "   2. 配置DNS记录 (如未配置)"
echo "   3. 等待部署完成 (1-10分钟)"
echo "   4. 测试所有URL"
echo "   5. 启用HTTPS强制重定向"
echo

echo "📞 如有问题，请检查:"
echo "   - GitHub Actions日志"
echo "   - GitHub Pages设置页面"
echo "   - 域名提供商DNS控制台"
echo

echo "✅ 本地配置已完成，等待GitHub Pages设置和DNS传播。"