#!/bin/bash
# Simple push script for AI Gas website

echo "🚀 AI Gas Website Push Script"
echo "=============================="

if [ $# -lt 1 ]; then
    echo "Usage: $0 <github-username> [repository-name]"
    echo "Example: $0 yourusername ai-gas-website"
    exit 1
fi

USERNAME=$1
REPO=${2:-"ai-gas-website"}

echo "📦 Building website..."
hugo --minify

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "💾 Committing changes..."
git add .
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')" || true

echo "🔗 Setting remote..."
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/$USERNAME/$REPO.git

echo "📤 Pushing to GitHub..."
git branch -M main
git push -u origin main --force

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Website deployed."
    echo ""
    echo "🌐 Your website URLs:"
    echo "   GitHub Pages: https://$USERNAME.github.io/$REPO/"
    echo "   Custom domain: https://aigas.top"
    echo ""
    echo "📊 Check deployment status:"
    echo "   https://github.com/$USERNAME/$REPO/actions"
    echo "   https://github.com/$USERNAME/$REPO/settings/pages"
    echo ""
    echo "💰 Monetization ready:"
    echo "   - AdSense: ca-pub-4630162780874150"
    echo "   - Affiliate links configured"
    echo "   - SEO optimized"
else
    echo "❌ Push failed"
    echo "Check:"
    echo "1. Repository exists: https://github.com/$USERNAME/$REPO"
    echo "2. You have push permissions"
    echo "3. Internet connection"
fi
