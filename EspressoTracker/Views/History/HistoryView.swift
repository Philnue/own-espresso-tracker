//
//  HistoryView.swift
//  EspressoTracker
//
//  View for displaying brewing session history
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BrewingSession.startTime, order: .reverse) private var sessions: [BrewingSession]

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if sessions.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Statistics summary
                            statisticsSection

                            // Session list
                            LazyVStack(spacing: 12) {
                                ForEach(sessions) { session in
                                    NavigationLink(destination: SessionDetailView(session: session)) {
                                        SessionCardView(session: session)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    private var statisticsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Shots",
                    value: "\(sessions.count)",
                    icon: "cup.and.saucer.fill"
                )

                StatCard(
                    title: "Avg Time",
                    value: averageBrewTime,
                    icon: "timer",
                    color: .successGreen
                )
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Avg Ratio",
                    value: averageRatio,
                    icon: "scalemass",
                    color: .richCrema
                )

                StatCard(
                    title: "This Week",
                    value: "\(sessionsThisWeek)",
                    icon: "calendar",
                    color: .warningOrange
                )
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.fill")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)

            Text(LocalizedString.get("no_history_yet"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(LocalizedString.get("no_history_description"))
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    // Computed statistics
    private var averageBrewTime: String {
        guard !sessions.isEmpty else { return "0s" }
        let total = sessions.reduce(0.0) { $0 + $1.brewTime }
        let average = total / Double(sessions.count)
        return String(format: "%.0fs", average)
    }

    private var averageRatio: String {
        guard !sessions.isEmpty else { return "0.0" }
        let validSessions = sessions.filter { $0.doseIn > 0 }
        guard !validSessions.isEmpty else { return "0.0" }
        let total = validSessions.reduce(0.0) { $0 + $1.brewRatio }
        let average = total / Double(validSessions.count)
        return String(format: "1:%.1f", average)
    }

    private var sessionsThisWeek: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions.filter { $0.startTime >= weekAgo }.count
    }
}

struct SessionCardView: View {
    let session: BrewingSession

    var body: some View {
        CustomCard {
            VStack(alignment: .leading, spacing: 12) {
                // Header with date, brewing method and rating
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.startTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        HStack(spacing: 6) {
                            Image(systemName: brewMethodIcon(for: session.brewMethod))
                                .font(.caption2)
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get(session.brewMethod.lowercased()))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                            Text(session.startTime.formatted(date: .omitted, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }

                    Spacer()

                    // Rating stars
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= session.rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(star <= session.rating ? .espressoBrown : .textTertiary)
                        }
                    }
                }

                Divider()
                    .background(Color.dividerColor)

                // Brewing details
                HStack(spacing: 20) {
                    // Time
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.brewTimeFormatted)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        Text("Brew Time")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    Divider()
                        .frame(height: 40)

                    // Ratio
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.brewRatioString)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        Text("Ratio")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    Divider()
                        .frame(height: 40)

                    // Dose
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: "%.1fg", session.doseIn))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        Text("Dose")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }

                // Equipment and bean
                if session.bean != nil || session.grinder != nil {
                    Divider()
                        .background(Color.dividerColor)

                    HStack(spacing: 16) {
                        if let bean = session.bean {
                            HStack(spacing: 6) {
                                Image(systemName: "leaf.fill")
                                    .font(.caption)
                                    .foregroundColor(.espressoBrown)
                                Text(bean.wrappedName)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                    .lineLimit(1)
                            }
                        }

                        if let grinder = session.grinder {
                            HStack(spacing: 6) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.caption)
                                    .foregroundColor(.espressoBrown)
                                Text(grinder.wrappedName)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }

                // Extraction quality indicator
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(session.brewTime >= 20 && session.brewTime <= 35 ? .successGreen : .warningOrange)
                    Text(session.extraction)
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
    }

    private func brewMethodIcon(for method: String) -> String {
        switch method.lowercased() {
        case "espresso": return "cup.and.saucer.fill"
        case "aeropress": return "arrow.down.circle.fill"
        case "frenchpress", "french_press": return "cylinder.fill"
        case "coldbrew", "cold_brew": return "snowflake"
        case "pourover", "pour_over": return "drop.fill"
        case "moka", "moka_pot": return "flame.fill"
        default: return "cup.and.saucer.fill"
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: BrewingSession.self, inMemory: true)
}
