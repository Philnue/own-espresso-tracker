# 🚀 Quick Install - 5 Minutes to Running App

Follow these exact steps to get the app running:

## Step 1: Get Latest Code (30 seconds)

```bash
cd /path/to/own-espresso-tracker
git checkout claude/espresso-brewing-app-011CUzoSym5ydC22XsKUDoJh
git pull
```

## Step 2: Verify Files (30 seconds)

```bash
./verify_files.sh
```

Should show ✅ for all files.

## Step 3: Open Xcode (10 seconds)

Open `EspressoTracker.xcodeproj`

## Step 4: Add Files to Xcode (2 minutes)

### Drag & Drop Method:

1. Open **Finder** → Navigate to project folder
2. Open the `EspressoTracker/` subfolder
3. In Xcode, **delete** the default files:
   - Delete default `ContentView.swift`
   - Delete default `EspressoTrackerApp.swift`
   - Delete any default Core Data files

4. **Drag these folders** from Finder to Xcode's left panel:
   ```
   Components/
   Core/
   Models/
   Theme/
   ViewModels/
   Views/
   EspressoTracker.xcdatamodeld/
   ```

5. **Drag these files**:
   ```
   ContentView.swift
   EspressoTrackerApp.swift
   Info.plist
   ```

6. In the dialog that appears:
   - ✅ Check "Copy items if needed"
   - ✅ Select "Create groups"
   - ✅ Check your target
   - Click **Finish**

## Step 5: Configure (1 minute)

1. Click project name → Select target
2. **General** tab:
   - Set **iOS Deployment Target**: 17.0
   - **Team**: Select your Apple ID
   - **Bundle Identifier**: Keep default or change to your preference

3. **Build Settings** tab:
   - Search "Swift"
   - Verify **Swift Language Version** = Swift 5

## Step 6: Make it Local-Only (30 seconds)

In Xcode:
1. Find `Core/Persistence.swift`
2. **Delete it** (Move to Trash)
3. Find `Core/Persistence-LocalOnly.swift`
4. **Rename it** to `Persistence.swift`

This keeps data local (no iCloud).

## Step 7: Build & Run! (30 seconds)

1. Select **iPhone 15 Pro** simulator (top bar)
2. Press **Cmd + R**
3. Wait for build...
4. App should launch! 🎉

---

## Quick Test

Once running:

1. **Equipment Tab** → Tap + → Add a grinder
2. **Beans Tab** → Tap + → Add coffee beans
3. **Brew Tab** → Select equipment → Tap Start
4. Wait ~25 seconds → Tap Stop
5. Enter yield → Save
6. **History Tab** → See your shot!

---

## Issues?

### Build Fails
```bash
# In Xcode:
Product → Clean Build Folder (Cmd + Shift + K)
Product → Build (Cmd + B)
```

### "Cannot find type 'Grinder'"
- Select `Grinder+CoreDataClass.swift`
- Right panel → File Inspector
- Check your target is selected

### Core Data Errors
1. Clean build folder
2. Delete Xcode derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/EspressoTracker-*
   ```
3. Rebuild

### App Crashes
- Check console (Cmd + Shift + Y)
- Look for error messages
- Reset simulator: Device → Erase All Content

---

## File Structure Check

Your Xcode should look like this:

```
EspressoTracker/
├── 📄 EspressoTrackerApp.swift
├── 📄 ContentView.swift
├── 📄 Info.plist
├── 📁 Components/
│   ├── CustomButton.swift
│   └── CustomCard.swift
├── 📁 Core/
│   └── Persistence.swift
├── 📁 Models/
│   ├── Grinder+CoreDataClass.swift
│   ├── Machine+CoreDataClass.swift
│   ├── Bean+CoreDataClass.swift
│   └── BrewingSession+CoreDataClass.swift
├── 📁 Theme/
│   └── ColorTheme.swift
├── 📁 ViewModels/
│   ├── DataManager.swift
│   └── BrewingViewModel.swift
├── 📁 Views/
│   ├── 📁 Brewing/
│   ├── 📁 Equipment/
│   ├── 📁 Beans/
│   └── 📁 History/
├── 📁 EspressoTracker.xcdatamodeld/
│   └── EspressoTracker.xcdatamodel
└── 📁 Assets.xcassets/
```

---

## Success Checklist

- [x] Files verified with `verify_files.sh`
- [x] All folders added to Xcode
- [x] Target membership checked
- [x] Persistence-LocalOnly renamed to Persistence
- [x] Build succeeded (Cmd + B)
- [x] App launched (Cmd + R)
- [x] Dark mode active
- [x] 4 tabs visible
- [x] Can add equipment
- [x] Can brew a shot

---

## Need More Help?

See **INSTALLATION_GUIDE.md** for detailed troubleshooting.

---

**Total Time**: ~5 minutes
**Difficulty**: Easy
**Result**: Working espresso tracker app! ☕
