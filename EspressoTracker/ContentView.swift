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
        Group {
            TabView {
                BrewingView()
                    .tabItem {
                        Label(LocalizedString.get("tab_brew"), systemImage: "cup.and.saucer.fill")
                    }

                HistoryView()
                    .tabItem {
                        Label(LocalizedString.get("tab_history"), systemImage: "clock.fill")
                    }

                BeansView()
                    .tabItem {
                        Label(LocalizedString.get("tab_beans"), systemImage: "leaf.fill")
                    }

                RecipeCalculatorView()
                    .tabItem {
                        Label(LocalizedString.get("tab_recipes"), systemImage: "book.fill")
                    }

                EquipmentView()
                    .tabItem {
                        Label(LocalizedString.get("tab_equipment"), systemImage: "wrench.and.screwdriver.fill")
                    }

                SettingsView()
                    .tabItem {
                        Label(LocalizedString.get("tab_settings"), systemImage: "gearshape.fill")
                    }
            }
            .accentColor(.espressoBrown)
        }
        .preferredColorScheme(settings.colorScheme == "dark" ? .dark : settings.colorScheme == "light" ? .light : nil)
        .id("\(settings.appLanguage)_\(settings.colorScheme)") // Force refresh when language or theme changes
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Bean.self, Grinder.self, Machine.self, BrewingSession.self], inMemory: true)
}
