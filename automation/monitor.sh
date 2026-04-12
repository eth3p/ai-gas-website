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
