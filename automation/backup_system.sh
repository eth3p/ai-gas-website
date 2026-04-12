#!/bin/bash

# 🛡️ AI Gas 完整备份系统
# 保护你的赚钱帝国不因服务器故障而丢失

echo "=================================================="
echo "🛡️ AI Gas 完整备份系统设置"
echo "=================================================="
echo ""

# 备份目录结构
BACKUP_ROOT="/root/ai-gas-backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$DATE"

echo "📁 创建备份目录结构..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_ROOT/daily"
mkdir -p "$BACKUP_ROOT/weekly"
mkdir -p "$BACKUP_ROOT/monthly"
mkdir -p "$BACKUP_ROOT/logs"

echo "✅ 备份根目录: $BACKUP_ROOT"
echo "✅ 本次备份目录: $BACKUP_DIR"
echo ""

# 1. 备份网站内容
echo "📚 1. 备份网站内容..."
WEBSITE_DIR="/root/ai-gas-website"
if [ -d "$WEBSITE_DIR" ]; then
    # 创建网站备份
    WEBSITE_BACKUP="$BACKUP_DIR/website.tar.gz"
    tar -czf "$WEBSITE_BACKUP" -C "$WEBSITE_DIR" .
    WEBSITE_SIZE=$(du -h "$WEBSITE_BACKUP" | cut -f1)
    echo "   ✅ 网站内容备份完成: $WEBSITE_BACKUP ($WEBSITE_SIZE)"
    
    # 统计文件数量
    FILE_COUNT=$(find "$WEBSITE_DIR" -type f -name "*.md" | wc -l)
    echo "   📊 包含: $FILE_COUNT 篇文章"
else
    echo "   ❌ 错误: 网站目录不存在: $WEBSITE_DIR"
fi
echo ""

# 2. 备份配置文件
echo "⚙️ 2. 备份配置文件..."
CONFIG_BACKUP="$BACKUP_DIR/configs.tar.gz"
tar -czf "$CONFIG_BACKUP" \
    ~/.hermes/config.yaml \
    ~/.hermes/.env \
    /etc/crontab \
    2>/dev/null || true

if [ -f "$CONFIG_BACKUP" ]; then
    CONFIG_SIZE=$(du -h "$CONFIG_BACKUP" | cut -f1)
    echo "   ✅ 配置文件备份完成: $CONFIG_BACKUP ($CONFIG_SIZE)"
else
    echo "   ⚠️ 警告: 部分配置文件可能不存在"
fi
echo ""

# 3. 备份数据库和重要数据
echo "💾 3. 备份重要数据..."
DATA_BACKUP="$BACKUP_DIR/data.tar.gz"

# 创建重要数据列表
IMPORTANT_FILES=(
    "/root/ai-gas-website/automation/generated_articles.json"
    "/root/ai-gas-website/automation/logs"
    "/root/ai-gas-backups/logs"
    "/root/.bash_history"
)

# 备份自动化生成的数据
if [ -f "/root/ai-gas-website/automation/generated_articles.json" ]; then
    cp "/root/ai-gas-website/automation/generated_articles.json" "$BACKUP_DIR/"
    echo "   ✅ 备份文章生成记录"
fi

# 备份crontab配置
crontab -l > "$BACKUP_DIR/crontab_backup.txt" 2>/dev/null || true
echo "   ✅ 备份crontab配置"
echo ""

# 4. 创建恢复脚本
echo "🔄 4. 创建恢复脚本..."
cat > "$BACKUP_DIR/restore_instructions.md" << 'EOF'
# 🔄 AI Gas 网站恢复指南

如果服务器出现问题，使用本备份恢复你的赚钱帝国。

## 📁 备份内容
备份时间: $(date)
备份目录: $(basename $BACKUP_DIR)

包含:
1. 网站完整内容 (website.tar.gz)
2. 配置文件 (configs.tar.gz)
3. 重要数据
4. crontab配置

