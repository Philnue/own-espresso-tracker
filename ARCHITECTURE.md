# Espresso Tracker - Architecture Documentation

## Overview

Espresso Tracker is a comprehensive iOS application built with SwiftUI and Core Data that helps coffee enthusiasts track their espresso brewing journey. The app features equipment management, bean tracking, real-time brewing with stopwatch functionality, and detailed session history.

## Architecture Pattern

The application follows the **MVVM (Model-View-ViewModel)** architecture pattern with a clear separation of concerns:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (SwiftUI Views + View Components)      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│          ViewModel Layer                │
│  (BrewingViewModel, DataManager)        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│            Data Layer                   │
│  (Core Data Models + Persistence)       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│         Storage Layer                   │
│  (Local SQLite + iCloud Sync)           │
└─────────────────────────────────────────┘
```

## Project Structure

```
EspressoTracker/
├── EspressoTrackerApp.swift          # App entry point
├── ContentView.swift                 # Main tab navigation
│
├── Core/
│   └── Persistence.swift             # Core Data stack with iCloud sync
│
├── Models/                           # Core Data entities
│   ├── Grinder+CoreDataClass.swift
│   ├── Machine+CoreDataClass.swift
│   ├── Bean+CoreDataClass.swift
│   └── BrewingSession+CoreDataClass.swift
│
├── ViewModels/                       # Business logic layer
│   ├── DataManager.swift             # CRUD operations manager
│   └── BrewingViewModel.swift        # Brewing session state & timer
│
├── Views/                            # UI layer
│   ├── Equipment/
│   │   ├── EquipmentView.swift       # Equipment tab parent
│   │   ├── GrinderListView.swift
│   │   ├── AddGrinderView.swift
│   │   ├── GrinderDetailView.swift
│   │   ├── EditGrinderView.swift
│   │   ├── MachineListView.swift
│   │   ├── AddMachineView.swift
│   │   ├── MachineDetailView.swift
│   │   └── EditMachineView.swift
│   │
│   ├── Beans/
│   │   ├── BeansView.swift           # Beans list
│   │   ├── AddBeanView.swift
│   │   ├── BeanDetailView.swift
│   │   └── EditBeanView.swift
│   │
│   ├── Brewing/
│   │   ├── BrewingView.swift         # Main brewing interface
│   │   └── FinishBrewView.swift      # Save shot details
│   │
│   └── History/
│       ├── HistoryView.swift         # Session history list
│       └── SessionDetailView.swift   # Individual session details
│
├── Components/                       # Reusable UI components
│   ├── CustomButton.swift
│   └── CustomCard.swift
│
├── Theme/
│   └── ColorTheme.swift              # Dark mode color palette
│
└── EspressoTracker.xcdatamodeld/
    └── EspressoTracker.xcdatamodel/
        └── contents                  # Core Data schema
```

## Core Data Schema

### Entities and Relationships

```
┌─────────────┐
│   Grinder   │
├─────────────┤
│ id          │
│ name        │
│ brand       │
│ burrType    │
│ burrSize    │
│ imageData   │
│ notes       │
└──────┬──────┘
       │ 1:N
       │
       │        ┌──────────────────┐
       │        │  BrewingSession  │
       └───────►├──────────────────┤
                │ id               │
       ┌───────►│ startTime        │
       │        │ endTime          │
       │ 1:N    │ grindSetting     │
       │        │ doseIn           │
┌──────┴──────┐ │ yieldOut         │
│   Machine   │ │ brewTime         │
├─────────────┤ │ waterTemp        │
│ id          │ │ pressure         │
│ name        │ │ rating           │
│ brand       │ │ notes            │
│ boilerType  │ │ imageData        │
│ groupHeadType│ └────────┬─────────┘
│ pressureBar │           │
│ imageData   │           │ N:1
│ notes       │           │
└─────────────┘           │
                          │
                   ┌──────┴──────┐
                   │    Bean     │
                   ├─────────────┤
                   │ id          │
                   │ name        │
                   │ roaster     │
                   │ origin      │
                   │ roastLevel  │
                   │ roastDate   │
                   │ process     │
                   │ variety     │
                   │ tastingNotes│
                   │ price       │
                   │ weight      │
                   │ imageData   │
                   │ notes       │
                   └─────────────┘
```

### Relationships
- **Grinder** → BrewingSession (One-to-Many)
- **Machine** → BrewingSession (One-to-Many)
- **Bean** → BrewingSession (One-to-Many)
- Each BrewingSession can reference one Grinder, one Machine, and one Bean

## Key Features & Implementation

### 1. Brewing Session with Stopwatch

**Location**: `Views/Brewing/BrewingView.swift`

The brewing view is the core feature of the app:

```
Flow:
1. Select equipment (Grinder, Machine, Bean)
2. Set parameters (grind setting, water temp, pressure)
3. Configure brew ratio (preset or custom)
4. Enter dose in (grams)
5. Start stopwatch when pulling shot
6. Stop when shot is complete
7. Enter actual yield out
8. Rate and add notes
9. Save session to history
```

**Technical Implementation**:
- Uses `Timer` with 0.1s interval for smooth stopwatch display
- Real-time extraction status based on brew time
- Automatic ratio calculation (1:1.5 to 1:3.0)
- State management via `BrewingViewModel`

### 2. Equipment Management

**Grinders** and **Machines** follow the same CRUD pattern:
- List view with cards
- Add/Edit forms with image picker
- Detail view with statistics
- Delete with confirmation

**Features**:
- Image storage via Core Data binary data
- Custom specifications tracking
- Usage statistics (total shots, last used)

### 3. Bean Management with Freshness Tracking

**Location**: `Views/Beans/`

Special features:
- **Roast date tracking** with automatic age calculation
- **Freshness indicators**:
  - Very Fresh (0-7 days)
  - Fresh (8-14 days)
  - Good (15-21 days)
  - Aging (22-30 days)
  - Stale (30+ days)
- Tasting notes and origin tracking
- Process and variety classification

### 4. History & Analytics

**Location**: `Views/History/`

Features:
- Chronological session list
- Statistics dashboard:
  - Total shots
  - Average brew time
  - Average ratio
  - Shots this week
- Extraction quality indicators
- Session detail view with full parameters

### 5. Dark Mode Theme

**Location**: `Theme/ColorTheme.swift`

Custom espresso-inspired color palette:
- Primary: Espresso Brown (`#7A5449`)
- Dark Coffee (`#3D2E23`)
- Rich Crema (`#C7996B`)
- Background layers for depth
- Status colors (success, warning, error)

