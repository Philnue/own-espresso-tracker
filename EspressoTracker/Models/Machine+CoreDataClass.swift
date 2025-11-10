//
//  Machine+CoreDataClass.swift
//  EspressoTracker
//
//  Core Data class for Machine entity
//

import Foundation
import CoreData

@objc(Machine)
public class Machine: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Machine> {
        return NSFetchRequest<Machine>(entityName: "Machine")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var brand: String?
    @NSManaged public var model: String?
    @NSManaged public var boilerType: String? // Single, Double, Heat Exchanger
    @NSManaged public var groupHeadType: String? // E61, etc.
    @NSManaged public var pressureBar: Double
    @NSManaged public var imageData: Data?
    @NSManaged public var notes: String?
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var brewingSessions: NSSet?

    var wrappedName: String {
        name ?? "Unknown Machine"
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
extension Machine {
    @objc(addBrewingSessionsObject:)
    @NSManaged public func addToBrewingSessions(_ value: BrewingSession)

    @objc(removeBrewingSessionsObject:)
    @NSManaged public func removeFromBrewingSessions(_ value: BrewingSession)

    @objc(addBrewingSessions:)
    @NSManaged public func addToBrewingSessions(_ values: NSSet)

    @objc(removeBrewingSessions:)
    @NSManaged public func removeFromBrewingSessions(_ values: NSSet)
}

extension Machine: Identifiable {}
