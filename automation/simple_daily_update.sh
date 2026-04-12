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
