//
//  SettingsView.swift
//  EspressoTracker
//
//  Settings and preferences
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var settings = UserSettings.shared

    @State private var showingImport = false
    @State private var showingExport = false
    @State private var showingExportSuccess = false
    @State private var showingTestDataAlert = false
    @State private var showingTestDataSuccess = false
    @State private var showingTutorial = false
    @State private var exportURL: URL?

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                // Equipment
                Section(header: Text(LocalizedString.get("equipment")).foregroundColor(.espressoBrown)) {
                    NavigationLink(destination: EquipmentView()) {
                        HStack {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("equipment"))
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Brewing Methods
                Section(header: Text(LocalizedString.get("brewing_methods")).foregroundColor(.espressoBrown)) {
                    NavigationLink(destination: BrewingMethodsView()) {
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("manage_brewing_methods"))
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Brewing Defaults
                Section(header: Text(LocalizedString.get("brewing_defaults")).foregroundColor(.espressoBrown)) {
                    HStack {
                        Text(LocalizedString.get("default_dose"))
                        Spacer()
                        TextField("18.0", value: $settings.defaultDoseIn, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("g")
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text(LocalizedString.get("default_ratio"))
                        Spacer()
                        TextField("2.0", value: $settings.defaultRatio, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("1:x")
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text(LocalizedString.get("water_temperature"))
                        Spacer()
                        TextField("93", value: $settings.defaultWaterTemp, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("°C")
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text(LocalizedString.get("pressure_espresso"))
                        Spacer()
                        TextField("9.0", value: $settings.defaultPressure, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("bar")
                            .foregroundColor(.textSecondary)
                    }

                    Picker(LocalizedString.get("default_method"), selection: $settings.defaultBrewMethod) {
                        ForEach(BrewMethod.allCases, id: \.rawValue) { method in
                            HStack {
                                Image(systemName: method.icon)
                                Text(method.rawValue)
                            }
                            .tag(method.rawValue.lowercased())
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Units
                Section(header: Text(LocalizedString.get("units")).foregroundColor(.espressoBrown)) {
                    Picker(LocalizedString.get("weight"), selection: $settings.weightUnit) {
                        Text(LocalizedString.get("grams")).tag("grams")
                        Text(LocalizedString.get("ounces")).tag("ounces")
                    }

                    Picker(LocalizedString.get("temperature"), selection: $settings.temperatureUnit) {
                        Text(LocalizedString.get("celsius")).tag("celsius")
                        Text(LocalizedString.get("fahrenheit")).tag("fahrenheit")
                    }

                    Picker(LocalizedString.get("volume"), selection: $settings.volumeUnit) {
                        Text(LocalizedString.get("milliliters")).tag("ml")
                        Text(LocalizedString.get("fluid_ounces")).tag("oz")
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Appearance
                Section(header: Text(LocalizedString.get("appearance")).foregroundColor(.espressoBrown)) {
                    Picker(LocalizedString.get("theme"), selection: $settings.colorScheme) {
                        Text(LocalizedString.get("dark")).tag("dark")
                        Text(LocalizedString.get("light")).tag("light")
                        Text(LocalizedString.get("system")).tag("system")
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.cardBackground)

                // Language
                Section(header: Text(LocalizedString.get("language")).foregroundColor(.espressoBrown)) {
                    Picker(LocalizedString.get("app_language"), selection: $settings.appLanguage) {
                        HStack {
                            Text(LocalizedString.get("english"))
                            Text("🇺🇸")
                        }
                        .tag("en")

                        HStack {
                            Text(LocalizedString.get("german"))
                            Text("🇩🇪")
                        }
                        .tag("de")
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Data Management
                Section(header: Text(LocalizedString.get("data_management")).foregroundColor(.espressoBrown)) {
                    Button(action: { showingTestDataAlert = true }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(.warningOrange)
                            Text(LocalizedString.get("add_test_data"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textTertiary)
                                .font(.caption)
                        }
                    }

                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("export_data"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textTertiary)
                                .font(.caption)
                        }
                    }

                    Button(action: { showingImport = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("import_data"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textTertiary)
                                .font(.caption)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // About
                Section(header: Text(LocalizedString.get("about")).foregroundColor(.espressoBrown)) {
                    Button(action: { showingTutorial = true }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("view_tutorial"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textTertiary)
                                .font(.caption)
                        }
                    }

                    HStack {
                        Text(LocalizedString.get("version"))
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text(LocalizedString.get("build"))
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundColor(.textSecondary)
                    }
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .id(settings.appLanguage) // Force refresh when language changes
        }
        .navigationTitle(LocalizedString.get("tab_settings"))
        .fileImporter(
            isPresented: $showingImport,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
        .alert(LocalizedString.get("export_success"), isPresented: $showingExportSuccess) {
            Button(LocalizedString.get("ok"), role: .cancel) { }
            if let url = exportURL {
                Button(LocalizedString.get("share")) {
                    shareFile(url)
                }
            }
        } message: {
            Text(LocalizedString.get("export_success_message"))
        }
        .alert(LocalizedString.get("add_test_data"), isPresented: $showingTestDataAlert) {
            Button(LocalizedString.get("cancel"), role: .cancel) { }
            Button(LocalizedString.get("add")) {
                populateTestData()
            }
        } message: {
            Text(LocalizedString.get("add_test_data_message"))
        }
        .alert(LocalizedString.get("test_data_added"), isPresented: $showingTestDataSuccess) {
            Button(LocalizedString.get("ok"), role: .cancel) { }
        } message: {
            Text(LocalizedString.get("test_data_added_message"))
        }
        .fullScreenCover(isPresented: $showingTutorial) {
            TutorialView()
        }
        }
    }

    private func populateTestData() {
        let dataManager = DataManager(modelContext: modelContext)

        // Add default brewing methods if none exist
        let descriptor = FetchDescriptor<BrewingMethodModel>()
        let existingMethods = (try? modelContext.fetch(descriptor)) ?? []
        if existingMethods.isEmpty {
            for method in BrewingMethodModel.allDefaultMethods() {
                modelContext.insert(method)
            }
        }

        // Add test grinders
        dataManager.createGrinder(
            name: "Niche Zero",
            brand: "Niche",
            burrType: "Conical",
            burrSize: 63,
            notes: "Single-dose grinder with excellent consistency",
            imageData: nil
        )

        dataManager.createGrinder(
            name: "DF64",
            brand: "Turin",
            burrType: "Flat",
            burrSize: 64,
            notes: "Great value flat burr grinder",
            imageData: nil
        )

        dataManager.createGrinder(
            name: "Comandante C40",
            brand: "Comandante",
            burrType: "Conical",
            burrSize: 40,
            notes: "Hand grinder for travel",
            imageData: nil
        )

        // Add test machines
        dataManager.createMachine(
            name: "Gaggia Classic Pro",
            brand: "Gaggia",
            model: "Classic Pro",
            boilerType: "Single Boiler",
            groupHeadType: "Standard",
            pressureBar: 9.0,
            notes: "Modded with PID and OPV adjustment",
            imageData: nil,
            purchaseDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())
        )

        dataManager.createMachine(
            name: "Rancilio Silvia",
            brand: "Rancilio",
            model: "Silvia V6",
            boilerType: "Single Boiler",
            groupHeadType: "Standard",
            pressureBar: 9.5,
            notes: "Reliable single boiler machine",
            imageData: nil,
            purchaseDate: nil
        )

        dataManager.createMachine(
            name: "Lelit Bianca",
            brand: "Lelit",
            model: "Bianca V3",
            boilerType: "Dual Boiler",
            groupHeadType: "E61",
            pressureBar: 9.0,
            notes: "Flow control and pressure profiling capable",
            imageData: nil,
            purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())
        )

        // Add test beans
        let roastDate1 = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Ethiopia Yirgacheffe",
            roaster: "Local Coffee Roasters",
            origin: "Ethiopia",
            roastLevel: "Light",
            roastDate: roastDate1,
            process: "Washed",
            variety: "Heirloom",
            tastingNotes: "Floral, citrus, bergamot",
            price: 18.50,
            weight: 250.0,
            notes: "Great for filter and espresso",
            imageData: nil,
            isArchived: false
        )

        let roastDate2 = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Colombia Huila",
            roaster: "Specialty Coffee Co",
            origin: "Colombia",
            roastLevel: "Medium",
            roastDate: roastDate2,
            process: "Washed",
            variety: "Caturra",
            tastingNotes: "Chocolate, caramel, nuts",
            price: 16.00,
            weight: 250.0,
            notes: "Classic espresso profile",
            imageData: nil,
            isArchived: false
        )

        let roastDate3 = Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Brazil Cerrado",
            roaster: "Bean Brothers",
            origin: "Brazil",
            roastLevel: "Medium-Dark",
            roastDate: roastDate3,
            process: "Natural",
            variety: "Yellow Bourbon",
            tastingNotes: "Dark chocolate, molasses, low acidity",
            price: 14.50,
            weight: 500.0,
            notes: "Great for milk drinks",
            imageData: nil,
            isArchived: false
        )

        let roastDate4 = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Kenya AA",
            roaster: "Third Wave Coffee",
            origin: "Kenya",
            roastLevel: "Light-Medium",
            roastDate: roastDate4,
            process: "Washed",
            variety: "SL28, SL34",
            tastingNotes: "Blackcurrant, tomato, bright acidity",
            price: 22.00,
            weight: 250.0,
            notes: "Complex and fruity",
            imageData: nil,
            isArchived: false
        )

        // Show success alert
        showingTestDataSuccess = true
    }

    private func exportData() {
        Task {
            do {
                let exporter = DataExporter(modelContext: modelContext)
                let url = try await exporter.exportAllData()
                await MainActor.run {
                    exportURL = url
                    showingExportSuccess = true
                }
            } catch {
                print("Export failed: \(error)")
            }
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        do {
            guard let selectedFile = try result.get().first else { return }
            let importer = DataImporter(modelContext: modelContext)
            Task {
                try await importer.importData(from: selectedFile)
            }
        } catch {
            print("Import failed: \(error)")
        }
    }

    private func shareFile(_ url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
