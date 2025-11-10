//
//  GrinderDetailView.swift
//  EspressoTracker
//
//  Detailed view for a single grinder
//

import SwiftUI
import SwiftData

struct GrinderDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var grinder: Grinder

    @State private var showingEditView = false
    @State private var showingDeleteAlert = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header with image
                    if let imageData = grinder.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                    } else {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 80))
                            .foregroundColor(.textSecondary)
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(20)
                    }

                    // Info card
                    CustomCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(grinder.wrappedName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)

                            Text(grinder.wrappedBrand)
                                .font(.title3)
                                .foregroundColor(.espressoBrown)

                            Divider()
                                .background(Color.dividerColor)

                            if !grinder.burrType.isEmpty {
                                InfoRow(
                                    icon: "gearshape.2",
                                    label: "Burr Type",
                                    value: grinder.burrType
                                )
                            }

                            if grinder.burrSize > 0 {
                                InfoRow(
                                    icon: "ruler",
                                    label: "Burr Size",
                                    value: "\(grinder.burrSize)mm"
                                )
                            }

                            if !grinder.wrappedNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(.espressoBrown)
                                        Text("Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text(grinder.wrappedNotes)
                                        .font(.body)
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }

                    // Statistics card
                    let sessionCount = grinder.sessionsArray.count
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

                                if let lastSession = grinder.sessionsArray.first {
                                    InfoRow(
                                        icon: "clock",
                                        label: "Last Used",
                                        value: lastSession.startTime.formatted(date: .abbreviated, time: .omitted)
                                    )
                                }
                            }
                        }
                    }

                    // Action buttons
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Edit Grinder") {
                            showingEditView = true
                        }

                        PrimaryButton(title: "Delete Grinder", action: {
                            showingDeleteAlert = true
                        }, isDestructive: true)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditGrinderView(grinder: grinder)
        }
        .alert("Delete Grinder", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteGrinder()
            }
        } message: {
            Text("Are you sure you want to delete this grinder? This action cannot be undone.")
        }
    }

    private func deleteGrinder() {
        modelContext.delete(grinder)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error deleting grinder: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Grinder.self, configurations: config)
    let grinder = Grinder(name: "Sample Grinder", brand: "Sample Brand", burrType: "Conical", burrSize: 63, imageData: nil, notes: "")
    container.mainContext.insert(grinder)

    return NavigationView {
        GrinderDetailView(grinder: grinder)
    }
    .modelContainer(container)
}
