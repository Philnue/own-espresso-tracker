# Installation Guide - Getting the App Running in Xcode

## Current Situation

You have:
- ✅ Xcode project created (`EspressoTracker.xcodeproj`)
- ✅ Git repository with all the code
- ❓ Need to connect them

Let's get it running!

---

## Step 1: Get Latest Code from Git

Open Terminal and navigate to your project folder:

```bash
cd /path/to/own-espresso-tracker

# Make sure you're on the right branch
git checkout claude/espresso-brewing-app-011CUzoSym5ydC22XsKUDoJh

# Pull the latest changes
git pull origin claude/espresso-brewing-app-011CUzoSym5ydC22XsKUDoJh
```

Now you should have all the Swift files in the `EspressoTracker/` folder.

---

## Step 2: Open Your Xcode Project

1. Open `EspressoTracker.xcodeproj` in Xcode
2. You'll see the default structure Xcode created

---

## Step 3: Remove Default Files (That Xcode Created)

In Xcode's Project Navigator (left sidebar), **delete** these default files:
- `ContentView.swift` (we have a better one)
- `EspressoTrackerApp.swift` (we have our own)
- Any default Core Data model files

**Important**: When deleting, choose "**Move to Trash**" (not just remove reference)

---

## Step 4: Add Our Files to Xcode

### Method A: Drag & Drop (Easiest)

1. In **Finder**, navigate to your project folder
2. Open the `EspressoTracker/` subfolder
3. **Drag these folders** from Finder into Xcode's Project Navigator:
   - `Components/`
   - `Core/`
   - `Models/`
   - `Theme/`
   - `ViewModels/`
   - `Views/`
   - `EspressoTracker.xcdatamodeld/`

4. **Drag these individual files**:
   - `ContentView.swift`
   - `EspressoTrackerApp.swift`
   - `Info.plist`

5. When the dialog appears:
   - ✅ Check "**Copy items if needed**"
   - ✅ Check "**Create groups**" (not folder references)
   - ✅ Make sure your app target is selected
   - Click "**Finish**"

### Method B: Add Files Menu (Alternative)

1. Right-click on the `EspressoTracker` folder in Xcode
2. Choose "**Add Files to 'EspressoTracker'...**"
3. Navigate to your `EspressoTracker/` folder
4. Select all the folders and files
5. Make sure:
   - ✅ "Copy items if needed" is checked
   - ✅ "Create groups" is selected
   - ✅ Your target is checked
6. Click "Add"

---

## Step 5: Verify File Structure

Your Xcode Project Navigator should now look like this:

```
EspressoTracker/
├── EspressoTrackerApp.swift
├── ContentView.swift
├── Components/
│   ├── CustomButton.swift
│   └── CustomCard.swift
├── Core/
│   ├── Persistence.swift
│   └── Persistence-LocalOnly.swift
├── Models/
│   ├── Grinder+CoreDataClass.swift
│   ├── Machine+CoreDataClass.swift
│   ├── Bean+CoreDataClass.swift
│   └── BrewingSession+CoreDataClass.swift
├── Theme/
│   └── ColorTheme.swift
├── ViewModels/
│   ├── DataManager.swift
│   └── BrewingViewModel.swift
├── Views/
│   ├── Brewing/
│   ├── Equipment/
│   ├── Beans/
│   └── History/
├── EspressoTracker.xcdatamodeld/
│   └── EspressoTracker.xcdatamodel
├── Info.plist
└── Assets.xcassets (already there)
```

---

## Step 6: Configure Project Settings

### A. Set Info.plist

1. Click on your project name at the top of Project Navigator
2. Select your target "EspressoTracker"
3. Go to "**Info**" tab
4. Look for "**Custom iOS Target Properties**"
5. Find or add these keys:

**If Info.plist isn't properly configured:**
1. Click on `Info.plist` in Xcode
2. Right-click → "Open As" → "**Source Code**"
3. Make sure it matches the file I created (should already be there)

### B. Set Deployment Target

