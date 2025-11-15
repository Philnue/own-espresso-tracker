//
//  BeanShotRowView.swift
//  EspressoTracker
//
//  Compact row view for displaying a shot in bean history
//

import SwiftUI

struct BeanShotRowView: View {
    let session: BrewingSession

    var body: some View {
        HStack(spacing: 12) {
            // Session image or icon
            if let imageData = session.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.title2)
                    .foregroundColor(.espressoBrown)
                    .frame(width: 50, height: 50)
                    .background(Color.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // Date
                    Text(session.startTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)

                    // Rating stars
                    if session.rating > 0 {
                        HStack(spacing: 2) {
                            ForEach(1...session.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.warningOrange)
                            }
                        }
                    }
                }

                HStack(spacing: 8) {
                    // Dose
                    HStack(spacing: 2) {
                        Text("\(String(format: "%.1f", session.doseIn))g")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    Text("•")
                        .foregroundColor(.textTertiary)

                    // Brew time
                    HStack(spacing: 2) {
                        Text(session.brewTimeFormatted)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    Text("•")
                        .foregroundColor(.textTertiary)

                    // Ratio
                    HStack(spacing: 2) {
                        Text(session.brewRatioString)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .contentShape(Rectangle())
    }
}
