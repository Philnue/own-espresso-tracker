//
//  Models.swift
//  EspressoTracker
//
//  SwiftData models - Modern alternative to Core Data
//  This single file replaces all 4 Core Data model files!
//

import Foundation
import SwiftData

// MARK: - Grinder Model
@Model
final class Grinder {
    var id: UUID
    var name: String
    var brand: String
    var burrType: String?
    var burrSize: Int16
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.grinder)
    var brewingSessions: [BrewingSession]?

    var wrappedName: String {
        name.isEmpty ? "Unknown Grinder" : name
    }

    var wrappedBrand: String {
        brand.isEmpty ? "Unknown Brand" : brand
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) }
    }

    init(name: String, brand: String, burrType: String? = nil,
         burrSize: Int16 = 0, imageData: Data? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.burrType = burrType
        self.burrSize = burrSize
        self.imageData = imageData
        self.notes = notes
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

// MARK: - Machine Model
@Model
final class Machine {
    var id: UUID
    var name: String
    var brand: String
    var model: String?
    var boilerType: String?
    var groupHeadType: String?
    var pressureBar: Double
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var purchaseDate: Date?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.machine)
    var brewingSessions: [BrewingSession]?

    var wrappedName: String {
        name.isEmpty ? "Unknown Machine" : name
    }

    var wrappedBrand: String {
        brand.isEmpty ? "Unknown Brand" : brand
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) }
    }

    init(name: String, brand: String, model: String? = nil,
         boilerType: String? = nil, groupHeadType: String? = nil,
         pressureBar: Double = 9.0, imageData: Data? = nil,
         notes: String? = nil, purchaseDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.model = model
        self.boilerType = boilerType
        self.groupHeadType = groupHeadType
        self.pressureBar = pressureBar
        self.imageData = imageData
        self.notes = notes
        self.purchaseDate = purchaseDate
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

// MARK: - Bean Model
@Model
final class Bean {
    var id: UUID
    var name: String
    var roaster: String
    var origin: String
    var roastLevel: String?
    var roastDate: Date?
    var process: String?
    var variety: String?
    var tastingNotes: String?
    var price: Double
    var weight: Double
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.bean)
    var brewingSessions: [BrewingSession]?

    var wrappedName: String {
        name.isEmpty ? "Unknown Bean" : name
    }

    var wrappedRoaster: String {
        roaster.isEmpty ? "Unknown Roaster" : roaster
    }

    var wrappedOrigin: String {
        origin.isEmpty ? "Unknown Origin" : origin
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    var daysFromRoast: Int? {
        guard let roastDate = roastDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: roastDate, to: Date())
        return components.day
    }

    var isStale: Bool {
        guard let days = daysFromRoast else { return false }
        return days > 30
    }

    var freshnessIndicator: String {
        guard let days = daysFromRoast else { return "Unknown" }
        if days <= 7 { return "Very Fresh" }
        if days <= 14 { return "Fresh" }
        if days <= 21 { return "Good" }
        if days <= 30 { return "Aging" }
        return "Stale"
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) }
    }

    init(name: String, roaster: String, origin: String,
         roastLevel: String? = nil, roastDate: Date? = nil,
         process: String? = nil, variety: String? = nil,
         tastingNotes: String? = nil, price: Double = 0,
         weight: Double = 250, imageData: Data? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.roaster = roaster
        self.origin = origin
        self.roastLevel = roastLevel
        self.roastDate = roastDate
        self.process = process
        self.variety = variety
        self.tastingNotes = tastingNotes
        self.price = price
        self.weight = weight
        self.imageData = imageData
        self.notes = notes
        self.createdAt = Date()
        self.brewingSessions = []
    }
}

// MARK: - BrewingSession Model
@Model
final class BrewingSession {
    var id: UUID
    var startTime: Date?
    var endTime: Date?
    var grindSetting: String?
    var doseIn: Double
    var yieldOut: Double
    var brewTime: Double
    var waterTemp: Double
    var pressure: Double
    var rating: Int16
    var notes: String?
    @Attribute(.externalStorage) var imageData: Data?
    var createdAt: Date

    var grinder: Grinder?
    var machine: Machine?
    var bean: Bean?

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

    init(grinder: Grinder? = nil, machine: Machine? = nil, bean: Bean? = nil,
         grindSetting: String? = nil, doseIn: Double, yieldOut: Double,
         brewTime: Double, waterTemp: Double = 93, pressure: Double = 9,
         rating: Int16 = 3, notes: String? = nil, imageData: Data? = nil) {
        self.id = UUID()
        self.startTime = Date()
        self.endTime = Date().addingTimeInterval(brewTime)
        self.grinder = grinder
        self.machine = machine
        self.bean = bean
        self.grindSetting = grindSetting
        self.doseIn = doseIn
        self.yieldOut = yieldOut
        self.brewTime = brewTime
        self.waterTemp = waterTemp
        self.pressure = pressure
        self.rating = rating
        self.notes = notes
        self.imageData = imageData
        self.createdAt = Date()
    }
}
