//
//  AddGrinderView.swift
//  EspressoTracker
//
//  View for adding a new grinder
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddGrinderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var brand = ""
    @State private var burrType = "Conical"
    @State private var burrSize = "63"
    @State private var notes = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    let burrTypes = ["Flat", "Conical", "Other"]

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Form {
                Section(header: Text("Basic Information").foregroundColor(.espressoBrown)) {
                    TextField("Name", text: $name)
                    TextField("Brand", text: $brand)
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text("Specifications").foregroundColor(.espressoBrown)) {
                    Picker("Burr Type", selection: $burrType) {
                        ForEach(burrTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    HStack {
                        Text("Burr Size (mm)")
                        Spacer()
                        TextField("63", text: $burrSize)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text("Image").foregroundColor(.espressoBrown)) {
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
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.textSecondary)
                                    .frame(width: 60, height: 60)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(8)
                            }

                            Text("Select Image")
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

                Section(header: Text("Notes").foregroundColor(.espressoBrown)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .foregroundColor(.textPrimary)
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Add Grinder")
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
                    saveGrinder()
                }
                .foregroundColor(.espressoBrown)
                .disabled(name.isEmpty)
            }
        }
    }

    private func saveGrinder() {
        let burrSizeValue = Int(burrSize) ?? 0
        let dataManager = DataManager(modelContext: modelContext)
        dataManager.createGrinder(
            name: name,
            brand: brand,
            burrType: burrType,
            burrSize: burrSizeValue,
            notes: notes,
            imageData: imageData
        )
        dismiss()
    }
}

#Preview {
    AddGrinderView()
        .modelContainer(for: Grinder.self, inMemory: true)
}
