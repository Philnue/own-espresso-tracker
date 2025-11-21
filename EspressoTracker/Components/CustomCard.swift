//
//  CustomCard.swift
//  EspressoTracker
//
//  Reusable card component for displaying items
//

import SwiftUI

struct CustomCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
            )
            .cardShadow()
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = .textPrimary

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.espressoBrown)
                .frame(width: 24)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .lineLimit(1)
                .layoutPriority(1)

            Spacer(minLength: 8)

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .espressoBrown

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
        )
        .cardShadow()
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomCard {
            VStack(alignment: .leading) {
                Text("Custom Card")
                    .font(.headline)
                Text("This is a custom card component")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }

        InfoRow(icon: "timer", label: "Brew Time", value: "28s")

        StatCard(title: "Total Shots", value: "142", icon: "cup.and.saucer.fill")
    }
    .padding()
    .background(Color.backgroundPrimary)
}