1. With project selected, go to "**General**" tab
2. Under "**Minimum Deployments**"
3. Set "**iOS**" to **17.0** or higher

### C. Configure Signing

1. Still in "**General**" tab
2. Under "**Signing & Capabilities**"
3. Check "**Automatically manage signing**"
4. Select your "**Team**" (your Apple Developer account)
5. The bundle identifier should be something like: `com.yourname.EspressoTracker`

---

## Step 7: Build Settings

1. Go to "**Build Settings**" tab
2. Search for "**Swift Language Version**"
3. Make sure it's set to **Swift 5** or later

---

## Step 8: Choose Your Storage Option

### Option A: Local-Only (Recommended for Now)

**Replace** `Core/Persistence.swift` with `Core/Persistence-LocalOnly.swift`:

1. In Xcode, find `Persistence.swift` in the `Core/` folder
2. Delete it (Move to Trash)
3. Rename `Persistence-LocalOnly.swift` to `Persistence.swift`

This removes iCloud and keeps everything local!

### Option B: Keep iCloud Sync

If you want iCloud sync:

1. Go to "**Signing & Capabilities**"
2. Click "+ Capability"
3. Add "**iCloud**"
4. Check "**CloudKit**"
5. Set container to: `iCloud.com.espressotracker.app`

**Note**: For iCloud to work, you'll need to change the container identifier to one you own.

---

## Step 9: First Build

1. Select a simulator (iPhone 15 Pro recommended) or your device
2. Press **Cmd + B** to build
3. Wait for it to compile...

### Common Build Errors & Fixes

**Error: "Cannot find type 'Grinder' in scope"**
- **Fix**: Make sure all files in `Models/` are added to your target
- Select each file → File Inspector (right panel) → Check your target

**Error: "No such module 'SwiftUI'"**
- **Fix**: Clean build folder (Cmd + Shift + K), then rebuild

**Error: "Failed to find a unique match for entity 'Grinder'"**
- **Fix**: Make sure `EspressoTracker.xcdatamodeld` is added to target
- Check that there's only one .xcdatamodel file

**Error: Core Data issues**
- **Fix**:
  1. Product → Clean Build Folder (Cmd + Shift + K)
  2. Delete derived data: Xcode → Preferences → Locations → click arrow next to Derived Data
  3. Delete the EspressoTracker folder
  4. Rebuild

---

## Step 10: Run the App! 🚀

1. Press **Cmd + R** to build and run
2. The app should launch in the simulator
3. You'll see the dark mode UI with 4 tabs at the bottom

### First Run Checklist

✅ App launches without crashing
✅ You see 4 tabs: Brew, History, Equipment, Beans
✅ Dark mode is applied
✅ Empty states show up (no data yet)

---

## Step 11: Test the App

### Add Your First Grinder

1. Tap "**Equipment**" tab
2. Tap "**+**" button (top right)
3. Fill in:
   - Name: "My Grinder"
   - Brand: "Test Brand"
   - Burr Type: "Conical"
   - Burr Size: "63"
4. Tap "**Save**"
5. You should see your grinder in the list!

### Add a Machine

1. In Equipment tab, swipe to "**Machines**"
2. Tap "**+**"
3. Fill in details
4. Save

### Add Beans

1. Go to "**Beans**" tab
2. Tap "**+**"
3. Fill in:
   - Name: "Test Beans"
   - Roaster: "Local Roasters"
   - Origin: "Ethiopia"
   - Roast Date: Today's date
4. Save

### Pull Your First Shot!

1. Go to "**Brew**" tab
2. Select your grinder, machine, and beans from dropdowns
3. Enter grind setting (e.g., "15")
4. Enter dose (e.g., "18")
5. Tap "**Start**" to begin timer
6. Let it run for ~25 seconds
7. Tap "**Stop**"
8. Tap "**Finish & Save Shot**"
9. Enter yield out (e.g., "36")
10. Rate it (tap stars)
11. Tap "**Save**"

### Check History

