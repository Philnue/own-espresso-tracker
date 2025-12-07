//
//  ColorTheme.swift
//  EspressoTracker
//
//  Adaptive color theme for light and dark modes
//

import SwiftUI

extension Color {
    // Primary colors - Espresso-inspired palette
    static let espressoBrown = Color(red: 0.48, green: 0.33, blue: 0.28)       // #7A5449
    static let darkCoffee = Color(red: 0.24, green: 0.18, blue: 0.14)          // #3D2E23
    static let creamyFoam = Color(red: 0.95, green: 0.94, blue: 0.92)          // #F2F0EB
    static let richCrema = Color(red: 0.78, green: 0.60, blue: 0.42)           // #C7996B

    // Adaptive Background colors
    static let backgroundPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)  // Dark: #1C1C1E
            : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)  // Light: #F2F2F7
    })

    static let backgroundSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.14, green: 0.14, blue: 0.15, alpha: 1.0)  // Dark: #242426
            : UIColor(red: 0.98, green: 0.98, blue: 1.00, alpha: 1.0)  // Light: #FAFAFF
    })

    static let backgroundTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)  // Dark: #2C2C2E
            : UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)  // Light: #FFFFFF
    })

    // Adaptive UI Element colors
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.0)  // Dark: #303032
            : UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)  // Light: #FFFFFF
    })

    static let dividerColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1.0)  // Dark: #3A3A3C
            : UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)  // Light: #C7C7CC
    })

    // Status colors (same for both modes)
    static let successGreen = Color(red: 0.20, green: 0.78, blue: 0.35)        // #34C759 - Very Fresh
    static let freshGreen = Color(red: 0.30, green: 0.69, blue: 0.31)          // #4CAF50 - Fresh
    static let goodBlue = Color(red: 0.13, green: 0.59, blue: 0.95)            // #2196F3 - Good
    static let warningOrange = Color(red: 1.00, green: 0.58, blue: 0.00)       // #FF9500 - Aging
    static let errorRed = Color(red: 1.00, green: 0.27, blue: 0.23)            // #FF453A - Stale

    // Adaptive Text colors
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white                                             // Dark: White
            : UIColor.black                                             // Light: Black
    })

    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.62, green: 0.62, blue: 0.66, alpha: 1.0)  // Dark: #9E9EA6
            : UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1.0)  // Light: #3C3C43
    })

    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.46, green: 0.46, blue: 0.50, alpha: 1.0)  // Dark: #76767F
            : UIColor(red: 0.44, green: 0.44, blue: 0.46, alpha: 1.0)  // Light: #707073
    })
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
