//
//  LocalizedStrings.swift
//  EspressoTracker
//
//  Simple localization helper for German and English
//

import Foundation

struct LocalizedString {
    static func get(_ key: String, language: String = UserSettings.shared.appLanguage) -> String {
        return translations[language]?[key] ?? translations["en"]?[key] ?? key
    }

    private static let translations: [String: [String: String]] = [
        "en": [
            // Tab Bar
            "tab_brew": "Brew",
            "tab_history": "History",
            "tab_beans": "Beans",
            "tab_recipes": "Recipes",
            "tab_equipment": "Equipment",
            "tab_settings": "Settings",

            // Common
            "save": "Save",
            "cancel": "Cancel",
            "delete": "Delete",
            "edit": "Edit",

            // Brewing
            "brewing_method": "Brewing Method",
            "dose_in": "Dose In",
            "yield_out": "Yield Out",
            "brew_time": "Brew Time",
            "water_temp": "Water Temp",
            "pressure": "Pressure",
            "grind_setting": "Grind Setting",

            // Taste Profile
            "taste_profile": "Taste Profile",
            "acidity": "Acidity",
            "sweetness": "Sweetness",
            "bitterness": "Bitterness",
            "body": "Body",
            "aftertaste": "Aftertaste",

            // Recommendations
            "recommendations": "Recommendations",
            "great_shot": "Great shot! Current parameters are working well",

            // Settings
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
            "import_data": "Import Data",
            "export_data": "Export Data"
        ],
        "de": [
            // Tab Bar
            "tab_brew": "Brühen",
            "tab_history": "Verlauf",
            "tab_beans": "Bohnen",
            "tab_recipes": "Rezepte",
            "tab_equipment": "Ausstattung",
            "tab_settings": "Einstellungen",

            // Common
            "save": "Speichern",
            "cancel": "Abbrechen",
            "delete": "Löschen",
            "edit": "Bearbeiten",

            // Brewing
            "brewing_method": "Brühmethode",
            "dose_in": "Dosis",
            "yield_out": "Ertrag",
            "brew_time": "Brühzeit",
            "water_temp": "Wassertemp",
            "pressure": "Druck",
            "grind_setting": "Mahlgrad",

            // Taste Profile
            "taste_profile": "Geschmacksprofil",
            "acidity": "Säure",
            "sweetness": "Süße",
            "bitterness": "Bitterkeit",
            "body": "Körper",
            "aftertaste": "Nachgeschmack",

            // Recommendations
            "recommendations": "Empfehlungen",
            "great_shot": "Perfekter Shot! Die aktuellen Parameter funktionieren gut",

            // Settings
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
            "import_data": "Daten importieren",
            "export_data": "Daten exportieren"
        ]
    ]
}
