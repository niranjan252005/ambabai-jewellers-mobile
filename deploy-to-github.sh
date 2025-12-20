#!/bin/bash

echo "🚀 DEPLOYING AMBABAI JEWELLERS WEBSITE TO GITHUB"
echo "================================================"
echo

echo "📋 This script will help you deploy your website to GitHub"
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed"
    echo "Please install Git from: https://git-scm.com"
    echo
    exit 1
fi

echo "✅ Git is installed"
echo

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

echo
echo "📝 Adding all files to Git..."
git add .

echo
echo "💾 Creating commit..."
git commit -m "Deploy Ambabai Jewellers Website - Complete jewelry store with admin panel"

echo
echo "🌐 NEXT STEPS:"
echo "============"
echo
echo "1. Go to https://github.com and create a new repository"
echo "2. Repository name: ambabai-jewellers-website"
echo "3. Description: Ambabai Jewellers - Premium Jewelry Website"
echo "4. Make it Public (for free hosting)"
echo "5. DO NOT initialize with README"
echo "6. Click 'Create repository'"
echo
echo "7. Copy the repository URL (it will look like):"
echo "   https://github.com/YOUR_USERNAME/ambabai-jewellers-website.git"
echo

read -p "8. Paste your GitHub repository URL here: " repo_url

if [ -z "$repo_url" ]; then
    echo "❌ No URL provided. Please run the script again with the repository URL."
    exit 1
fi

echo
echo "🔗 Adding GitHub remote..."
git remote add origin "$repo_url"

echo
echo "📤 Pushing to GitHub..."
git branch -M main
git push -u origin main

if [ $? -ne 0 ]; then
    echo
    echo "❌ Push failed. This might be due to authentication."
    echo
    echo "🔐 AUTHENTICATION HELP:"
    echo "====================="
    echo "If prompted for credentials:"
    echo "- Username: Your GitHub username"
    echo "- Password: Use Personal Access Token (NOT your GitHub password)"
    echo
    echo "To create Personal Access Token:"
    echo "1. Go to GitHub Settings → Developer settings → Personal access tokens"
    echo "2. Generate new token (classic)"
    echo "3. Select 'repo' scope"
    echo "4. Copy token and use as password"
    echo
    exit 1
fi

echo
echo "🎉 SUCCESS! Your website is now on GitHub!"
echo "=========================================="
echo
echo "📍 Your repository: $repo_url"
echo
echo "🌐 NEXT: GET YOUR LIVE WEBSITE LINK"
echo "==================================="
echo
echo "Choose a hosting platform:"
echo
echo "1. RAILWAY (Recommended - Free, Easy)"
echo "   → Go to: https://railway.app"
echo "   → Sign up with GitHub"
echo "   → Deploy from GitHub repo"
echo "   → Select your repository"
echo "   → Get live link in 2 minutes!"
echo
echo "2. RENDER (Professional)"
echo "   → Go to: https://render.com"
echo "   → Connect GitHub repository"
echo "   → Auto-deploy with render.yaml"
echo
echo "3. VERCEL (Instant)"
echo "   → Go to: https://vercel.com"
echo "   → Import GitHub repository"
echo "   → Instant deployment"
echo
echo "📖 Read GITHUB_DEPLOYMENT.md for detailed instructions"
echo
echo "🏪 Your Ambabai Jewellers website will be live soon!"
echo