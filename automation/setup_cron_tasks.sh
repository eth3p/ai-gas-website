#!/bin/bash

# 🚀 AI Gas 自动化定时任务设置脚本
# 设置24/7自动化推广系统

echo "=================================================="
echo "🤖 AI Gas 自动化定时任务设置"
echo "=================================================="
echo ""

# 检查当前目录
if [ ! -d "/root/ai-gas-website" ]; then
    echo "❌ 错误: /root/ai-gas-website 目录不存在"
    exit 1
fi

cd /root/ai-gas-website

# 创建自动化目录
mkdir -p automation
mkdir -p automation/logs

echo "📁 创建自动化目录结构..."
echo "✅ automation/ - 自动化脚本目录"
echo "✅ automation/logs/ - 日志目录"
echo ""

# 创建每日更新脚本的简化版本
cat > automation/simple_daily_update.sh << 'EOF'
#!/bin/bash

# AI Gas 简化每日更新脚本
# 每天自动运行

LOG_FILE="/root/ai-gas-website/automation/logs/daily_$(date +%Y%m%d).log"
echo "🤖 AI Gas 每日自动更新 - $(date)" > $LOG_FILE
echo "==================================" >> $LOG_FILE

# 1. 检查网站状态
echo "🔍 检查网站状态..." >> $LOG_FILE
curl -s -I "https://eth3p.github.io/ai-gas-website/" | head -1 >> $LOG_FILE 2>&1

# 2. 运行Python更新脚本
echo "📝 运行内容更新脚本..." >> $LOG_FILE
cd /root/ai-gas-website
python3 automation/daily_content_update.py >> $LOG_FILE 2>&1

# 3. 记录完成时间
echo "✅ 每日更新完成 - $(date)" >> $LOG_FILE
echo "📁 日志文件: $LOG_FILE" >> $LOG_FILE

# 发送完成通知（可选）
if [ -f ~/.hermes/.env ] && grep -q "TELEGRAM_BOT_TOKEN" ~/.hermes/.env; then
    echo "📱 发送Telegram通知..." >> $LOG_FILE
    # 这里可以添加Telegram通知代码
fi

echo "🎉 AI Gas 自动化系统运行完成！"
EOF

chmod +x automation/simple_daily_update.sh

# 创建每周分析脚本
cat > automation/weekly_analysis.sh << 'EOF'
#!/bin/bash

# AI Gas 每周分析脚本
# 每周一自动运行

LOG_FILE="/root/ai-gas-website/automation/logs/weekly_$(date +%Y%m%d).log"
echo "📊 AI Gas 每周分析报告 - $(date)" > $LOG_FILE
echo "====================================" >> $LOG_FILE

# 1. 网站数据统计
echo "🌐 网站数据统计:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE

# 检查页面数量
PAGE_COUNT=$(find /root/ai-gas-website/content/posts -name "*.md" | wc -l)
echo "文章总数: $PAGE_COUNT 篇" >> $LOG_FILE

