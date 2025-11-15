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
    @State private var exportURL: URL?

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
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
                            Text("Water Temperature")
                            Spacer()
                            TextField("93", value: $settings.defaultWaterTemp, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("°C")
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text("Pressure (Espresso)")
                            Spacer()
                            TextField("9.0", value: $settings.defaultPressure, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("bar")
                                .foregroundColor(.textSecondary)
                        }

                        Picker("Default Method", selection: $settings.defaultBrewMethod) {
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
                            Text("Grams").tag("grams")
                            Text("Ounces").tag("ounces")
                        }

                        Picker(LocalizedString.get("temperature"), selection: $settings.temperatureUnit) {
                            Text("Celsius").tag("celsius")
                            Text("Fahrenheit").tag("fahrenheit")
                        }

                        Picker(LocalizedString.get("volume"), selection: $settings.volumeUnit) {
                            Text("Milliliters").tag("ml")
                            Text("Fluid Ounces").tag("oz")
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Appearance
                    Section(header: Text(LocalizedString.get("appearance")).foregroundColor(.espressoBrown)) {
                        Picker(LocalizedString.get("theme"), selection: $settings.colorScheme) {
                            Text("Dark").tag("dark")
                            Text("Light").tag("light")
                            Text("System").tag("system")
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.cardBackground)

                    // Language
                    Section(header: Text(LocalizedString.get("language")).foregroundColor(.espressoBrown)) {
                        Picker("App Language", selection: $settings.appLanguage) {
                            HStack {
                                Text("🇺🇸")
                                Text("English")
                            }
                            .tag("en")

                            HStack {
                                Text("🇩🇪")
                                Text("Deutsch")
                            }
                            .tag("de")
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Data Management
                    Section(header: Text("Data Management").foregroundColor(.espressoBrown)) {
                        Button(action: { showingTestDataAlert = true }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.warningOrange)
                                Text("Add Test Data")
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
                                Text("Export All Data")
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
                                Text("Import Data")
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
                    Section(header: Text("About").foregroundColor(.espressoBrown)) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text("Build")
                            Spacer()
                            Text("2024.1")
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
            .alert("Export Successful", isPresented: $showingExportSuccess) {
                Button("OK", role: .cancel) { }
                if let url = exportURL {
                    Button("Share") {
                        shareFile(url)
                    }
                }
            } message: {
                Text("Your data has been exported successfully.")
            }
            .alert("Add Test Data", isPresented: $showingTestDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    populateTestData()
                }
            } message: {
                Text("This will add sample grinders, machines, and beans to your database. This is helpful for testing the app.")
            }
            .alert("Test Data Added", isPresented: $showingTestDataSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Successfully added 3 grinders, 3 machines, and 4 beans. Check the Equipment and Beans tabs!")
            }
        }
    }

    private func populateTestData() {
        do {
            TestDataHelper.populateTestData(modelContext: modelContext)
            showingTestDataSuccess = true
        } catch {
            print("Error populating test data: \(error)")
        }
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
