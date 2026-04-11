#!/bin/bash
# AI Gas Website Deployment Script
# Run this script to deploy your website to GitHub Pages

set -e

echo "🚀 AI Gas Website Deployment"
echo "=============================="

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

if ! command -v hugo &> /dev/null; then
    echo "❌ Hugo is not installed. Please install Hugo: https://gohugo.io/installation/"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Build the site
echo "📦 Building website..."
hugo --minify

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Check Hugo errors above."
    exit 1
fi

echo "✅ Website built successfully"

# Check if already a git repo
if [ ! -d ".git" ]; then
    echo "🔧 Initializing Git repository..."
    git init
    git config user.email "admin@aigas.top"
    git config user.name "AI Gas Admin"
fi

# Create .gitignore if not exists
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << EOF
# Hugo
/public/
/resources/_gen/
/assets/jsconfig.json
hugo_stats.json

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
EOF
fi

# Add and commit
echo "💾 Committing changes..."
git add .
git commit -m "Deploy AI Gas website $(date '+%Y-%m-%d %H:%M:%S')"

echo ""
echo "✅ Local deployment ready!"
echo ""
echo "📋 NEXT STEPS:"
echo "=============="
echo "1. Create a new repository on GitHub:"
echo "   Visit https://github.com/new"
echo "   Repository name: ai-gas-website"
echo "   Description: AI Gas - AI Tools Reviews, Tutorials & Guides"
echo "   Public repository"
echo "   DO NOT initialize with README"
echo ""
echo "2. Connect local repository to GitHub:"
echo "   Run these commands:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/ai-gas-website.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   Go to Repository Settings > Pages"
echo "   Source: Deploy from a branch"
echo "   Branch: main, folder: /public"
echo "   Save"
echo ""
echo "4. Set custom domain (optional):"
echo "   Add custom domain: aigas.top"
echo "   Update DNS records to point to GitHub Pages"
echo ""
echo "💰 MONETIZATION SETUP:"
echo "======================"
echo "1. Google AdSense: Already configured with your ID"
echo "2. ChatGPT Affiliate: Sign up at https://platform.openai.com/affiliates"
echo "3. Midjourney Affiliate: Apply at https://www.midjourney.com/affiliates"
echo "4. Amazon Associates: Join at https://affiliate-program.amazon.com"
echo ""
echo "📊 For help, visit: https://aigas.top/about/"
echo ""

# Create push script
cat > push-to-github.sh << 'EOF'
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
EOF

chmod +x push-to-github.sh

echo "📁 Created deployment script: ./push-to-github.sh"
echo "📁 Usage: ./push-to-github.sh YOUR_GITHUB_USERNAME"
echo ""
echo "🌐 Your website will be live at:"
echo "   https://YOUR_USERNAME.github.io/ai-gas-website/"
echo "   or https://aigas.top (with custom domain)"