## Data Flow

### Creating a Brewing Session

```
User Action                  →  ViewModel               →  DataManager           →  Core Data
────────────────────────────────────────────────────────────────────────────────────────────
1. Start timer              →  viewModel.startTimer()
2. Stop timer               →  viewModel.stopTimer()
3. Fill finish form         →  Update @State vars
4. Tap "Save"               →                          →  dataManager.create    →  Save context
                                                           BrewingSession()
5. Dismiss sheet            ←  View updates            ←  @Published change     ←  Sync complete
```

### iCloud Sync

The app uses `NSPersistentCloudKitContainer` for automatic iCloud synchronization:

```swift
// Persistence.swift
let container = NSPersistentCloudKitContainer(name: "EspressoTracker")

// Enable iCloud sync
let cloudKitOptions = NSPersistentCloudKitContainerOptions(
    containerIdentifier: "iCloud.com.espressotracker.app"
)
description.cloudKitContainerOptions = cloudKitOptions

// Enable history tracking for sync
description.setOption(true, forKey: NSPersistentHistoryTrackingKey)
description.setOption(true, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
```

**Sync Features**:
- Automatic sync when internet available
- Conflict resolution via merge policy
- Background sync support
- Cross-device data availability

## State Management

### @StateObject vs @ObservedObject

- **@StateObject**: Used for creating view models (owns lifecycle)
  ```swift
  @StateObject private var viewModel = BrewingViewModel()
  ```

- **@ObservedObject**: Used for passed objects (doesn't own lifecycle)
  ```swift
  @ObservedObject var grinder: Grinder
  ```

### @FetchRequest for Core Data

```swift
@FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \BrewingSession.startTime, ascending: false)],
    animation: .default
)
private var sessions: FetchedResults<BrewingSession>
```

Automatically updates views when Core Data changes.

## Best Practices Implemented

### 1. Separation of Concerns
- Views only handle UI
- ViewModels manage business logic
- DataManager handles data operations
- Models contain domain logic

### 2. Reusable Components
- `CustomCard`: Consistent card styling
- `PrimaryButton`, `SecondaryButton`: Themed buttons
- `InfoRow`: Consistent key-value pairs
- `StatCard`: Statistics display

### 3. Error Handling
- Graceful Core Data error handling
- Input validation on forms
- Required field checks

### 4. Performance
- Lazy loading with `LazyVStack`
- Efficient image handling (binary data)
- Optimized fetch requests
- Preview support for development

### 5. User Experience
- Empty states for all lists
- Confirmation dialogs for destructive actions
- Loading placeholders
- Smooth animations

## Extending the App

### Adding a New Entity

1. **Update Core Data Model**:
   ```xml
   <!-- EspressoTracker.xcdatamodel/contents -->
   <entity name="NewEntity">
       <attribute name="id" attributeType="UUID"/>
       <!-- Add attributes -->
   </entity>
   ```

2. **Create Model Class**:
   ```swift
   // Models/NewEntity+CoreDataClass.swift
   @objc(NewEntity)
   public class NewEntity: NSManagedObject {
       // Properties and methods
   }
   ```

3. **Add CRUD Operations**:
   ```swift
   // ViewModels/DataManager.swift
   func createNewEntity(...) { }
   func updateNewEntity(...) { }
   func deleteNewEntity(...) { }
   ```

4. **Create Views**:
   - ListView (list all)
   - AddView (create new)
   - DetailView (show details)
   - EditView (modify existing)

### Adding New Features

Example: Add water filter tracking

1. Create `WaterFilter` entity
2. Link to Machine (many-to-one)
3. Create management views
4. Add to Equipment tab
5. Reference in BrewingSession

## Testing

### Preview Support

All views include SwiftUI previews:

```swift
#Preview {
    BrewingView()
        .environment(\.managedObjectContext,
                     PersistenceController.preview.container.viewContext)
}
```

### Mock Data

`PersistenceController.preview` provides sample data for development and testing.

## Performance Considerations

1. **Image Storage**: Binary data in Core Data (consider file system for larger apps)
2. **Fetch Limits**: Consider pagination for large session histories
3. **Background Sync**: CloudKit handles background operations
4. **Memory**: Lazy loading prevents loading all data at once

## Future Enhancements

Potential features to add:
- [ ] Export data (CSV, PDF)
- [ ] Charts and analytics
- [ ] Shot comparison
- [ ] Recipe templates
- [ ] Maintenance tracking
- [ ] Water chemistry tracking
- [ ] Pressure profiling
- [ ] Video recording integration
- [ ] Social sharing
- [ ] Backup/restore

## Conclusion

Espresso Tracker demonstrates modern iOS development practices with:
- Clean MVVM architecture
- SwiftUI declarative UI
- Core Data persistence
- iCloud synchronization
- Beautiful dark mode design
- Reusable components
- Comprehensive feature set

The modular structure makes it easy to extend and maintain while providing an excellent user experience for espresso enthusiasts.
