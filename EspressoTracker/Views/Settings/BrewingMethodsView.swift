//
//  BrewingMethodsView.swift
//  EspressoTracker
//
//  Manage brewing methods with custom default parameters
//

import SwiftUI
import SwiftData

struct BrewingMethodsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \BrewingMethodModel.sortOrder) private var brewingMethods: [BrewingMethodModel]

    @State private var showingAddMethod = false
    @State private var selectedMethod: BrewingMethodModel?

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack {
                if brewingMethods.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(brewingMethods) { method in
                            BrewingMethodRowView(method: method)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedMethod = method
                                }
                        }
                        .onDelete(perform: deleteMethods)
                        .listRowBackground(Color.cardBackground)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle(LocalizedString.get("brewing_methods"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddMethod = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddMethod) {
            BrewingMethodEditView(isNew: true)
        }
        .sheet(item: $selectedMethod) { method in
            BrewingMethodEditView(method: method, isNew: false)
        }
        .onAppear {
            initializeDefaultMethodsIfNeeded()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)

            Text(LocalizedString.get("no_brewing_methods"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(LocalizedString.get("add_brewing_methods_description"))
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { initializeDefaultMethods() }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text(LocalizedString.get("add_default_methods"))
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.espressoBrown)
                .cornerRadius(10)
            }
        }
    }

    private func initializeDefaultMethodsIfNeeded() {
        if brewingMethods.isEmpty {
            initializeDefaultMethods()
        }
    }

    private func initializeDefaultMethods() {
        for method in BrewingMethodModel.allDefaultMethods() {
            modelContext.insert(method)
        }
        try? modelContext.save()
    }

    private func deleteMethods(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(brewingMethods[index])
        }
        try? modelContext.save()
    }
}

struct BrewingMethodRowView: View {
    let method: BrewingMethodModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: method.icon)
                .font(.title2)
                .foregroundColor(.espressoBrown)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(method.name)
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                HStack(spacing: 12) {
                    Label("\(Int(method.defaultDoseGrams))g", systemImage: "scalemass")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Label(method.ratioRangeString, systemImage: "arrow.left.arrow.right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Label(method.brewTimeRangeString, systemImage: "timer")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(.vertical, 8)
    }
}

struct BrewingMethodEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let method: BrewingMethodModel?
    let isNew: Bool

    @State private var name: String
    @State private var icon: String
    @State private var defaultDoseGrams: Double
    @State private var defaultRatioMin: Double
    @State private var defaultRatioMax: Double
    @State private var defaultBrewTimeMin: Double
    @State private var defaultBrewTimeMax: Double
    @State private var defaultWaterTemp: Double
    @State private var defaultPressure: Double

    init(method: BrewingMethodModel? = nil, isNew: Bool) {
        self.method = method
        self.isNew = isNew
        _name = State(initialValue: method?.name ?? "")
        _icon = State(initialValue: method?.icon ?? "cup.and.saucer.fill")
        _defaultDoseGrams = State(initialValue: method?.defaultDoseGrams ?? 18.0)
        _defaultRatioMin = State(initialValue: method?.defaultRatioMin ?? 2.0)
        _defaultRatioMax = State(initialValue: method?.defaultRatioMax ?? 2.5)
        _defaultBrewTimeMin = State(initialValue: method?.defaultBrewTimeMin ?? 25.0)
        _defaultBrewTimeMax = State(initialValue: method?.defaultBrewTimeMax ?? 30.0)
        _defaultWaterTemp = State(initialValue: method?.defaultWaterTemp ?? 93.0)
        _defaultPressure = State(initialValue: method?.defaultPressure ?? 9.0)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                    Section(header: Text(LocalizedString.get("basic_information"))) {
                        TextField(LocalizedString.get("method_name"), text: $name)

                        HStack {
                            Text(LocalizedString.get("icon"))
                            Spacer()
                            Image(systemName: icon)
                                .foregroundColor(.espressoBrown)
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("default_parameters"))) {
                        HStack {
                            Text(LocalizedString.get("default_dose"))
                            Spacer()
                            TextField("18.0", value: $defaultDoseGrams, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("g")
                                .foregroundColor(.textSecondary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedString.get("ratio_range"))
                                .font(.subheadline)
                            HStack {
                                Text(LocalizedString.get("min"))
                                    .foregroundColor(.textSecondary)
                                TextField("2.0", value: $defaultRatioMin, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 60)

                                Text("-")
                                    .foregroundColor(.textSecondary)

                                Text(LocalizedString.get("max"))
                                    .foregroundColor(.textSecondary)
                                TextField("2.5", value: $defaultRatioMax, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 60)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedString.get("brew_time_range"))
                                .font(.subheadline)
                            HStack {
                                Text(LocalizedString.get("min"))
                                    .foregroundColor(.textSecondary)
                                TextField("25", value: $defaultBrewTimeMin, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 60)

                                Text("-")
                                    .foregroundColor(.textSecondary)

                                Text(LocalizedString.get("max"))
                                    .foregroundColor(.textSecondary)
                                TextField("30", value: $defaultBrewTimeMax, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 60)
                            }
                        }

                        HStack {
                            Text(LocalizedString.get("water_temperature"))
                            Spacer()
                            TextField("93", value: $defaultWaterTemp, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("°C")
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text(LocalizedString.get("pressure"))
                            Spacer()
                            TextField("9.0", value: $defaultPressure, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("bar")
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(isNew ? LocalizedString.get("add_method") : LocalizedString.get("edit_method"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedString.get("cancel")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedString.get("save")) {
                        saveMethod()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveMethod() {
        if isNew {
            let newMethod = BrewingMethodModel(
                name: name,
                icon: icon,
                defaultDoseGrams: defaultDoseGrams,
                defaultRatioMin: defaultRatioMin,
                defaultRatioMax: defaultRatioMax,
                defaultBrewTimeMin: defaultBrewTimeMin,
                defaultBrewTimeMax: defaultBrewTimeMax,
                defaultWaterTemp: defaultWaterTemp,
                defaultPressure: defaultPressure
            )
            modelContext.insert(newMethod)
        } else if let method = method {
            method.name = name
            method.icon = icon
            method.defaultDoseGrams = defaultDoseGrams
            method.defaultRatioMin = defaultRatioMin
            method.defaultRatioMax = defaultRatioMax
            method.defaultBrewTimeMin = defaultBrewTimeMin
            method.defaultBrewTimeMax = defaultBrewTimeMax
            method.defaultWaterTemp = defaultWaterTemp
            method.defaultPressure = defaultPressure
            method.updatedAt = Date()
        }

        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    BrewingMethodsView()
        .modelContainer(for: BrewingMethodModel.self, inMemory: true)
}
