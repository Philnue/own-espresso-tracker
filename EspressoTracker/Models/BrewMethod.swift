//
//  BrewMethod.swift
//  EspressoTracker
//
//  Different brewing methods supported
//

import Foundation

enum BrewMethod: String, CaseIterable, Codable {
    case espresso = "Espresso"
    case aeropress = "Aeropress"
    case frenchPress = "French Press"
    case coldBrew = "Cold Brew"
    case pourOver = "Pour Over"
    case moka = "Moka Pot"

    var icon: String {
        switch self {
        case .espresso: return "cup.and.saucer.fill"
        case .aeropress: return "arrow.down.circle.fill"
        case .frenchPress: return "cylinder.fill"
        case .coldBrew: return "snowflake"
        case .pourOver: return "drop.fill"
        case .moka: return "kettle.fill"
        }
    }

    var typicalRatio: ClosedRange<Double> {
        switch self {
        case .espresso: return 1.5...3.0
        case .aeropress: return 12.0...18.0
        case .frenchPress: return 15.0...18.0
        case .coldBrew: return 4.0...8.0
        case .pourOver: return 15.0...17.0
        case .moka: return 7.0...10.0
        }
    }

    var typicalBrewTime: ClosedRange<Double> {
        switch self {
        case .espresso: return 20...35
        case .aeropress: return 60...120
        case .frenchPress: return 240...300
        case .coldBrew: return 43200...86400 // 12-24 hours
        case .pourOver: return 180...240
        case .moka: return 240...360
        }
    }

    var localizedName: String {
        // Will be localized later
        self.rawValue
    }
}
