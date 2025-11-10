//
//  SessionDetailView.swift
//  EspressoTracker
//
//  Detailed view for a single brewing session
//

import SwiftUI
import SwiftData

struct SessionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var session: BrewingSession

    @State private var showingDeleteAlert = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Photo if available
                    if let imageData = session.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                    }

                    // Rating and date
                    CustomCard {
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                Text(session.startTime.formatted(date: .long, time: .omitted))
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                Text(session.startTime.formatted(date: .omitted, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                            }

                            // Rating
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= session.rating ? "star.fill" : "star")
                                        .font(.title3)
                                        .foregroundColor(star <= session.rating ? .espressoBrown : .textTertiary)
                                }
                            }

                            // Quality assessment
                            Text(session.qualityAssessment)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(session.brewTime >= 20 && session.brewTime <= 35 ? .successGreen : .warningOrange)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(
                                    (session.brewTime >= 20 && session.brewTime <= 35 ? Color.successGreen : Color.warningOrange).opacity(0.15)
                                )
                                .cornerRadius(8)
                        }
                    }

                    // Brewing parameters
                    CustomCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Brewing Parameters")
                                .font(.headline)
                                .foregroundColor(.textPrimary)

                            Divider()
                                .background(Color.dividerColor)

                            InfoRow(
                                icon: "timer",
                                label: "Brew Time",
                                value: session.brewTimeFormatted
                            )

                            InfoRow(
                                icon: "scalemass",
                                label: "Dose In",
                                value: String(format: "%.1fg", session.doseIn)
                            )

                            InfoRow(
                                icon: "drop.fill",
                                label: "Yield Out",
                                value: String(format: "%.1fg", session.yieldOut)
                            )

                            InfoRow(
                                icon: "chart.bar.fill",
                                label: "Brew Ratio",
                                value: session.brewRatioString,
                                valueColor: .espressoBrown
                            )

                            if session.waterTemp > 0 {
                                InfoRow(
                                    icon: "thermometer",
                                    label: "Water Temp",
                                    value: String(format: "%.1f°C", session.waterTemp)
                                )
                            }

                            if session.pressure > 0 {
                                InfoRow(
                                    icon: "gauge.with.needle",
                                    label: "Pressure",
                                    value: String(format: "%.1f bar", session.pressure)
                                )
                            }

                            if !session.grindSetting.isEmpty {
                                InfoRow(
                                    icon: "gearshape.2",
                                    label: "Grind Setting",
                                    value: session.grindSetting
                                )
                            }
                        }
                    }

                    // Equipment used
                    if session.grinder != nil || session.machine != nil || session.bean != nil {
                        CustomCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Equipment & Beans")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)

                                Divider()
                                    .background(Color.dividerColor)

                                if let grinder = session.grinder {
                                    InfoRow(
                                        icon: "slider.horizontal.3",
                                        label: "Grinder",
                                        value: grinder.wrappedName
                                    )
                                }

                                if let machine = session.machine {
                                    InfoRow(
                                        icon: "refrigerator",
                                        label: "Machine",
                                        value: machine.wrappedName
                                    )
                                }

                                if let bean = session.bean {
                                    VStack(alignment: .leading, spacing: 8) {
                                        InfoRow(
                                            icon: "leaf.fill",
                                            label: "Bean",
                                            value: bean.wrappedName
                                        )

                                        if !bean.wrappedRoaster.isEmpty {
                                            HStack(spacing: 12) {
                                                Spacer()
                                                    .frame(width: 24)
                                                Text("Roaster")
                                                    .font(.caption)
                                                    .foregroundColor(.textTertiary)
                                                Spacer()
                                                Text(bean.wrappedRoaster)
                                                    .font(.caption)
                                                    .foregroundColor(.textSecondary)
                                            }
                                        }

                                        HStack(spacing: 12) {
                                            Spacer()
                                                .frame(width: 24)
                                            Text("Freshness")
                                                .font(.caption)
                                                .foregroundColor(.textTertiary)
                                            Spacer()
                                            Text("\(bean.daysFromRoast) days from roast")
                                                .font(.caption)
                                                .foregroundColor(.textSecondary)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Notes
                    if !session.wrappedNotes.isEmpty {
                        CustomCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "note.text")
                                        .foregroundColor(.espressoBrown)
                                    Text("Tasting Notes")
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)
                                }

                                Text(session.wrappedNotes)
                                    .font(.body)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }

                    // Taste Profile
                    CustomCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "cup.and.saucer.fill")
                                    .foregroundColor(.espressoBrown)
                                Text("Taste Profile")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Text(session.tasteBalance)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.espressoBrown)
                                    .cornerRadius(8)
                            }

                            Divider()
                                .background(Color.dividerColor)

                            VStack(spacing: 12) {
                                TasteBar(label: "Acidity", value: session.acidity, icon: "sparkles")
                                TasteBar(label: "Sweetness", value: session.sweetness, icon: "heart.fill")
                                TasteBar(label: "Bitterness", value: session.bitterness, icon: "flame.fill")
                                TasteBar(label: "Body", value: session.body, icon: "drop.fill")
                                TasteBar(label: "Aftertaste", value: session.aftertaste, icon: "star.fill")
                            }
                        }
                    }

                    // Recommendations
                    CustomCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.espressoBrown)
                                Text("Recommendations")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                            }

                            Divider()
                                .background(Color.dividerColor)

                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(session.recommendations.enumerated()), id: \.offset) { index, recommendation in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(.espressoBrown)
                                            .padding(.top, 2)
                                        Text(recommendation)
                                            .font(.subheadline)
                                            .foregroundColor(.textPrimary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }

                    // Extraction analysis
                    CustomCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Extraction Analysis")
                                .font(.headline)
                                .foregroundColor(.textPrimary)

                            Divider()
                                .background(Color.dividerColor)

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Status")
                                        .font(.subheadline)
                                        .foregroundColor(.textSecondary)
                                    Text(session.extraction)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(
                                            session.brewTime >= 20 && session.brewTime <= 35
                                                ? .successGreen
                                                : .warningOrange
                                        )
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("Target Range")
                                        .font(.subheadline)
                                        .foregroundColor(.textSecondary)
                                    Text("20-35s")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }

                    // Delete button
                    PrimaryButton(title: "Delete Session", action: {
                        showingDeleteAlert = true
                    }, isDestructive: true)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Shot Details")
        .alert("Delete Session", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteSession()
            }
        } message: {
            Text("Are you sure you want to delete this brewing session? This action cannot be undone.")
        }
    }

    private func deleteSession() {
        modelContext.delete(session)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error deleting session: \(error)")
        }
    }
}

struct TasteBar: View {
    let label: String
    let value: Int
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.espressoBrown)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(value)/5")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.espressoBrown)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.backgroundSecondary)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.espressoBrown)
                        .frame(width: geometry.size.width * (CGFloat(value) / 5.0), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
