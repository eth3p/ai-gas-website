#!/bin/bash
# Push to GitHub script

if [ -z "$1" ]; then
    echo "Usage: $0 <github-username>"
    echo "Example: $0 yourusername"
    exit 1
fi

USERNAME=$1
REPO="ai-gas-website"

echo "🚀 Pushing to GitHub..."
git remote add origin https://github.com/$USERNAME/$REPO.git 2>/dev/null || true
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Success! Your website is pushed to GitHub."
    echo ""
    echo "📋 Next:"
    echo "1. Visit https://github.com/$USERNAME/$REPO/settings/pages"
    echo "2. Enable GitHub Pages (source: main branch, /public folder)"
    echo "3. Wait a few minutes for deployment"
    echo "4. Your site will be at: https://$USERNAME.github.io/$REPO/"
    echo "5. Or custom domain: https://aigas.top"
else
    echo "❌ Push failed. Check your GitHub repository URL and permissions."
fi