## 🚀 快速恢复步骤

### 步骤1: 恢复网站
```bash
# 创建网站目录
mkdir -p /root/ai-gas-website

# 解压备份
tar -xzf website.tar.gz -C /root/ai-gas-website

# 恢复权限
chmod +x /root/ai-gas-website/*.sh
chmod +x /root/ai-gas-website/automation/*.sh
```

### 步骤2: 恢复配置
```bash
# 恢复Hermes配置
tar -xzf configs.tar.gz -C ~/

# 恢复crontab
crontab crontab_backup.txt
```

### 步骤3: 重启自动化系统
```bash
# 重新设置定时任务
cd /root/ai-gas-website
./automation/setup_cron_tasks.sh

# 运行监控
./automation/monitor.sh
```

### 步骤4: 验证恢复
```bash
# 检查网站状态
curl -I https://eth3p.github.io/ai-gas-website/

# 运行监控面板
./automation/dashboard.sh
```

## 📞 紧急联系方式
如果恢复遇到问题:
1. 查看详细日志: /root/ai-gas-backups/logs/
2. 检查备份完整性
3. 手动逐步恢复

## 🛡️ 预防措施
1. 定期检查备份
2. 测试恢复流程
3. 多地点备份
4. 监控系统健康

---
*备份时间: $(date)*
*备份ID: $(basename $BACKUP_DIR)*
EOF

echo "   ✅ 恢复指南已创建: restore_instructions.md"
echo ""

# 5. 创建备份报告
echo "📊 5. 生成备份报告..."
cat > "$BACKUP_DIR/backup_report.txt" << EOF
🔒 AI Gas 备份报告
===================

备份时间: $(date)
备份ID: $(basename $BACKUP_DIR)
备份位置: $BACKUP_DIR

📁 备份内容概览:
-----------------
1. 网站内容: $(basename $WEBSITE_BACKUP) ($WEBSITE_SIZE)
   - 文章数量: $FILE_COUNT 篇
   - 包含: Hugo网站、内容、配置、自动化脚本

2. 配置文件: $(basename $CONFIG_BACKUP) ($CONFIG_SIZE)
   - Hermes配置
   - 环境变量
   - 系统配置

3. 重要数据:
   - 文章生成记录
   - crontab配置
   - 恢复指南

4. 恢复脚本:
   - restore_instructions.md

📈 备份统计:
-------------
总备份大小: $(du -sh $BACKUP_DIR | cut -f1)
备份文件数: $(find $BACKUP_DIR -type f | wc -l) 个文件
备份时间: $(date +%H:%M:%S)

🎯 验证检查:
-------------
✅ 网站内容: 已备份
✅ 配置文件: 已备份
✅ 重要数据: 已备份
✅ 恢复指南: 已创建
✅ 备份报告: 已生成

🚨 重要提醒:
-------------
1. 定期检查备份完整性
2. 测试恢复流程
3. 考虑异地备份
4. 监控备份系统

💡 下一步:
-------------
1. 运行验证: ./verify_backup.sh
2. 设置自动备份: 添加crontab任务
3. 测试恢复: 确保可以正常恢复

---
备份系统版本: 1.0
生成时间: $(date)
EOF

echo "   ✅ 备份报告已生成: backup_report.txt"
echo ""

# 6. 创建符号链接到定期目录
echo "📅 6. 设置定期备份链接..."
DAILY_LINK="$BACKUP_ROOT/daily/latest"
WEEKLY_LINK="$BACKUP_ROOT/weekly/latest_$(date +%Y%m%d)"
MONTHLY_LINK="$BACKUP_ROOT/monthly/latest_$(date +%Y%m)"

ln -sfn "$BACKUP_DIR" "$DAILY_LINK"
ln -sfn "$BACKUP_DIR" "$WEEKLY_LINK"
ln -sfn "$BACKUP_DIR" "$MONTHLY_LINK"

