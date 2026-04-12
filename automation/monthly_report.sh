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
