//
//  DataManager.swift
//  EspressoTracker
//
//  Central data management for Core Data operations
//

import CoreData
import SwiftUI

class DataManager: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init(container: NSPersistentCloudKitContainer = PersistenceController.shared.container) {
        self.container = container
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Grinder Operations
    func createGrinder(name: String, brand: String, burrType: String, burrSize: Int16, notes: String, imageData: Data?) {
        let grinder = Grinder(context: viewContext)
        grinder.id = UUID()
        grinder.name = name
        grinder.brand = brand
        grinder.burrType = burrType
        grinder.burrSize = burrSize
        grinder.notes = notes
        grinder.imageData = imageData
        grinder.createdAt = Date()
        grinder.updatedAt = Date()

        saveContext()
    }

    func updateGrinder(_ grinder: Grinder, name: String, brand: String, burrType: String, burrSize: Int16, notes: String, imageData: Data?) {
        grinder.name = name
        grinder.brand = brand
        grinder.burrType = burrType
        grinder.burrSize = burrSize
        grinder.notes = notes
        if let imageData = imageData {
            grinder.imageData = imageData
        }
        grinder.updatedAt = Date()

        saveContext()
    }

    func deleteGrinder(_ grinder: Grinder) {
        viewContext.delete(grinder)
        saveContext()
    }

    // MARK: - Machine Operations
    func createMachine(name: String, brand: String, model: String, boilerType: String, groupHeadType: String, pressureBar: Double, notes: String, imageData: Data?, purchaseDate: Date?) {
        let machine = Machine(context: viewContext)
        machine.id = UUID()
        machine.name = name
        machine.brand = brand
        machine.model = model
        machine.boilerType = boilerType
        machine.groupHeadType = groupHeadType
        machine.pressureBar = pressureBar
        machine.notes = notes
        machine.imageData = imageData
        machine.purchaseDate = purchaseDate
        machine.createdAt = Date()
        machine.updatedAt = Date()

        saveContext()
    }

    func updateMachine(_ machine: Machine, name: String, brand: String, model: String, boilerType: String, groupHeadType: String, pressureBar: Double, notes: String, imageData: Data?, purchaseDate: Date?) {
        machine.name = name
        machine.brand = brand
        machine.model = model
        machine.boilerType = boilerType
        machine.groupHeadType = groupHeadType
        machine.pressureBar = pressureBar
        machine.notes = notes
        if let imageData = imageData {
            machine.imageData = imageData
        }
        machine.purchaseDate = purchaseDate
        machine.updatedAt = Date()

        saveContext()
    }

    func deleteMachine(_ machine: Machine) {
        viewContext.delete(machine)
        saveContext()
    }

    // MARK: - Bean Operations
    func createBean(name: String, roaster: String, origin: String, roastLevel: String, roastDate: Date, process: String, variety: String, tastingNotes: String, price: Double, weight: Double, notes: String, imageData: Data?) {
        let bean = Bean(context: viewContext)
        bean.id = UUID()
        bean.name = name
        bean.roaster = roaster
        bean.origin = origin
        bean.roastLevel = roastLevel
        bean.roastDate = roastDate
        bean.process = process
        bean.variety = variety
        bean.tastingNotes = tastingNotes
        bean.price = price
        bean.weight = weight
        bean.notes = notes
        bean.imageData = imageData
        bean.createdAt = Date()
        bean.updatedAt = Date()

        saveContext()
    }

    func updateBean(_ bean: Bean, name: String, roaster: String, origin: String, roastLevel: String, roastDate: Date, process: String, variety: String, tastingNotes: String, price: Double, weight: Double, notes: String, imageData: Data?) {
        bean.name = name
        bean.roaster = roaster
        bean.origin = origin
        bean.roastLevel = roastLevel
        bean.roastDate = roastDate
        bean.process = process
        bean.variety = variety
        bean.tastingNotes = tastingNotes
        bean.price = price
        bean.weight = weight
        bean.notes = notes
        if let imageData = imageData {
            bean.imageData = imageData
        }
        bean.updatedAt = Date()

        saveContext()
    }

    func deleteBean(_ bean: Bean) {
        viewContext.delete(bean)
        saveContext()
    }

    // MARK: - Brewing Session Operations
    func createBrewingSession(grinder: Grinder?, machine: Machine?, bean: Bean?, grindSetting: String, doseIn: Double, yieldOut: Double, brewTime: Double, waterTemp: Double, pressure: Double, rating: Int16, notes: String, imageData: Data?) {
        let session = BrewingSession(context: viewContext)
        session.id = UUID()
        session.startTime = Date()
        session.endTime = Date().addingTimeInterval(brewTime)
        session.grinder = grinder
        session.machine = machine
        session.bean = bean
        session.grindSetting = grindSetting
        session.doseIn = doseIn
        session.yieldOut = yieldOut
        session.brewTime = brewTime
        session.waterTemp = waterTemp
        session.pressure = pressure
        session.rating = rating
        session.notes = notes
        session.imageData = imageData
        session.createdAt = Date()

        saveContext()
    }

    func deleteBrewingSession(_ session: BrewingSession) {
        viewContext.delete(session)
        saveContext()
    }

    // MARK: - Save Context
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
