# Local-Only Setup Guide

## Making the App Purely Local (No iCloud)

The app is already local-first! iCloud sync is **optional**. Here's how to ensure it stays local:

### Option 1: Keep Core Data, Remove iCloud (Simplest)

**Step 1: Update Persistence.swift**

Replace the `Persistence.swift` file with this local-only version:

```swift
//
//  Persistence.swift
//  EspressoTracker
//
//  LOCAL-ONLY Core Data stack (no iCloud sync)
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create sample data for previews
        let sampleGrinder = Grinder(context: viewContext)
        sampleGrinder.id = UUID()
        sampleGrinder.name = "Niche Zero"
        sampleGrinder.brand = "Niche"
        sampleGrinder.burrType = "Conical"
        sampleGrinder.burrSize = 63
        sampleGrinder.notes = "Single dosing grinder"
        sampleGrinder.createdAt = Date()

        let sampleMachine = Machine(context: viewContext)
        sampleMachine.id = UUID()
        sampleMachine.name = "Gaggia Classic Pro"
        sampleMachine.brand = "Gaggia"
        sampleMachine.boilerType = "Single Boiler"
        sampleMachine.createdAt = Date()

        let sampleBean = Bean(context: viewContext)
        sampleBean.id = UUID()
        sampleBean.name = "Ethiopia Yirgacheffe"
        sampleBean.roaster = "Local Coffee Roasters"
        sampleBean.origin = "Ethiopia"
        sampleBean.roastLevel = "Light"
        sampleBean.roastDate = Date().addingTimeInterval(-7*24*60*60)
        sampleBean.createdAt = Date()

        do {
            try viewContext.save()
        } catch {
            fatalError("Preview error: \(error)")
        }

        return controller
    }()

    // Changed from NSPersistentCloudKitContainer to NSPersistentContainer
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Use regular NSPersistentContainer (not CloudKit version)
        container = NSPersistentContainer(name: "EspressoTracker")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        // No iCloud configuration needed!

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
```

**Step 2: Update DataManager.swift**

Change line 12 from:
```swift
let container: NSPersistentCloudKitContainer
```
to:
```swift
let container: NSPersistentContainer
```

And line 14 from:
```swift
init(container: NSPersistentCloudKitContainer = PersistenceController.shared.container) {
```
to:
```swift
init(container: NSPersistentContainer = PersistenceController.shared.container) {
```

**Step 3: In Xcode Project**

- Don't add the iCloud capability
- Skip the CloudKit container setup
- That's it! Data stays local.

### Where Data is Stored

Your data is saved to:
```
/Users/YourName/Library/Developer/CoreSimulator/Devices/[DEVICE-ID]/
  data/Containers/Data/Application/[APP-ID]/
    Library/Application Support/EspressoTracker.sqlite
```

On real device:
```
/var/mobile/Containers/Data/Application/[APP-ID]/
  Library/Application Support/EspressoTracker.sqlite
```

**Data persists** between app launches!
**Data is local** to the device!
**Data survives** app updates!

---

## Option 2: Convert to SwiftData (Recommended for Modern Apps)

SwiftData is Apple's new, simpler framework. Here's how to convert:

### Benefits of SwiftData:
- 70% less code
- Native Swift syntax
- Automatic model updates
- Better performance
- Easier to understand

### SwiftData Models

Replace the 4 Core Data files with these simple SwiftData models:

