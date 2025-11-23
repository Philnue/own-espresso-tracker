//
//  Bean.swift
//  EspressoTracker
//
//  SwiftData model for Bean entity
//

import Foundation
import SwiftData

@Model
final class Bean {
    @Attribute(.unique) var id: UUID
    var name: String
    var roaster: String
    var origin: String
    var roastLevel: String // Light, Medium, Dark
    var roastDate: Date
    var process: String // Washed, Natural, Honey
    var variety: String // Arabica, Robusta, etc.
    var tastingNotes: String
    var price: Double
    var weight: Double // in grams
    var isArchived: Bool // Track if bean is archived/finished
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    var batchNumber: Int = 1 // Track multiple batches of the same bean
    var purchaseDate: Date = Date() // When this batch was purchased

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.bean)
    var brewingSessions: [BrewingSession]?

    init(
        id: UUID = UUID(),
        name: String = "",
        roaster: String = "",
        origin: String = "",
        roastLevel: String = "Medium",
        roastDate: Date = Date(),
        process: String = "Washed",
        variety: String = "Arabica",
        tastingNotes: String = "",
        price: Double = 0,
        weight: Double = 0,
        isArchived: Bool = false,
        imageData: Data? = nil,
        notes: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        batchNumber: Int = 1,
        purchaseDate: Date = Date()
    ) {
        self.id = id
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
        self.isArchived = isArchived
        self.imageData = imageData
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.batchNumber = batchNumber
        self.purchaseDate = purchaseDate
    }

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
        notes
    }

    var daysFromRoast: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: roastDate, to: Date())
        return components.day ?? 0
    }

    var isStale: Bool {
        daysFromRoast > 30
    }

    var freshnessIndicator: String {
        let days = daysFromRoast
        if days <= 7 { return LocalizedString.get("very_fresh") }
        if days <= 14 { return LocalizedString.get("fresh") }
        if days <= 21 { return LocalizedString.get("good") }
        if days <= 30 { return LocalizedString.get("aging") }
        return LocalizedString.get("stale")
    }

    // Returns freshness level for color coding: 0=very fresh, 1=fresh, 2=good, 3=aging, 4=stale
    var freshnessLevel: Int {
        let days = daysFromRoast
        if days <= 7 { return 0 }  // very fresh - bright green
        if days <= 14 { return 1 } // fresh - green
        if days <= 21 { return 2 } // good - espresso brown
        if days <= 30 { return 3 } // aging - orange
        return 4                    // stale - red/warning
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { $0.startTime > $1.startTime }
    }

    // Consumption tracking
    var totalGramsUsed: Double {
        sessionsArray.reduce(0) { $0 + $1.doseIn }
    }

    var remainingWeight: Double {
        max(0, weight - totalGramsUsed)
    }

    var usagePercentage: Double {
        guard weight > 0 else { return 0 }
        return min(100, (totalGramsUsed / weight) * 100)
    }

    var isLowStock: Bool {
        remainingWeight < 50 && remainingWeight > 0
    }

    var isFinished: Bool {
        remainingWeight <= 0
    }

    // Batch display name (e.g., "Ethiopia Yirgacheffe #2")
    var displayName: String {
        if batchNumber > 1 {
            return "\(wrappedName) #\(batchNumber)"
        }
        return wrappedName
    }

    // Format purchase date for display
    var formattedPurchaseDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: purchaseDate)
    }
}
