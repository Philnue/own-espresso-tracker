//
//  CustomButton.swift
//  EspressoTracker
//
//  Reusable button component with espresso theme
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isDestructive: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isDestructive
                        ? Color.errorRed
                        : (isEnabled ? Color.espressoBrown : Color.textTertiary)
                )
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
        .buttonShadow()
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.espressoBrown)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.espressoBrown, lineWidth: 1.5)
                )
        }
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var color: Color = .espressoBrown

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(Color.cardBackground)
                .cornerRadius(10)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Start Brewing", action: {})
        SecondaryButton(title: "Cancel", action: {})
        IconButton(icon: "plus", action: {})
    }
    .padding()
    .background(Color.backgroundPrimary)
}
