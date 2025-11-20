//
//  SearchableBeanPicker.swift
//  EspressoTracker
//
//  Searchable picker for beans with filter and inventory display
//

import SwiftUI
import SwiftData

struct SearchableBeanPicker: View {
    @Binding var selectedBean: Bean?
    let beans: [Bean]
    @Binding var showArchivedBeans: Bool
    let onDismiss: () -> Void

    @State private var searchText = ""
    @State private var sortOption: BeanSortOption = .name

    enum BeanSortOption: String, CaseIterable {
        case name = "Name"
        case roaster = "Roaster"
        case freshness = "Freshness"
        case remaining = "Remaining"
    }

    private var filteredBeans: [Bean] {
        var result = beans

        // Filter by archive status
        if !showArchivedBeans {
            result = result.filter { !$0.isArchived }
        }

        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { bean in
                bean.wrappedName.localizedCaseInsensitiveContains(searchText) ||
                bean.wrappedRoaster.localizedCaseInsensitiveContains(searchText) ||
                bean.wrappedOrigin.localizedCaseInsensitiveContains(searchText) ||
                bean.tastingNotes.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort beans
        switch sortOption {
        case .name:
            result.sort { $0.wrappedName < $1.wrappedName }
        case .roaster:
            result.sort { $0.wrappedRoaster < $1.wrappedRoaster }
        case .freshness:
            result.sort { $0.daysFromRoast < $1.daysFromRoast }
        case .remaining:
            result.sort { $0.remainingWeight > $1.remainingWeight }
        }

        return result
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search and filter bar
                    VStack(spacing: 12) {
                        // Search field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.textSecondary)
                            TextField("Search beans...", text: $searchText)
                                .foregroundColor(.textPrimary)
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.cardBackground)
                        .cornerRadius(10)

                        // Sort and filter options
                        HStack {
                            // Sort picker
                            Menu {
                                ForEach(BeanSortOption.allCases, id: \.self) { option in
                                    Button(action: { sortOption = option }) {
                                        HStack {
                                            Text(option.rawValue)
                                            if sortOption == option {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.up.arrow.down")
                                    Text(sortOption.rawValue)
                                        .font(.caption)
                                }
                                .foregroundColor(.espressoBrown)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                            }

                            Spacer()

                            // Archive toggle
                            Button(action: { showArchivedBeans.toggle() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: showArchivedBeans ? "archivebox.fill" : "archivebox")
                                    Text(showArchivedBeans ? "Hide Archived" : "Show Archived")
                                        .font(.caption)
                                }
                                .foregroundColor(.espressoBrown)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()

                    // Bean list
                    if filteredBeans.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "leaf")
                                .font(.system(size: 48))
                                .foregroundColor(.textTertiary)
                            Text(searchText.isEmpty ? "No beans available" : "No beans match your search")
                                .font(.headline)
                                .foregroundColor(.textSecondary)
                            if searchText.isEmpty {
                                Text("Add beans in the Beans tab")
                                    .font(.subheadline)
                                    .foregroundColor(.textTertiary)
                            }
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredBeans) { bean in
                                    BeanPickerRow(
                                        bean: bean,
                                        isSelected: selectedBean?.id == bean.id
                                    ) {
                                        selectedBean = bean
                                        onDismiss()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Select Beans")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

struct BeanPickerRow: View {
    let bean: Bean
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Bean image or icon
                if let imageData = bean.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(.espressoBrown)
                        .frame(width: 50, height: 50)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(8)
                }

                // Bean info
                VStack(alignment: .leading, spacing: 4) {
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
                                .foregroundColor(.textTertiary)
                        }
                    }

                    Text(bean.wrappedRoaster)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)

                    HStack(spacing: 8) {
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

                        // Freshness
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text("\(bean.daysFromRoast)d")
                                .font(.caption)
                        }
                        .foregroundColor(.textSecondary)

                        // Freshness badge
                        Text(bean.freshnessIndicator)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(freshnessColor(for: bean).opacity(0.2))
                            .foregroundColor(freshnessColor(for: bean))
                            .cornerRadius(4)
                    }
                }

                Spacer()

                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.espressoBrown)
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.textTertiary)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.espressoBrown.opacity(0.1) : Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.espressoBrown : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func freshnessColor(for bean: Bean) -> Color {
        switch bean.freshnessIndicator {
        case "Very Fresh", "Fresh":
            return .successGreen
        case "Good":
            return .espressoBrown
        case "Aging":
            return .warningOrange
        default:
            return .errorRed
        }
    }
}

#Preview {
    SearchableBeanPicker(
        selectedBean: .constant(nil),
        beans: [],
        showArchivedBeans: .constant(false),
        onDismiss: {}
    )
}
