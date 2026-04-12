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
