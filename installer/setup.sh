#!/bin/bash

echo "========================================"
echo "   Jewelry Mobile App - Quick Setup"
echo "========================================"
echo

echo "[1/3] Setting up Backend Server..."
cd backend
echo "Installing backend dependencies..."
npm install
echo

echo "Initializing database with sample data..."
node install.js
echo

echo "Starting backend server in background..."
npm start &
echo "Backend server started on http://localhost:3000"
echo

echo "[2/3] Checking Flutter Installation..."
if ! command -v flutter &> /dev/null; then
    echo
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    echo "Then run this script again."
    exit 1
fi

flutter --version
echo

echo "[3/3] Setting up Mobile App..."
cd ../mobile
echo "Installing Flutter dependencies..."
flutter pub get
echo

echo "========================================"
echo "    Setup Complete! 🎉"
echo "========================================"
echo
echo "Your jewelry app is ready to run!"
echo
echo "Backend Server: http://localhost:3000"
echo "Login: admin@jewelry.com / admin123"
echo
echo "To run the mobile app:"
echo "  cd mobile"
echo "  flutter run"
echo
echo "Press Enter to continue..."
read