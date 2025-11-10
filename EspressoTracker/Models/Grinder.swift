//
//  Grinder.swift
//  EspressoTracker
//
//  SwiftData model for Grinder entity
//

import Foundation
import SwiftData

@Model
final class Grinder {
    @Attribute(.unique) var id: UUID
    var name: String
    var brand: String
    var burrType: String // Flat, Conical, etc.
    var burrSize: Int // in mm
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.grinder)
    var brewingSessions: [BrewingSession]?

    init(
        id: UUID = UUID(),
        name: String = "",
        brand: String = "",
        burrType: String = "Flat",
        burrSize: Int = 0,
        imageData: Data? = nil,
        notes: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.burrType = burrType
        self.burrSize = burrSize
        self.imageData = imageData
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var wrappedName: String {
        name.isEmpty ? "Unknown Grinder" : name
    }

    var wrappedBrand: String {
        brand.isEmpty ? "Unknown Brand" : brand
    }

    var wrappedNotes: String {
        notes
    }

    var sessionsArray: [BrewingSession] {
        (brewingSessions ?? []).sorted { $0.startTime > $1.startTime }
    }
}
