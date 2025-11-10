//
//  ColorTheme.swift
//  EspressoTracker
//
//  Dark mode color theme for the app
//

import SwiftUI

extension Color {
    // Primary colors - Espresso-inspired palette
    static let espressoBrown = Color(red: 0.48, green: 0.33, blue: 0.28)       // #7A5449
    static let darkCoffee = Color(red: 0.24, green: 0.18, blue: 0.14)          // #3D2E23
    static let creamyFoam = Color(red: 0.95, green: 0.94, blue: 0.92)          // #F2F0EB
    static let richCrema = Color(red: 0.78, green: 0.60, blue: 0.42)           // #C7996B

    // Background colors
    static let backgroundPrimary = Color(red: 0.11, green: 0.11, blue: 0.12)   // #1C1C1E
    static let backgroundSecondary = Color(red: 0.14, green: 0.14, blue: 0.15) // #242426
    static let backgroundTertiary = Color(red: 0.17, green: 0.17, blue: 0.18)  // #2C2C2E

    // UI Element colors
    static let cardBackground = Color(red: 0.19, green: 0.19, blue: 0.20)      // #303032
    static let dividerColor = Color(red: 0.23, green: 0.23, blue: 0.24)        // #3A3A3C

    // Status colors
    static let successGreen = Color(red: 0.20, green: 0.78, blue: 0.35)        // #34C759
    static let warningOrange = Color(red: 1.00, green: 0.58, blue: 0.00)       // #FF9500
    static let errorRed = Color(red: 1.00, green: 0.27, blue: 0.23)            // #FF453A

    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.62, green: 0.62, blue: 0.66)       // #9E9EA6
    static let textTertiary = Color(red: 0.46, green: 0.46, blue: 0.50)        // #76767F
}

// Gradient styles
extension LinearGradient {
    static let espressoGradient = LinearGradient(
        gradient: Gradient(colors: [Color.espressoBrown, Color.darkCoffee]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.backgroundTertiary]),
        startPoint: .top,
        endPoint: .bottom
    )
}

// Shadow styles
extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    func buttonShadow() -> some View {
        self.shadow(color: Color.espressoBrown.opacity(0.5), radius: 4, x: 0, y: 2)
    }
}
