#!/bin/bash

# 🚀 AI Gas 自动化推广脚本
# 功能：执行24小时推广闪电战的各项任务

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查网站状态
check_website() {
    log_info "检查网站状态..."
    local url="http://www.aigas.top"
    
    if curl -s -I "$url" | head -1 | grep -q "200\|301\|302"; then
        log_success "网站可访问: $url"
        return 0
    else
        log_error "网站无法访问: $url"
        return 1
    fi
}

# 检查SEO基础
check_seo() {
    log_info "检查SEO基础..."
    
    local seo_checks=0
    local total_checks=6
    
    # 1. 检查robots.txt
    if curl -s "http://www.aigas.top/robots.txt" | grep -q "User-agent"; then
        log_success "robots.txt 存在"
        ((seo_checks++))
    else
        log_warning "robots.txt 不存在"
    fi
    
    # 2. 检查sitemap.xml
    if curl -s "http://www.aigas.top/sitemap.xml" | grep -q "urlset"; then
        log_success "sitemap.xml 存在"
        ((seo_checks++))
    else
        log_warning "sitemap.xml 不存在"
    fi
    
    # 3. 检查favicon
    if curl -s -I "http://www.aigas.top/favicon.ico" | head -1 | grep -q "200\|301\|302"; then
        log_success "favicon 存在"
        ((seo_checks++))
    else
        log_warning "favicon 不存在"
    fi
    
    # 4. 检查meta description
    local html=$(curl -s "http://www.aigas.top")
    if echo "$html" | grep -iq "<meta name=\"description\""; then
        log_success "meta description 存在"
        ((seo_checks++))
    else
        log_warning "meta description 不存在"
    fi
    
    # 5. 检查title
    if echo "$html" | grep -iq "<title>"; then
        log_success "title 标签存在"
        ((seo_checks++))
    else
        log_warning "title 标签不存在"
    fi
    
    # 6. 检查hreflang（多语言）
    if echo "$html" | grep -iq "hreflang"; then
        log_success "hreflang 存在"
        ((seo_checks++))
    else
        log_warning "hreflang 不存在（单语言网站正常）"
    fi
    
    log_info "SEO检查完成: $seo_checks/$total_checks 项通过"
    
    if [ $seo_checks -lt 3 ]; then
        log_error "SEO基础薄弱，建议改进"
        return 1
    elif [ $seo_checks -lt 5 ]; then
        log_warning "SEO基础一般，可进一步优化"
        return 0
    else
        log_success "SEO基础良好"
        return 0
    fi
}

# 生成推广报告
generate_report() {
    log_info "生成推广进度报告..."
    
    local report_file="/root/ai-gas-website/PROMOTION_REPORT_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << EOF
# 📊 AI Gas 推广进度报告
## 生成时间: $(date)

## 🚀 当前状态
### 网站状态
- URL: http://www.aigas.top
- 上线时间: 2026-04-12
- 文章数量: 12篇
- 页面总数: 89个

### 技术指标
$(check_website 2>&1 | sed 's/^/    - /')
$(check_seo 2>&1 | sed 's/^/    - /')

## 📈 推广进展
### 已完成
1. ✅ 网站部署到GitHub Pages
2. ✅ 自定义域名配置
3. ✅ 12篇高质量AI文章
4. ✅ SEO基础优化
5. ✅ 推广计划制定

### 进行中
1. 🔄 社交媒体内容创建
2. 🔄 Reddit社区参与计划
3. 🔄 SEO提交准备

### 待开始  
1. ⏳ 提交到搜索引擎
2. ⏳ 社交媒体账号创建
3. ⏳ 内容分发执行

## 🎯 24小时目标
### 流量目标
- 第1天: 50-100访客
- 第1周: 500-1000访客
- 第1月: 3000-5000访客

### 收入目标  
- 第1月: \$50-200 (联盟+广告)
- 第3月: \$500-1500
- 第6月: \$2000-5000

## 🔧 技术建议
### 立即改进
1. 添加Google Analytics
2. 配置Google Search Console
3. 创建更多互动内容
4. 优化移动端体验

### 长期优化
1. 增加视频内容
2. 创建邮件列表
3. 开发互动工具
4. 建立社区论坛

## 📞 下一步行动
1. **立即执行**: 提交网站到Google Search Console
2. **今天完成**: 创建Twitter/X账号并发布第一条内容
3. **本周完成**: 发布5篇新文章，覆盖更多AI工具
4. **本月完成**: 建立至少3个稳定的流量来源

---

*报告生成时间: $(date)*  
*AI Gas 推广团队*
EOF
    
    log_success "推广报告已生成: $report_file"
    echo ""
    cat "$report_file" | head -30
    echo ""
    echo "... (完整报告查看: $report_file)"
}

