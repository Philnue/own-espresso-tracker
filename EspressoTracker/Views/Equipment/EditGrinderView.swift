//
//  EditGrinderView.swift
//  EspressoTracker
//
//  View for editing an existing grinder
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditGrinderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var grinder: Grinder

    @State private var name = ""
    @State private var brand = ""
    @State private var burrType = "Conical"
    @State private var burrSize = ""
    @State private var notes = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    let burrTypes = ["Flat", "Conical", "Other"]

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Form {
                Section(header: Text(LocalizedString.get("basic_information")).foregroundColor(.espressoBrown)) {
                    TextField(LocalizedString.get("name"), text: $name)
                    TextField(LocalizedString.get("brand"), text: $brand)
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text(LocalizedString.get("specifications")).foregroundColor(.espressoBrown)) {
                    Picker(LocalizedString.get("burr_type"), selection: $burrType) {
                        ForEach(burrTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    HStack {
                        Text(LocalizedString.get("burr_size_mm"))
                        Spacer()
                        TextField("63", text: $burrSize)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text(LocalizedString.get("image")).foregroundColor(.espressoBrown)) {
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

                            Text(LocalizedString.get("change_image"))
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

                Section(header: Text(LocalizedString.get("notes")).foregroundColor(.espressoBrown)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .foregroundColor(.textPrimary)
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(LocalizedString.get("edit_grinder"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(LocalizedString.get("cancel")) {
                    dismiss()
                }
                .foregroundColor(.textSecondary)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(LocalizedString.get("save")) {
                    saveChanges()
                }
                .foregroundColor(.espressoBrown)
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            loadGrinderData()
        }
    }

    private func loadGrinderData() {
        name = grinder.wrappedName
        brand = grinder.wrappedBrand
        burrType = grinder.burrType
        burrSize = String(grinder.burrSize)
        notes = grinder.wrappedNotes
        imageData = grinder.imageData
    }

    private func saveChanges() {
        let burrSizeValue = Int(burrSize) ?? 0
        let dataManager = DataManager(modelContext: modelContext)
        dataManager.updateGrinder(
            grinder,
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
