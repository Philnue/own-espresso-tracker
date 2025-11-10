//
//  MachineListView.swift
//  EspressoTracker
//
//  View for displaying list of espresso machines
//

import SwiftUI
import SwiftData

struct MachineListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Machine.createdAt, order: .reverse) private var machines: [Machine]

    @State private var showingAddMachine = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            if machines.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(machines) { machine in
                            NavigationLink(destination: MachineDetailView(machine: machine)) {
                                MachineCardView(machine: machine)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Machines")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddMachine = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(.espressoBrown)
                }
            }
        }
        .sheet(isPresented: $showingAddMachine) {
            AddMachineView()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "refrigerator")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)

            Text("No Machines Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text("Add your espresso machine to start brewing")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingAddMachine = true }) {
                Label("Add Machine", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.espressoBrown)
                    .cornerRadius(10)
            }
            .buttonShadow()
        }
    }
}

struct MachineCardView: View {
    let machine: Machine

    var body: some View {
        CustomCard {
            HStack(spacing: 16) {
                // Image or placeholder
                if let imageData = machine.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "refrigerator")
                        .font(.system(size: 32))
                        .foregroundColor(.textSecondary)
                        .frame(width: 80, height: 80)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(machine.wrappedName)
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text(machine.wrappedBrand)
                        .font(.subheadline)
                        .foregroundColor(.espressoBrown)

                    if !machine.boilerType.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.caption)
                            Text(machine.boilerType)
                                .font(.caption)
                        }
                        .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
            }
        }
    }
}

#Preview {
    NavigationView {
        MachineListView()
    }
    .modelContainer(for: Machine.self, inMemory: true)
}