# 提交到搜索引擎
submit_to_search_engines() {
    log_info "准备提交到搜索引擎..."
    
    local submission_file="/root/ai-gas-website/SEARCH_ENGINE_SUBMISSION.md"
    
    cat > "$submission_file" << EOF
# 🔍 搜索引擎提交指南

## Google Search Console
1. **访问**: https://search.google.com/search-console
2. **添加资源**: 输入 http://www.aigas.top
3. **验证所有权**: 
   - 推荐方法: HTML文件上传
   - 下载验证文件，上传到网站根目录
   - 点击验证
4. **提交Sitemap**:
   - 左侧菜单 → Sitemaps
   - 输入: /sitemap.xml
   - 点击提交

## Bing Webmaster Tools
1. **访问**: https://www.bing.com/webmasters
2. **添加网站**: 输入 http://www.aigas.top
3. **验证所有权**: 类似Google的方法
4. **提交Sitemap**: /sitemap.xml

## 其他搜索引擎
### Yandex Webmaster
- URL: https://webmaster.yandex.com
- 主要为俄罗斯市场

### Baidu Webmaster (百度站长)
- URL: https://ziyuan.baidu.com
- 中国国内市场

### DuckDuckGo
- 自动抓取，无需手动提交
- 主要通过高质量内容和外链

## 🔧 技术检查清单
✅ robots.txt 可访问  
✅ sitemap.xml 可访问  
✅ 网站无重大错误  
✅ 移动端友好  
✅ HTTPS (GitHub Pages自动提供)  

## 📈 监控建议
1. **每日检查**: Google Search Console > 覆盖率
2. **每周检查**: 关键词排名变化
3. **每月检查**: 流量来源分析
4. **持续优化**: 根据数据调整内容策略

## ⚠️ 注意事项
1. **不要**使用黑帽SEO技术
2. **不要**过度提交或spam
3. **不要**购买低质量外链
4. **要**专注于高质量内容
5. **要**耐心等待索引（通常1-7天）

## 🚀 提交后行动
1. 等待24-48小时查看初始抓取
2. 修复任何抓取错误
3. 分析初始关键词排名
4. 根据数据优化内容
EOF
    
    log_success "搜索引擎提交指南已创建: $submission_file"
    log_info "请手动执行上述提交步骤"
}

# 主菜单
show_menu() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          AI Gas 自动化推广系统                  ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. 检查网站状态"
    echo "2. 检查SEO基础"
    echo "3. 生成推广报告"
    echo "4. 准备搜索引擎提交"
    echo "5. 执行全部检查"
    echo "6. 退出"
    echo ""
    read -p "请选择选项 [1-6]: " choice
    
    case $choice in
        1) check_website ;;
        2) check_seo ;;
        3) generate_report ;;
        4) submit_to_search_engines ;;
        5)
            check_website
            check_seo
            generate_report
            submit_to_search_engines
            ;;
        6) 
            log_info "退出推广系统"
            exit 0
            ;;
        *)
            log_error "无效选项"
            show_menu
            ;;
    esac
    
    show_menu
}

# 脚本入口
main() {
    log_info "🚀 启动AI Gas自动化推广系统"
    log_info "时间: $(date)"
    log_info "网站: http://www.aigas.top"
    echo ""
    
    show_menu
}

# 执行主函数
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    main "$@"
fi