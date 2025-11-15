//
//  BrewingView.swift
//  EspressoTracker
//
//  Main brewing view with stopwatch and ratio calculator
//

import SwiftUI
import SwiftData

struct BrewingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = BrewingViewModel()
    @ObservedObject private var settings = UserSettings.shared

    @Query(sort: \Grinder.name) private var grinders: [Grinder]
    @Query(sort: \Machine.name) private var machines: [Machine]
    @Query(sort: \Bean.createdAt, order: .reverse) private var allBeans: [Bean]

    @State private var selectedGrinder: Grinder?
    @State private var selectedMachine: Machine?
    @State private var selectedBean: Bean?
    @State private var selectedMethod: BrewMethod = .espresso
    @State private var showingFinishSheet = false
    @State private var showArchivedBeans = false

    // Filtered beans based on archive status
    private var beans: [Bean] {
        if showArchivedBeans {
            return allBeans
        } else {
            return allBeans.filter { !$0.isArchived }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Brewing method selector
                        methodSelector

                        // Stopwatch section
                        stopwatchSection

                        // Equipment selection
                        equipmentSection

                        // Brewing parameters
                        parametersSection

                        // Ratio calculator
                        ratioSection

                        // Action buttons
                        actionButtons
                    }
                    .padding()
                }
            }
            .navigationTitle("Brew")
            .sheet(isPresented: $showingFinishSheet) {
                FinishBrewView(
                    viewModel: viewModel,
                    brewMethod: selectedMethod.rawValue.lowercased(),
                    grinder: selectedGrinder,
                    machine: selectedMachine,
                    bean: selectedBean
                )
            }
            .onAppear {
                // Load default settings
                viewModel.doseIn = String(settings.defaultDoseIn)
                viewModel.targetRatio = settings.defaultRatio
                viewModel.waterTemp = String(settings.defaultWaterTemp)
                viewModel.pressure = String(settings.defaultPressure)
                if let method = BrewMethod.allCases.first(where: { $0.rawValue.lowercased() == settings.defaultBrewMethod }) {
                    selectedMethod = method
                }
            }
        }
    }

    private var methodSelector: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Brewing Method")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            Button(action: {
                                selectedMethod = method
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: method.icon)
                                        .font(.title3)
                                    Text(method.rawValue)
                                        .font(.caption2)
                                }
                                .frame(width: 70, height: 60)
                                .foregroundColor(selectedMethod == method ? .white : .textSecondary)
                                .background(selectedMethod == method ? Color.espressoBrown : Color.backgroundSecondary)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
    }

    private var stopwatchSection: some View {
        CustomCard {
            VStack(spacing: 20) {
                // Timer display
                Text(viewModel.elapsedTimeString)
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(.espressoBrown)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                // Timer controls
                HStack(spacing: 20) {
                    // Start/Stop button
                    Button(action: {
                        viewModel.toggleTimer()
                    }) {
                        HStack {
                            Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                            Text(viewModel.isRunning ? "Stop" : "Start")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 60)
                        .background(
                            LinearGradient.espressoGradient
                        )
                        .cornerRadius(16)
                    }
                    .buttonShadow()

                    // Reset button
                    Button(action: {
                        viewModel.resetTimer()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.espressoBrown)
                        .frame(width: 140, height: 60)
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.espressoBrown, lineWidth: 2)
                        )
                    }
                }

                // Extraction indicator
                if viewModel.elapsedTime > 0 {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Extraction")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text(extractionStatus)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(extractionColor)
                        }

                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.backgroundSecondary)
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(extractionColor)
                                    .frame(width: min(geometry.size.width, geometry.size.width * CGFloat(viewModel.elapsedTime / 35)), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
        }
    }

    private var equipmentSection: some View {
        VStack(spacing: 16) {
            Text("Equipment")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Grinder selection
            Menu {
                ForEach(grinders) { grinder in
                    Button(grinder.wrappedName) {
                        selectedGrinder = grinder
                    }
                }
            } label: {
                CustomCard {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.espressoBrown)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Grinder")
                                .font(.caption)
                                .foregroundColor(.textSecondary)

                            if let grinder = selectedGrinder {
                                Text(grinder.wrappedName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                            } else {
                                Text("Select grinder")
                                    .font(.body)
                                    .foregroundColor(.textTertiary)
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.espressoBrown)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Machine selection
            Menu {
                ForEach(machines) { machine in
                    Button(machine.wrappedName) {
                        selectedMachine = machine
                    }
                }
            } label: {
                CustomCard {
                    HStack {
                        Image(systemName: "refrigerator")
                            .font(.title2)
                            .foregroundColor(.espressoBrown)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Machine")
                                .font(.caption)
                                .foregroundColor(.textSecondary)

                            if let machine = selectedMachine {
                                Text(machine.wrappedName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                            } else {
                                Text("Select machine")
                                    .font(.body)
                                    .foregroundColor(.textTertiary)
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.espressoBrown)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Bean selection
            Menu {
                // Show archived toggle
                Button(action: {
                    showArchivedBeans.toggle()
                }) {
                    Label(
                        showArchivedBeans ? "Hide Archived" : "Show Archived",
                        systemImage: showArchivedBeans ? "eye.slash" : "eye"
                    )
                }

                Divider()

                ForEach(beans) { bean in
                    Button(action: {
                        selectedBean = bean
                    }) {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(bean.wrappedName)
                                if bean.isArchived {
                                    Image(systemName: "archivebox")
                                        .font(.caption)
                                }
                            }

                            HStack(spacing: 4) {
                                Text(bean.wrappedRoaster)
                                    .font(.caption)
                                Text("•")
                                if bean.weight > 0 {
                                    Text("\(Int(bean.remainingWeight))g")
                                        .foregroundColor(bean.isLowStock ? .warningOrange : .primary)
                                    Text("•")
                                }
                                Text("\(bean.freshnessIndicator)")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
            } label: {
                CustomCard {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .font(.title2)
                                .foregroundColor(.espressoBrown)
                                .frame(width: 40)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Beans")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)

                                if let bean = selectedBean {
                                    Text(bean.wrappedName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.textPrimary)

                                    HStack(spacing: 8) {
                                        Text(bean.wrappedRoaster)
                                            .font(.caption2)
                                            .foregroundColor(.textSecondary)

                                        if bean.weight > 0 {
                                            Text("•")
                                                .foregroundColor(.textTertiary)
                                            Text("\(Int(bean.remainingWeight))g left")
                                                .font(.caption2)
                                                .foregroundColor(bean.isLowStock ? .warningOrange : .textSecondary)
                                        }

                                        Text("•")
                                            .foregroundColor(.textTertiary)
                                        Text("\(bean.daysFromRoast)d")
                                            .font(.caption2)
                                            .foregroundColor(.textSecondary)
                                    }
                                } else {
                                    Text("Select beans")
                                        .font(.body)
                                        .foregroundColor(.textTertiary)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.down")
                                .foregroundColor(.espressoBrown)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var parametersSection: some View {
        VStack(spacing: 16) {
            Text("Parameters")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomCard {
                VStack(spacing: 16) {
                    // Grind setting
                    HStack {
                        Text("Grind Setting")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        TextField("e.g., 15", text: $viewModel.grindSetting)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .foregroundColor(.textPrimary)
                    }

                    Divider()
                        .background(Color.dividerColor)

                    // Water temperature
                    HStack {
                        Text("Water Temp (°C)")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        TextField("93", text: $viewModel.waterTemp)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .foregroundColor(.textPrimary)
                    }

                    Divider()
                        .background(Color.dividerColor)

                    // Pressure
                    HStack {
                        Text("Pressure (bar)")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        TextField("9.0", text: $viewModel.pressure)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }

    private var ratioSection: some View {
        VStack(spacing: 16) {
            Text("Brew Ratio")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Ratio presets
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.ratioPresets, id: \.name) { preset in
                        Button(action: {
                            viewModel.targetRatio = preset.ratio
                        }) {
                            VStack(spacing: 4) {
                                Text(preset.name)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Text("1:\(String(format: "%.1f", preset.ratio))")
                                    .font(.caption2)
                            }
                            .foregroundColor(viewModel.targetRatio == preset.ratio ? .white : .espressoBrown)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                viewModel.targetRatio == preset.ratio
                                    ? Color.espressoBrown
                                    : Color.cardBackground
                            )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.espressoBrown, lineWidth: 1)
                            )
                        }
                    }
                }
            }

            // Dose and yield
            CustomCard {
                VStack(spacing: 20) {
                    // Dose input
                    VStack(spacing: 8) {
                        Text("Dose In")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)

                        HStack {
                            TextField("18", text: $viewModel.doseIn)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textPrimary)

                            Text("g")
                                .font(.title3)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .foregroundColor(.espressoBrown)

                    // Target yield (calculated)
                    VStack(spacing: 8) {
                        Text("Target Yield (1:\(String(format: "%.1f", viewModel.targetRatio)))")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)

                        HStack {
                            Text(viewModel.targetYieldString)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.espressoBrown)

                            Text("g")
                                .font(.title3)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Finish & Save Shot") {
                if !viewModel.isRunning {
                    showingFinishSheet = true
                }
            }
            .disabled(viewModel.isRunning || viewModel.elapsedTime == 0 || selectedGrinder == nil || selectedMachine == nil || selectedBean == nil)

            // Show helpful message when equipment is missing
            if selectedGrinder == nil || selectedMachine == nil || selectedBean == nil {
                Text("Please select grinder, machine, and beans to continue")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var extractionStatus: String {
        let time = viewModel.elapsedTime
        if time < 20 {
            return "Under-extracted"
        } else if time <= 30 {
            return "Optimal"
        } else if time <= 35 {
            return "Good"
        } else {
            return "Over-extracted"
        }
    }

    private var extractionColor: Color {
        let time = viewModel.elapsedTime
        if time < 20 {
            return .warningOrange
        } else if time <= 35 {
            return .successGreen
        } else {
            return .errorRed
        }
    }
}

#Preview {
    BrewingView()
        .modelContainer(for: [Grinder.self, Machine.self, Bean.self], inMemory: true)
}
