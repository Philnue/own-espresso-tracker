//
//  EquipmentView.swift
//  EspressoTracker
//
//  Parent view for equipment management (Grinders and Machines)
//

import SwiftUI
import SwiftData

struct EquipmentView: View {
    @State private var selectedCategory = 0
    let categories = ["Grinders", "Machines"]

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Custom segmented control
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(Color.backgroundSecondary)

                    // Content
                    TabView(selection: $selectedCategory) {
                        GrinderListView()
                            .tag(0)

                        MachineListView()
                            .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    EquipmentView()
        .modelContainer(for: [Grinder.self, Machine.self], inMemory: true)
}