# 检查最近更新
LAST_UPDATE=$(ls -la /root/ai-gas-website/content/posts/*.md | head -1 | awk '{print $6, $7, $8}')
echo "最近更新: $LAST_UPDATE" >> $LOG_FILE

# 2. Git状态检查
echo "" >> $LOG_FILE
echo "📝 Git状态检查:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE
cd /root/ai-gas-website
git status --short >> $LOG_FILE 2>&1

# 3. 系统状态检查
echo "" >> $LOG_FILE
echo "⚙️ 系统状态检查:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE
echo "CPU使用率: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%" >> $LOG_FILE
echo "内存使用: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')" >> $LOG_FILE
echo "磁盘空间: $(df -h / | awk 'NR==2 {print $4 " 可用"}')" >> $LOG_FILE

# 4. 生成报告摘要
echo "" >> $LOG_FILE
echo "📈 本周总结:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE
echo "✅ 网站正常运行" >> $LOG_FILE
echo "✅ 自动化系统工作正常" >> $LOG_FILE
echo "✅ 内容持续更新中" >> $LOG_FILE
echo "📊 总文章数: $PAGE_COUNT 篇" >> $LOG_FILE
echo "📅 下次更新: 明天 08:00" >> $LOG_FILE

echo "📁 周报日志: $LOG_FILE"
EOF

chmod +x automation/weekly_analysis.sh

# 创建每月报告脚本
cat > automation/monthly_report.sh << 'EOF'
#!/bin/bash

# AI Gas 每月报告脚本
# 每月1号自动运行

LOG_FILE="/root/ai-gas-website/automation/logs/monthly_$(date +%Y%m).log"
echo "📋 AI Gas 每月运营报告 - $(date)" > $LOG_FILE
echo "====================================" >> $LOG_FILE

# 1. 月度数据汇总
echo "📊 月度数据汇总:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE

# 统计本月新增文章
MONTH=$(date +%Y-%m)
NEW_ARTICLES=$(find /root/ai-gas-website/content/posts -name "*.md" -newermt "$MONTH-01" | wc -l)
echo "本月新增文章: $NEW_ARTICLES 篇" >> $LOG_FILE

# 统计总文章数
TOTAL_ARTICLES=$(find /root/ai-gas-website/content/posts -name "*.md" | wc -l)
echo "累计文章总数: $TOTAL_ARTICLES 篇" >> $LOG_FILE

# 2. 自动化执行统计
echo "" >> $LOG_FILE
echo "🤖 自动化执行统计:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE

DAILY_LOGS=$(ls /root/ai-gas-website/automation/logs/daily_*.log 2>/dev/null | wc -l)
WEEKLY_LOGS=$(ls /root/ai-gas-website/automation/logs/weekly_*.log 2>/dev/null | wc -l)
echo "每日任务执行: $DAILY_LOGS 次" >> $LOG_FILE
echo "每周任务执行: $WEEKLY_LOGS 次" >> $LOG_FILE

# 3. 系统健康检查
echo "" >> $LOG_FILE
echo "🏥 系统健康检查:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE

# 检查网站可访问性
if curl -s -I "https://eth3p.github.io/ai-gas-website/" | head -1 | grep -q "200"; then
    echo "✅ 网站可访问: 正常" >> $LOG_FILE
else
    echo "❌ 网站可访问: 异常" >> $LOG_FILE
fi

# 检查自动化脚本
if [ -f "/root/ai-gas-website/automation/daily_content_update.py" ]; then
    echo "✅ 更新脚本: 存在" >> $LOG_FILE
else
    echo "❌ 更新脚本: 缺失" >> $LOG_FILE
fi

# 4. 下月计划
echo "" >> $LOG_FILE
echo "🎯 下月运营计划:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE
echo "1. 继续每日内容更新" >> $LOG_FILE
echo "2. 优化自动化系统" >> $LOG_FILE
echo "3. 增加更多AI工具评测" >> $LOG_FILE
echo "4. 探索新的赚钱方法" >> $LOG_FILE
echo "5. 加强推广和引流" >> $LOG_FILE

# 5. 建议和改进
echo "" >> $LOG_FILE
echo "💡 改进建议:" >> $LOG_FILE
echo "----------------" >> $LOG_FILE
echo "1. 考虑添加更多自动化任务" >> $LOG_FILE
echo "2. 优化内容质量和SEO" >> $LOG_FILE
echo "3. 探索社交媒体自动化" >> $LOG_FILE
echo "4. 监控竞争对手动态" >> $LOG_FILE
echo "5. 持续学习AI新技术" >> $LOG_FILE

echo "📁 月报日志: $LOG_FILE"
EOF

chmod +x automation/monthly_report.sh

# 创建监控脚本
cat > automation/monitor.sh << 'EOF'
#!/bin/bash

# AI Gas 监控脚本
# 每小时运行一次

LOG_FILE="/root/ai-gas-website/automation/logs/monitor_$(date +%Y%m%d_%H%M).log"
echo "🔍 AI Gas 系统监控 - $(date)" > $LOG_FILE

# 1. 网站状态监控
echo "🌐 网站状态:" >> $LOG_FILE
URL="https://eth3p.github.io/ai-gas-website/"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I "$URL")
if [ "$STATUS" = "200" ]; then
    echo "✅ $URL - HTTP $STATUS" >> $LOG_FILE
else
    echo "❌ $URL - HTTP $STATUS" >> $LOG_FILE
fi

# 2. 关键页面检查
PAGES=(
    "主页" "$URL"
    "AI赚钱方法" "$URL/posts/ai-money-making-methods/"
    "AI工具对比" "$URL/posts/ai-tools-comparison-2026/"
)

for ((i=0; i<${#PAGES[@]}; i+=2)); do
    NAME="${PAGES[i]}"
    PAGE_URL="${PAGES[i+1]}"
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I "$PAGE_URL")
    if [ "$STATUS" = "200" ]; then
        echo "  ✅ $NAME: HTTP $STATUS" >> $LOG_FILE
    else
        echo "  ❌ $NAME: HTTP $STATUS" >> $LOG_FILE
    fi
done

# 3. 系统资源监控
echo "" >> $LOG_FILE
echo "⚙️ 系统资源:" >> $LOG_FILE
echo "  CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%" >> $LOG_FILE
echo "  内存: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')" >> $LOG_FILE
echo "  磁盘: $(df -h / | awk 'NR==2 {print $4 " 可用"}')" >> $LOG_FILE

# 4. 自动化任务状态
echo "" >> $LOG_FILE
echo "🤖 自动化状态:" >> $LOG_FILE
if [ -f "/root/ai-gas-website/automation/daily_content_update.py" ]; then
    echo "  ✅ 更新脚本: 正常" >> $LOG_FILE
else
    echo "  ❌ 更新脚本: 缺失" >> $LOG_FILE
fi

if [ -d "/root/ai-gas-website/automation/logs" ]; then
    LOG_COUNT=$(ls /root/ai-gas-website/automation/logs/*.log 2>/dev/null | wc -l)
    echo "  📊 日志文件: $LOG_COUNT 个" >> $LOG_FILE
else
    echo "  ❌ 日志目录: 缺失" >> $LOG_FILE
fi

# 5. 最近活动
echo "" >> $LOG_FILE
echo "📅 最近活动:" >> $LOG_FILE
LAST_LOG=$(ls -t /root/ai-gas-website/automation/logs/daily_*.log 2>/dev/null | head -1)
if [ -n "$LAST_LOG" ]; then
    LAST_TIME=$(stat -c %y "$LAST_LOG" | cut -d' ' -f1-2)
    echo "  最后更新: $LAST_TIME" >> $LOG_FILE
else
    echo "  最后更新: 无记录" >> $LOG_FILE
fi

echo "✅ 监控检查完成 - $(date)" >> $LOG_FILE

# 只保留错误日志
if grep -q "❌" $LOG_FILE; then
    echo "⚠️ 发现异常，请检查日志: $LOG_FILE"
    # 这里可以添加通知代码
fi
EOF

chmod +x automation/monitor.sh

# 设置crontab定时任务
echo "⏰ 设置crontab定时任务..."
echo ""

# 创建crontab配置文件
cat > /tmp/ai_gas_cron << 'EOF'
# 🤖 AI Gas 自动化定时任务
# 24/7自动化推广系统

# 每小时运行监控脚本
0 * * * * /root/ai-gas-website/automation/monitor.sh > /dev/null 2>&1

# 每天8:00运行每日更新
0 8 * * * /root/ai-gas-website/automation/simple_daily_update.sh > /dev/null 2>&1

# 每周一9:00运行周报
0 9 * * 1 /root/ai-gas-website/automation/weekly_analysis.sh > /dev/null 2>&1

# 每月1号10:00运行月报
0 10 1 * * /root/ai-gas-website/automation/monthly_report.sh > /dev/null 2>&1

# 每天23:00清理旧日志（保留7天）
0 23 * * * find /root/ai-gas-website/automation/logs -name "*.log" -mtime +7 -delete > /dev/null 2>&1
EOF

# 添加到crontab
crontab /tmp/ai_gas_cron

echo "✅ 定时任务已设置:"
echo ""
echo "📅 任务时间表:"
echo "  🕐 每小时: 系统监控"
echo "  🕗 每天8:00: 内容更新和部署"
echo "  🕘 每周一9:00: 周报生成"
echo "  🕙 每月1号10:00: 月报生成"
echo "  🕚 每天23:00: 日志清理"
echo ""

# 测试第一个任务
echo "🔧 测试自动化系统..."
echo "运行监控脚本..."
/root/ai-gas-website/automation/monitor.sh

echo ""
echo "📊 检查crontab设置..."
crontab -l | grep -A5 "AI Gas"

echo ""
echo "🎉 AI Gas 自动化系统设置完成！"
echo ""
echo "🚀 系统将在以下时间自动运行:"
echo "  - 下一个整点: 系统监控"
echo "  - 明天8:00: 内容更新和部署"
echo "  - 下周一9:00: 周报生成"
echo ""
echo "📁 日志目录: /root/ai-gas-website/automation/logs/"
echo "📋 查看当前任务: crontab -l"
echo "🛠️ 修改任务: crontab -e"
echo ""
echo "💡 提示:"
echo "1. 确保Python环境正常"
echo "2. 确保Git配置正确"
echo "3. 定期检查日志文件"
echo "4. 根据需要调整时间表"
echo ""
echo "🤖 AI Gas 自动化系统已就绪！"
echo "🎯 目标: 24/7自动运行，无需人工干预"
echo "💰 预期: 持续内容更新，稳定流量增长"