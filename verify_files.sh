#!/bin/bash
# Verify all required files are present

echo "🔍 Verifying EspressoTracker files..."
echo ""

missing=0

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ MISSING: $1"
        ((missing++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $1/"
    else
        echo "❌ MISSING DIR: $1/"
        ((missing++))
    fi
}

echo "📱 Core Files:"
check_file "EspressoTracker/EspressoTrackerApp.swift"
check_file "EspressoTracker/ContentView.swift"
check_file "EspressoTracker/Info.plist"
echo ""

echo "🗄️ Data Layer:"
check_file "EspressoTracker/Core/Persistence.swift"
check_file "EspressoTracker/Models/Grinder+CoreDataClass.swift"
check_file "EspressoTracker/Models/Machine+CoreDataClass.swift"
check_file "EspressoTracker/Models/Bean+CoreDataClass.swift"
check_file "EspressoTracker/Models/BrewingSession+CoreDataClass.swift"
check_dir "EspressoTracker/EspressoTracker.xcdatamodeld"
echo ""

echo "🧠 ViewModels:"
check_file "EspressoTracker/ViewModels/DataManager.swift"
check_file "EspressoTracker/ViewModels/BrewingViewModel.swift"
echo ""

echo "🎨 UI Components:"
check_file "EspressoTracker/Components/CustomButton.swift"
check_file "EspressoTracker/Components/CustomCard.swift"
check_file "EspressoTracker/Theme/ColorTheme.swift"
echo ""

echo "📺 Views:"
check_dir "EspressoTracker/Views/Brewing"
check_dir "EspressoTracker/Views/Equipment"
check_dir "EspressoTracker/Views/Beans"
check_dir "EspressoTracker/Views/History"
echo ""

echo "📚 Documentation:"
check_file "README.md"
check_file "ARCHITECTURE.md"
check_file "QUICK_START.md"
check_file "INSTALLATION_GUIDE.md"
echo ""

if [ $missing -eq 0 ]; then
    echo "✅ All files present! Ready to add to Xcode."
else
    echo "⚠️  $missing file(s) missing. Run 'git pull' to get them."
fi
