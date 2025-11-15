//
//  TestDataHelper.swift
//  EspressoTracker
//
//  Helper for populating test data
//

import SwiftData
import Foundation

@MainActor
class TestDataHelper {
    static func populateTestData(modelContext: ModelContext) {
        let dataManager = DataManager(modelContext: modelContext)

        // Add test grinders
        dataManager.createGrinder(
            name: "Niche Zero",
            brand: "Niche",
            burrType: "Conical",
            burrSize: 63,
            notes: "Single-dose grinder with excellent consistency",
            imageData: nil
        )

        dataManager.createGrinder(
            name: "DF64",
            brand: "Turin",
            burrType: "Flat",
            burrSize: 64,
            notes: "Great value flat burr grinder",
            imageData: nil
        )

        dataManager.createGrinder(
            name: "Comandante C40",
            brand: "Comandante",
            burrType: "Conical",
            burrSize: 40,
            notes: "Hand grinder for travel",
            imageData: nil
        )

        // Add test machines
        dataManager.createMachine(
            name: "Gaggia Classic Pro",
            brand: "Gaggia",
            model: "Classic Pro",
            boilerType: "Single Boiler",
            groupHeadType: "Standard",
            pressureBar: 9.0,
            notes: "Modded with PID and OPV adjustment",
            imageData: nil,
            purchaseDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())
        )

        dataManager.createMachine(
            name: "Rancilio Silvia",
            brand: "Rancilio",
            model: "Silvia V6",
            boilerType: "Single Boiler",
            groupHeadType: "Standard",
            pressureBar: 9.5,
            notes: "Reliable single boiler machine",
            imageData: nil,
            purchaseDate: nil
        )

        dataManager.createMachine(
            name: "Lelit Bianca",
            brand: "Lelit",
            model: "Bianca V3",
            boilerType: "Dual Boiler",
            groupHeadType: "E61",
            pressureBar: 9.0,
            notes: "Flow control and pressure profiling capable",
            imageData: nil,
            purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())
        )

        // Add test beans
        let roastDate1 = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Ethiopia Yirgacheffe",
            roaster: "Local Coffee Roasters",
            origin: "Ethiopia",
            roastLevel: "Light",
            roastDate: roastDate1,
            process: "Washed",
            variety: "Heirloom",
            tastingNotes: "Floral, citrus, bergamot",
            price: 18.50,
            weight: 250.0,
            notes: "Great for filter and espresso",
            imageData: nil
        )

        let roastDate2 = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Colombia Huila",
            roaster: "Specialty Coffee Co",
            origin: "Colombia",
            roastLevel: "Medium",
            roastDate: roastDate2,
            process: "Washed",
            variety: "Caturra",
            tastingNotes: "Chocolate, caramel, nuts",
            price: 16.00,
            weight: 250.0,
            notes: "Classic espresso profile",
            imageData: nil
        )

        let roastDate3 = Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Brazil Cerrado",
            roaster: "Bean Brothers",
            origin: "Brazil",
            roastLevel: "Medium-Dark",
            roastDate: roastDate3,
            process: "Natural",
            variety: "Yellow Bourbon",
            tastingNotes: "Dark chocolate, molasses, low acidity",
            price: 14.50,
            weight: 500.0,
            notes: "Great for milk drinks",
            imageData: nil
        )

        let roastDate4 = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        dataManager.createBean(
            name: "Kenya AA",
            roaster: "Third Wave Coffee",
            origin: "Kenya",
            roastLevel: "Light-Medium",
            roastDate: roastDate4,
            process: "Washed",
            variety: "SL28, SL34",
            tastingNotes: "Blackcurrant, tomato, bright acidity",
            price: 22.00,
            weight: 250.0,
            notes: "Complex and fruity",
            imageData: nil
        )
    }
}
