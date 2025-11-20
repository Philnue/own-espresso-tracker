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
    init() {
        // Initialize default brewing methods on first launch
        initializeDefaultBrewingMethods()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Bean.self, Grinder.self, Machine.self, BrewingSession.self, BrewingMethodModel.self])
    }

    private func initializeDefaultBrewingMethods() {
        let container = try? ModelContainer(for: BrewingMethodModel.self)
        guard let context = container?.mainContext else { return }

        let descriptor = FetchDescriptor<BrewingMethodModel>()
        let existingMethods = (try? context.fetch(descriptor)) ?? []

        if existingMethods.isEmpty {
            // Add default brewing methods
            for method in BrewingMethodModel.allDefaultMethods() {
                context.insert(method)
            }
            try? context.save()
        }
    }
}
