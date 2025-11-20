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

    var categories: [String] {
        [LocalizedString.get("grinders"), LocalizedString.get("machines")]
    }

    var body: some View {
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
        .navigationTitle(LocalizedString.get("equipment"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EquipmentView()
        .modelContainer(for: [Grinder.self, Machine.self], inMemory: true)
}