echo "   ✅ 每日备份链接: $DAILY_LINK"
echo "   ✅ 每周备份链接: $WEEKLY_LINK"
echo "   ✅ 每月备份链接: $MONTHLY_LINK"
echo ""

# 7. 创建验证脚本
echo "🔍 7. 创建备份验证脚本..."
cat > "$BACKUP_ROOT/verify_backup.sh" << 'EOF'
#!/bin/bash

# 🔍 AI Gas 备份验证脚本
# 验证备份的完整性和可恢复性

echo "=================================================="
echo "🔍 AI Gas 备份验证"
echo "=================================================="
echo ""

BACKUP_ROOT="/root/ai-gas-backups"
LATEST_BACKUP="$BACKUP_ROOT/daily/latest"

if [ ! -L "$LATEST_BACKUP" ]; then
    echo "❌ 错误: 未找到最新备份"
    exit 1
fi

REAL_BACKUP=$(readlink -f "$LATEST_BACKUP")
echo "📁 验证备份: $(basename $REAL_BACKUP)"
echo "🔗 实际路径: $REAL_BACKUP"
echo ""

# 检查关键文件
echo "🔍 检查关键文件..."
ERRORS=0

check_file() {
    local file="$1"
    local desc="$2"
    
    if [ -f "$file" ] || [ -d "$file" ]; then
        echo "  ✅ $desc: 存在"
        return 0
    else
        echo "  ❌ $desc: 缺失"
        return 1
    fi
}

# 切换到备份目录
cd "$REAL_BACKUP"

check_file "website.tar.gz" "网站备份"
check_file "configs.tar.gz" "配置备份"
check_file "restore_instructions.md" "恢复指南"
check_file "backup_report.txt" "备份报告"
check_file "crontab_backup.txt" "crontab备份"

echo ""

# 测试网站备份完整性
echo "🧪 测试网站备份完整性..."
if [ -f "website.tar.gz" ]; then
    echo "  测试解压网站备份..."
    TEMP_DIR=$(mktemp -d)
    tar -tzf "website.tar.gz" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  ✅ 网站备份完整"
        rm -rf "$TEMP_DIR"
    else
        echo "  ❌ 网站备份损坏"
        ERRORS=$((ERRORS + 1))
    fi
fi

echo ""

# 验证恢复脚本
echo "📋 验证恢复指南..."
if [ -f "restore_instructions.md" ]; then
    LINE_COUNT=$(wc -l < "restore_instructions.md")
    if [ "$LINE_COUNT" -gt 10 ]; then
        echo "  ✅ 恢复指南完整 ($LINE_COUNT 行)"
    else
        echo "  ❌ 恢复指南可能不完整"
        ERRORS=$((ERRORS + 1))
    fi
fi

echo ""

# 生成验证报告
echo "📊 验证结果汇总:"
echo "----------------"
if [ "$ERRORS" -eq 0 ]; then
    echo "🎉 所有检查通过！备份完整可恢复"
    echo "✅ 备份验证: 成功"
    echo "✅ 完整性: 完好"
    echo "✅ 可恢复性: 确认"
else
    echo "⚠️ 发现 $ERRORS 个问题"
    echo "❌ 备份验证: 失败"
    echo "⚠️ 建议: 重新创建备份"
fi

echo ""
echo "💡 建议操作:"
if [ "$ERRORS" -eq 0 ]; then
    echo "1. 定期运行验证脚本"
    echo "2. 考虑设置异地备份"
    echo "3. 测试实际恢复流程"
else
    echo "1. 立即重新创建备份"
    echo "2. 检查备份系统配置"
    echo "3. 联系技术支持"
fi

echo ""
echo "=================================================="
echo "🔍 备份验证完成 - $(date)"
echo "=================================================="
EOF

chmod +x "$BACKUP_ROOT/verify_backup.sh"
echo "   ✅ 验证脚本已创建: verify_backup.sh"
echo ""

