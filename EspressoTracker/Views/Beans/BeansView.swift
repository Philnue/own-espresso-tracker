//
//  BeansView.swift
//  EspressoTracker
//
//  View for displaying list of coffee beans
//

import SwiftUI
import SwiftData

struct BeansView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bean.createdAt, order: .reverse) private var beans: [Bean]

    @State private var showingAddBean = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if beans.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(beans) { bean in
                                NavigationLink(destination: BeanDetailView(bean: bean)) {
                                    BeanCardView(bean: bean)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Beans")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBean = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.espressoBrown)
                    }
                }
            }
            .sheet(isPresented: $showingAddBean) {
                AddBeanView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)

            Text("No Beans Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text("Add your coffee beans to track freshness and flavor profiles")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingAddBean = true }) {
                Label("Add Beans", systemImage: "plus")
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

struct BeanCardView: View {
    let bean: Bean

    var body: some View {
        CustomCard {
            HStack(spacing: 16) {
                // Image or placeholder
                if let imageData = bean.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.textSecondary)
                        .frame(width: 80, height: 80)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(bean.wrappedName)
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text(bean.wrappedRoaster)
                        .font(.subheadline)
                        .foregroundColor(.espressoBrown)

                    HStack(spacing: 12) {
                        // Origin
                        if !bean.wrappedOrigin.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "globe")
                                    .font(.caption)
                                Text(bean.wrappedOrigin)
                                    .font(.caption)
                            }
                        }

                        // Freshness indicator
                        if let freshness = bean.daysFromRoast {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.caption)
                                Text("\(freshness)d")
                                    .font(.caption)
                            }
                            .foregroundColor(bean.isStale ? .warningOrange : .successGreen)
                        }
                    }
                    .foregroundColor(.textSecondary)
                }

                Spacer()

                // Freshness badge
                VStack {
                    Text(bean.freshnessIndicator)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            bean.isStale ? Color.warningOrange : Color.successGreen
                        )
                        .cornerRadius(6)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.textTertiary)
                }
            }
        }
    }
}

#Preview {
    BeansView()
        .modelContainer(for: Bean.self, inMemory: true)
}
