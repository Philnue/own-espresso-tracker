//
//  ContentView.swift
//  EspressoTracker
//
//  Main tab view navigation
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject private var settings = UserSettings.shared

    var body: some View {
        TabView {
            BrewingView()
                .tabItem {
                    Label("Brew", systemImage: "cup.and.saucer.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            BeansView()
                .tabItem {
                    Label("Beans", systemImage: "leaf.fill")
                }

            RecipeCalculatorView()
                .tabItem {
                    Label("Recipes", systemImage: "book.fill")
                }

            EquipmentView()
                .tabItem {
                    Label("Equipment", systemImage: "gearshape.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.espressoBrown)
        .preferredColorScheme(settings.preferredColorScheme)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Bean.self, Grinder.self, Machine.self, BrewingSession.self], inMemory: true)
}
