//
//  BeanDetailView.swift
//  EspressoTracker
//
//  Detailed view for a single coffee bean
//

import SwiftUI
import SwiftData

struct BeanDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var bean: Bean

    @State private var showingEditView = false
    @State private var showingDeleteAlert = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header with image
                    if let imageData = bean.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                    } else {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.textSecondary)
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(20)
                    }

                    // Freshness indicator
                    if let daysFromRoast = bean.daysFromRoast {
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(daysFromRoast)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.textPrimary)
                                Text("days from roast")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }

                            Divider()
                                .frame(height: 40)

                            VStack {
                                Text(bean.freshnessIndicator)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(bean.isStale ? .warningOrange : .successGreen)
                                Text("freshness")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .cardShadow()
                    }

                    // Info card
                    CustomCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(bean.wrappedName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)

                            Text(bean.wrappedRoaster)
                                .font(.title3)
                                .foregroundColor(.espressoBrown)

                            Divider()
                                .background(Color.dividerColor)

                            InfoRow(
                                icon: "globe",
                                label: "Origin",
                                value: bean.wrappedOrigin
                            )

                            if let roastLevel = bean.roastLevel {
                                InfoRow(
                                    icon: "flame",
                                    label: "Roast Level",
                                    value: roastLevel
                                )
                            }

                            if let roastDate = bean.roastDate {
                                InfoRow(
                                    icon: "calendar",
                                    label: "Roast Date",
                                    value: roastDate.formatted(date: .long, time: .omitted)
                                )
                            }

                            if let process = bean.process {
                                InfoRow(
                                    icon: "leaf",
                                    label: "Process",
                                    value: process
                                )
                            }

                            if let variety = bean.variety {
                                InfoRow(
                                    icon: "tag",
                                    label: "Variety",
                                    value: variety
                                )
                            }

                            if let tastingNotes = bean.tastingNotes, !tastingNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer")
                                            .foregroundColor(.espressoBrown)
                                        Text("Tasting Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text(tastingNotes)
                                        .font(.body)
                                        .foregroundColor(.textPrimary)
                                }
                            }

                            if bean.price > 0 {
                                InfoRow(
                                    icon: "dollarsign.circle",
                                    label: "Price",
                                    value: String(format: "$%.2f", bean.price)
                                )
                            }

                            if bean.weight > 0 {
                                InfoRow(
                                    icon: "scalemass",
                                    label: "Weight",
                                    value: String(format: "%.0fg", bean.weight)
                                )
                            }

                            if !bean.wrappedNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(.espressoBrown)
                                        Text("Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text(bean.wrappedNotes)
                                        .font(.body)
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }

                    // Statistics card
                    let sessionCount = bean.sessionsArray.count
                    if sessionCount > 0 {
                        CustomCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Statistics")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)

                                InfoRow(
                                    icon: "cup.and.saucer.fill",
                                    label: "Total Shots",
                                    value: "\(sessionCount)"
                                )

                                if let lastSession = bean.sessionsArray.first,
                                   let date = lastSession.startTime {
                                    InfoRow(
                                        icon: "clock",
                                        label: "Last Used",
                                        value: date.formatted(date: .abbreviated, time: .omitted)
                                    )
                                }
                            }
                        }
                    }

                    // Action buttons
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Edit Bean") {
                            showingEditView = true
                        }

                        PrimaryButton(title: "Delete Bean", action: {
                            showingDeleteAlert = true
                        }, isDestructive: true)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditBeanView(bean: bean)
        }
        .alert("Delete Bean", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteBean()
            }
        } message: {
            Text("Are you sure you want to delete this bean? This action cannot be undone.")
        }
    }

    private func deleteBean() {
        modelContext.delete(bean)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error deleting bean: \(error)")
        }
    }
}
