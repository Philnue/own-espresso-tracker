//
//  EspressoTrackerApp.swift
//  EspressoTracker
//
//  Main app entry point
//

import SwiftUI
import SwiftData

@main
struct EspressoTrackerApp: App {
    let sharedModelContainer: ModelContainer

    init() {
        // Create shared model container
        do {
            sharedModelContainer = try ModelContainer(for: Bean.self, Grinder.self, Machine.self, BrewingSession.self, BrewingMethodModel.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        // Initialize default brewing methods on first launch using the shared container
        initializeDefaultBrewingMethods(context: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }

    private func initializeDefaultBrewingMethods(context: ModelContext) {
        let descriptor = FetchDescriptor<BrewingMethodModel>()
        let existingMethods = (try? context.fetch(descriptor)) ?? []

        if existingMethods.isEmpty {
            // Add default brewing methods
            for method in BrewingMethodModel.allDefaultMethods() {
                context.insert(method)
            }
            do {
                try context.save()
            } catch {
                print("Error saving default brewing methods: \(error)")
            }
        }
    }
}