```swift
//
//  Models.swift
//  EspressoTracker
//
//  SwiftData models (replaces all Core Data files)
//

import Foundation
import SwiftData

@Model
final class Grinder {
    var id: UUID
    var name: String
    var brand: String
    var burrType: String?
    var burrSize: Int16
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.grinder)
    var brewingSessions: [BrewingSession]?

    init(name: String, brand: String, burrType: String? = nil,
         burrSize: Int16 = 0, imageData: Data? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.burrType = burrType
        self.burrSize = burrSize
        self.imageData = imageData
        self.notes = notes
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

@Model
final class Machine {
    var id: UUID
    var name: String
    var brand: String
    var model: String?
    var boilerType: String?
    var groupHeadType: String?
    var pressureBar: Double
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var purchaseDate: Date?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.machine)
    var brewingSessions: [BrewingSession]?

    init(name: String, brand: String, model: String? = nil,
         boilerType: String? = nil, groupHeadType: String? = nil,
         pressureBar: Double = 9.0, imageData: Data? = nil,
         notes: String? = nil, purchaseDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.model = model
        self.boilerType = boilerType
        self.groupHeadType = groupHeadType
        self.pressureBar = pressureBar
        self.imageData = imageData
        self.notes = notes
        self.purchaseDate = purchaseDate
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

@Model
final class Bean {
    var id: UUID
    var name: String
    var roaster: String
    var origin: String
    var roastLevel: String?
    var roastDate: Date?
    var process: String?
    var variety: String?
    var tastingNotes: String?
    var price: Double
    var weight: Double
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.bean)
    var brewingSessions: [BrewingSession]?

    // Computed properties
    var daysFromRoast: Int? {
        guard let roastDate = roastDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: roastDate, to: Date())
        return components.day
    }

    var freshnessIndicator: String {
        guard let days = daysFromRoast else { return "Unknown" }
        if days <= 7 { return "Very Fresh" }
        if days <= 14 { return "Fresh" }
        if days <= 21 { return "Good" }
        if days <= 30 { return "Aging" }
        return "Stale"
    }

    var isStale: Bool {
        guard let days = daysFromRoast else { return false }
        return days > 30
    }

    init(name: String, roaster: String, origin: String,
         roastLevel: String? = nil, roastDate: Date? = nil,
         process: String? = nil, variety: String? = nil,
         tastingNotes: String? = nil, price: Double = 0,
         weight: Double = 250, imageData: Data? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.roaster = roaster
        self.origin = origin
        self.roastLevel = roastLevel
        self.roastDate = roastDate
        self.process = process
        self.variety = variety
        self.tastingNotes = tastingNotes
        self.price = price
        self.weight = weight
        self.imageData = imageData
        self.notes = notes
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

@Model
final class BrewingSession {
    var id: UUID
    var startTime: Date?
    var endTime: Date?
    var grindSetting: String?
    var doseIn: Double
    var yieldOut: Double
    var brewTime: Double
    var waterTemp: Double
    var pressure: Double
    var rating: Int16
    var notes: String?
    @Attribute(.externalStorage) var imageData: Data?
    var createdAt: Date

    var grinder: Grinder?
    var machine: Machine?
    var bean: Bean?

    // Computed properties
    var brewRatio: Double {
        guard doseIn > 0 else { return 0 }
        return yieldOut / doseIn
    }

    var brewRatioString: String {
        String(format: "1:%.1f", brewRatio)
    }

    var brewTimeFormatted: String {
        let minutes = Int(brewTime) / 60
        let seconds = Int(brewTime) % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }

    var extraction: String {
        if brewTime < 20 {
            return "Under-extracted"
        } else if brewTime > 35 {
            return "Over-extracted"
        } else {
            return "Optimal"
        }
    }

    var qualityAssessment: String {
        let isRatioGood = brewRatio >= 1.5 && brewRatio <= 3.0
        let isTimeGood = brewTime >= 20 && brewTime <= 35

        if isRatioGood && isTimeGood {
            return "On Target"
        } else if !isRatioGood && !isTimeGood {
            return "Needs Adjustment"
        } else if !isRatioGood {
            return "Check Ratio"
        } else {
            return "Check Time"
        }
    }

    init(grinder: Grinder? = nil, machine: Machine? = nil, bean: Bean? = nil,
         grindSetting: String? = nil, doseIn: Double, yieldOut: Double,
         brewTime: Double, waterTemp: Double = 93, pressure: Double = 9,
         rating: Int16 = 3, notes: String? = nil, imageData: Data? = nil) {
        self.id = UUID()
        self.startTime = Date()
        self.endTime = Date().addingTimeInterval(brewTime)
        self.grinder = grinder
        self.machine = machine
        self.bean = bean
        self.grindSetting = grindSetting
        self.doseIn = doseIn
        self.yieldOut = yieldOut
        self.brewTime = brewTime
        self.waterTemp = waterTemp
        self.pressure = pressure
        self.rating = rating
        self.notes = notes
        self.imageData = imageData
        self.createdAt = Date()
    }
}
```

### SwiftData App Entry

Replace `EspressoTrackerApp.swift`:

```swift
//
//  EspressoTrackerApp.swift
//  EspressoTracker
//
//  SwiftData version
//

import SwiftUI
import SwiftData

@main
struct EspressoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Grinder.self, Machine.self, Bean.self, BrewingSession.self])
    }
}
```

### Update Views for SwiftData

In ALL view files, replace:
```swift
@Environment(\.managedObjectContext) private var viewContext
@FetchRequest(...)
private var items: FetchedResults<Item>
```

