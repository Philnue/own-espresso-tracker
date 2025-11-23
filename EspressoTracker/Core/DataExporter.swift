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
    let batchNumber: Int
    let purchaseDate: Date
    let isArchived: Bool

    // Custom decoder for backward compatibility with older exports
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        roaster = try container.decode(String.self, forKey: .roaster)
        origin = try container.decode(String.self, forKey: .origin)
        roastLevel = try container.decode(String.self, forKey: .roastLevel)
        roastDate = try container.decode(Date.self, forKey: .roastDate)
        process = try container.decode(String.self, forKey: .process)
        variety = try container.decode(String.self, forKey: .variety)
        tastingNotes = try container.decode(String.self, forKey: .tastingNotes)
        price = try container.decode(Double.self, forKey: .price)
        weight = try container.decode(Double.self, forKey: .weight)
        notes = try container.decode(String.self, forKey: .notes)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        // New fields with defaults for older exports
        batchNumber = try container.decodeIfPresent(Int.self, forKey: .batchNumber) ?? 1
        purchaseDate = try container.decodeIfPresent(Date.self, forKey: .purchaseDate) ?? createdAt
        isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
    }

    // Standard init for encoding
    init(id: UUID, name: String, roaster: String, origin: String, roastLevel: String, roastDate: Date, process: String, variety: String, tastingNotes: String, price: Double, weight: Double, notes: String, createdAt: Date, batchNumber: Int, purchaseDate: Date, isArchived: Bool) {
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
        self.notes = notes
        self.createdAt = createdAt
        self.batchNumber = batchNumber
        self.purchaseDate = purchaseDate
        self.isArchived = isArchived
    }
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
    // Taste Profile
    let acidity: Int
    let sweetness: Int
    let bitterness: Int
    let bodyWeight: Int
    let aftertaste: Int
    // Puck Preparation
    let puckPrepWDT: Bool
    let puckPrepRDT: Bool

    // Custom decoder for backward compatibility with older exports
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        startTime = try container.decode(Date.self, forKey: .startTime)
        brewMethod = try container.decode(String.self, forKey: .brewMethod)
        grindSetting = try container.decode(String.self, forKey: .grindSetting)
        doseIn = try container.decode(Double.self, forKey: .doseIn)
        yieldOut = try container.decode(Double.self, forKey: .yieldOut)
        brewTime = try container.decode(Double.self, forKey: .brewTime)
        waterTemp = try container.decode(Double.self, forKey: .waterTemp)
        pressure = try container.decode(Double.self, forKey: .pressure)
        rating = try container.decode(Int.self, forKey: .rating)
        notes = try container.decode(String.self, forKey: .notes)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        grinderId = try container.decodeIfPresent(UUID.self, forKey: .grinderId)
        machineId = try container.decodeIfPresent(UUID.self, forKey: .machineId)
        beanId = try container.decodeIfPresent(UUID.self, forKey: .beanId)
        // New fields with defaults for older exports
        acidity = try container.decodeIfPresent(Int.self, forKey: .acidity) ?? 3
        sweetness = try container.decodeIfPresent(Int.self, forKey: .sweetness) ?? 3
        bitterness = try container.decodeIfPresent(Int.self, forKey: .bitterness) ?? 3
        bodyWeight = try container.decodeIfPresent(Int.self, forKey: .bodyWeight) ?? 3
        aftertaste = try container.decodeIfPresent(Int.self, forKey: .aftertaste) ?? 3
        puckPrepWDT = try container.decodeIfPresent(Bool.self, forKey: .puckPrepWDT) ?? false
        puckPrepRDT = try container.decodeIfPresent(Bool.self, forKey: .puckPrepRDT) ?? false
    }

    // Standard init for encoding
    init(id: UUID, startTime: Date, brewMethod: String, grindSetting: String, doseIn: Double, yieldOut: Double, brewTime: Double, waterTemp: Double, pressure: Double, rating: Int, notes: String, createdAt: Date, grinderId: UUID?, machineId: UUID?, beanId: UUID?, acidity: Int, sweetness: Int, bitterness: Int, bodyWeight: Int, aftertaste: Int, puckPrepWDT: Bool, puckPrepRDT: Bool) {
        self.id = id
        self.startTime = startTime
        self.brewMethod = brewMethod
        self.grindSetting = grindSetting
        self.doseIn = doseIn
        self.yieldOut = yieldOut
        self.brewTime = brewTime
        self.waterTemp = waterTemp
        self.pressure = pressure
        self.rating = rating
        self.notes = notes
        self.createdAt = createdAt
        self.grinderId = grinderId
        self.machineId = machineId
        self.beanId = beanId
        self.acidity = acidity
        self.sweetness = sweetness
        self.bitterness = bitterness
        self.bodyWeight = bodyWeight
        self.aftertaste = aftertaste
        self.puckPrepWDT = puckPrepWDT
        self.puckPrepRDT = puckPrepRDT
    }
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
                    createdAt: bean.createdAt,
                    batchNumber: bean.batchNumber,
                    purchaseDate: bean.purchaseDate,
                    isArchived: bean.isArchived
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
                    beanId: session.bean?.id,
                    acidity: session.acidity,
                    sweetness: session.sweetness,
                    bitterness: session.bitterness,
                    bodyWeight: session.bodyWeight,
                    aftertaste: session.aftertaste,
                    puckPrepWDT: session.puckPrepWDT,
                    puckPrepRDT: session.puckPrepRDT
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
