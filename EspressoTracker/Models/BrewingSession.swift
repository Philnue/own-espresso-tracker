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
    var brewMethod: String // "espresso", "aeropress", "frenchPress", "coldBrew", "pourOver", "moka"
    var grindSetting: String
    var doseIn: Double // Input dose in grams
    var yieldOut: Double // Output yield in grams
    var brewTime: Double // Time in seconds
    var waterTemp: Double // Temperature in Celsius
    var pressure: Double // Pressure in bars (for espresso)
    var rating: Int // 1-5 stars
    var notes: String
    @Attribute(.externalStorage) var imageData: Data?
    var createdAt: Date

    // Taste Profile (1-5 scale)
    var acidity: Int // Brightness/Sourness
    var sweetness: Int // Sweet notes
    var bitterness: Int // Bitter notes
    var bodyWeight: Int // Mouthfeel/Weight
    var aftertaste: Int // Finish quality

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
        brewMethod: String = "espresso",
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
        acidity: Int = 3,
        sweetness: Int = 3,
        bitterness: Int = 3,
        bodyWeight: Int = 3,
        aftertaste: Int = 3,
        grinder: Grinder? = nil,
        machine: Machine? = nil,
        bean: Bean? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.brewMethod = brewMethod
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
        self.acidity = acidity
        self.sweetness = sweetness
        self.bitterness = bitterness
        self.bodyWeight = bodyWeight
        self.aftertaste = aftertaste
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

    // Brewing recommendations based on taste profile
    var recommendations: [String] {
        var suggestions: [String] = []

        // Analyze bitterness (high = over-extraction)
        if bitterness >= 4 {
            suggestions.append("Too bitter: Try coarser grind, lower water temp (88-91°C), or shorter brew time")
        }

        // Analyze acidity (high = under-extraction or bright beans)
        if acidity >= 4 {
            suggestions.append("Too acidic: Try finer grind, higher water temp (93-96°C), or longer brew time")
        } else if acidity <= 2 {
            suggestions.append("Lacking brightness: Increase water temp slightly or use fresher beans")
        }

        // Analyze body
        if bodyWeight <= 2 {
            suggestions.append("Weak body: Increase dose, use finer grind, or higher pressure")
        } else if bodyWeight >= 4 {
            suggestions.append("Too heavy: Decrease dose or try a coarser grind")
        }

        // Analyze sweetness
        if sweetness <= 2 {
            suggestions.append("Lacking sweetness: Ensure proper extraction (25-30s), check bean freshness")
        }

        // Analyze aftertaste
        if aftertaste <= 2 {
            suggestions.append("Poor finish: Check bean quality, adjust extraction time")
        }

        // Combined analysis
        if bitterness >= 4 && acidity <= 2 {
            suggestions.append("Over-extracted: Significantly coarsen grind and reduce brew time")
        } else if acidity >= 4 && bitterness <= 2 {
            suggestions.append("Under-extracted: Finer grind and longer brew time needed")
        }

        // Ratio analysis
        if brewRatio < 1.5 {
            suggestions.append("Very concentrated - consider increasing yield for more balance")
        } else if brewRatio > 3.0 {
            suggestions.append("Over-diluted - reduce yield or increase dose")
        }

        if suggestions.isEmpty {
            suggestions.append("Great shot! Current parameters are working well")
        }

        return suggestions
    }

    var tasteBalance: String {
        let total = acidity + sweetness + bitterness + bodyWeight + aftertaste
        let average = Double(total) / 5.0

        if average >= 4.0 {
            return "Excellent"
        } else if average >= 3.5 {
            return "Good"
        } else if average >= 2.5 {
            return "Fair"
        } else {
            return "Needs Work"
        }
    }
}
