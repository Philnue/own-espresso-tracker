//
//  Persistence-LocalOnly.swift
//  EspressoTracker
//
//  LOCAL-ONLY Core Data stack (no iCloud sync)
//  Replace Persistence.swift with this file to keep data local
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
        sampleGrinder.notes = "Single dosing grinder with excellent grind quality"
        sampleGrinder.createdAt = Date()

        let sampleMachine = Machine(context: viewContext)
        sampleMachine.id = UUID()
        sampleMachine.name = "Gaggia Classic Pro"
        sampleMachine.brand = "Gaggia"
        sampleMachine.boilerType = "Single Boiler"
        sampleMachine.groupHeadType = "E61"
        sampleMachine.pressureBar = 9.0
        sampleMachine.notes = "Classic entry-level espresso machine"
        sampleMachine.createdAt = Date()

        let sampleBean = Bean(context: viewContext)
        sampleBean.id = UUID()
        sampleBean.name = "Ethiopia Yirgacheffe"
        sampleBean.roaster = "Local Coffee Roasters"
        sampleBean.origin = "Ethiopia"
        sampleBean.roastLevel = "Light"
        sampleBean.roastDate = Date().addingTimeInterval(-7*24*60*60) // 7 days ago
        sampleBean.notes = "Floral and citrus notes"
        sampleBean.tastingNotes = "Bergamot, jasmine, lemon"
        sampleBean.price = 18.50
        sampleBean.weight = 250
        sampleBean.createdAt = Date()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    // Changed from NSPersistentCloudKitContainer to NSPersistentContainer
    // This keeps all data LOCAL - no iCloud sync
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Use regular NSPersistentContainer instead of CloudKit version
        container = NSPersistentContainer(name: "EspressoTracker")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        // No iCloud configuration - all data stays local!

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
