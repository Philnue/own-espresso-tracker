//
//  LocalizedStrings.swift
//  EspressoTracker
//
//  Localization helper that loads translations from JSON files
//

import Foundation

struct LocalizedString {
    private static var translations: [String: [String: String]] = loadTranslations()

    static func get(_ key: String, language: String = UserSettings.shared.appLanguage) -> String {
        return translations[language]?[key] ?? translations["en"]?[key] ?? key
    }

    private static func loadTranslations() -> [String: [String: String]] {
        var result: [String: [String: String]] = [:]

        print("🌍 [LocalizedString] Starting to load translations...")

        // Load English translations
        print("🌍 [LocalizedString] Looking for en.json in Localization subdirectory...")
        if let enURL = Bundle.main.url(forResource: "en", withExtension: "json", subdirectory: "Localization") {
            print("🌍 [LocalizedString] ✅ Found en.json at: \(enURL.path)")
            if let enData = try? Data(contentsOf: enURL) {
                print("🌍 [LocalizedString] ✅ Loaded en.json data (\(enData.count) bytes)")
                if let enDict = try? JSONDecoder().decode([String: String].self, from: enData) {
                    print("🌍 [LocalizedString] ✅ Decoded en.json with \(enDict.count) keys")
                    result["en"] = enDict
                } else {
                    print("🌍 [LocalizedString] ❌ Failed to decode en.json")
                }
            } else {
                print("🌍 [LocalizedString] ❌ Failed to load data from en.json")
            }
        } else {
            print("🌍 [LocalizedString] ❌ Could not find en.json in bundle")
        }

        // Load German translations
        print("🌍 [LocalizedString] Looking for de.json in Localization subdirectory...")
        if let deURL = Bundle.main.url(forResource: "de", withExtension: "json", subdirectory: "Localization") {
            print("🌍 [LocalizedString] ✅ Found de.json at: \(deURL.path)")
            if let deData = try? Data(contentsOf: deURL) {
                print("🌍 [LocalizedString] ✅ Loaded de.json data (\(deData.count) bytes)")
                if let deDict = try? JSONDecoder().decode([String: String].self, from: deData) {
                    print("🌍 [LocalizedString] ✅ Decoded de.json with \(deDict.count) keys")
                    result["de"] = deDict
                } else {
                    print("🌍 [LocalizedString] ❌ Failed to decode de.json")
                }
            } else {
                print("🌍 [LocalizedString] ❌ Failed to load data from de.json")
            }
        } else {
            print("🌍 [LocalizedString] ❌ Could not find de.json in bundle")
        }

        // Fallback to embedded translations if JSON files not found
        if result.isEmpty {
            print("🌍 [LocalizedString] ⚠️ No JSON files loaded, using embedded fallback translations")
            result = embeddedTranslations()
        } else {
            print("🌍 [LocalizedString] ✅ Successfully loaded translations from JSON files")
        }

        return result
    }

    // Embedded fallback translations (kept for safety)
    private static func embeddedTranslations() -> [String: [String: String]] {
        return [
            "en": [
                "tab_brew": "Brew",
                "tab_history": "History",
                "tab_beans": "Beans",
                "tab_recipes": "Recipes",
                "tab_equipment": "Equipment",
                "tab_settings": "Settings",
                "save": "Save",
                "cancel": "Cancel",
                "delete": "Delete",
                "edit": "Edit",
                "brewing_defaults": "Brewing Defaults",
                "default_dose": "Default Dose",
                "default_ratio": "Default Ratio",
                "default_method": "Default Method",
                "appearance": "Appearance",
                "theme": "Theme",
                "language": "Language",
                "units": "Units",
                "weight": "Weight",
                "temperature": "Temperature",
                "volume": "Volume",
                "brewing_method": "Brewing Method",
                "dose_in": "Dose In",
                "yield_out": "Yield Out",
                "brew_time": "Brew Time",
                "water_temp": "Water Temp",
                "pressure": "Pressure",
                "grind_setting": "Grind Setting",
                "taste_profile": "Taste Profile",
                "acidity": "Acidity",
                "sweetness": "Sweetness",
                "bitterness": "Bitterness",
                "body": "Body",
                "aftertaste": "Aftertaste",
                "recommendations": "Recommendations",
                "great_shot": "Great shot! Current parameters are working well",
                "import_data": "Import Data",
                "export_data": "Export Data",
                "no_history_yet": "No Brewing History",
                "no_history_description": "Your brewing sessions will appear here"
            ],
            "de": [
                "tab_brew": "Brühen",
                "tab_history": "Verlauf",
                "tab_beans": "Bohnen",
                "tab_recipes": "Rezepte",
                "tab_equipment": "Ausstattung",
                "tab_settings": "Einstellungen",
                "save": "Speichern",
                "cancel": "Abbrechen",
                "delete": "Löschen",
                "edit": "Bearbeiten",
                "brewing_defaults": "Standard-Einstellungen",
                "default_dose": "Standard-Dosis",
                "default_ratio": "Standard-Verhältnis",
                "default_method": "Standard-Methode",
                "appearance": "Erscheinungsbild",
                "theme": "Design",
                "language": "Sprache",
                "units": "Einheiten",
                "weight": "Gewicht",
                "temperature": "Temperatur",
                "volume": "Volumen",
                "brewing_method": "Brühmethode",
                "dose_in": "Dosis",
                "yield_out": "Ertrag",
                "brew_time": "Brühzeit",
                "water_temp": "Wassertemp",
                "pressure": "Druck",
                "grind_setting": "Mahlgrad",
                "taste_profile": "Geschmacksprofil",
                "acidity": "Säure",
                "sweetness": "Süße",
                "bitterness": "Bitterkeit",
                "body": "Körper",
                "aftertaste": "Nachgeschmack",
                "recommendations": "Empfehlungen",
                "great_shot": "Perfekter Shot! Die aktuellen Parameter funktionieren gut",
                "import_data": "Daten importieren",
                "export_data": "Daten exportieren",
                "no_history_yet": "Keine Brühhistorie",
                "no_history_description": "Ihre Brühsitzungen erscheinen hier"
            ]
        ]
    }
}
