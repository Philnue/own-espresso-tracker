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

        // Load English translations
        if let enURL = Bundle.main.url(forResource: "en", withExtension: "json", subdirectory: "Localization"),
           let enData = try? Data(contentsOf: enURL),
           let enDict = try? JSONDecoder().decode([String: String].self, from: enData) {
            result["en"] = enDict
        }

        // Load German translations
        if let deURL = Bundle.main.url(forResource: "de", withExtension: "json", subdirectory: "Localization"),
           let deData = try? Data(contentsOf: deURL),
           let deDict = try? JSONDecoder().decode([String: String].self, from: deData) {
            result["de"] = deDict
        }

        // Fallback to embedded translations if JSON files not found
        if result.isEmpty {
            result = embeddedTranslations()
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
