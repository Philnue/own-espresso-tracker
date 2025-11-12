//
//  DataImporter.swift
//  EspressoTracker
//
//  Import data from JSON
//

import Foundation
import SwiftData

@MainActor
class DataImporter {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func importData(from url: URL) async throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let exportData = try decoder.decode(ExportData.self, from: data)

        // Import beans
        var beanMap: [UUID: Bean] = [:]
        for beanExport in exportData.beans {
            let bean = Bean(
                id: beanExport.id,
                name: beanExport.name,
                roaster: beanExport.roaster,
                origin: beanExport.origin,
                roastLevel: beanExport.roastLevel,
                roastDate: beanExport.roastDate,
                process: beanExport.process,
                variety: beanExport.variety,
                tastingNotes: beanExport.tastingNotes,
                price: beanExport.price,
                weight: beanExport.weight,
                notes: beanExport.notes,
                createdAt: beanExport.createdAt,
                updatedAt: beanExport.createdAt
            )
            modelContext.insert(bean)
            beanMap[bean.id] = bean
        }

        // Import grinders
        var grinderMap: [UUID: Grinder] = [:]
        for grinderExport in exportData.grinders {
            let grinder = Grinder(
                id: grinderExport.id,
                name: grinderExport.name,
                brand: grinderExport.brand,
                burrType: grinderExport.burrType,
                burrSize: grinderExport.burrSize,
                notes: grinderExport.notes,
                createdAt: grinderExport.createdAt,
                updatedAt: grinderExport.createdAt
            )
            modelContext.insert(grinder)
            grinderMap[grinder.id] = grinder
        }

        // Import machines
        var machineMap: [UUID: Machine] = [:]
        for machineExport in exportData.machines {
            let machine = Machine(
                id: machineExport.id,
                name: machineExport.name,
                brand: machineExport.brand,
                model: machineExport.model,
                boilerType: machineExport.boilerType,
                groupHeadType: machineExport.groupHeadType,
                pressureBar: machineExport.pressureBar,
                notes: machineExport.notes,
                purchaseDate: machineExport.purchaseDate,
                createdAt: machineExport.createdAt,
                updatedAt: machineExport.createdAt
            )
            modelContext.insert(machine)
            machineMap[machine.id] = machine
        }

        // Import sessions with relationships
        for sessionExport in exportData.sessions {
            let session = BrewingSession(
                id: sessionExport.id,
                startTime: sessionExport.startTime,
                endTime: sessionExport.startTime.addingTimeInterval(sessionExport.brewTime),
                brewMethod: sessionExport.brewMethod,
                grindSetting: sessionExport.grindSetting,
                doseIn: sessionExport.doseIn,
                yieldOut: sessionExport.yieldOut,
                brewTime: sessionExport.brewTime,
                waterTemp: sessionExport.waterTemp,
                pressure: sessionExport.pressure,
                rating: sessionExport.rating,
                notes: sessionExport.notes,
                createdAt: sessionExport.createdAt,
                grinder: sessionExport.grinderId.flatMap { grinderMap[$0] },
                machine: sessionExport.machineId.flatMap { machineMap[$0] },
                bean: sessionExport.beanId.flatMap { beanMap[$0] }
            )
            modelContext.insert(session)
        }

        try modelContext.save()
    }
}
