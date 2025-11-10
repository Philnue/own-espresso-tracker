#!/bin/bash

echo "🔧 Xcode Project Setup Helper"
echo "================================"
echo ""

# Check if we're in the git repo
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in git repository root"
    echo "Run this script from: /path/to/own-espresso-tracker/"
    exit 1
fi

# Check if xcodeproj already exists
if [ -d "EspressoTracker.xcodeproj" ]; then
    echo "✅ Xcode project already exists in correct location!"
    echo ""
    echo "Next steps:"
    echo "1. Open EspressoTracker.xcodeproj in Xcode"
    echo "2. Delete default generated files"
    echo "3. Add files from EspressoTracker/ folder"
    echo ""
    echo "See XCODE_PROJECT_SETUP.md for detailed instructions."
    exit 0
fi

# Check if EspressoTracker folder exists
if [ ! -d "EspressoTracker" ]; then
    echo "❌ Error: EspressoTracker folder not found"
    echo "Make sure you've pulled the latest code:"
    echo "  git pull origin claude/espresso-brewing-app-011CUzoSym5ydC22XsKUDoJh"
    exit 1
fi

echo "📍 Current location: $(pwd)"
echo ""
echo "✅ Ready to create Xcode project here!"
echo ""
echo "Next steps:"
echo ""
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Choose: iOS → App"
echo "4. Configure:"
echo "   - Product Name: EspressoTracker"
echo "   - Interface: SwiftUI"
echo "   - Storage: Core Data"
echo "   - Uncheck: 'Create Git repository'"
echo "5. Save to: $(pwd)"
echo ""
echo "Then follow: XCODE_PROJECT_SETUP.md"
echo ""
