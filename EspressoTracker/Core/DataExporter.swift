//
//  DataExporter.swift
//  EspressoTracker
//
//  Export all data to JSON
//

import Foundation
import SwiftData

struct ExportData: Codable {
    let beans: [BeanExport]
    let grinders: [GrinderExport]
    let machines: [MachineExport]
    let sessions: [SessionExport]
    let exportDate: Date
    let appVersion: String
}

struct BeanExport: Codable {
    let id: UUID
    let name: String
    let roaster: String
    let origin: String
    let roastLevel: String
    let roastDate: Date
    let process: String
    let variety: String
    let tastingNotes: String
    let price: Double
    let weight: Double
    let notes: String
    let createdAt: Date
}

struct GrinderExport: Codable {
    let id: UUID
    let name: String
    let brand: String
    let burrType: String
    let burrSize: Int
    let notes: String
    let createdAt: Date
}

struct MachineExport: Codable {
    let id: UUID
    let name: String
    let brand: String
    let model: String
    let boilerType: String
    let groupHeadType: String
    let pressureBar: Double
    let notes: String
    let purchaseDate: Date?
    let createdAt: Date
}

struct SessionExport: Codable {
    let id: UUID
    let startTime: Date
    let brewMethod: String
    let grindSetting: String
    let doseIn: Double
    let yieldOut: Double
    let brewTime: Double
    let waterTemp: Double
    let pressure: Double
    let rating: Int
    let notes: String
    let createdAt: Date
    let grinderId: UUID?
    let machineId: UUID?
    let beanId: UUID?
}

@MainActor
class DataExporter {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func exportAllData() async throws -> URL {
        let descriptor = FetchDescriptor<Bean>()
        let beans = try modelContext.fetch(descriptor)

        let grinderDescriptor = FetchDescriptor<Grinder>()
        let grinders = try modelContext.fetch(grinderDescriptor)

        let machineDescriptor = FetchDescriptor<Machine>()
        let machines = try modelContext.fetch(machineDescriptor)

        let sessionDescriptor = FetchDescriptor<BrewingSession>()
        let sessions = try modelContext.fetch(sessionDescriptor)

        let exportData = ExportData(
            beans: beans.map { bean in
                BeanExport(
                    id: bean.id,
                    name: bean.name,
                    roaster: bean.roaster,
                    origin: bean.origin,
                    roastLevel: bean.roastLevel,
                    roastDate: bean.roastDate,
                    process: bean.process,
                    variety: bean.variety,
                    tastingNotes: bean.tastingNotes,
                    price: bean.price,
                    weight: bean.weight,
                    notes: bean.notes,
                    createdAt: bean.createdAt
                )
            },
            grinders: grinders.map { grinder in
                GrinderExport(
                    id: grinder.id,
                    name: grinder.name,
                    brand: grinder.brand,
                    burrType: grinder.burrType,
                    burrSize: grinder.burrSize,
                    notes: grinder.notes,
                    createdAt: grinder.createdAt
                )
            },
            machines: machines.map { machine in
                MachineExport(
                    id: machine.id,
                    name: machine.name,
                    brand: machine.brand,
                    model: machine.model,
                    boilerType: machine.boilerType,
                    groupHeadType: machine.groupHeadType,
                    pressureBar: machine.pressureBar,
                    notes: machine.notes,
                    purchaseDate: machine.purchaseDate,
                    createdAt: machine.createdAt
                )
            },
            sessions: sessions.map { session in
                SessionExport(
                    id: session.id,
                    startTime: session.startTime,
                    brewMethod: session.brewMethod,
                    grindSetting: session.grindSetting,
                    doseIn: session.doseIn,
                    yieldOut: session.yieldOut,
                    brewTime: session.brewTime,
                    waterTemp: session.waterTemp,
                    pressure: session.pressure,
                    rating: session.rating,
                    notes: session.notes,
                    createdAt: session.createdAt,
                    grinderId: session.grinder?.id,
                    machineId: session.machine?.id,
                    beanId: session.bean?.id
                )
            },
            exportDate: Date(),
            appVersion: "1.0.0"
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(exportData)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        let filename = "EspressoTracker_Export_\(dateString).json"

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: tempURL)

        return tempURL
    }
}
