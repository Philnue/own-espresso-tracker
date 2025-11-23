//
//  RecipeCalculatorView.swift
//  EspressoTracker
//
//  Recipe calculator for different brewing methods
//

import SwiftUI
import SwiftData

struct RecipeCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<BrewingMethodModel> { $0.isActive }, sort: \BrewingMethodModel.sortOrder) private var brewingMethods: [BrewingMethodModel]
    @ObservedObject private var settings = UserSettings.shared
    @State private var selectedMethodIndex: Int = 0
    @State private var doseIn: String = "18"
    @State private var ratio: String = "2.0"
    @State private var targetYield: Double = 36.0

    var selectedMethod: BrewingMethodModel? {
        guard !brewingMethods.isEmpty, selectedMethodIndex < brewingMethods.count else { return nil }
        return brewingMethods[selectedMethodIndex]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Method Selector
                        methodSelectorCard

                        // Input Card
                        inputCard

                        // Results Card
                        resultsCard

                        // Brewing Guide
                        brewingGuideCard
                    }
                    .padding()
                }
            }
            .navigationTitle(LocalizedString.get("recipe_calculator"))
            .onAppear {
                if let firstMethod = brewingMethods.first {
                    updateDefaults(for: firstMethod)
                }
            }
        }
    }

    private var methodSelectorCard: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 16) {
                Text(LocalizedString.get("brewing_method"))
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                if brewingMethods.isEmpty {
                    Text(LocalizedString.get("no_brewing_methods"))
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(brewingMethods.enumerated()), id: \.element.id) { index, method in
                                MethodCardButton(
                                    method: method,
                                    isSelected: selectedMethodIndex == index
                                ) {
                                    selectedMethodIndex = index
                                    updateDefaults(for: method)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var inputCard: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 20) {
                Text(LocalizedString.get("recipe_parameters"))
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Divider()
                    .background(Color.dividerColor)

                // Coffee Dose
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.get("coffee_dose"))
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)

                    HStack {
                        TextField("18.0", text: $doseIn)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .onChange(of: doseIn) { _, newValue in
                                calculateYield()
                            }

                        Text(LocalizedString.get("grams"))
                            .foregroundColor(.textSecondary)

                        Spacer()
                    }
                }

                // Brew Ratio
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.get("brew_ratio_1x"))
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)

                    HStack {
                        TextField("2.0", text: $ratio)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .onChange(of: ratio) { _, newValue in
                                calculateYield()
                            }

                        Text(LocalizedString.get("ratio"))
                            .foregroundColor(.textSecondary)

                        Spacer()
                    }
                }

                // Typical Range
                if let method = selectedMethod {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.espressoBrown)
                        Text(LocalizedString.get("typical_ratio") + ": 1:\(String(format: "%.1f", method.defaultRatioMin)) - 1:\(String(format: "%.1f", method.defaultRatioMax))")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    private var resultsCard: some View {
        CustomCard {
            VStack(spacing: 20) {
                Text(LocalizedString.get("results"))
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                HStack(spacing: 20) {
                    // Target Yield
                    VStack {
                        Text(String(format: "%.1f", targetYield))
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.espressoBrown)
                        Text("\(LocalizedString.get("target_yield")) (g)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()
                        .frame(height: 60)

                    // Water Amount
                    VStack {
                        let waterAmount = targetYield - (Double(doseIn) ?? 0)
                        Text(String(format: "%.0f", waterAmount))
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.espressoBrown)
                        Text(LocalizedString.get("water_ml"))
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var brewingGuideCard: some View {
        CustomCard {
            if let method = selectedMethod {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: method.icon)
                            .foregroundColor(.espressoBrown)
                            .font(.title2)
                        Text("\(method.name) " + LocalizedString.get("brewing_guide"))
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                    }

                    Divider()
                        .background(Color.dividerColor)

                    InfoRow(
                        icon: "timer",
                        label: LocalizedString.get("brew_time"),
                        value: formatBrewTime(method.defaultBrewTimeMin...method.defaultBrewTimeMax)
                    )

                    InfoRow(
                        icon: "drop.fill",
                        label: LocalizedString.get("typical_ratio"),
                        value: "1:\(String(format: "%.1f", method.defaultRatioMin))-\(String(format: "%.1f", method.defaultRatioMax))"
                    )

                    InfoRow(
                        icon: "thermometer",
                        label: LocalizedString.get("water_temp"),
                        value: "\(String(format: "%.0f", method.defaultWaterTemp))°C"
                    )

                    if method.defaultPressure > 0 {
                        InfoRow(
                            icon: "gauge",
                            label: LocalizedString.get("pressure"),
                            value: "\(String(format: "%.1f", method.defaultPressure)) bar"
                        )
                    }
                }
            } else {
                Text(LocalizedString.get("no_brewing_methods"))
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }
    }

    private func calculateYield() {
        guard let dose = Double(doseIn),
              let ratioValue = Double(ratio) else {
            targetYield = 0
            return
        }
        targetYield = dose * ratioValue
    }

    private func updateDefaults(for method: BrewingMethodModel) {
        doseIn = String(format: "%.0f", method.defaultDoseGrams)
        ratio = String(format: "%.1f", (method.defaultRatioMin + method.defaultRatioMax) / 2.0)
        calculateYield()
    }

    private func formatBrewTime(_ range: ClosedRange<Double>) -> String {
        let lower = range.lowerBound
        let upper = range.upperBound

        if upper >= 3600 {
            return "\(Int(lower/3600))-\(Int(upper/3600)) \(LocalizedString.get("hours"))"
        } else if upper >= 60 {
            return "\(Int(lower/60))-\(Int(upper/60)) \(LocalizedString.get("minutes"))"
        } else {
            return "\(Int(lower))-\(Int(upper)) \(LocalizedString.get("seconds"))"
        }
    }
}

struct MethodCardButton: View {
    let method: BrewingMethodModel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: method.icon)
                    .font(.title2)
                Text(method.name)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .background(isSelected ? Color.espressoBrown : Color.backgroundSecondary)
            .cornerRadius(12)
        }
    }
}

#Preview {
    RecipeCalculatorView()
}
