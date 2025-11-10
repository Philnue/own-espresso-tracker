//
//  UserSettings.swift
//  EspressoTracker
//
//  User preferences and settings
//

import Foundation
import SwiftUI

@MainActor
class UserSettings: ObservableObject {
    static let shared = UserSettings()

    // MARK: - Brewing Defaults
    @AppStorage("defaultDoseIn") var defaultDoseIn: Double = 18.0
    @AppStorage("defaultRatio") var defaultRatio: Double = 2.0
    @AppStorage("defaultWaterTemp") var defaultWaterTemp: Double = 93.0
    @AppStorage("defaultPressure") var defaultPressure: Double = 9.0
    @AppStorage("defaultGrindSetting") var defaultGrindSetting: String = ""

    // MARK: - Appearance
    @AppStorage("colorScheme") var colorScheme: String = "dark" // dark, light, system

    // MARK: - Localization
    @AppStorage("appLanguage") var appLanguage: String = "en" // en, de

    // MARK: - Units
    @AppStorage("weightUnit") var weightUnit: String = "grams" // grams, ounces
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius" // celsius, fahrenheit
    @AppStorage("volumeUnit") var volumeUnit: String = "ml" // ml, oz

    // MARK: - Brewing Method
    @AppStorage("defaultBrewMethod") var defaultBrewMethod: String = "espresso"

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
