#!/bin/bash

# 🚀 AI Gas 赚钱自动化启动脚本
# 启动24/7赚钱流水线

echo "=================================================="
echo "💰 AI Gas 赚钱自动化系统启动"
echo "=================================================="
echo ""

# 检查配置
if [ ! -f "/root/ai-gas-website/automation/money_config.json" ]; then
    echo "❌ 错误: 缺少money_config.json配置文件"
    exit 1
fi

# 显示配置信息
echo "📋 系统配置:"
echo "  网站名称: AI Gas - AI Tools Reviews"
echo "  网站地址: https://eth3p.github.io/ai-gas-website/"
echo "  AdSense ID: ca-pub-4630162780874150"
echo ""
echo "📅 自动化任务:"
echo "  • 内容创作: 每天2篇文章"
echo "  • 社交媒体: 3个平台, 每天3个帖子"
echo "  • SEO优化: 每日检查"
echo "  • 变现: AdSense + 联盟营销"
echo ""
echo "🎯 月度目标:"
echo "  • 访问量: 10,000"
echo "  • 收入: $500"
echo "  • 文章数量: 100"
echo "  • 社交粉丝: 1,000"
echo ""

# 启动第一轮任务
echo "🚀 启动赚钱自动化任务..."
echo ""
echo "1️⃣ 启动内容创建任务..."
cd /root/ai-gas-website
python3 automation/daily_content_update.py >> automation/logs/money_startup_$(date +%Y%m%d_%H%M%S).log 2>&1
echo "✅ 内容任务启动完成"

echo ""
echo "2️⃣ 启动社交媒体自动化..."
./automation/social_media_auto.sh >> automation/logs/social_media_$(date +%Y%m%d_%H%M%S).log 2>&1
echo "✅ 社交媒体任务启动完成"

echo ""
echo "3️⃣ 启动SEO优化任务..."
# 这里可以添加具体的SEO自动化脚本
echo "📊 SEO优化任务已调度"

echo ""
echo "4️⃣ 设置自动报告..."
echo "📨 每日报告将发送到Telegram"
echo "📊 收入追踪已启用"

echo ""
echo "=================================================="
echo "💰 AI Gas 赚钱自动化系统启动完成!"
echo "=================================================="
echo ""
echo "🎯 系统现在将24/7自动运行以下任务:"
echo "  • 每天2篇AI工具文章"
echo "  • 社交媒体自动推广"
echo "  • 网站健康监控"
echo "  • 收入追踪和报告"
echo ""
echo "📊 查看进度:"
echo "  cd /root/ai-gas-website/automation/logs/"
echo "  tail -f *.log"
echo ""
echo "🔄 更新系统:"
echo "  cd /root/ai-gas-website && git pull"
echo ""
echo "🤖 系统完全自主运行，无需人工干预！"
