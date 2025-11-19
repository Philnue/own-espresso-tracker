//
//  DataManager.swift
//  EspressoTracker
//
//  Central data management for SwiftData operations
//

import SwiftData
import SwiftUI

@MainActor
class DataManager {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Grinder Operations
    func createGrinder(name: String, brand: String, burrType: String, burrSize: Int, notes: String, imageData: Data?) {
        let grinder = Grinder(
            name: name,
            brand: brand,
            burrType: burrType,
            burrSize: burrSize,
            imageData: imageData,
            notes: notes
        )
        modelContext.insert(grinder)
        saveContext()
    }

    func updateGrinder(_ grinder: Grinder, name: String, brand: String, burrType: String, burrSize: Int, notes: String, imageData: Data?) {
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
        modelContext.delete(grinder)
        saveContext()
    }

    // MARK: - Machine Operations
    func createMachine(name: String, brand: String, model: String, boilerType: String, groupHeadType: String, pressureBar: Double, notes: String, imageData: Data?, purchaseDate: Date?) {
        let machine = Machine(
            name: name,
            brand: brand,
            model: model,
            boilerType: boilerType,
            groupHeadType: groupHeadType,
            pressureBar: pressureBar,
            imageData: imageData,
            notes: notes,
            purchaseDate: purchaseDate
        )
        modelContext.insert(machine)
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
        modelContext.delete(machine)
        saveContext()
    }

    // MARK: - Bean Operations
    func createBean(name: String, roaster: String, origin: String, roastLevel: String, roastDate: Date, process: String, variety: String, tastingNotes: String, price: Double, weight: Double, notes: String, imageData: Data?, isArchived: Bool = false, batchNumber: Int = 1, purchaseDate: Date = Date()) {
        let bean = Bean(
            name: name,
            roaster: roaster,
            origin: origin,
            roastLevel: roastLevel,
            roastDate: roastDate,
            process: process,
            variety: variety,
            tastingNotes: tastingNotes,
            price: price,
            weight: weight,
            isArchived: isArchived,
            imageData: imageData,
            notes: notes,
            batchNumber: batchNumber,
            purchaseDate: purchaseDate
        )
        modelContext.insert(bean)
        saveContext()
    }

    // Create a new batch of an existing bean
    func createBatchFromBean(_ existingBean: Bean, weight: Double, roastDate: Date, purchaseDate: Date = Date(), price: Double) {
        // Find the highest batch number for this bean name/roaster combo
        let descriptor = FetchDescriptor<Bean>(
            predicate: #Predicate { bean in
                bean.name == existingBean.name && bean.roaster == existingBean.roaster
            }
        )

        let existingBeans = (try? modelContext.fetch(descriptor)) ?? []
        let maxBatchNumber = existingBeans.map { $0.batchNumber }.max() ?? 0

        let newBean = Bean(
            name: existingBean.name,
            roaster: existingBean.roaster,
            origin: existingBean.origin,
            roastLevel: existingBean.roastLevel,
            roastDate: roastDate,
            process: existingBean.process,
            variety: existingBean.variety,
            tastingNotes: existingBean.tastingNotes,
            price: price,
            weight: weight,
            isArchived: false,
            imageData: existingBean.imageData,
            notes: existingBean.notes,
            batchNumber: maxBatchNumber + 1,
            purchaseDate: purchaseDate
        )
        modelContext.insert(newBean)
        saveContext()
    }

    func updateBean(_ bean: Bean, name: String, roaster: String, origin: String, roastLevel: String, roastDate: Date, process: String, variety: String, tastingNotes: String, price: Double, weight: Double, notes: String, imageData: Data?, isArchived: Bool = false) {
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
        bean.isArchived = isArchived
        bean.notes = notes
        if let imageData = imageData {
            bean.imageData = imageData
        }
        bean.updatedAt = Date()
        saveContext()
    }

    func deleteBean(_ bean: Bean) {
        modelContext.delete(bean)
        saveContext()
    }

    // MARK: - Brewing Session Operations
    func createBrewingSession(grinder: Grinder?, machine: Machine?, bean: Bean?, brewMethod: String = "espresso", grindSetting: String, doseIn: Double, yieldOut: Double, brewTime: Double, waterTemp: Double, pressure: Double, rating: Int, notes: String, imageData: Data?, acidity: Int = 3, sweetness: Int = 3, bitterness: Int = 3, bodyWeight: Int = 3, aftertaste: Int = 3, puckPrepWDT: Bool = false, puckPrepRDT: Bool = false) {
        let session = BrewingSession(
            startTime: Date(),
            endTime: Date().addingTimeInterval(brewTime),
            brewMethod: brewMethod,
            grindSetting: grindSetting,
            doseIn: doseIn,
            yieldOut: yieldOut,
            brewTime: brewTime,
            waterTemp: waterTemp,
            pressure: pressure,
            rating: rating,
            notes: notes,
            imageData: imageData,
            acidity: acidity,
            sweetness: sweetness,
            bitterness: bitterness,
            bodyWeight: bodyWeight,
            aftertaste: aftertaste,
            puckPrepWDT: puckPrepWDT,
            puckPrepRDT: puckPrepRDT,
            grinder: grinder,
            machine: machine,
            bean: bean
        )
        modelContext.insert(session)
        saveContext()
    }

    func deleteBrewingSession(_ session: BrewingSession) {
        modelContext.delete(session)
        saveContext()
    }

    // MARK: - Save Context
    func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
