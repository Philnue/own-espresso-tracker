//
//  Grinder+CoreDataClass.swift
//  EspressoTracker
//
//  Core Data class for Grinder entity
//

import Foundation
import CoreData

@objc(Grinder)
public class Grinder: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grinder> {
        return NSFetchRequest<Grinder>(entityName: "Grinder")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var brand: String?
    @NSManaged public var burrType: String? // Flat, Conical, etc.
    @NSManaged public var burrSize: Int16 // in mm
    @NSManaged public var imageData: Data?
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var brewingSessions: NSSet?

    var wrappedName: String {
        name ?? "Unknown Grinder"
    }

    var wrappedBrand: String {
        brand ?? "Unknown Brand"
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    var sessionsArray: [BrewingSession] {
        let set = brewingSessions as? Set<BrewingSession> ?? []
        return set.sorted { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) }
    }
}

// MARK: Generated accessors for brewingSessions
extension Grinder {
    @objc(addBrewingSessionsObject:)
    @NSManaged public func addToBrewingSessions(_ value: BrewingSession)

    @objc(removeBrewingSessionsObject:)
    @NSManaged public func removeFromBrewingSessions(_ value: BrewingSession)

    @objc(addBrewingSessions:)
    @NSManaged public func addToBrewingSessions(_ values: NSSet)

    @objc(removeBrewingSessions:)
    @NSManaged public func removeFromBrewingSessions(_ values: NSSet)
}

extension Grinder: Identifiable {}
