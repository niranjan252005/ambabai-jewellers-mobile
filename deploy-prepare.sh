#!/bin/bash

echo "🚀 PREPARING AMBABAI JEWELLERS WEBSITE FOR DEPLOYMENT"
echo "================================================"
echo

echo "📁 Creating deployment package..."
echo

# Create deployment folder
mkdir -p deployment

# Copy all necessary files
echo "✅ Copying backend files..."
cp -r backend deployment/

echo "✅ Copying configuration files..."
cp package.json deployment/
cp vercel.json deployment/
cp netlify.toml deployment/
cp render.yaml deployment/
cp railway.json deployment/
cp Procfile deployment/

echo "✅ Copying documentation..."
cp DEPLOYMENT_GUIDE.md deployment/
cp COMPLETE_WEBSITE_READY.md deployment/
cp README.md deployment/

echo
echo "🎉 DEPLOYMENT PACKAGE READY!"
echo "================================"
echo
echo "📂 Your deployment files are in the 'deployment' folder"
echo
echo "🌐 NEXT STEPS:"
echo "1. Go to https://railway.app (RECOMMENDED - FREE & EASY)"
echo "2. Sign up with GitHub"
echo "3. Create new project"
echo "4. Upload the 'deployment' folder contents"
echo "5. Get your live website link!"
echo
echo "📖 Read DEPLOYMENT_GUIDE.md for detailed instructions"
echo
echo "🏪 Your Ambabai Jewellers website will be live soon!"
echo