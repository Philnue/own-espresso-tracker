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
            VStack(spacing: 0) {
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
                        HStack {
                            Text(bean.wrappedName)
                                .font(.headline)
                                .foregroundColor(.textPrimary)

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
                        }

                        Text(bean.wrappedRoaster)
                            .font(.subheadline)
                            .foregroundColor(.espressoBrown)

                        HStack(spacing: 8) {
                            // Origin
                            if !bean.wrappedOrigin.isEmpty {
                                HStack(spacing: 2) {
                                    Image(systemName: "globe")
                                        .font(.caption2)
                                    Text(bean.wrappedOrigin)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }

                            // Freshness indicator
                            HStack(spacing: 2) {
                                Image(systemName: "calendar")
                                    .font(.caption2)
                                Text("\(bean.daysFromRoast)d")
                                    .font(.caption)
                            }
                            .foregroundColor(bean.isStale ? .warningOrange : .successGreen)

                            // Remaining weight
                            if bean.weight > 0 {
                                HStack(spacing: 2) {
                                    Image(systemName: "scalemass")
                                        .font(.caption2)
                                    Text("\(Int(bean.remainingWeight))g")
                                        .font(.caption)
                                }
                                .foregroundColor(bean.isLowStock ? .warningOrange : (bean.isFinished ? .errorRed : .textSecondary))
                            }
                        }
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
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
                        .padding(.top, 12)

                        HStack {
                            Text("\(String(format: "%.1f%%", bean.usagePercentage)) \(LocalizedString.get("used").lowercased())")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text("\(bean.sessionsArray.count) \(LocalizedString.get("shots"))")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    BeansView()
        .modelContainer(for: Bean.self, inMemory: true)
}
