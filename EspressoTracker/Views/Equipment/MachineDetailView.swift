//
//  MachineDetailView.swift
//  EspressoTracker
//
//  Detailed view for a single espresso machine
//

import SwiftUI
import SwiftData

struct MachineDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var machine: Machine

    @State private var showingEditView = false
    @State private var showingDeleteAlert = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header with image
                    if let imageData = machine.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                    } else {
                        Image(systemName: "refrigerator")
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
                            Text(machine.wrappedName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)

                            Text(machine.wrappedBrand)
                                .font(.title3)
                                .foregroundColor(.espressoBrown)

                            if let model = machine.model, !model.isEmpty {
                                Text("Model: \(model)")
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                            }

                            Divider()
                                .background(Color.dividerColor)

                            if let boilerType = machine.boilerType {
                                InfoRow(
                                    icon: "flame",
                                    label: "Boiler Type",
                                    value: boilerType
                                )
                            }

                            if let groupHeadType = machine.groupHeadType {
                                InfoRow(
                                    icon: "circle.hexagonpath",
                                    label: "Group Head",
                                    value: groupHeadType
                                )
                            }

                            if machine.pressureBar > 0 {
                                InfoRow(
                                    icon: "gauge.with.needle",
                                    label: "Pressure",
                                    value: String(format: "%.1f bar", machine.pressureBar)
                                )
                            }

                            if let purchaseDate = machine.purchaseDate {
                                InfoRow(
                                    icon: "calendar",
                                    label: "Purchased",
                                    value: purchaseDate.formatted(date: .long, time: .omitted)
                                )
                            }

                            if !machine.wrappedNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(.espressoBrown)
                                        Text("Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text(machine.wrappedNotes)
                                        .font(.body)
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }

                    // Statistics card
                    let sessionCount = machine.sessionsArray.count
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

                                if let lastSession = machine.sessionsArray.first,
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
                        PrimaryButton(title: "Edit Machine") {
                            showingEditView = true
                        }

                        PrimaryButton(title: "Delete Machine", action: {
                            showingDeleteAlert = true
                        }, isDestructive: true)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditMachineView(machine: machine)
        }
        .alert("Delete Machine", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteMachine()
            }
        } message: {
            Text("Are you sure you want to delete this machine? This action cannot be undone.")
        }
    }

    private func deleteMachine() {
        modelContext.delete(machine)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error deleting machine: \(error)")
        }
    }
}