1. Go to "**History**" tab
2. You should see your shot!
3. Tap on it to see full details

---

## Troubleshooting

### App Crashes on Launch

**Check Console Output**:
1. When app crashes, check Xcode's console (bottom panel)
2. Look for error messages

**Common causes**:
- Core Data model not loaded → Check .xcdatamodeld is in target
- Missing files → Verify all Swift files are added
- Info.plist issues → Make sure Info.plist is properly configured

### Data Not Saving

**Check**:
1. Core Data model is correct
2. Persistence.swift is properly set up
3. Console shows no save errors

**Fix**:
1. Reset simulator: Device → Erase All Content and Settings
2. Rebuild and run

### UI Looks Wrong

**Check**:
1. Dark mode is enabled (should be in Info.plist)
2. Color theme file is loaded
3. Try different simulator

### Preview Crashes

**Fix**:
1. Make sure `PersistenceController.preview` is set up
2. Check that preview code has proper context
3. Try: Product → Clean Build Folder

---

## Quick Reference Commands

```bash
# Clean build
Cmd + Shift + K

# Build
Cmd + B

# Run
Cmd + R

# Stop
Cmd + .

# Open simulator device menu
Cmd + Shift + 2

# Show/hide console
Cmd + Shift + Y

# Show/hide navigator
Cmd + 0
```

---

## File Checklist

Make sure these files are in Xcode with target membership:

**App Entry:**
- [x] EspressoTrackerApp.swift
- [x] ContentView.swift
- [x] Info.plist

**Data Layer:**
- [x] Core/Persistence.swift (or Persistence-LocalOnly.swift)
- [x] Models/Grinder+CoreDataClass.swift
- [x] Models/Machine+CoreDataClass.swift
- [x] Models/Bean+CoreDataClass.swift
- [x] Models/BrewingSession+CoreDataClass.swift
- [x] EspressoTracker.xcdatamodeld/

**ViewModels:**
- [x] ViewModels/DataManager.swift
- [x] ViewModels/BrewingViewModel.swift

**Views:**
- [x] Views/Brewing/BrewingView.swift
- [x] Views/Brewing/FinishBrewView.swift
- [x] Views/Equipment/EquipmentView.swift
- [x] Views/Equipment/GrinderListView.swift
- [x] Views/Equipment/AddGrinderView.swift
- [x] Views/Equipment/GrinderDetailView.swift
- [x] Views/Equipment/EditGrinderView.swift
- [x] Views/Equipment/MachineListView.swift
- [x] Views/Equipment/AddMachineView.swift
- [x] Views/Equipment/MachineDetailView.swift
- [x] Views/Equipment/EditMachineView.swift
- [x] Views/Beans/BeansView.swift
- [x] Views/Beans/AddBeanView.swift
- [x] Views/Beans/BeanDetailView.swift
- [x] Views/Beans/EditBeanView.swift
- [x] Views/History/HistoryView.swift
- [x] Views/History/SessionDetailView.swift

**Components:**
- [x] Components/CustomButton.swift
- [x] Components/CustomCard.swift

**Theme:**
- [x] Theme/ColorTheme.swift

---

## Success! 🎉

If you made it here and the app is running, congratulations! You now have a fully functional espresso tracking app.

### Next Steps

1. **Add your real equipment** in the Equipment tab
2. **Add your current beans** in the Beans tab
3. **Pull a shot** and track it!
4. **Check out the statistics** in History

### Need Help?

- Check the console for error messages
- Review PROJECT_SUMMARY.md for architecture details
- Read ARCHITECTURE.md for deep technical info
- See QUICK_START.md for usage tips

---

## Optional: Enable iCloud Sync (Later)

When you're ready to add iCloud:

1. Sign up for Apple Developer Program ($99/year)
2. Create your own CloudKit container
3. Update the container identifier in Persistence.swift
4. Add iCloud capability in Xcode
5. Test on multiple devices

For now, local storage works perfectly!

---

**Enjoy tracking your espresso journey!** ☕✨
