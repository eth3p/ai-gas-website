
# OrrisAI Show Me The Money 自动化命令清单

## 立即执行的命令:
1. /money content "为AI Gas网站生成5篇最新的AI工具评测文章"
2. /money social "在Twitter/X, LinkedIn, Reddit推广AI Gas网站内容"
3. /money seo "优化AI Gas网站的关键词排名和SEO结构"
4. /money ops "设置24小时网站监控和自动内容更新"
5. /money finance "设置AI Gas网站的收入追踪和报告系统"

## 定时任务 (通过cron):
6. 每日内容生成: hermes cron add "ai_gas_daily_content" "0 8 * * *" "/money content '为AI Gas网站生成2篇新文章'" deliver="telegram"
7. 每日推广: hermes cron add "ai_gas_daily_social" "0 12 * * *" "/money social '发布3个社交媒体帖子推广AI工具评测'" deliver="telegram"
8. 每周SEO检查: hermes cron add "ai_gas_weekly_seo" "0 10 * * 1" "/money seo '运行每周SEO优化检查'" deliver="telegram"
9. 每日监控: hermes cron add "ai_gas_daily_monitor" "*/30 * * * *" "/money ops '检查网站状态和收入'" deliver="telegram"

## 收入自动化:
10. /money ads "设置AI Gas网站的Google AdSense优化"
11. /money product "创建AI工具评测报告数字产品"
12. /money outreach "联系AI工具公司获取联盟合作"
