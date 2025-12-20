#!/bin/bash

echo "🚀 DEPLOYING AMBABAI JEWELLERS TO RAILWAY"
echo "=========================================="

echo ""
echo "📋 Step 1: Installing Railway CLI..."
npm install -g @railway/cli

echo ""
echo "📋 Step 2: Login to Railway..."
echo "Please login to Railway in your browser when prompted"
railway login

echo ""
echo "📋 Step 3: Creating new Railway project..."
cd backend
railway init

echo ""
echo "📋 Step 4: Deploying to Railway..."
railway up

echo ""
echo "✅ DEPLOYMENT COMPLETE!"
echo ""
echo "📱 Your app will be available at: https://your-project-name.railway.app"
echo "📧 Admin notifications will go to: barwadeniranjan@gmail.com and ambabaijewellers@gmail.com"
echo ""
echo "🔧 Next steps:"
echo "1. Copy your Railway URL"
echo "2. Update mobile app with new server URL"
echo "3. Rebuild mobile app"
echo ""