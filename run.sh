#!/bin/bash

# Planner+ Quick Run Script
# Detects available devices and runs the app

set -e

echo "Planner+ - Quick Run"
echo "===================="
echo ""

# Check available devices
echo "Checking available devices..."
flutter devices

echo ""
echo "Select platform:"
echo "1) Linux Desktop"
echo "2) Web Browser"
echo "3) Android Device/Emulator"
echo "4) List devices and exit"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "Running on Linux Desktop..."
        flutter run -d linux
        ;;
    2)
        echo "Running on Web Browser..."
        flutter run -d chrome --web-renderer html
        ;;
    3)
        echo "Running on Android..."
        flutter run
        ;;
    4)
        flutter devices
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
