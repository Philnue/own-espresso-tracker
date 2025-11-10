//
//  EspressoTrackerApp.swift
//  EspressoTracker
//
//  Main app entry point
//

import SwiftUI
import CoreData

@main
struct EspressoTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark) // Force dark mode
        }
    }
}
