#!/bin/bash

# 🎛️ AI Gas 自动化监控面板
# 实时查看自动化系统状态

echo "=================================================="
echo "🎛️ AI Gas 自动化监控面板"
echo "=================================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取当前时间
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# 1. 系统概览
echo "📊 系统概览"
echo "----------"
echo "时间: $CURRENT_TIME"
echo "运行目录: /root/ai-gas-website"
echo ""

# 2. 网站状态
echo "🌐 网站状态"
echo "----------"

check_website() {
    URL="https://eth3p.github.io/ai-gas-website/"
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I "$URL" 2>/dev/null || echo "000")
    
    if [ "$STATUS" = "200" ]; then
        echo -e "${GREEN}✅ 主站: HTTP $STATUS - 正常${NC}"
    else
        echo -e "${RED}❌ 主站: HTTP $STATUS - 异常${NC}"
    fi
    
    # 检查关键页面
    PAGES=(
        "AI赚钱方法" "/posts/ai-money-making-methods/"
        "AI工具对比" "/posts/ai-tools-comparison-2026/"
        "互动投票" "/posts/ai-tools-poll-2026/"
    )
    
    for ((i=0; i<${#PAGES[@]}; i+=2)); do
        NAME="${PAGES[i]}"
        PATH="${PAGES[i+1]}"
        PAGE_URL="${URL}${PATH}"
        STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I "$PAGE_URL" 2>/dev/null || echo "000")
        
        if [ "$STATUS" = "200" ]; then
            echo -e "  ${GREEN}✅ $NAME: HTTP $STATUS${NC}"
        else
            echo -e "  ${RED}❌ $NAME: HTTP $STATUS${NC}"
        fi
    done
}

check_website
echo ""

# 3. 内容统计
echo "📚 内容统计"
echo "----------"

if [ -d "/root/ai-gas-website/content/posts" ]; then
    TOTAL_ARTICLES=$(find /root/ai-gas-website/content/posts -name "*.md" | wc -l)
    TODAY_ARTICLES=$(find /root/ai-gas-website/content/posts -name "*.md" -newermt "$(date +%Y-%m-%d)" | wc -l)
    WEEK_ARTICLES=$(find /root/ai-gas-website/content/posts -name "*.md" -newermt "$(date -d '7 days ago' +%Y-%m-%d)" | wc -l)
    
    echo -e "${GREEN}📄 总文章数: $TOTAL_ARTICLES 篇${NC}"
    echo -e "${BLUE}📅 今日新增: $TODAY_ARTICLES 篇${NC}"
    echo -e "${BLUE}📅 本周新增: $WEEK_ARTICLES 篇${NC}"
    
    # 显示最新文章
    LATEST=$(ls -t /root/ai-gas-website/content/posts/*.md 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
        LATEST_NAME=$(basename "$LATEST" .md)
        LATEST_TIME=$(stat -c %y "$LATEST" | cut -d' ' -f1-2)
        echo -e "${YELLOW}🆕 最新文章: $LATEST_NAME${NC}"
        echo -e "${YELLOW}⏰ 更新时间: $LATEST_TIME${NC}"
    fi
else
    echo -e "${RED}❌ 内容目录不存在${NC}"
fi
echo ""

# 4. 自动化任务状态
echo "🤖 自动化任务状态"
echo "----------------"

# 检查crontab任务
CRON_COUNT=$(crontab -l 2>/dev/null | grep -c "ai-gas-website")
if [ "$CRON_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✅ 定时任务: $CRON_COUNT 个已配置${NC}"
    
    # 显示任务列表
    echo "  任务列表:"
    crontab -l 2>/dev/null | grep "ai-gas-website" | while read line; do
        echo "  - $line" | sed 's/>.*//'
    done
else
    echo -e "${RED}❌ 定时任务: 未配置${NC}"
fi
echo ""

# 5. 日志文件状态
echo "📁 日志文件状态"
echo "--------------"

LOG_DIR="/root/ai-gas-website/automation/logs"
if [ -d "$LOG_DIR" ]; then
    LOG_COUNT=$(ls "$LOG_DIR"/*.log 2>/dev/null | wc -l)
    if [ "$LOG_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✅ 日志文件: $LOG_COUNT 个${NC}"
        
        # 显示最新日志
        LATEST_LOG=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
        if [ -n "$LATEST_LOG" ]; then
            LOG_NAME=$(basename "$LATEST_LOG")
            LOG_TIME=$(stat -c %y "$LATEST_LOG" | cut -d' ' -f1-2)
            LOG_SIZE=$(du -h "$LATEST_LOG" | cut -f1)
            
            echo -e "${BLUE}📄 最新日志: $LOG_NAME${NC}"
            echo -e "${BLUE}⏰ 记录时间: $LOG_TIME${NC}"
            echo -e "${BLUE}📏 文件大小: $LOG_SIZE${NC}"
            
            # 显示日志摘要
            echo "  最后5行日志:"
            tail -5 "$LATEST_LOG" | while read line; do
                echo "  $line"
            done
        fi
    else
        echo -e "${YELLOW}⚠️ 日志文件: 目录存在但无日志${NC}"
    fi
else
    echo -e "${RED}❌ 日志目录: 不存在${NC}"
fi
echo ""

# 6. Git状态
echo "📝 Git状态"
echo "----------"

cd /root/ai-gas-website 2>/dev/null
if [ $? -eq 0 ]; then
    # 检查是否有未提交的更改
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$CHANGES" -gt 0 ]; then
        echo -e "${YELLOW}⚠️ 未提交更改: $CHANGES 个文件${NC}"
        echo "  更改文件:"
        git status --porcelain 2>/dev/null | head -5 | while read line; do
            echo "  - $line"
        done
        if [ "$CHANGES" -gt 5 ]; then
            echo "  ... 还有 $(($CHANGES - 5)) 个文件"
        fi
    else
        echo -e "${GREEN}✅ Git仓库: 已同步${NC}"
    fi
    
    # 显示最近提交
    LAST_COMMIT=$(git log -1 --oneline 2>/dev/null)
    if [ -n "$LAST_COMMIT" ]; then
        echo -e "${BLUE}📌 最近提交: $LAST_COMMIT${NC}"
    fi
else
    echo -e "${RED}❌ Git仓库: 无法访问${NC}"
fi
echo ""

# 7. 系统资源
echo "⚙️ 系统资源"
echo "----------"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
MEM_USAGE=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')

echo -e "${BLUE}💻 CPU使用率: $CPU_USAGE%${NC}"
echo -e "${BLUE}🧠 内存使用: $MEM_USAGE${NC}"
echo -e "${BLUE}💾 磁盘可用: $DISK_FREE${NC}"
echo -e "${BLUE}📈 系统负载: $LOAD_AVG${NC}"
echo ""

# 8. 下一步建议
echo "🎯 下一步建议"
echo "------------"

# 基于当前状态给出建议
if [ ! -d "$LOG_DIR" ] || [ "$LOG_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}1. 🔧 运行自动化测试: ./automation/monitor.sh${NC}"
fi

if [ "$CHANGES" -gt 0 ]; then
    echo -e "${YELLOW}2. 📝 提交Git更改: git add . && git commit -m '更新'${NC}"
fi

if [ "$TODAY_ARTICLES" -eq 0 ]; then
    echo -e "${YELLOW}3. 📄 运行内容更新: python3 automation/daily_content_update.py${NC}"
fi

echo -e "${GREEN}4. 📱 生成社交媒体内容: ./automation/social_media_auto.sh${NC}"
echo -e "${GREEN}5. 🕐 查看定时任务: crontab -l${NC}"
echo -e "${GREEN}6. 🔍 查看详细日志: ls -la automation/logs/${NC}"

echo ""
echo "=================================================="
echo "🚀 AI Gas 自动化系统运行中..."
echo "🎯 目标: 24/7自动运行，持续增长"
echo "💰 愿景: 建立自动化赚钱帝国"
echo "=================================================="
echo ""
echo "💡 提示:"
echo "• 运行 './automation/dashboard.sh' 随时查看状态"
echo "• 检查日志了解详细运行情况"
echo "• 根据需要调整自动化配置"
echo "• 保持系统持续运行和优化"
echo ""
echo "🤖 大精灵自动化系统 - 监控面板 v1.0"
echo "生成时间: $CURRENT_TIME"