#!/bin/bash

# DocXpress Startup Script
# Starts both backend and frontend servers in separate terminal windows/tabs

set -e

PROJECT_DIR="/home/ranesh/MY_APPS/DocXpress"

echo "================================================"
echo "DocXpress - Starting Application"
echo "================================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK is not installed. Please install Flutter SDK first."
    exit 1
fi

echo "✓ Node.js found: $(node --version)"
echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Install backend dependencies if needed
if [ ! -d "$PROJECT_DIR/node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    cd "$PROJECT_DIR"
    npm install
    echo "✓ Backend dependencies installed"
    echo ""
fi

# Install Flutter dependencies if needed
if [ ! -d "$PROJECT_DIR/flutter_app/pubspec.lock" ]; then
    echo "📦 Installing Flutter dependencies..."
    cd "$PROJECT_DIR/flutter_app"
    flutter pub get
    echo "✓ Flutter dependencies installed"
    echo ""
fi

echo "================================================"
echo "🚀 Starting Services"
echo "================================================"
echo ""

# Start backend in new terminal
echo "📌 Starting Backend Server..."
echo "   Command: cd $PROJECT_DIR && npm start"
echo "   Running on: http://localhost:5000"
echo ""

# Try to open new terminal for backend
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "cd '$PROJECT_DIR' && npm start; bash"
elif command -v konsole &> /dev/null; then
    konsole -e bash -c "cd '$PROJECT_DIR' && npm start; bash" &
elif command -v xterm &> /dev/null; then
    xterm -hold -e bash -c "cd '$PROJECT_DIR' && npm start" &
else
    echo "⚠️  Could not open new terminal for backend. Starting in background..."
    cd "$PROJECT_DIR"
    npm start &
fi

sleep 3

echo ""
echo "📌 Starting Flutter App..."
echo "   Command: cd $PROJECT_DIR/flutter_app && flutter run"
echo ""

# Try to open new terminal for frontend
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "cd '$PROJECT_DIR/flutter_app' && flutter run; bash"
elif command -v konsole &> /dev/null; then
    konsole -e bash -c "cd '$PROJECT_DIR/flutter_app' && flutter run; bash" &
elif command -v xterm &> /dev/null; then
    xterm -hold -e bash -c "cd '$PROJECT_DIR/flutter_app' && flutter run" &
else
    echo "⚠️  Could not open new terminal for frontend. Please run manually:"
    echo "   cd $PROJECT_DIR/flutter_app && flutter run"
fi

echo ""
echo "================================================"
echo "✅ Services are starting!"
echo "================================================"
echo ""
echo "📋 API Health Check:"
echo "   curl http://localhost:5000/health"
echo ""
echo "📝 Notes:"
echo "   - Backend: http://localhost:5000"
echo "   - Check terminal windows for status"
echo "   - Press Ctrl+C in any terminal to stop that service"
echo ""
