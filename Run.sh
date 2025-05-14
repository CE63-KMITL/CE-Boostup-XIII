#!/bin/bash

echo "======================================================="
echo "         🚀 CE Boostup XIII - Starting System 🚀"
echo "======================================================="
echo

echo "🔄 Pulling latest data from Git repositories..."
echo

echo "Plan (self) repository..."
git pull
echo "✅ Plan (self) updated"
echo

echo "Backend repository..."
cd ./CE-Boostup-XIII-Backend
git pull origin dev
cd ..
echo "✅ Backend updated"
echo

echo "Frontend repository..."
cd ./CE-Boostup-XIII-Frontend
git pull origin dev
cd ..
echo "✅ Frontend updated"
echo

echo "Compiler repository..."
cd ./CE-Boostup-XIII-Compiler
git pull
cd ..
echo "✅ Compiler updated"
echo

echo "======================================================="
echo "     🐳 Managing Docker Containers 🐳"
echo "======================================================="
echo
echo "   ⏬ Stopping existing containers (if any)..."
sudo docker compose down
echo
echo "   ⏫ Starting and rebuilding containers..."
echo
sudo docker compose up --force-recreate --build
echo
