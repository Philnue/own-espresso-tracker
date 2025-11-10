//
//  BrewingSession+CoreDataClass.swift
//  EspressoTracker
//
//  Core Data class for BrewingSession entity
//

import Foundation
import CoreData

@objc(BrewingSession)
public class BrewingSession: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BrewingSession> {
        return NSFetchRequest<BrewingSession>(entityName: "BrewingSession")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var grindSetting: String?
    @NSManaged public var doseIn: Double // Input dose in grams
    @NSManaged public var yieldOut: Double // Output yield in grams
    @NSManaged public var brewTime: Double // Time in seconds
    @NSManaged public var waterTemp: Double // Temperature in Celsius
    @NSManaged public var pressure: Double // Pressure in bars
    @NSManaged public var rating: Int16 // 1-5 stars
    @NSManaged public var notes: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var grinder: Grinder?
    @NSManaged public var machine: Machine?
    @NSManaged public var bean: Bean?

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
        notes ?? ""
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

extension BrewingSession: Identifiable {}
