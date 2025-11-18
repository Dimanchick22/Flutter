#!/bin/bash

# Planner+ Setup Script for Arch Linux
# This script helps set up the Flutter development environment on Arch Linux

set -e

echo "============================================"
echo "Planner+ - Setup for Arch Linux"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}Flutter is not installed!${NC}"
    echo ""
    echo "To install Flutter on Arch Linux, run:"
    echo "  yay -S flutter"
    echo "or"
    echo "  paru -S flutter"
    echo ""
    echo "For manual installation:"
    echo "1. Download Flutter SDK: https://flutter.dev/docs/get-started/install/linux"
    echo "2. Extract to your preferred location"
    echo "3. Add Flutter to PATH in ~/.bashrc or ~/.zshrc:"
    echo "   export PATH=\"\$PATH:/path/to/flutter/bin\""
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Flutter is installed${NC}"
flutter --version
echo ""

# Check if Android SDK is installed
if ! command -v adb &> /dev/null; then
    echo -e "${YELLOW}⚠ Android SDK is not installed${NC}"
    echo "To install Android SDK on Arch Linux:"
    echo "  yay -S android-sdk android-sdk-platform-tools"
    echo ""
    echo "You can still run the app on web or Linux desktop."
    echo ""
else
    echo -e "${GREEN}✓ Android SDK is installed${NC}"
fi

# Check if Chrome/Chromium is installed (for web development)
if command -v google-chrome-stable &> /dev/null || command -v chromium &> /dev/null; then
    echo -e "${GREEN}✓ Chrome/Chromium is installed (for web development)${NC}"
else
    echo -e "${YELLOW}⚠ Chrome/Chromium not found${NC}"
    echo "Install with: sudo pacman -S chromium"
    echo ""
fi

# Clean previous build
echo ""
echo "Cleaning previous build..."
flutter clean

# Install Flutter dependencies
echo ""
echo "Installing Flutter dependencies..."
if ! flutter pub get; then
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    echo ""
    echo "If you see version conflicts, try:"
    echo "  flutter pub cache clean"
    echo "  flutter pub get"
    echo ""
    exit 1
fi

# Generate code
echo ""
echo "Generating code..."
if ! flutter pub run build_runner build --delete-conflicting-outputs; then
    echo -e "${YELLOW}⚠ Code generation failed, but this might be okay${NC}"
    echo "You can try running it manually later:"
    echo "  flutter pub run build_runner build --delete-conflicting-outputs"
    echo ""
fi

# Check for Flutter doctor issues
echo ""
echo "Running Flutter doctor..."
flutter doctor

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Available commands:"
echo "  flutter run -d linux     # Run on Linux desktop"
echo "  flutter run -d chrome    # Run on web browser"
echo "  flutter run -d android   # Run on Android device/emulator"
echo "  flutter test             # Run tests"
echo "  flutter analyze          # Analyze code"
echo ""
echo "For web development:"
echo "  flutter run -d web-server --web-port 8080"
echo ""
echo "To build APK:"
echo "  flutter build apk --release"
echo ""
