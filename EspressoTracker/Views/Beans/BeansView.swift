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
    @Query(sort: \Bean.createdAt, order: .reverse) private var allBeans: [Bean]

    @State private var showingAddBean = false
    @State private var showArchivedBeans = false

    private var beans: [Bean] {
        if showArchivedBeans {
            return allBeans
        } else {
            return allBeans.filter { !$0.isArchived }
        }
    }

    private var activeBeanCount: Int {
        allBeans.filter { !$0.isArchived }.count
    }

    private var archivedBeanCount: Int {
        allBeans.filter { $0.isArchived }.count
    }

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
            .navigationTitle(showArchivedBeans ? LocalizedString.get("all_beans") : LocalizedString.get("active_beans"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if archivedBeanCount > 0 {
                        Button(action: {
                            showArchivedBeans.toggle()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: showArchivedBeans ? "eye.slash" : "eye")
                                if showArchivedBeans {
                                    Text(LocalizedString.get("hide_archived"))
                                        .font(.caption)
                                } else {
                                    Text("\(LocalizedString.get("show_archived")) (\(archivedBeanCount))")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.espressoBrown)
                        }
                    }
                }

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

            Text(LocalizedString.get("no_beans_yet"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(LocalizedString.get("no_beans_description"))
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingAddBean = true }) {
                Label(LocalizedString.get("add_beans"), systemImage: "plus")
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
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    // Image or placeholder
                    if let imageData = bean.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .frame(width: 70, height: 70)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(10)
                    }

                    // Bean info
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(bean.wrappedName)
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)

                            if bean.batchNumber > 1 {
                                Text("#\(bean.batchNumber)")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.espressoBrown)
                                    .cornerRadius(4)
                            }

                            if bean.isArchived {
                                Image(systemName: "archivebox.fill")
                                    .font(.caption)
                                    .foregroundColor(.warningOrange)
                            }

                            Spacer()

                            // Freshness badge
                            Text(bean.freshnessIndicator)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(freshnessColor(for: bean.freshnessLevel))
                                .cornerRadius(6)
                        }

                        Text(bean.wrappedRoaster)
                            .font(.subheadline)
                            .foregroundColor(.espressoBrown)
                            .lineLimit(1)
                    }
                }

                // Details row - vertical layout
                Divider()
                    .background(Color.dividerColor)

                HStack(spacing: 8) {
                    // Origin
                    if !bean.wrappedOrigin.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "globe")
                                .font(.caption2)
                                .foregroundColor(.espressoBrown)
                            Text(bean.wrappedOrigin)
                                .font(.caption)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    // Freshness
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                            .foregroundColor(freshnessColor(for: bean.freshnessLevel))
                        Text("\(bean.daysFromRoast)d")
                            .font(.caption)
                            .foregroundColor(freshnessColor(for: bean.freshnessLevel))
                    }

                    // Remaining weight
                    if bean.weight > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "scalemass")
                                .font(.caption2)
                                .foregroundColor(bean.isLowStock ? .warningOrange : (bean.isFinished ? .errorRed : .espressoBrown))
                            Text("\(Int(bean.remainingWeight))g")
                                .font(.caption)
                                .foregroundColor(bean.isLowStock ? .warningOrange : (bean.isFinished ? .errorRed : .textPrimary))
                        }
                    }

                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }

                // Usage progress bar
                if bean.weight > 0 && bean.totalGramsUsed > 0 {
                    VStack(spacing: 4) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.backgroundSecondary)
                                    .frame(height: 4)

                                RoundedRectangle(cornerRadius: 2)
                                    .fill(bean.isFinished ? Color.errorRed : (bean.isLowStock ? Color.warningOrange : Color.espressoBrown))
                                    .frame(width: min(geometry.size.width, geometry.size.width * CGFloat(bean.usagePercentage / 100)), height: 4)
                            }
                        }
                        .frame(height: 4)

                        HStack {
                            Text("\(String(format: "%.1f%%", bean.usagePercentage)) \(LocalizedString.get("used").lowercased())")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text("\(bean.sessionsArray.count) \(LocalizedString.get("shots"))")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private func freshnessColor(for level: Int) -> Color {
        switch level {
        case 0: return .successGreen      // Very Fresh - bright green
        case 1: return .successGreen      // Fresh - green
        case 2: return .espressoBrown     // Good - brown
        case 3: return .warningOrange     // Aging - orange
        default: return .errorRed         // Stale - red
        }
    }
}

#Preview {
    BeansView()
        .modelContainer(for: Bean.self, inMemory: true)
}
