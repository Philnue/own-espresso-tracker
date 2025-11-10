//
//  FinishBrewView.swift
//  EspressoTracker
//
//  View for finishing and saving a brewing session
//

import SwiftUI
import SwiftData
import PhotosUI

struct FinishBrewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BrewingViewModel

    let brewMethod: String
    let grinder: Grinder?
    let machine: Machine?
    let bean: Bean?

    @State private var yieldOut: String = ""
    @State private var rating: Int = 3
    @State private var notes: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    var actualRatio: Double {
        guard let dose = Double(viewModel.doseIn),
              let yield = Double(yieldOut),
              dose > 0 else { return 0 }
        return yield / dose
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                    // Summary section
                    Section(header: Text("Brew Summary").foregroundColor(.espressoBrown)) {
                        InfoRow(
                            icon: "timer",
                            label: "Brew Time",
                            value: String(format: "%.1fs", viewModel.elapsedTime)
                        )

                        InfoRow(
                            icon: "scalemass",
                            label: "Dose In",
                            value: "\(viewModel.doseIn)g"
                        )

                        if !yieldOut.isEmpty, let yield = Double(yieldOut) {
                            InfoRow(
                                icon: "drop.fill",
                                label: "Actual Ratio",
                                value: String(format: "1:%.2f", actualRatio),
                                valueColor: actualRatio >= 1.5 && actualRatio <= 3.0 ? .successGreen : .warningOrange
                            )
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Yield output
                    Section(header: Text("Output").foregroundColor(.espressoBrown)) {
                        HStack {
                            Text("Yield Out (g)")
                                .foregroundColor(.textPrimary)
                            Spacer()
                            TextField(viewModel.targetYieldString, text: $yieldOut)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                                .foregroundColor(.textPrimary)
                        }

                        Text("Target: \(viewModel.targetYieldString)g")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .listRowBackground(Color.cardBackground)

                    // Rating
                    Section(header: Text("Rating").foregroundColor(.espressoBrown)) {
                        HStack {
                            Text("Quality")
                                .foregroundColor(.textPrimary)
                            Spacer()
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.title3)
                                            .foregroundColor(star <= rating ? .espressoBrown : .textTertiary)
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Equipment used
                    Section(header: Text("Equipment Used").foregroundColor(.espressoBrown)) {
                        if let grinder = grinder {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.espressoBrown)
                                Text(grinder.wrappedName)
                                    .foregroundColor(.textPrimary)
                            }
                        }

                        if let machine = machine {
                            HStack {
                                Image(systemName: "refrigerator")
                                    .foregroundColor(.espressoBrown)
                                Text(machine.wrappedName)
                                    .foregroundColor(.textPrimary)
                            }
                        }

                        if let bean = bean {
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.espressoBrown)
                                Text(bean.wrappedName)
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Photo
                    Section(header: Text("Shot Photo (Optional)").foregroundColor(.espressoBrown)) {
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            HStack {
                                if let imageData = imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                } else {
                                    Image(systemName: "camera")
                                        .font(.title2)
                                        .foregroundColor(.textSecondary)
                                        .frame(width: 60, height: 60)
                                        .background(Color.backgroundSecondary)
                                        .cornerRadius(8)
                                }

                                Text("Add Photo")
                                    .foregroundColor(.espressoBrown)

                                Spacer()
                            }
                        }
                        .onChange(of: selectedImage) { oldValue, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Notes
                    Section(header: Text("Tasting Notes").foregroundColor(.espressoBrown)) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.textPrimary)
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Finish Shot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBrewingSession()
                    }
                    .foregroundColor(.espressoBrown)
                    .disabled(yieldOut.isEmpty)
                }
            }
        }
    }

    private func saveBrewingSession() {
        guard let yield = Double(yieldOut),
              let dose = Double(viewModel.doseIn) else { return }

        let waterTemp = Double(viewModel.waterTemp) ?? 93.0
        let pressure = Double(viewModel.pressure) ?? 9.0

        let dataManager = DataManager(modelContext: modelContext)
        dataManager.createBrewingSession(
            grinder: grinder,
            machine: machine,
            bean: bean,
            brewMethod: brewMethod,
            grindSetting: viewModel.grindSetting,
            doseIn: dose,
            yieldOut: yield,
            brewTime: viewModel.elapsedTime,
            waterTemp: waterTemp,
            pressure: pressure,
            rating: rating,
            notes: notes,
            imageData: imageData
        )

        // Reset the view model
        viewModel.resetTimer()
        viewModel.doseIn = "18"
        viewModel.grindSetting = ""

        dismiss()
    }
}