With:
```swift
@Environment(\.modelContext) private var modelContext
@Query(sort: \Item.createdAt, order: .reverse)
private var items: [Item]
```

Example for `GrinderListView.swift`:
```swift
@Environment(\.modelContext) private var modelContext
@Query(sort: \Grinder.createdAt, order: .reverse)
private var grinders: [Grinder]
```

### Simplified DataManager for SwiftData

```swift
//
//  DataManager.swift
//  EspressoTracker
//
//  SwiftData version - MUCH SIMPLER!
//

import SwiftUI
import SwiftData

@Observable
class DataManager {
    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Create operations
    func createGrinder(name: String, brand: String, burrType: String,
                      burrSize: Int16, notes: String, imageData: Data?) {
        let grinder = Grinder(name: name, brand: brand, burrType: burrType,
                             burrSize: burrSize, imageData: imageData, notes: notes)
        modelContext.insert(grinder)
        try? modelContext.save()
    }

    func createMachine(name: String, brand: String, model: String,
                      boilerType: String, groupHeadType: String,
                      pressureBar: Double, notes: String, imageData: Data?,
                      purchaseDate: Date?) {
        let machine = Machine(name: name, brand: brand, model: model,
                             boilerType: boilerType, groupHeadType: groupHeadType,
                             pressureBar: pressureBar, imageData: imageData,
                             notes: notes, purchaseDate: purchaseDate)
        modelContext.insert(machine)
        try? modelContext.save()
    }

    func createBean(name: String, roaster: String, origin: String,
                   roastLevel: String, roastDate: Date, process: String,
                   variety: String, tastingNotes: String, price: Double,
                   weight: Double, notes: String, imageData: Data?) {
        let bean = Bean(name: name, roaster: roaster, origin: origin,
                       roastLevel: roastLevel, roastDate: roastDate,
                       process: process, variety: variety,
                       tastingNotes: tastingNotes, price: price,
                       weight: weight, imageData: imageData, notes: notes)
        modelContext.insert(bean)
        try? modelContext.save()
    }

    func createBrewingSession(grinder: Grinder?, machine: Machine?, bean: Bean?,
                            grindSetting: String, doseIn: Double, yieldOut: Double,
                            brewTime: Double, waterTemp: Double, pressure: Double,
                            rating: Int16, notes: String, imageData: Data?) {
        let session = BrewingSession(grinder: grinder, machine: machine, bean: bean,
                                    grindSetting: grindSetting, doseIn: doseIn,
                                    yieldOut: yieldOut, brewTime: brewTime,
                                    waterTemp: waterTemp, pressure: pressure,
                                    rating: rating, notes: notes, imageData: imageData)
        modelContext.insert(session)
        try? modelContext.save()
    }

    // Delete operations
    func delete(_ item: any PersistentModel) {
        modelContext.delete(item)
        try? modelContext.save()
    }
}
```

---

## Comparison: Core Data vs SwiftData

| Feature | Core Data | SwiftData |
|---------|-----------|-----------|
| **Code Amount** | More boilerplate | 70% less code |
| **Syntax** | Objective-C style | Pure Swift |
| **Learning Curve** | Steeper | Gentle |
| **iOS Version** | iOS 3+ | iOS 17+ only |
| **Maturity** | Very mature | Still new |
| **Migration** | Complex | Simple |
| **Performance** | Excellent | Excellent |
| **Documentation** | Extensive | Growing |

## My Recommendation

**For Your Use Case:**
Use **SwiftData** because:
- ✅ Simpler code
- ✅ Modern Swift syntax
- ✅ iOS 17+ is fine for new apps
- ✅ Easier to maintain
- ✅ Better for learning
- ✅ Apple's future direction

**Stick with Core Data if:**
- You need iOS 16 or older support
- You want battle-tested stability
- You have complex migrations

## Data Backup

Both Core Data and SwiftData are **local by default**. Data persists:
- ✅ Between app launches
- ✅ After device restart
- ✅ During app updates

**Backed up by:**
- iTunes backup
- iCloud backup (if user enabled it in Settings)
- Manual device backup

**NOT automatically synced** unless you add iCloud capability!

---

## Next Steps

1. **Easy Mode**: Keep Core Data, just remove iCloud (Option 1 above)
2. **Modern Mode**: Convert to SwiftData (Option 2 above)
3. **Current State**: Already works locally! iCloud is optional.

Let me know which approach you prefer and I can help implement it!
