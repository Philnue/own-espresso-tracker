//
//  ContentView.swift
//  EspressoTracker
//
//  Main navigation and tab view
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            BrewingView()
                .tabItem {
                    Label("Brew", systemImage: "cup.and.saucer.fill")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(1)

            EquipmentView()
                .tabItem {
                    Label("Equipment", systemImage: "wrench.and.screwdriver.fill")
                }
                .tag(2)

            BeansView()
                .tabItem {
                    Label("Beans", systemImage: "leaf.fill")
                }
                .tag(3)
        }
        .accentColor(.espressoBrown)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Bean.self, Grinder.self, Machine.self, BrewingSession.self], inMemory: true)
}
