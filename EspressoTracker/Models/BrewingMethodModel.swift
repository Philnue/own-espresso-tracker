//
//  BrewingMethodModel.swift
//  EspressoTracker
//
//  SwiftData model for customizable brewing methods with default parameters
//

import Foundation
import SwiftData

@Model
final class BrewingMethodModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String // SF Symbol name
    var isActive: Bool
    var sortOrder: Int

    // Default brewing parameters
    var defaultDoseGrams: Double
    var defaultRatioMin: Double // 1:x format, minimum
    var defaultRatioMax: Double // 1:x format, maximum
    var defaultBrewTimeMin: Double // in seconds
    var defaultBrewTimeMax: Double // in seconds
    var defaultWaterTemp: Double // in Celsius
    var defaultPressure: Double // in bars (for espresso-style methods)

    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        icon: String = "cup.and.saucer.fill",
        isActive: Bool = true,
        sortOrder: Int = 0,
        defaultDoseGrams: Double = 18.0,
        defaultRatioMin: Double = 2.0,
        defaultRatioMax: Double = 2.5,
        defaultBrewTimeMin: Double = 25.0,
        defaultBrewTimeMax: Double = 30.0,
        defaultWaterTemp: Double = 93.0,
        defaultPressure: Double = 9.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.isActive = isActive
        self.sortOrder = sortOrder
        self.defaultDoseGrams = defaultDoseGrams
        self.defaultRatioMin = defaultRatioMin
        self.defaultRatioMax = defaultRatioMax
        self.defaultBrewTimeMin = defaultBrewTimeMin
        self.defaultBrewTimeMax = defaultBrewTimeMax
        self.defaultWaterTemp = defaultWaterTemp
        self.defaultPressure = defaultPressure
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var defaultYieldGrams: Double {
        return defaultDoseGrams * ((defaultRatioMin + defaultRatioMax) / 2.0)
    }

    var ratioRangeString: String {
        return String(format: "1:%.1f - 1:%.1f", defaultRatioMin, defaultRatioMax)
    }

    var brewTimeRangeString: String {
        return String(format: "%.0f-%.0fs", defaultBrewTimeMin, defaultBrewTimeMax)
    }

    // Factory methods for creating default brewing methods
    static func espresso() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "Espresso",
            icon: "cup.and.saucer.fill",
            sortOrder: 1,
            defaultDoseGrams: 18.0,
            defaultRatioMin: 2.0,
            defaultRatioMax: 2.5,
            defaultBrewTimeMin: 25.0,
            defaultBrewTimeMax: 30.0,
            defaultWaterTemp: 93.0,
            defaultPressure: 9.0
        )
    }

    static func aeropress() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "Aeropress",
            icon: "arrow.down.circle.fill",
            sortOrder: 2,
            defaultDoseGrams: 15.0,
            defaultRatioMin: 14.0,
            defaultRatioMax: 16.0,
            defaultBrewTimeMin: 60.0,
            defaultBrewTimeMax: 120.0,
            defaultWaterTemp: 85.0,
            defaultPressure: 0.0
        )
    }

    static func frenchPress() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "French Press",
            icon: "cylinder.fill",
            sortOrder: 3,
            defaultDoseGrams: 30.0,
            defaultRatioMin: 15.0,
            defaultRatioMax: 17.0,
            defaultBrewTimeMin: 240.0,
            defaultBrewTimeMax: 300.0,
            defaultWaterTemp: 93.0,
            defaultPressure: 0.0
        )
    }

    static func pourOver() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "Pour Over",
            icon: "drop.fill",
            sortOrder: 4,
            defaultDoseGrams: 20.0,
            defaultRatioMin: 15.0,
            defaultRatioMax: 17.0,
            defaultBrewTimeMin: 180.0,
            defaultBrewTimeMax: 240.0,
            defaultWaterTemp: 93.0,
            defaultPressure: 0.0
        )
    }

    static func coldBrew() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "Cold Brew",
            icon: "snowflake",
            sortOrder: 5,
            defaultDoseGrams: 100.0,
            defaultRatioMin: 5.0,
            defaultRatioMax: 7.0,
            defaultBrewTimeMin: 43200.0, // 12 hours
            defaultBrewTimeMax: 86400.0, // 24 hours
            defaultWaterTemp: 20.0,
            defaultPressure: 0.0
        )
    }

    static func mokaPot() -> BrewingMethodModel {
        BrewingMethodModel(
            name: "Moka Pot",
            icon: "flame.fill",
            sortOrder: 6,
            defaultDoseGrams: 20.0,
            defaultRatioMin: 8.0,
            defaultRatioMax: 10.0,
            defaultBrewTimeMin: 240.0,
            defaultBrewTimeMax: 360.0,
            defaultWaterTemp: 100.0,
            defaultPressure: 1.5
        )
    }

    static func allDefaultMethods() -> [BrewingMethodModel] {
        return [
            espresso(),
            aeropress(),
            frenchPress(),
            pourOver(),
            coldBrew(),
            mokaPot()
        ]
    }
}
