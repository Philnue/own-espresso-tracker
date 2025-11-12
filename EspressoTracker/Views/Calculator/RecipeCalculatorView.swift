//
//  RecipeCalculatorView.swift
//  EspressoTracker
//
//  Recipe calculator for different brewing methods
//

import SwiftUI

struct RecipeCalculatorView: View {
    @ObservedObject private var settings = UserSettings.shared
    @State private var selectedMethod: BrewMethod = .espresso
    @State private var doseIn: String = "18"
    @State private var ratio: String = "2.0"
    @State private var targetYield: Double = 36.0

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

                        // Common Recipes
                        commonRecipesCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Recipe Calculator")
        }
    }

    private var methodSelectorCard: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Brewing Method")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            MethodButton(
                                method: method,
                                isSelected: selectedMethod == method
                            ) {
                                selectedMethod = method
                                updateDefaults(for: method)
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
                Text("Recipe Parameters")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Divider()
                    .background(Color.dividerColor)

                // Coffee Dose
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coffee Dose")
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

                        Text("grams")
                            .foregroundColor(.textSecondary)

                        Spacer()
                    }
                }

                // Brew Ratio
                VStack(alignment: .leading, spacing: 8) {
                    Text("Brew Ratio (1:x)")
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

                        Text("ratio")
                            .foregroundColor(.textSecondary)

                        Spacer()
                    }
                }

                // Typical Range
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.espressoBrown)
                    Text("Typical ratio: 1:\(String(format: "%.0f", selectedMethod.typicalRatio.lowerBound)) - 1:\(String(format: "%.0f", selectedMethod.typicalRatio.upperBound))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }

    private var resultsCard: some View {
        CustomCard {
            VStack(spacing: 20) {
                Text("Results")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                HStack(spacing: 20) {
                    // Target Yield
                    VStack {
                        Text(String(format: "%.1f", targetYield))
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.espressoBrown)
                        Text("Target Yield (g)")
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
                        Text("Water (ml)")
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
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: selectedMethod.icon)
                        .foregroundColor(.espressoBrown)
                        .font(.title2)
                    Text("\(selectedMethod.rawValue) Guide")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }

                Divider()
                    .background(Color.dividerColor)

                InfoRow(
                    icon: "timer",
                    label: "Brew Time",
                    value: formatBrewTime(selectedMethod.typicalBrewTime)
                )

                InfoRow(
                    icon: "drop.fill",
                    label: "Typical Ratio",
                    value: "1:\(String(format: "%.0f", selectedMethod.typicalRatio.lowerBound))-\(String(format: "%.0f", selectedMethod.typicalRatio.upperBound))"
                )

                // Method-specific tips
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.espressoBrown)
                        Text("Tips")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)
                    }

                    Text(getTipsForMethod(selectedMethod))
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var commonRecipesCard: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Common Recipes")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Divider()
                    .background(Color.dividerColor)

                ForEach(getCommonRecipes(for: selectedMethod), id: \.name) { recipe in
                    RecipeRow(recipe: recipe) {
                        applyRecipe(recipe)
                    }
                }
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

    private func updateDefaults(for method: BrewMethod) {
        switch method {
        case .espresso:
            doseIn = "18"
            ratio = "2.0"
        case .aeropress:
            doseIn = "15"
            ratio = "16.0"
        case .frenchPress:
            doseIn = "30"
            ratio = "16.0"
        case .coldBrew:
            doseIn = "100"
            ratio = "5.0"
        case .pourOver:
            doseIn = "20"
            ratio = "16.0"
        case .moka:
            doseIn = "20"
            ratio = "8.0"
        }
        calculateYield()
    }

    private func formatBrewTime(_ range: ClosedRange<Double>) -> String {
        let lower = range.lowerBound
        let upper = range.upperBound

        if upper >= 3600 {
            return "\(Int(lower/3600))-\(Int(upper/3600)) hours"
        } else if upper >= 60 {
            return "\(Int(lower/60))-\(Int(upper/60)) min"
        } else {
            return "\(Int(lower))-\(Int(upper)) sec"
        }
    }

    private func getTipsForMethod(_ method: BrewMethod) -> String {
        switch method {
        case .espresso:
            return "Aim for 25-30 seconds extraction time. Adjust grind size if too fast (<20s) or too slow (>35s)."
        case .aeropress:
            return "Use medium-fine grind. Experiment with inverted method for more control. Stir 10 seconds before plunging."
        case .frenchPress:
            return "Use coarse grind to prevent over-extraction. Stir after 4 minutes, let settle 1 minute before plunging."
        case .coldBrew:
            return "Use coarse grind. Brew in refrigerator for 12-24 hours. Dilute concentrate 1:1 with water or milk."
        case .pourOver:
            return "Use medium grind. Bloom for 30-45 seconds with 2x coffee weight in water. Pour in circles."
        case .moka:
            return "Use medium-fine grind. Fill water to valve level. Use medium heat and remove from heat when coffee starts sputtering."
        }
    }

    private func getCommonRecipes(for method: BrewMethod) -> [CommonRecipe] {
        switch method {
        case .espresso:
            return [
                CommonRecipe(name: "Ristretto", dose: 18, ratio: 1.5, description: "Short, intense shot"),
                CommonRecipe(name: "Normale", dose: 18, ratio: 2.0, description: "Standard espresso"),
                CommonRecipe(name: "Lungo", dose: 18, ratio: 2.5, description: "Longer extraction")
            ]
        case .aeropress:
            return [
                CommonRecipe(name: "Classic", dose: 15, ratio: 16.0, description: "Standard Aeropress"),
                CommonRecipe(name: "Concentrated", dose: 18, ratio: 12.0, description: "Strong brew"),
                CommonRecipe(name: "Diluted", dose: 12, ratio: 18.0, description: "Lighter brew")
            ]
        case .frenchPress:
            return [
                CommonRecipe(name: "Standard", dose: 30, ratio: 16.0, description: "Balanced brew"),
                CommonRecipe(name: "Strong", dose: 35, ratio: 14.0, description: "Full-bodied"),
                CommonRecipe(name: "Light", dose: 25, ratio: 18.0, description: "Milder flavor")
            ]
        case .coldBrew:
            return [
                CommonRecipe(name: "Concentrate", dose: 100, ratio: 5.0, description: "Strong concentrate"),
                CommonRecipe(name: "Ready to Drink", dose: 80, ratio: 8.0, description: "Pre-diluted"),
                CommonRecipe(name: "Extra Strong", dose: 120, ratio: 4.0, description: "Maximum flavor")
            ]
        case .pourOver:
            return [
                CommonRecipe(name: "Hario V60", dose: 20, ratio: 16.0, description: "Classic V60"),
                CommonRecipe(name: "Stronger", dose: 22, ratio: 15.0, description: "Full-bodied"),
                CommonRecipe(name: "Lighter", dose: 18, ratio: 17.0, description: "Bright & clean")
            ]
        case .moka:
            return [
                CommonRecipe(name: "Classic", dose: 20, ratio: 8.0, description: "Traditional moka"),
                CommonRecipe(name: "Strong", dose: 22, ratio: 7.0, description: "Intense flavor"),
                CommonRecipe(name: "Light", dose: 18, ratio: 9.0, description: "Mild brew")
            ]
        }
    }

    private func applyRecipe(_ recipe: CommonRecipe) {
        doseIn = String(format: "%.0f", recipe.dose)
        ratio = String(format: "%.1f", recipe.ratio)
        calculateYield()
    }
}

struct CommonRecipe {
    let name: String
    let dose: Double
    let ratio: Double
    let description: String
}

struct MethodButton: View {
    let method: BrewMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: method.icon)
                    .font(.title2)
                Text(method.rawValue)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .background(isSelected ? Color.espressoBrown : Color.backgroundSecondary)
            .cornerRadius(12)
        }
    }
}

struct RecipeRow: View {
    let recipe: CommonRecipe
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    Text(recipe.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(String(format: "%.0f", recipe.dose))g")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.espressoBrown)
                    Text("1:\(String(format: "%.1f", recipe.ratio))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    RecipeCalculatorView()
}