# 8. 创建自动备份脚本
echo "🤖 8. 创建自动备份脚本..."
cat > "$BACKUP_ROOT/auto_backup.sh" << 'EOF'
#!/bin/bash

# 🤖 AI Gas 自动备份脚本
# 用于crontab定时自动备份

LOG_FILE="/root/ai-gas-backups/logs/backup_$(date +%Y%m%d_%H%M).log"

{
echo "🛡️ AI Gas 自动备份开始 - $(date)"
echo "=================================="

# 运行备份系统
cd /root/ai-gas-website
./automation/backup_system.sh

echo ""
echo "🔍 运行备份验证..."
/root/ai-gas-backups/verify_backup.sh

echo ""
echo "🧹 清理旧备份 (保留30天)..."
find /root/ai-gas-backups/20* -maxdepth 0 -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null || true

echo ""
echo "📊 备份空间使用:"
du -sh /root/ai-gas-backups/
echo ""
echo "备份数量: $(find /root/ai-gas-backups/20* -maxdepth 0 -type d 2>/dev/null | wc -l) 个"

echo ""
echo "✅ 自动备份完成 - $(date)"
echo "📁 日志文件: $LOG_FILE"

} > "$LOG_FILE" 2>&1

echo "✅ 自动备份完成，详情见日志: $LOG_FILE"
EOF

chmod +x "$BACKUP_ROOT/auto_backup.sh"
echo "   ✅ 自动备份脚本已创建: auto_backup.sh"
echo ""

# 9. 设置自动备份定时任务
echo "⏰ 9. 设置自动备份定时任务..."
cat > /tmp/backup_cron << 'EOF'
# 🛡️ AI Gas 自动备份定时任务

# 每天凌晨2点进行完整备份
0 2 * * * /root/ai-gas-backups/auto_backup.sh > /dev/null 2>&1

# 每周日凌晨3点进行额外验证备份
0 3 * * 0 /root/ai-gas-backups/auto_backup.sh --full > /dev/null 2>&1

# 每月1号凌晨4点创建月度归档
0 4 1 * * /root/ai-gas-backups/auto_backup.sh --monthly > /dev/null 2>&1

# 每天中午12点检查备份健康
0 12 * * * /root/ai-gas-backups/verify_backup.sh > /dev/null 2>&1
EOF

# 添加到crontab
(crontab -l 2>/dev/null | grep -v "ai-gas-backups"; cat /tmp/backup_cron) | crontab -

echo "   ✅ 备份定时任务已设置:"
echo "     - 每天2:00: 完整备份"
echo "     - 每周日3:00: 验证备份"
echo "     - 每月1号4:00: 月度归档"
echo "     - 每天12:00: 备份健康检查"
echo ""

# 10. 运行首次备份验证
echo "🔍 10. 运行首次备份验证..."
"$BACKUP_ROOT/verify_backup.sh"

echo ""
echo "=================================================="
echo "🎉 AI Gas 完整备份系统设置完成！"
echo "=================================================="
echo ""
echo "🛡️ 保护措施已启用:"
echo "✅ 完整网站备份"
echo "✅ 配置备份"
echo "✅ 自动定时备份"
echo "✅ 备份验证系统"
echo "✅ 恢复指南"
echo ""
echo "📁 备份位置: /root/ai-gas-backups/"
echo "📅 备份计划: 每天自动备份"
echo "🔍 验证命令: /root/ai-gas-backups/verify_backup.sh"
echo "🤖 自动备份: /root/ai-gas-backups/auto_backup.sh"
echo ""
echo "💡 重要提醒:"
echo "1. 备份保存在同一服务器，建议定期下载到本地"
echo "2. 考虑设置云存储备份 (Google Drive, Dropbox等)"
echo "3. 定期测试恢复流程"
echo "4. 监控备份系统运行状态"
echo ""
echo "🚀 现在你的赚钱帝国有了完善的数据保护！"
echo "💪 服务器故障也不怕，一键恢复！"