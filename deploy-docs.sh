#!/bin/bash
# Deploy Hugo site to GitHub Pages (docs folder method)

echo "🚀 Building Hugo site..."
hugo --minify

echo "📁 Copying to docs folder..."
rm -rf docs
cp -r public docs

echo "📄 Creating Jekyll disable config..."
cat > docs/_config.yml << EOF
# Disable Jekyll processing
safe: true
plugins: []
theme: null
EOF

echo "✅ Ready for GitHub Pages deployment!"
echo ""
echo "📋 Next steps:"
echo "1. git add ."
echo "2. git commit -m 'Deploy to GitHub Pages'"
echo "3. git push"
echo ""
echo "🔗 Enable GitHub Pages:"
echo "   Go to Settings > Pages"
echo "   Source: Deploy from a branch"
echo "   Branch: main"
echo "   Folder: /docs"
echo "   Save"
