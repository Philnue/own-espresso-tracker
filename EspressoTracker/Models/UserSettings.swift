//
//  UserSettings.swift
//  EspressoTracker
//
//  User preferences and settings
//

import Foundation
import SwiftUI
import Combine

class UserSettings: ObservableObject {
    static let shared = UserSettings()

    private let defaults = UserDefaults.standard

    // MARK: - Brewing Defaults
    @Published var defaultDoseIn: Double {
        didSet { defaults.set(defaultDoseIn, forKey: "defaultDoseIn") }
    }

    @Published var defaultRatio: Double {
        didSet { defaults.set(defaultRatio, forKey: "defaultRatio") }
    }

    @Published var defaultWaterTemp: Double {
        didSet { defaults.set(defaultWaterTemp, forKey: "defaultWaterTemp") }
    }

    @Published var defaultPressure: Double {
        didSet { defaults.set(defaultPressure, forKey: "defaultPressure") }
    }

    @Published var defaultGrindSetting: String {
        didSet { defaults.set(defaultGrindSetting, forKey: "defaultGrindSetting") }
    }

    // MARK: - Appearance
    @Published var colorScheme: String {
        didSet { defaults.set(colorScheme, forKey: "colorScheme") }
    }

    // MARK: - Localization
    @Published var appLanguage: String {
        didSet { defaults.set(appLanguage, forKey: "appLanguage") }
    }

    // MARK: - Units
    @Published var weightUnit: String {
        didSet { defaults.set(weightUnit, forKey: "weightUnit") }
    }

    @Published var temperatureUnit: String {
        didSet { defaults.set(temperatureUnit, forKey: "temperatureUnit") }
    }

    @Published var volumeUnit: String {
        didSet { defaults.set(volumeUnit, forKey: "volumeUnit") }
    }

    // MARK: - Brewing Method
    @Published var defaultBrewMethod: String {
        didSet { defaults.set(defaultBrewMethod, forKey: "defaultBrewMethod") }
    }

    private init() {
        self.defaultDoseIn = defaults.double(forKey: "defaultDoseIn") != 0 ? defaults.double(forKey: "defaultDoseIn") : 18.0
        self.defaultRatio = defaults.double(forKey: "defaultRatio") != 0 ? defaults.double(forKey: "defaultRatio") : 2.0
        self.defaultWaterTemp = defaults.double(forKey: "defaultWaterTemp") != 0 ? defaults.double(forKey: "defaultWaterTemp") : 93.0
        self.defaultPressure = defaults.double(forKey: "defaultPressure") != 0 ? defaults.double(forKey: "defaultPressure") : 9.0
        self.defaultGrindSetting = defaults.string(forKey: "defaultGrindSetting") ?? ""
        self.colorScheme = defaults.string(forKey: "colorScheme") ?? "dark"

        // Detect device language and set as default on first launch
        if let savedLanguage = defaults.string(forKey: "appLanguage") {
            self.appLanguage = savedLanguage
        } else {
            // Get device's preferred language
            let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            // Map to supported languages (en, de)
            if deviceLanguage == "de" {
                self.appLanguage = "de"
            } else {
                self.appLanguage = "en"
            }
            // Save the detected language
            defaults.set(self.appLanguage, forKey: "appLanguage")
        }

        self.weightUnit = defaults.string(forKey: "weightUnit") ?? "grams"
        self.temperatureUnit = defaults.string(forKey: "temperatureUnit") ?? "celsius"
        self.volumeUnit = defaults.string(forKey: "volumeUnit") ?? "ml"
        self.defaultBrewMethod = defaults.string(forKey: "defaultBrewMethod") ?? "espresso"
    }

    var preferredColorScheme: ColorScheme? {
        switch colorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil // system
        }
    }

    // MARK: - Unit Conversions
    func convertWeight(_ grams: Double) -> String {
        if weightUnit == "ounces" {
            let oz = grams * 0.035274
            return String(format: "%.2f oz", oz)
        }
        return String(format: "%.1f g", grams)
    }

    func convertTemperature(_ celsius: Double) -> String {
        if temperatureUnit == "fahrenheit" {
            let fahrenheit = (celsius * 9/5) + 32
            return String(format: "%.1f°F", fahrenheit)
        }
        return String(format: "%.1f°C", celsius)
    }

    func convertVolume(_ ml: Double) -> String {
        if volumeUnit == "oz" {
            let oz = ml * 0.033814
            return String(format: "%.1f oz", oz)
        }
        return String(format: "%.0f ml", ml)
    }
}
