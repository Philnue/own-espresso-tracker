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
    var bean: Bean

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

                    // Freshness and usage indicator
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(bean.daysFromRoast)")
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

                            if bean.weight > 0 {
                                Divider()
                                    .frame(height: 40)

                                VStack {
                                    Text("\(Int(bean.remainingWeight))g")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(bean.isLowStock ? .warningOrange : (bean.isFinished ? .errorRed : .textPrimary))
                                    Text("remaining")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .cardShadow()

                        // Archive status badge
                        if bean.isArchived {
                            HStack {
                                Image(systemName: "archivebox.fill")
                                    .foregroundColor(.warningOrange)
                                Text("Archived")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.warningOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.warningOrange.opacity(0.1))
                            .cornerRadius(10)
                        }
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

                            if !bean.roastLevel.isEmpty {
                                InfoRow(
                                    icon: "flame",
                                    label: "Roast Level",
                                    value: bean.roastLevel
                                )
                            }

                            InfoRow(
                                icon: "calendar",
                                label: "Roast Date",
                                value: bean.roastDate.formatted(date: .long, time: .omitted)
                            )

                            if !bean.process.isEmpty {
                                InfoRow(
                                    icon: "leaf",
                                    label: "Process",
                                    value: bean.process
                                )
                            }

                            if !bean.variety.isEmpty {
                                InfoRow(
                                    icon: "tag",
                                    label: "Variety",
                                    value: bean.variety
                                )
                            }

                            if !bean.tastingNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer")
                                            .foregroundColor(.espressoBrown)
                                        Text("Tasting Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text(bean.tastingNotes)
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
                    if sessionCount > 0 || bean.weight > 0 {
                        CustomCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Usage & Statistics")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)

                                if sessionCount > 0 {
                                    InfoRow(
                                        icon: "cup.and.saucer.fill",
                                        label: "Total Shots",
                                        value: "\(sessionCount)"
                                    )

                                    if let lastSession = bean.sessionsArray.first {
                                        InfoRow(
                                            icon: "clock",
                                            label: "Last Used",
                                            value: lastSession.startTime.formatted(date: .abbreviated, time: .omitted)
                                        )
                                    }
                                }

                                if bean.weight > 0 {
                                    Divider()
                                        .background(Color.dividerColor)

                                    InfoRow(
                                        icon: "scalemass.fill",
                                        label: "Coffee Used",
                                        value: String(format: "%.1fg", bean.totalGramsUsed)
                                    )

                                    InfoRow(
                                        icon: "chart.bar.fill",
                                        label: "Usage",
                                        value: String(format: "%.1f%%", bean.usagePercentage)
                                    )

                                    // Usage progress bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.backgroundSecondary)
                                                .frame(height: 8)

                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(bean.isFinished ? Color.errorRed : (bean.isLowStock ? Color.warningOrange : Color.espressoBrown))
                                                .frame(width: min(geometry.size.width, geometry.size.width * CGFloat(bean.usagePercentage / 100)), height: 8)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                        }
                    }

                    // Shot History
                    if sessionCount > 0 {
                        CustomCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Shot History")
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)

                                    Spacer()

                                    Text("\(sessionCount) shots")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }

                                Divider()
                                    .background(Color.dividerColor)

                                ForEach(bean.sessionsArray) { session in
                                    NavigationLink(destination: SessionDetailView(session: session)) {
                                        BeanShotRowView(session: session)
                                    }

                                    if session.id != bean.sessionsArray.last?.id {
                                        Divider()
                                            .background(Color.dividerColor)
                                    }
                                }
                            }
                        }
                    }

                    // Action buttons
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Edit Bean") {
                            showingEditView = true
                        }

                        Button(action: {
                            toggleArchive()
                        }) {
                            HStack {
                                Image(systemName: bean.isArchived ? "arrow.uturn.backward" : "archivebox")
                                Text(bean.isArchived ? "Unarchive Bean" : "Archive Bean")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.warningOrange)
                            .cornerRadius(16)
                        }
                        .buttonShadow()

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

    private func toggleArchive() {
        bean.isArchived.toggle()
        do {
            try modelContext.save()
        } catch {
            print("Error archiving bean: \(error)")
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
