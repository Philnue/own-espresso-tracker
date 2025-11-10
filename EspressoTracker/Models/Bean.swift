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
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String
    var createdAt: Date
    var updatedAt: Date

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
        imageData: Data? = nil,
        notes: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
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
        self.imageData = imageData
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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
        if days <= 7 { return "Very Fresh" }
        if days <= 14 { return "Fresh" }
        if days <= 21 { return "Good" }
        if days <= 30 { return "Aging" }
        return "Stale"
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { $0.startTime > $1.startTime }
    }
}
