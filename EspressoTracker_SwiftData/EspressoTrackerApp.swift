//
//  EspressoTrackerApp.swift
//  EspressoTracker
//
//  SwiftData version - Much simpler than Core Data!
//

import SwiftUI
import SwiftData

@main
struct EspressoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode
        }
        // This single line replaces all the Core Data setup!
        .modelContainer(for: [
            Grinder.self,
            Machine.self,
            Bean.self,
            BrewingSession.self
        ])
    }
}
