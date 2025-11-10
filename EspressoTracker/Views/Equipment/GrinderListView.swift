//
//  GrinderListView.swift
//  EspressoTracker
//
//  View for displaying list of grinders
//

import SwiftUI
import SwiftData

struct GrinderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Grinder.createdAt, order: .reverse) private var grinders: [Grinder]

    @State private var showingAddGrinder = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if grinders.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(grinders) { grinder in
                                NavigationLink(destination: GrinderDetailView(grinder: grinder)) {
                                    GrinderCardView(grinder: grinder)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Grinders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGrinder = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.espressoBrown)
                    }
                }
            }
            .sheet(isPresented: $showingAddGrinder) {
                AddGrinderView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)

            Text("No Grinders Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text("Add your first grinder to start tracking your espresso journey")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingAddGrinder = true }) {
                Label("Add Grinder", systemImage: "plus")
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

struct GrinderCardView: View {
    let grinder: Grinder

    var body: some View {
        CustomCard {
            HStack(spacing: 16) {
                // Image or placeholder
                if let imageData = grinder.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 32))
                        .foregroundColor(.textSecondary)
                        .frame(width: 80, height: 80)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(grinder.wrappedName)
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text(grinder.wrappedBrand)
                        .font(.subheadline)
                        .foregroundColor(.espressoBrown)

                    if !grinder.burrType.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "gearshape.2")
                                .font(.caption)
                            Text("\(grinder.burrType) - \(grinder.burrSize)mm")
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
    GrinderListView()
        .modelContainer(for: Grinder.self, inMemory: true)
}
