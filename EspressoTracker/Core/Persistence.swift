//
//  Persistence.swift
//  EspressoTracker
//
//  SwiftData ModelContainer configuration
//

import Foundation
import SwiftData

@MainActor
class DataStore {
    static let shared = DataStore()

    let container: ModelContainer
    var context: ModelContext {
        container.mainContext
    }

    // Preview container with sample data
    static var preview: DataStore = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Bean.self, Grinder.self, Machine.self, BrewingSession.self,
            configurations: config
        )
        let context = container.mainContext

        // Create sample data for previews
        let sampleGrinder = Grinder(
            name: "Niche Zero",
            brand: "Niche",
            burrType: "Conical",
            burrSize: 63,
            notes: "Single dosing grinder with excellent grind quality"
        )
        context.insert(sampleGrinder)

        let sampleMachine = Machine(
            name: "Gaggia Classic Pro",
            brand: "Gaggia",
            model: "Classic Pro",
            boilerType: "Single Boiler",
            groupHeadType: "E61",
            pressureBar: 9.0,
            notes: "Classic entry-level espresso machine"
        )
        context.insert(sampleMachine)

        let sampleBean = Bean(
            name: "Ethiopia Yirgacheffe",
            roaster: "Local Coffee Roasters",
            origin: "Ethiopia",
            roastLevel: "Light",
            roastDate: Date().addingTimeInterval(-7*24*60*60), // 7 days ago
            process: "Washed",
            variety: "Arabica",
            tastingNotes: "Bergamot, jasmine, lemon",
            price: 18.50,
            weight: 250,
            notes: "Floral and citrus notes"
        )
        context.insert(sampleBean)

        let sampleSession = BrewingSession(
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date().addingTimeInterval(-3570),
            grindSetting: "12",
            doseIn: 18.0,
            yieldOut: 36.0,
            brewTime: 28.0,
            waterTemp: 93.0,
            pressure: 9.0,
            rating: 4,
            notes: "Great shot!",
            grinder: sampleGrinder,
            machine: sampleMachine,
            bean: sampleBean
        )
        context.insert(sampleSession)

        try? context.save()

        return DataStore(container: container)
    }()

    init(inMemory: Bool = false) {
        do {
            let config: ModelConfiguration
            if inMemory {
                config = ModelConfiguration(isStoredInMemoryOnly: true)
            } else {
                config = ModelConfiguration()
            }

            container = try ModelContainer(
                for: Bean.self, Grinder.self, Machine.self, BrewingSession.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    private init(container: ModelContainer) {
        self.container = container
    }
}
