//
//  Machine.swift
//  EspressoTracker
//
//  SwiftData model for Machine entity
//

import Foundation
import SwiftData

@Model
final class Machine {
    @Attribute(.unique) var id: UUID
    var name: String
    var brand: String
    var model: String
    var boilerType: String // Single, Double, Heat Exchanger
    var groupHeadType: String // E61, etc.
    var pressureBar: Double
    @Attribute(.externalStorage) var imageData: Data?
    var notes: String
    var purchaseDate: Date?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .nullify, inverse: \BrewingSession.machine)
    var brewingSessions: [BrewingSession]?

    init(
        id: UUID = UUID(),
        name: String = "",
        brand: String = "",
        model: String = "",
        boilerType: String = "Single",
        groupHeadType: String = "",
        pressureBar: Double = 9.0,
        imageData: Data? = nil,
        notes: String = "",
        purchaseDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.model = model
        self.boilerType = boilerType
        self.groupHeadType = groupHeadType
        self.pressureBar = pressureBar
        self.imageData = imageData
        self.notes = notes
        self.purchaseDate = purchaseDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var wrappedName: String {
        name.isEmpty ? "Unknown Machine" : name
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
