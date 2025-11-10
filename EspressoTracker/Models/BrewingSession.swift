//
//  BrewingSession.swift
//  EspressoTracker
//
//  SwiftData model for BrewingSession entity
//

import Foundation
import SwiftData

@Model
final class BrewingSession {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date
    var grindSetting: String
    var doseIn: Double // Input dose in grams
    var yieldOut: Double // Output yield in grams
    var brewTime: Double // Time in seconds
    var waterTemp: Double // Temperature in Celsius
    var pressure: Double // Pressure in bars
    var rating: Int // 1-5 stars
    var notes: String
    @Attribute(.externalStorage) var imageData: Data?
    var createdAt: Date

    @Relationship(deleteRule: .nullify)
    var grinder: Grinder?

    @Relationship(deleteRule: .nullify)
    var machine: Machine?

    @Relationship(deleteRule: .nullify)
    var bean: Bean?

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date = Date(),
        grindSetting: String = "",
        doseIn: Double = 0,
        yieldOut: Double = 0,
        brewTime: Double = 0,
        waterTemp: Double = 93,
        pressure: Double = 9,
        rating: Int = 0,
        notes: String = "",
        imageData: Data? = nil,
        createdAt: Date = Date(),
        grinder: Grinder? = nil,
        machine: Machine? = nil,
        bean: Bean? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.grindSetting = grindSetting
        self.doseIn = doseIn
        self.yieldOut = yieldOut
        self.brewTime = brewTime
        self.waterTemp = waterTemp
        self.pressure = pressure
        self.rating = rating
        self.notes = notes
        self.imageData = imageData
        self.createdAt = createdAt
        self.grinder = grinder
        self.machine = machine
        self.bean = bean
    }

    var brewRatio: Double {
        guard doseIn > 0 else { return 0 }
        return yieldOut / doseIn
    }

    var brewRatioString: String {
        String(format: "1:%.1f", brewRatio)
    }

    var brewTimeFormatted: String {
        let minutes = Int(brewTime) / 60
        let seconds = Int(brewTime) % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }

    var wrappedNotes: String {
        notes
    }

    var qualityAssessment: String {
        // Based on typical espresso parameters
        let isRatioGood = brewRatio >= 1.5 && brewRatio <= 3.0
        let isTimeGood = brewTime >= 20 && brewTime <= 35

        if isRatioGood && isTimeGood {
            return "On Target"
        } else if !isRatioGood && !isTimeGood {
            return "Needs Adjustment"
        } else if !isRatioGood {
            return "Check Ratio"
        } else {
            return "Check Time"
        }
    }

    var extraction: String {
        if brewTime < 20 {
            return "Under-extracted"
        } else if brewTime > 35 {
            return "Over-extracted"
        } else {
            return "Optimal"
        }
    }
}
