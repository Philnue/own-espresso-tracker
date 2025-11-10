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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode
        }
        .modelContainer(for: [Bean.self, Grinder.self, Machine.self, BrewingSession.self])
    }
}
