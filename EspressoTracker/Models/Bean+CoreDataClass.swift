//
//  Bean+CoreDataClass.swift
//  EspressoTracker
//
//  Core Data class for Bean entity
//

import Foundation
import CoreData

@objc(Bean)
public class Bean: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bean> {
        return NSFetchRequest<Bean>(entityName: "Bean")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var roaster: String?
    @NSManaged public var origin: String?
    @NSManaged public var roastLevel: String? // Light, Medium, Dark
    @NSManaged public var roastDate: Date?
    @NSManaged public var process: String? // Washed, Natural, Honey
    @NSManaged public var variety: String? // Arabica, Robusta, etc.
    @NSManaged public var tastingNotes: String?
    @NSManaged public var price: Double
    @NSManaged public var weight: Double // in grams
    @NSManaged public var imageData: Data?
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var brewingSessions: NSSet?

    var wrappedName: String {
        name ?? "Unknown Bean"
    }

    var wrappedRoaster: String {
        roaster ?? "Unknown Roaster"
    }

    var wrappedOrigin: String {
        origin ?? "Unknown Origin"
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
        let set = brewingSessions as? Set<BrewingSession> ?? []
        return set.sorted { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) }
    }
}

// MARK: Generated accessors for brewingSessions
extension Bean {
    @objc(addBrewingSessionsObject:)
    @NSManaged public func addToBrewingSessions(_ value: BrewingSession)

    @objc(removeBrewingSessionsObject:)
    @NSManaged public func removeFromBrewingSessions(_ value: BrewingSession)

    @objc(addBrewingSessions:)
    @NSManaged public func addToBrewingSessions(_ values: NSSet)

    @objc(removeBrewingSessions:)
    @NSManaged public func removeFromBrewingSessions(_ values: NSSet)
}

extension Bean: Identifiable {}
