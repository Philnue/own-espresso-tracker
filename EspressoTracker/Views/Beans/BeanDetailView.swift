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
    @State private var showingAddBatch = false

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
                                Text(LocalizedString.get("days_from_roast"))
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }

                            Divider()
                                .frame(height: 40)

                            VStack {
                                Text(bean.freshnessIndicator)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(freshnessColor(for: bean.freshnessLevel))
                                Text(LocalizedString.get("freshness"))
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
                                    Text(LocalizedString.get("remaining"))
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
                                Text(LocalizedString.get("archived"))
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
                            HStack {
                                Text(bean.displayName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.textPrimary)

                                Spacer()

                                if bean.batchNumber > 1 {
                                    Text("Batch #\(bean.batchNumber)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.espressoBrown)
                                        .cornerRadius(6)
                                }
                            }

                            Text(bean.wrappedRoaster)
                                .font(.title3)
                                .foregroundColor(.espressoBrown)

                            Divider()
                                .background(Color.dividerColor)

                            InfoRow(
                                icon: "globe",
                                label: LocalizedString.get("origin"),
                                value: bean.wrappedOrigin
                            )

                            if !bean.roastLevel.isEmpty {
                                InfoRow(
                                    icon: "flame",
                                    label: LocalizedString.get("roast_level"),
                                    value: bean.roastLevel
                                )
                            }

                            InfoRow(
                                icon: "calendar",
                                label: LocalizedString.get("roast_date"),
                                value: bean.roastDate.formatted(date: .long, time: .omitted)
                            )

                            if !bean.process.isEmpty {
                                InfoRow(
                                    icon: "leaf",
                                    label: LocalizedString.get("process"),
                                    value: bean.process
                                )
                            }

                            if !bean.variety.isEmpty {
                                InfoRow(
                                    icon: "tag",
                                    label: LocalizedString.get("variety"),
                                    value: bean.variety
                                )
                            }

                            if !bean.tastingNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer")
                                            .foregroundColor(.espressoBrown)
                                        Text(LocalizedString.get("tasting_notes"))
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
                                    label: LocalizedString.get("price"),
                                    value: String(format: "$%.2f", bean.price)
                                )
                            }

                            if bean.weight > 0 {
                                InfoRow(
                                    icon: "scalemass",
                                    label: LocalizedString.get("weight"),
                                    value: String(format: "%.0fg", bean.weight)
                                )
                            }

                            InfoRow(
                                icon: "bag",
                                label: LocalizedString.get("purchase_date"),
                                value: bean.formattedPurchaseDate
                            )

                            if !bean.wrappedNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(.espressoBrown)
                                        Text(LocalizedString.get("notes"))
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
                                Text(LocalizedString.get("usage_statistics"))
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)

                                if sessionCount > 0 {
                                    InfoRow(
                                        icon: "cup.and.saucer.fill",
                                        label: LocalizedString.get("total_shots"),
                                        value: "\(sessionCount)"
                                    )

                                    if let lastSession = bean.sessionsArray.first {
                                        InfoRow(
                                            icon: "clock",
                                            label: LocalizedString.get("last_used"),
                                            value: lastSession.startTime.formatted(date: .abbreviated, time: .omitted)
                                        )
                                    }
                                }

                                if bean.weight > 0 {
                                    Divider()
                                        .background(Color.dividerColor)

                                    InfoRow(
                                        icon: "scalemass.fill",
                                        label: LocalizedString.get("coffee_used"),
                                        value: String(format: "%.1fg", bean.totalGramsUsed)
                                    )

                                    InfoRow(
                                        icon: "chart.bar.fill",
                                        label: LocalizedString.get("usage"),
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
                                    Text(LocalizedString.get("shot_history"))
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)

                                    Spacer()

                                    Text("\(sessionCount) \(LocalizedString.get("shots"))")
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
                        // Buy Again button
                        Button(action: {
                            showingAddBatch = true
                        }) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text(LocalizedString.get("buy_again"))
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.successGreen)
                            .cornerRadius(16)
                        }
                        .buttonShadow()

                        PrimaryButton(title: LocalizedString.get("edit_bean")) {
                            showingEditView = true
                        }

                        Button(action: {
                            toggleArchive()
                        }) {
                            HStack {
                                Image(systemName: bean.isArchived ? "arrow.uturn.backward" : "archivebox")
                                Text(bean.isArchived ? LocalizedString.get("unarchive_bean") : LocalizedString.get("archive_bean"))
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

                        PrimaryButton(title: LocalizedString.get("delete_bean"), action: {
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
        .sheet(isPresented: $showingAddBatch) {
            AddBatchView(existingBean: bean)
        }
        .alert(LocalizedString.get("delete_bean"), isPresented: $showingDeleteAlert) {
            Button(LocalizedString.get("cancel"), role: .cancel) { }
            Button(LocalizedString.get("delete"), role: .destructive) {
                deleteBean()
            }
        } message: {
            Text(LocalizedString.get("delete_bean_confirm"))
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

    private func freshnessColor(for level: Int) -> Color {
        switch level {
        case 0: return .successGreen      // Very Fresh (0-7 days) - bright green
        case 1: return .freshGreen        // Fresh (8-14 days) - darker green
        case 2: return .goodBlue          // Good (15-21 days) - blue
        case 3: return .warningOrange     // Aging (22-30 days) - orange
        default: return .errorRed         // Stale (>30 days) - red
        }
    }
}
